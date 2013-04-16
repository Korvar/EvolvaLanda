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
	
	var buttonLeft:FlxButton;
	var buttonRight:FlxButton;
	var buttonUp:FlxButton;
	var buttonDown:FlxButton;
	var buttonA:FlxButton;
	
	public var zoomCamera:ZoomCamera;
	var defaultZoom:Float = 0.6;
	var landingZoom:Float = 3.0;
	
	
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
		debugString.cameras = [FlxG.camera];
		add(debugString);
		#end		
			
		super.create();
		#if mobile
		FlxG.mouse.hide();
		#end
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
		   newSprite.makeGraphic(16, 16, 0xFFFFFFFF);
			add (newSprite);
			if (i == 0)
			{
				FlxG.watch(newSprite, "frameWidth");
			}
		}
		
		lander = new NapeLander(1000, 300);
		add(lander);
		
		zoomCamera = new ZoomCamera(0, 0, FlxU.floor(FlxG.width / defaultZoom), FlxU.floor(FlxG.height / defaultZoom), defaultZoom);
		zoomCamera.targetZoom = defaultZoom;
		FlxG.camera.zoom = defaultZoom;
		FlxG.camera.antialiasing = true;
		//FlxG.resetCameras(zoomCamera);
		FlxG.camera.follow(lander);
		zoomCamera.follow(lander);
		zoomCamera.antialiasing = true;
		FlxG.addCamera(zoomCamera);


		FlxG.camera.setBounds(Registry.worldMinX, Registry.worldMinY, Registry.worldMaxX, Registry.worldMaxY, true);	
				
		var landscape:NapeLandscape = new NapeLandscape(0, 0);
		add(landscape);
		
		focusPoint = new FlxPoint(lander.x, lander.y);
		
		hud = new FlxGroup();
		buttonLeft = new FlxButton(10, 0, null);
		buttonRight = new FlxButton(110, 0, null);
		buttonUp = new FlxButton(60, - 50, null);
		buttonDown = new FlxButton(60, 50, null);
		buttonA = new FlxButton(FlxG.width - 60, 0, null);
		buttonLeft.loadGraphic("assets/data/button_left.png", true, false, 44, 45);
		buttonRight.loadGraphic("assets/data/button_right.png", true, false, 44, 45);
		buttonUp.loadGraphic("assets/data/button_up.png", true, false, 44, 45);
		buttonDown.loadGraphic("assets/data/button_down.png", true, false, 44, 45);
		buttonA.loadGraphic("assets/data/button_a.png", true, false, 44, 45);
		buttonLeft.scrollFactor = buttonRight.scrollFactor = buttonUp.scrollFactor = buttonDown.scrollFactor = buttonA.scrollFactor = new FlxPoint(0, 0);
		hud.add(buttonLeft);
		hud.add(buttonRight);
		hud.add(buttonUp);
		hud.add(buttonDown);
		hud.add(buttonA);

		var maxX:Float=-2000;
		var minX:Float = 0;
		var minY:Float = 0;
		var maxY:Float = -2000;
		var numPoints:Int = 0;
		for (i in hud.members)
		{
			var thisButton:FlxButton = cast(i, FlxButton);
			thisButton.x -= 1000;
			thisButton.y -= 1000;
			
			if (thisButton.x > maxX)
			{
				maxX = thisButton.x;
			}
			if (thisButton.x < minX)
			{
				minX = thisButton.x;
			}
			if (thisButton.y > maxY)
			{
				maxY = thisButton.y;
			}
			if (thisButton.y < minY)
			{
				minY = thisButton.y;
			}
			
			numPoints ++;
		}
		
		var meanX:Float = (minX + maxX) / numPoints;
		var meanY:Float = (minY + maxY) / numPoints;
		
		add(hud);
		
		Registry.buttonUp = buttonUp;
		Registry.buttonDown = buttonDown;
		Registry.buttonLeft = buttonLeft;
		Registry.buttonRight = buttonRight;
		
		var hudCamera:FlxCamera = new FlxCamera(0, FlxU.floor((FlxG.height * 4 / 5) - 50), FlxU.floor(FlxG.width), FlxU.floor((FlxG.height / 5) + 50));
		hudCamera.follow(buttonA);
		hudCamera.bgColor = 0x00ffffff;
		FlxG.addCamera(hudCamera);
		


	}
		   
	override public function update():Void
	{ 
		super.update();
		
 
		if (buttonA.status == FlxButton.PRESSED || FlxG.keys.justPressed("R"))
			FlxG.resetState();
			
				
		if (FlxG.keys.justPressed("Z"))
		{
			if (FlxG.camera.zoom == defaultZoom)
			{
				FlxG.camera.zoom = landingZoom;
				FlxG.camera.width = FlxU.floor(FlxG.width * landingZoom);
				FlxG.camera.height = FlxU.floor(FlxG.height * landingZoom);
				FlxG.camera.bgColor = 0xff000000;
				FlxG.updateCameras();
				
				zoomCamera.targetZoom = landingZoom;

			}
			else
			{
				FlxG.camera.zoom = defaultZoom;
				FlxG.camera.width = FlxU.floor(FlxG.width);
				FlxG.camera.height = FlxU.floor(FlxG.height);
				FlxG.updateCameras();
				
				zoomCamera.targetZoom = defaultZoom;

			}
		}
		
		if (FlxG.keys.justPressed("G"))
		{
			disablePhysDebug();
		}
	}
}