package com.chipacabra.Jumper 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author David Bell
	 */
	public class Coin extends FlxSprite 
	{
		[Embed(source = '../../../../art/coinspin.png')]public var imgCoin:Class;
		[Embed(source = '../../../../sounds/coin.mp3')]public var sndCoin:Class;
		public function Coin(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y);
			
			loadGraphic(imgCoin, true, false);
			addAnimation("spinning", [0, 1, 2, 3, 4, 5], 10, true);
			play("spinning");
		}
		
		override public function kill():void 
		{
			super.kill();
			FlxG.play(sndCoin, 3, false, 50);
			FlxG.score++;
		}
	}

}