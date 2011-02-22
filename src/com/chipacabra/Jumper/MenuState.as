package com.chipacabra.Jumper 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author David Bell
	 */
	public class MenuState extends FlxState 
	{
		[Embed(source = '../../../../art/pointer.png')]public var imgPoint:Class;
		
		[Embed(source = '../../../../sounds/coin.mp3')]public var sndClick:Class;
		[Embed(source = '../../../../sounds/menu.mp3')]public var sndPoint:Class;

		static public const OPTIONS:int=3; //How many menu options there are.
		static public const TEXT_SPEED:Number=200;
		
		private var _text1:FlxText;
		private var _text2:FlxText;
		private var _text3:FlxText;
		private var _text4:FlxText;
		private var _text5:FlxText;  // augh so many text objects. I should make arrays.
		private var _pointer:FlxSprite;
		private var _option:int;     // This will indicate what the pointer is pointing at
		
		override public function create():void 
		{
			//Each word is its own object so we can position them independantly
			//_text1 = new FlxText(FlxG.width/5, FlxG.height / 4, 320, "Project");
			_text1 = new FlxText(-220, FlxG.height / 4, 320, "Project");
			_text1.size = 40;
			_text1.color = 0xFFFF00;
			_text1.antialiasing = true;
			add(_text1);
			
			//Base everything off of text1, so if we change color or size, only have to change one
			//_text2 = new FlxText(FlxG.width / 2.5, FlxG.height / 2.5, 320, "Jumper");
			_text2 = new FlxText(FlxG.width-50, FlxG.height / 2.5, 320, "Jumper");
			_text2.size = _text1.size;
			_text2.color = _text1.color;
			_text2.antialiasing = _text1.antialiasing;
			add(_text2);
			
			//Set up the menu options
			_text3 = new FlxText(FlxG.width * 2 / 3, FlxG.height * 2 / 3, 150, "Play");
			_text4 = new FlxText(FlxG.width * 2 / 3, FlxG.height * 2 / 3+30, 150, "Visit NIWID");
			_text5 = new FlxText(FlxG.width * 2 / 3, FlxG.height * 2 / 3 + 60, 150, "Visit flixel.org");
			_text3.color = _text4.color = _text5.color =0xAAFFFF00; 
			_text3.size = _text4.size = _text5.size =16;
			_text3.antialiasing = _text4.antialiasing=_text5.antialiasing=true;
			add(_text3);
			add(_text4);
			add(_text5);
			
			_pointer = new FlxSprite();
			_pointer.loadGraphic(imgPoint);
			_pointer.x = _text3.x - _pointer.width - 10;
			add(_pointer);
			_option = 0;
			super.create();
		}
		
		override public function update():void 
		{
			if (_text1.x < FlxG.width / 5)	_text1.velocity.x = TEXT_SPEED;
			else _text1.velocity.x = 0;
			if (_text2.x > FlxG.width / 2.5) _text2.velocity.x = -TEXT_SPEED;
			else _text2.velocity.x = 0;
			
			switch(_option)    // this is the goofus way to do it. An array would be way better
			{
				case 0:
				_pointer.y = _text3.y;
				break;
				case 1:
				_pointer.y = _text4.y;
				break;
				case 2:
				_pointer.y = _text5.y;
				break;
			}
			if (FlxG.keys.justPressed("UP"))
				{
					_option = (_option +OPTIONS- 1) % OPTIONS;  // A goofy format, because % doesn't work on negative numbers
					FlxG.play(sndPoint, 1, false, 50);
				}
			if (FlxG.keys.justPressed("DOWN"))
				{
					_option = (_option +OPTIONS + 1) % OPTIONS;
					FlxG.play(sndPoint, 1, false, 50);
				}
			if (FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("ENTER"))
				switch (_option) 
				{
					case 0:
					FlxG.fade.start(0xFF969867, 1, startGame);
					FlxG.play(sndClick, 1, false, 50);
					break;
					case 1:
					onURL();
					break;
					case 2:
					onFlixel()
					break;
				}
			
			super.update();
		}
		
		private function onFlixel():void 
		{
			FlxU.openURL("http://flixel.org");
		}
		
		
		private function onURL():void 
		{
			FlxU.openURL("http://chipacabra.blogspot.com");
		}
		
		private function startGame():void
		{
			FlxG.state = new PlayState;
		}
	}
}