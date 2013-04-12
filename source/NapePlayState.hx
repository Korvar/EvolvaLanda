package ;

import org.flixel.FlxG;
import org.flixel.nape.FlxPhysSprite;
import org.flixel.nape.FlxPhysState;
import org.flixel.FlxPoint;
import org.flixel.FlxText;

/**
 * ...
 * @author Mike Cugley
 */
class NapePlayState extends FlxPhysState
{

	public function new() 
	{
		super();
	}
	
	override public function create():Void
	{ 
		#if debug
		// FlxG.watch(this, "messageString");

		var debugString:FlxText = new FlxText(0, 0, FlxG.width, "test");
		debugString.color = 0xFFFFFF;
		Registry.debugString = debugString;
		debugString.scrollFactor = (new FlxPoint(0, 0));
		add(debugString);
		#end		
			
		super.create();
		FlxG.mouse.show();
		// Sets gravity.
		FlxPhysState.space.gravity.setxy(0, 100);  // Moon gravity!
		// FlxPhysState shortcut to create bondaries around game area. 
		createWalls();
		// Creates 50 FlxPhysSprites randomly positioned.
		//for (i in 0...50) 
		//{
			//var startX = 30 + Std.random(FlxG.width - 60); // initial x between 30 and 370.
			//var startY = 30 + Std.random(FlxG.height - 60); // initial y between 30 and 370.
		   //
			//add ( new FlxPhysSprite(startX, startY ));
		//}
		
		var lander:NapeLander = new NapeLander(FlxG.width / 2, 100);
		add(lander);
	}
		   
	override public function update():Void
	{ 
		super.update();
		 
		if (FlxG.mouse.justPressed())
			FlxG.resetState();
	}
}