package com.chipacabra.Jumper
{
	import org.flixel.*;
 
	public class PlayState extends FlxState
	{
		[Embed(source = '../../../../levels/mapCSV_Group1_Map1.csv', mimeType = 'application/octet-stream')]public var levelMap:Class;
		[Embed(source = '../../../../levels/mapCSV_Group1_Map1back.csv', mimeType = 'application/octet-stream')]public var backgroundMap:Class;
		[Embed(source = '../../../../levels/mapCSV_Group1_Ladders.csv', mimeType = 'application/octet-stream')]public var laddersMap:Class;
		[Embed(source = '../../../../data/monstacoords.csv', mimeType = 'application/octet-stream')]public var monstaList:Class;
		[Embed(source = '../../../../data/lurkcoords.csv', mimeType = 'application/octet-stream')]public var lurkList:Class;
		[Embed(source = '../../../../data/coins.csv', mimeType = 'application/octet-stream')]public var coinList:Class;
		
		[Embed(source = '../../../../art/area02_level_tiles2.png')]public var levelTiles:Class;
		[Embed(source = '../../../../art/lizgibs.png')]public var imgLizGibs:Class;
		[Embed(source = '../../../../art/spikegibs.png')]public var imgSpikeGibs:Class;
		[Embed(source = '../../../../music/ScrollingSpace[1].mp3')]public var bgMusic:Class;

		
		public var map:FlxTilemap = new FlxTilemap;
		public var background:FlxTilemap = new FlxTilemap;
		public var ladders:FlxTilemap = new FlxTilemap;
		public var player:Player;
		//public var skelmonsta:Enemy;

		
		protected var _gibs:FlxEmitter;
		protected var _mongibs:FlxEmitter;
		protected var _bullets:FlxGroup;
		protected var _badbullets:FlxGroup;
		protected var _restart:Boolean;
		protected var _text1:FlxText;
		protected var _enemies:FlxGroup;
		protected var _coins:FlxGroup;
		protected var _score:FlxText;
		
		override public function create():void
		{
			_restart = false;
			// Set up the game over text
			_text1 = new FlxText(30, 30, 400, "Press R to Restart");
			_text1.visible = false;
			_text1.size = 40;
			_text1.color = 0xFFFF0000;
			_text1.antialiasing = true;
			_text1.scrollFactor.x = _text1.scrollFactor.y = 0;
			
			// Set up the gibs
			_gibs= new FlxEmitter();
			_gibs.delay = 3;
			_gibs.setXSpeed( -150, 150);
			_gibs.setYSpeed( -200, 0);
			_gibs.setRotation( -720, 720);
			_gibs.createSprites(imgLizGibs, 25, 15, true, .5, 0.65);
			
			_mongibs = new FlxEmitter();
			_mongibs.delay = 3;
			_mongibs.setXSpeed( -150, 150);
			_mongibs.setYSpeed( -200, 0);
			_mongibs.setRotation( -720, 720);
			_mongibs.createSprites(imgSpikeGibs, 25, 15, true, .5, .65);
			
			// Create the actual group of bullets here
			_bullets = new FlxGroup;
			_badbullets = new FlxGroup;
			
			add(background.loadMap(new backgroundMap, levelTiles, 16, 16));
			background.scrollFactor.x = background.scrollFactor.y = .5;
			
			add(map.loadMap(new levelMap, levelTiles, 16, 16));
			add(ladders.loadMap(new laddersMap, levelTiles, 16, 16));
			
			FlxU.setWorldBounds(0, 0, map.width, map.height);
			
			add(player = new Player(112, 92,this,_gibs,_bullets));
			
			FlxG.follow(player,1); // Attach the camera to the player. The number is how much to lag the camera to smooth things out
			FlxG.followAdjust(0,0); // Adjust the camera speed with this
			FlxG.followBounds(0, 0, 1600, 800);
			
			//add(skelmonsta = new Enemy(1260, 640, player, _mongibs));// I used DAME to find the coordinates I want.
			
			// Set up the enemies here
			_enemies = new FlxGroup;
			placeMonsters(new monstaList, Enemy);
			placeMonsters(new lurkList, Lurker);
			
			_coins = new FlxGroup;
			placeCoins(new coinList, Coin);
			
			add(_coins);
			add(_enemies);
			
			FlxG.score = 0;
			
			super.create();
			
			// Set up the individual bullets
			for (var i:uint = 0; i < 4; i++)    // Allow 4 bullets at a time
				_bullets.add(new Bullet());
			add(_badbullets);
			add(_bullets); 
			add(_gibs);
			add(_mongibs);
			
			
			//HUD - score
			var ssf:FlxPoint = new FlxPoint(0,0);
			_score = new FlxText(0,0,FlxG.width);
			_score.color = 0xFFFF00;
			_score.size = 16;
			_score.alignment = "center";
			_score.scrollFactor = ssf;
			_score.shadow = 0x131c1b;
			add(_score);
			
			add(_text1); // Add last so it goes on top, you know the drill.
			
			FlxG.playMusic(bgMusic, .5);
		}
		
		override public function update():void 
		{
			super.update();
			player.collide(map);
			_enemies.collide(map);
			_gibs.collide(map);
			_bullets.collide(map);
			_badbullets.collide(map);
			
			_score.text = '$' + FlxG.score.toString();
			
			if (FlxG.keys.justPressed("B"))
			{
				FlxG.showBounds = !FlxG.showBounds;
			}
			if (player.dead)
			{
				_text1.visible = true;
				if (FlxG.keys.justPressed("R")) _restart = true;
			}
			
			//Check for impact!
/*			if (player.overlaps(_enemies))
			{
				player.kill(); // This should probably be more interesting
			}*/
			
			FlxU.overlap(player, _enemies, hitPlayer);
			FlxU.overlap(_bullets, _enemies, hitmonster);
			FlxU.overlap(player, _coins, collectCoin);
			FlxU.overlap(player, _badbullets, hitPlayer);
			
			if (_restart) FlxG.state = new PlayState;
			
		}
		
		private function collectCoin(P:FlxObject, C:FlxObject):void 
		{
			C.kill();
		}
		
		private function hitPlayer(P:FlxObject,Monster:FlxObject):void 
		{
			if (Monster is Bullet)
				Monster.kill();
			if (Monster.health >0)
				P.hurt(1); // This should still be more interesting
		}
		
		private function hitmonster(Blt:FlxObject, Monster:FlxObject):void 
		{
			if (Monster.dead) { return;}  // Just in case
			if (Monster.health > 0) 
			{
				Blt.kill();
				Monster.hurt(1);
			}
		}
		
		private function placeMonsters(MonsterData:String, Monster:Class):void
		{
			var coords:Array;
			var entities:Array = MonsterData.split("\n");   // Each line becomes an entry in the array of strings
			for (var j:int = 0; j < entities.length; j++) 
			{
				coords = entities[j].split(",");  //Split each line into two coordinates
				if (Monster == Enemy)
				{_enemies.add(new Monster(uint(coords[0]), uint(coords[1]), player, _mongibs)); }
				else if (Monster == Lurker)
				{ _enemies.add(new Monster(uint(coords[0]), uint(coords[1]), player, _badbullets));}
				else if (Monster!=null)
				{ _enemies.add(new Monster(uint(coords[0]), uint(coords[1]), player));}
			}
		}
		
		private function placeCoins(CoinData:String, Sparkle:Class):void 
		{
			var coords:Array;
			var entities:Array = CoinData.split("\n");   // Each line becomes an entry in the array of strings
			for (var j:int = 0; j < entities.length; j++) 
			{
				coords = entities[j].split(",");  //Split each line into two coordinates
				if (Sparkle == Coin)
				{_coins.add(new Coin(uint(coords[0]), uint(coords[1]))); }
			}
		}
	}
}