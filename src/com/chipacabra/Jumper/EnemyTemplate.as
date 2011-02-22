package com.chipacabra.Jumper 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author David Bell
	 */
	public class EnemyTemplate extends FlxSprite 
	{
		
		protected var _player:Player;
		protected var _startx:Number;
		protected var _starty:Number;
		
		public function EnemyTemplate(X:Number, Y:Number, ThePlayer:Player) 
		{
			super(X, Y);
			_startx = X;
			_starty = Y;
			_player = ThePlayer;
		}
		
	}

}