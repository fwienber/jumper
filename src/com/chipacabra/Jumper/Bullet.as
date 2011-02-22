package com.chipacabra.Jumper 
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author David Bell
	 */
	public class Bullet extends FlxSprite 
	{
		[Embed(source = '../../../../art/bullet.png')]public var ImgBullet:Class;

		
		
		public function Bullet() 
		{
			super();
			loadGraphic(ImgBullet, false);
			exists = false; // We don't want the bullets to exist anywhere before we call them.
		}
		
		override public function update():void 
		{
			if (dead && finished) //Finished refers to animation, only included here in case I add animation later
				exists = false;   // Stop paying attention when the bullet dies. 
			if (getScreenXY().x < -64 || getScreenXY().x > FlxG.width+64) { kill();} // If the bullet makes it 64 pixels off the side of the screen, kill it
			else super.update();
		}
		
		//We want the bullet to go away when it hits something, not just stop.
		override public function hitSide(Contact:FlxObject,Velocity:Number):void { kill(); }
		override public function hitBottom(Contact:FlxObject,Velocity:Number):void { kill(); }
		override public function hitTop(Contact:FlxObject,Velocity:Number):void { kill(); }
		
		// We need some sort of function other classes can call that will let us actually fire the bullet. 
		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int):void
		{
			super.reset(X, Y);  // reset() makes the sprite exist again, at the new location you tell it.
			solid = true;
			velocity.x = VelocityX;
			velocity.y = VelocityY;
		}
		
		public function angleshoot(X:int, Y:int, Speed:int, Target:FlxPoint):void
		{
			super.reset(X, Y);
			solid = true;
			var dangle:Number = FlxU.getAngle(Target.x-(x+(width/2)), Target.y-(y+(height/2)));  //This gives angle in degrees
			var rangle:Number = dangle * (Math.PI / 180);          //We need it in radians
			velocity.x = Math.cos(rangle) * Speed;
			velocity.y = Math.sin(rangle) * Speed;
		}
		
	}

}