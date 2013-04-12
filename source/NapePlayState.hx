package ;

import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxU;
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

	var lander:NapeLander;
	var focusPoint:FlxPoint;
	var minimapCamera:FlxCamera;
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void
	{ 
		#if debug

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
		createWalls(Registry.worldMinX, Registry.worldMinY, Registry.worldMaxX, Registry.worldMaxY);
		// Creates 50 FlxPhysSprites randomly positioned.
		for (i in 0...50) 
		{
			var startX = 30 + Std.random(FlxG.width - 60); // initial x between 30 and 370.
			var startY = 30 + Std.random(FlxG.height - 60); // initial y between 30 and 370.
		   var newSprite:FlxPhysSprite = new FlxPhysSprite(startX, startY );
		   newSprite.makeGraphic(32, 32, 0xFFFFFFFF);
			add (newSprite);
		}
		
		lander = new NapeLander(FlxG.width / 2, 100);
		add(lander);
		FlxG.camera.follow(lander);
		FlxG.camera.setBounds(Registry.worldMinX, Registry.worldMinY, Registry.worldMaxX, Registry.worldMaxY, true);		
		var landscape:NapeLandscape = new NapeLandscape(0, 0);
		add(landscape);
		
		focusPoint = new FlxPoint(lander.x, lander.y);
		
		minimapCamera = new FlxCamera(FlxU.floor(FlxG.width * 3 / 4), 0, FlxU.floor(FlxG.width / 2), FlxU.floor(FlxG.height / 2), 0.5);
		minimapCamera.follow(lander);
		minimapCamera.setBounds(Registry.worldMinX, Registry.worldMinY, Registry.worldMaxX, Registry.worldMaxY);
		FlxG.addCamera(minimapCamera);
		minimapCamera.color = 0xFFCCCC;
	}
		   
	override public function update():Void
	{ 
		super.update();
		
		focusPoint.x = lander.x;
		focusPoint.y = lander.y;
		
		minimapCamera.focusOn(focusPoint);
		
		 
		if (FlxG.mouse.justPressed())
			FlxG.resetState();
	}
}