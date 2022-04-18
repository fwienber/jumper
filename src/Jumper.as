package
{
	import org.flixel.*; //Allows you to refer to flixel objects in your code
	import com.chipacabra.Jumper.*;
	[SWF(width = "640", height = "480", backgroundColor = "#000000")] //Set the size and color of the Flash file
  
  [Rename("com.chipacabra.Jumper.Jumper")]
	public class Jumper extends FlxGame
	{
		public function Jumper():void
		{
			super(640, 480, MenuState, 1); //Create a new FlxGame object at 640x480 with 1x pixels, then load MenuState
			FlxState.bgColor = 0xFF101414;
		}
	}
}