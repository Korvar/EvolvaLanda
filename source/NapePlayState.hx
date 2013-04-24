package ;

import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import org.flixel.FlxButton;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
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
	
	var mouseJoint:PivotJoint;
	
	var hud:FlxGroup;
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void
	{ 
		#if debug

		var debugString:FlxText = new FlxText(0, 0, FlxG.width, "test");
		debugString.size = 15;
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
		#if debug debugString.cameras = [FlxG.camera, zoomCamera]; #end

		FlxG.camera.setBounds(Registry.worldMinX, Registry.worldMinY, Registry.worldMaxX, Registry.worldMaxY, true);	
				
		var landscape:NapeLandscape = new NapeLandscape(0, 0);
		add(landscape);
		
		// Creates 500 "stars" randomly positioned.
		for (i in 0...500) 
		{
			var minX:Int = Std.int(Registry.worldMinX);
			var worldWidth:Int = Std.int(Registry.worldMaxX - Registry.worldMinX);
			var startX = minX + 30 + Std.random((worldWidth - 60)); 
			var minY:Int = Std.int(Registry.worldMinY);
			var worldHeight:Int = Std.int(Registry.worldMaxY - Registry.worldMinY);
			var startY = minY + 30 + Std.random((worldHeight - 60)); 
			var newSprite:FlxSprite = new FlxSprite(Std.int(startX), Std.int(startY) );
			newSprite.makeGraphic(2, 2, 0xFFFFFFFF);
			add (newSprite);
		}		
		
		focusPoint = new FlxPoint(lander.x, lander.y);
		

		hud = new FlxGroup();
		buttonLeft = new FlxButton(10, 50, null);
		buttonRight = new FlxButton(110, 50, null);
		buttonUp = new FlxButton(60, 0, null);
		buttonDown = new FlxButton(60, 100, null);
		buttonA = new FlxButton(FlxG.width - 60, 50, null);
		buttonLeft.loadGraphic("assets/data/button_left.png", true, false, 44, 45);
		buttonRight.loadGraphic("assets/data/button_right.png", true, false, 44, 45);
		buttonUp.loadGraphic("assets/data/button_up.png", true, false, 44, 45);
		buttonDown.loadGraphic("assets/data/button_down.png", true, false, 44, 45);
		buttonA.loadGraphic("assets/data/button_a.png", true, false, 44, 45);
		buttonLeft.scrollFactor = buttonRight.scrollFactor = buttonUp.scrollFactor = buttonDown.scrollFactor = buttonA.scrollFactor = new FlxPoint(0, 0);
		Registry.buttonUp = buttonUp;
		Registry.buttonDown = buttonDown;
		Registry.buttonLeft = buttonLeft;
		Registry.buttonRight = buttonRight;
		
		hud.add(buttonLeft);
		hud.add(buttonRight);
		hud.add(buttonUp);
		hud.add(buttonDown);
		hud.add(buttonA);

		var maxX:Float=-2000;
		var minX:Float = 2000;
		var minY:Float = 2000;
		var maxY:Float = -2000;
		var numPoints:Int = 0;

		var hudCamera:FlxCamera = new FlxCamera(0, FlxU.floor((FlxG.height * 4 / 5) - 50), FlxU.floor(FlxG.width), FlxU.floor((FlxG.height / 5) + 100));

		for (i in hud.members)
		{
			var thisButton:FlxButton = cast(i, FlxButton);
			#if android
			//thisButton.x -= 500;
			//thisButton.y -= 75;
			#end
			
			thisButton.cameras = [hudCamera];
			
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
		

		

		
		//hudCamera.follow(buttonA);
		hudCamera.y = FlxG.height - (maxY - minY) - Std.int(buttonDown.height);
		#if android
		hudCamera.y -= 75;
		#end
		hudCamera.height = Std.int((maxY - minY) + buttonDown.height);
		hudCamera.focusOn(new FlxPoint(meanX, meanY - 50));
		hudCamera.setBounds(minX, minY - 100, maxX, maxY);
		hudCamera.bgColor = 0x00000000;

		#if mobile
		FlxG.addCamera(hudCamera);
		add(hud);
		#end
		
		
		mouseJoint = new PivotJoint(FlxPhysState.space.world, null, Vec2.weak(), Vec2.weak());
		mouseJoint.space = FlxPhysState.space;
		mouseJoint.active = false;
		mouseJoint.stiff = false;
		
		disablePhysDebug();
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
		
		if (mouseJoint.active) 
		{
			mouseJoint.anchor1.setxy(FlxG.mouse.x, FlxG.mouse.y);
		}
		
		if (FlxG.mouse.justPressed())
		{
			var mousePoint:Vec2 = Vec2.get(FlxG.mouse.x, FlxG.mouse.y);
			for (body in FlxPhysState.space.bodiesUnderPoint(mousePoint))
			{
				if (!body.isDynamic())
				{
					continue;
				}
				mouseJoint.body2 = body;
				mouseJoint.anchor2.set(body.worldPointToLocal(mousePoint, true));
				mouseJoint.active = true;
				break;
			}
			mousePoint.dispose();
		}
		
		if (FlxG.mouse.justReleased())
		{
			mouseJoint.active = false;
		}
			
	}
}