package com.chipacabra.Jumper
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author David Bell
	 **/
	public class Player extends FlxSprite 
	{
		[Embed(source = '../../../../art/lizardhead3.png')]public var lizardhead:Class;
		[Embed(source = '../../../../sounds/death.mp3')]public var sndDeath:Class;
		[Embed(source = '../../../../sounds/jump.mp3')]public var sndJump:Class;
		[Embed(source = '../../../../sounds/shoot2.mp3')]public var sndShoot:Class; 
		
		protected static const RUN_SPEED:int = 90;
		protected static const GRAVITY:int =620;
		protected static const JUMP_SPEED:int = 250;
		protected static const BULLET_SPEED:int = 200;
		protected static const GUN_DELAY:Number = .4;
		
		
		protected var _gibs:FlxEmitter;
		protected var _bullets:FlxGroup;
		protected var _blt:Bullet;
		protected var _cooldown:Number;
		protected var _parent:*;
		protected var _onladder:Boolean;
		
		private var _jump:Number;
		private var _canDJump:Boolean;
		private var _xgridleft:int;
		private var _xgridright:int;
		private var _ygrid:int;
		
		public var climbing:Boolean;
		
		public function Player(X:int,Y:int,Parent:*,Gibs:FlxEmitter,Bullets:FlxGroup):void // X,Y: Starting coordinates
		{
			super(X, Y);
			
			_bullets = Bullets;
			
			loadGraphic(lizardhead, true, true,16,20);  //Set up the graphics
			addAnimation("walking", [0,1, 2,3], 12, true);
			addAnimation("idle", [3]);
			addAnimation("jump", [2]);
			
			drag.x = RUN_SPEED * 8;
			drag.y = RUN_SPEED*8;
			acceleration.y = GRAVITY;
			maxVelocity.x = RUN_SPEED;
			maxVelocity.y = JUMP_SPEED;
			height = 16;
			offset.y = 4;
			width = 12;
			offset.x = 3;
			
			_cooldown = GUN_DELAY; // Initialize the cooldown so that helmutguy can shoot right away.
			_gibs = Gibs;
			_parent = Parent;  // This is so we can look at properties of the playstate's tilemaps
			_jump = 0;
			_onladder = false;
			
			climbing = false; // just to make sure it never gets caught undefined. That would be embarassing.
			
		}
		
		public override function update():void
		{
			
			acceleration.x = 0; //Reset to 0 when no button is pushed
			
			if (climbing) acceleration.y = 0;  // Stop falling if you're climbing a ladder
			else acceleration.y = GRAVITY;
			
			if (FlxG.keys.LEFT)
			{
				facing = LEFT; 
				acceleration.x = -drag.x;
			}
			else if (FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				acceleration.x = drag.x;				
			}
			
			// Climbing
			if (FlxG.keys.UP)
			{
				if (_onladder) 
				{
					climbing = true;
					_canDJump = true;
				}
				if (climbing && (_parent.ladders.getTile(_xgridleft, _ygrid-1))) velocity.y = -RUN_SPEED;
			}
			if (FlxG.keys.DOWN) 
			{
				if (_onladder) 
				{
					climbing = true;
					_canDJump = true;
				}
				if (climbing) velocity.y = RUN_SPEED;
			}
			
			if (FlxG.keys.justPressed("C"))
			{
				if (climbing)
				{
					_jump = 0;
					climbing = false;
					FlxG.play(sndJump, 1, false, 50);
				}
				if (!velocity.y)
					FlxG.play(sndJump, 1, false, 50);
			}
			
			if (FlxG.keys.justPressed("C") && (velocity.y > 0) && _canDJump==true)
			{
				FlxG.play(sndJump, 1, false, 50);
				_jump = 0;
				_canDJump = false;
			}
			
            if((_jump >= 0) && (FlxG.keys.C)) //You can also use space or any other key you want
            {
                climbing = false;
				_jump += FlxG.elapsed;
                if(_jump > 0.25) _jump = -1; //You can't jump for more than 0.25 seconds
            }
            else _jump = -1;
 
            if (_jump > 0)
            {
                if(_jump < 0.035)   // this number is how long before a short slow jump shifts to a faster, high jump
                    velocity.y = -.6 * maxVelocity.y; //This is the minimum height of the jump
					
				else 
					velocity.y = -.8 * maxVelocity.y;
            }
			//Shooting
			if (FlxG.keys.X)
			{
				shoot();  //Let's put the shooting code in its own function to keep things organized
			}
			//Animation

			if (velocity.x > 0 || velocity.x <0 ) { play("walking"); }
			else if (!velocity.x) { play("idle"); }
			if (velocity.y<0) { play("jump"); }
			
			_cooldown += FlxG.elapsed;
			
			// Don't let helmuguy walk off the edge of the map
			if (x <= 0)
			x = 0;
			if ((x+width) > _parent.map.width)
			x = _parent.map.width - width;
			
			_xgridleft = int((x +3) / 16);   // Convert pixel positions to grid positions. int and floor are functionally the same, 
			_xgridright = int((x+width - 3) / 16);
			_ygrid = int((y+height-1) / 16);   // but I hear int is faster so let's go with that.
			
			if (_parent.ladders.getTile(_xgridleft,_ygrid)&&_parent.ladders.getTile(_xgridright,_ygrid)) {_onladder = true;}
			else 
			{
				_onladder = false;
				climbing = false;
			}
			if (climbing)
				{
					collideTop = false;
					collideBottom = false;
				}
			else
				{
					collideTop = true;
					collideBottom = true;
				}
			
			super.update();
		}
		
		private function shoot():void 
		{
			// Prepare some variables to pass on to the bullet
			var bulletX:int = x;
			var bulletY:int = y+4;
			var bXVeloc:int = 0;
			var bYVeloc:int = 0;
			
			if (_cooldown >= GUN_DELAY)
			{
			_blt = _bullets.getFirstAvail() as Bullet;	
			
			if (_blt)
			{
					if (facing == LEFT)
					{
						bulletX -= _blt.width-8; // nudge it a little to the side so it doesn't emerge from the middle of helmutguy
						bXVeloc = -BULLET_SPEED;
					}
					else
					{
						bulletX += width-8;
						bXVeloc = BULLET_SPEED;
					}
					_blt.shoot(bulletX, bulletY, bXVeloc, bYVeloc);
					FlxG.play(sndShoot, 1, false,50);
					_cooldown = 0; // reset the shot clock
				}
			}
		}
		
		override public function overlaps(Object:FlxObject):Boolean 
		{
			if (!(Object.dead))
				return super.overlaps(Object);
			else
				return false;
		}
		
		override public function hitBottom(Contact:FlxObject, Velocity:Number):void 
		{
            if (!FlxG.keys.C) // Don't let the player jump until he lets go of the button
			_jump = 0;
			_canDJump = true;  // Reset the double jump flag
            super.hitBottom(Contact, Velocity);
        }
		
		override public function kill():void
		{
			if (dead) { return; }
			//solid = false;
			super.kill();
			//exists = false;
			//visible = false;
			FlxG.quake.start(0.005, .35);
			FlxG.flash.start(0xffDB3624, .35);
			if (_gibs != null)
			{
				_gibs.at(this);
				_gibs.start(true, 2.80);
			}
			FlxG.play(sndDeath, 1, false,50);
		}
	}
}
	