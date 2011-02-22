package com.chipacabra.Jumper 
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author David Bell
	 */
	public class Enemy extends EnemyTemplate 
	{
		[Embed(source = '../../../../art/spikemonsta.png')]public var Spikemonsta:Class;
		[Embed(source = '../../../../sounds/monhurt2.mp3')]public var sndHurt:Class;
		[Embed(source = '../../../../sounds/mondead2.mp3')]public var sndDead:Class;
		
		protected static const RUN_SPEED:int = 60;
		protected static const GRAVITY:int =0;
		protected static const JUMP_SPEED:int = 60;
		protected static const HEALTH:int = 1;
		protected static const SPAWNTIME:Number = 30;
		
		//protected var _player:Player;
		protected var _gibs:FlxEmitter;
		//protected var _startx:Number;
		//protected var _starty:Number;
		protected var _spawntimer:Number;
		
		public function Enemy(X:Number, Y:Number, ThePlayer:Player, Gibs:FlxEmitter) 
		{
			super(X, Y,ThePlayer);
			
			// These will let us reset the monster later
			//_startx = X;
			//_starty = Y;
			_spawntimer = 0;
			
			loadGraphic(Spikemonsta, true, true);  //Set up the graphics
			addAnimation("walking", [0, 1], 10, true);
			addAnimation("idle", [0]);
			//_player = ThePlayer;
			
			drag.x = RUN_SPEED * 7;
			drag.y = JUMP_SPEED * 7;
			acceleration.y = GRAVITY;
			maxVelocity.x = RUN_SPEED;
			maxVelocity.y = JUMP_SPEED;
			health = HEALTH;
			
			_gibs = Gibs;
			
		}
		
		public override function update():void
		{
			if (dead)
			{
				_spawntimer += FlxG.elapsed;
				if (_spawntimer >= SPAWNTIME)
					{
						reset(_startx,_starty);
					}
			return;
			}
			
			acceleration.x = acceleration.y = 0; // Coast to 0 when not chasing the player
			
			var xdistance:Number = _player.x - x; // distance on x axis to player
			var ydistance:Number = _player.y - y; // distance on y axis to player
			var distancesquared:Number = xdistance * xdistance + ydistance * ydistance; // absolute distance to player (squared, because there's no need to spend cycles calculating the square root)
			if (distancesquared < 65000) // that's somewhere around 16 tiles
			{
				if (_player.x < x)
				{
					facing = RIGHT; // The sprite is facing the opposite direction than flixel is expecting, so hack it into the right direction
					acceleration.x = -drag.x;
				}
				else if (_player.x > x)
				{
					facing = LEFT;
					acceleration.x = drag.x;
				}
				if (_player.y < y) { acceleration.y = -drag.y; }
				else if (_player.y > y) { acceleration.y = drag.y;}
			}
			//Animation
			if (!velocity.x && !velocity.y) { play("idle"); }
			else {play("walking");}
			
			super.update();
		}
		
		override public function reset(X:Number, Y:Number):void 
		{
			super.reset(X, Y);
			health = HEALTH;
			_spawntimer = 0;
		}
		
		override public function hurt(Damage:Number):void 
		{
			if (facing == RIGHT) // remember, right means facing left
				velocity.x = drag.x * 4; // Knock him to the right
			else if (facing == LEFT) // Don't really need the if part, but hey.
				velocity.x = -drag.x * 4;
			flicker(.5);
			FlxG.play(sndHurt, 1, false,50)
			super.hurt(Damage);
		}
		
		override public function kill():void 
		{
			if (dead) { return; }
			
			if (_gibs != null)
			{
				_gibs.at(this);
				_gibs.start(true, 2.80);
				FlxG.play(sndDead, 1, false,50);
			}
			super.kill();
			//We need to keep updating for the respawn timer, so set exists back on.
			exists = true;
			visible = false;
			//Shove it off the map just to avoid any accidents before it respawns
			x = -10;
			y = -10;
		}
		
	
	}

}