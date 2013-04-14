package ;

import org.flixel.FlxButton;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
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
	
	var buttonLeft:FlxButton;
	var buttonRight:FlxButton;
	var buttonUp:FlxButton;
	var buttonDown:FlxButton;
	var buttonA:FlxButton;
	
	var hud:FlxGroup;
	
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
		   // newSprite.makeGraphic(32, 32, 0xFFFFFFFF);
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
		minimapCamera.follow(lander, FlxCamera.STYLE_LOCKON);
		minimapCamera.setBounds(Registry.worldMinX, Registry.worldMinY, Registry.worldMaxX, Registry.worldMaxY);
		FlxG.addCamera(minimapCamera);
		minimapCamera.color = 0xFFCCCC;
		
		hud = new FlxGroup();
		buttonLeft = new FlxButton(10, FlxG.height * 4 / 5, null);
		buttonRight = new FlxButton(110, FlxG.height * 4 / 5, null);
		buttonUp = new FlxButton(60, (FlxG.height * 4 / 5) - 50, null);
		buttonDown = new FlxButton(60, (FlxG.height * 4 / 5) + 50, null);
		buttonA = new FlxButton(FlxG.width - 60, FlxG.height * 4 / 5, null);
		buttonLeft.loadGraphic("assets/data/button_left.png", true, false, 44, 45);
		buttonRight.loadGraphic("assets/data/button_right.png", true, false, 44, 45);
		buttonUp.loadGraphic("assets/data/button_up.png", true, false, 44, 45);
		buttonDown.loadGraphic("assets/data/button_down.png", true, false, 44, 45);
		buttonA.loadGraphic("assets/data/button_a.png", true, false, 44, 45);
		buttonLeft.scrollFactor = buttonRight.scrollFactor = buttonUp.scrollFactor = buttonDown.scrollFactor = buttonA.scrollFactor = new FlxPoint(0, 0);
		buttonLeft.alpha = buttonRight.alpha = buttonUp.alpha = buttonDown.alpha = buttonA.alpha = 0.5;
		hud.add(buttonLeft);
		hud.add(buttonRight);
		hud.add(buttonUp);
		hud.add(buttonDown);
		hud.add(buttonA);
		
		Registry.buttonUp = buttonUp;
		Registry.buttonDown = buttonDown;
		Registry.buttonLeft = buttonLeft;
		Registry.buttonRight = buttonRight;
		
		
		add(hud);
	}
		   
	override public function update():Void
	{ 
		super.update();
		
		focusPoint.x = lander.x;
		focusPoint.y = lander.y;
		
		minimapCamera.focusOn(focusPoint);
		
		 
		if (buttonA.status == FlxButton.PRESSED)
			FlxG.resetState();
	}
}