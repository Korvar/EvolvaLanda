package ;

import nape.callbacks.CbType;
import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import org.flixel.FlxButton;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
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
	
	#if debug
	var debugHud:FlxGroup;
	var thrustMaxText:FlxText;
	var thrustDeltaText:FlxText;
	var maneuverJetThrustText:FlxText;
	var weldStrengthText:FlxText;
	var gravityText:FlxText;
	#end
	
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
		
		Registry.LANDSCAPE = new CbType();
		Registry.PROXIMITYDETECTOR = new CbType();
		
		
		
		// Sets gravity.
		FlxPhysState.space.gravity.setxy(0, 100);  // Moon gravity!
		
		// FlxPhysState shortcut to create bondaries around game area. 
		createWalls(Registry.worldMinX, Registry.worldMinY, Registry.worldMaxX, Registry.worldMaxY);

		zoomCamera = new ZoomCamera(0, 0, FlxU.floor(FlxG.width / defaultZoom), FlxU.floor(FlxG.height / defaultZoom), defaultZoom);
		zoomCamera.targetZoom = defaultZoom;
		FlxG.camera.zoom = defaultZoom;
		FlxG.camera.antialiasing = true;
		zoomCamera.antialiasing = true;
		FlxG.addCamera(zoomCamera);
		Registry.zoomCamera = zoomCamera;
		
		//FlxG.resetCameras(zoomCamera);
				
		lander = new NapeLander(1000, 300);
		add(lander);
		
		FlxG.camera.follow(lander);
		zoomCamera.follow(lander);

		#if debug debugString.cameras = [FlxG.camera, zoomCamera]; #end
		lander.cameras = [zoomCamera];
		
		
		FlxG.camera.setBounds(Registry.worldMinX, Registry.worldMinY, Registry.worldMaxX, Registry.worldMaxY, true);	
				
		var landscape:NapeLandscape = new NapeLandscape(0, 0);
		add(landscape);
		Registry.landscape = landscape;
		landscape.body.cbTypes.add(Registry.LANDSCAPE);
		
		createStars();		
		
		focusPoint = new FlxPoint(lander.x, lander.y);
		

		setupHUD();
		
		#if debug
		setupDebugHUD();
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
	
	private function setupHUD():Void 
	{
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
	}
	
	function setupDebugHUD()
	{
		debugHud = new FlxGroup();

		var thrustMaxButtonUp:FlxButton = new FlxButton(FlxG.width - 300, 100, null);
		var thrustMaxButtonDown:FlxButton = new FlxButton(FlxG.width - 64, 100, null);
		thrustMaxText = new FlxText(FlxG.width - 236, 100, 174, "ThrustMax: " + Std.string(Registry.thrustMax));
		thrustMaxText.alignment = "center";
		thrustMaxButtonUp.loadGraphic("assets/data/button_up.png", true, false, 44, 45);
		thrustMaxButtonDown.loadGraphic("assets/data/button_down.png", true, false, 44, 45);
		thrustMaxButtonDown.onDown = thrustMaxButtonDownHandler;
		thrustMaxButtonUp.onDown = thrustMaxButtonUpHandler;
		
		var thrustDeltaButtonUp:FlxButton = new FlxButton(FlxG.width - 300, 150, null);
		var thrustDeltaButtonDown:FlxButton = new FlxButton(FlxG.width - 64, 150, null);
		thrustDeltaText = new FlxText(FlxG.width - 236, 150, 174, "thrustDelta: " + Std.string(Registry.thrustDelta));
		thrustDeltaText.alignment = "center";
		thrustDeltaButtonUp.loadGraphic("assets/data/button_up.png", true, false, 44, 45);
		thrustDeltaButtonDown.loadGraphic("assets/data/button_down.png", true, false, 44, 45);
		thrustDeltaButtonDown.onDown = thrustDeltaButtonDownHandler;
		thrustDeltaButtonUp.onDown = thrustDeltaButtonUpHandler;
		
		var maneuverJetThrustButtonUp:FlxButton = new FlxButton(FlxG.width - 300, 200, null);
		var maneuverJetThrustButtonDown:FlxButton = new FlxButton(FlxG.width - 64, 200, null);
		maneuverJetThrustText = new FlxText(FlxG.width - 236, 200, 174, "maneuverJetThrust: " + Std.string(Registry.maneuverJetThrust));
		maneuverJetThrustText.alignment = "center";
		maneuverJetThrustButtonUp.loadGraphic("assets/data/button_up.png", true, false, 44, 45);
		maneuverJetThrustButtonDown.loadGraphic("assets/data/button_down.png", true, false, 44, 45);
		maneuverJetThrustButtonDown.onDown = maneuverJetThrustButtonDownHandler;
		maneuverJetThrustButtonUp.onDown = maneuverJetThrustButtonUpHandler;		
		
		
		var weldStrengthButtonUp:FlxButton = new FlxButton(FlxG.width - 300, 250, null);
		var weldStrengthButtonDown:FlxButton = new FlxButton(FlxG.width - 64, 250, null);
		weldStrengthText = new FlxText(FlxG.width - 236, 250, 174, "weldStrength: " + Std.string(Registry.weldStrength));
		weldStrengthText.alignment = "center";
		weldStrengthButtonUp.loadGraphic("assets/data/button_up.png", true, false, 44, 45);
		weldStrengthButtonDown.loadGraphic("assets/data/button_down.png", true, false, 44, 45);
		weldStrengthButtonDown.onDown = weldStrengthButtonDownHandler;
		weldStrengthButtonUp.onDown = weldStrengthButtonUpHandler;		
		
		for (item in [thrustMaxButtonDown, thrustMaxButtonUp, thrustMaxText, 
						thrustDeltaButtonUp, thrustDeltaButtonDown, thrustDeltaText,
						weldStrengthButtonUp, weldStrengthButtonDown, weldStrengthText,
						maneuverJetThrustButtonUp,maneuverJetThrustButtonDown, maneuverJetThrustText])
		{
			debugHud.add(item);
		}
		
		add(debugHud);
		
		var debugHUDCamera:FlxCamera = new FlxCamera(FlxG.width - 300, 0, 300, 300, 1);
		debugHUDCamera.setBounds(FlxG.width -300, 80, 300, 300);
		debugHUDCamera.bgColor = 0xFF000000;
		FlxG.addCamera(debugHUDCamera);
		debugHud.cameras = [debugHUDCamera];
		
		for (item in debugHud.members)
		{
			item.cameras = [debugHUDCamera];
			// cast(item, FlxObject).scrollFactor = new FlxPoint(0, 0);
		}
		debugHUDCamera.focusOn(new FlxPoint(FlxG.width - 150, 300));
		
	}
	
	function thrustMaxButtonDownHandler():Void
	{
		Registry.thrustMax -= 100;
		thrustMaxText.text = "ThrustMax: " + Std.string(Registry.thrustMax);
	}	
	function thrustMaxButtonUpHandler():Void
	{
		Registry.thrustMax += 100;
		thrustMaxText.text = "ThrustMax: " + Std.string(Registry.thrustMax);
	}
	
	function thrustDeltaButtonDownHandler():Void
	{
		Registry.thrustDelta -= 10;
		thrustDeltaText.text = "thrustDelta: " + Std.string(Registry.thrustDelta);
	}	
	function thrustDeltaButtonUpHandler():Void
	{
		Registry.thrustDelta += 10;
		thrustDeltaText.text = "thrustDelta: " + Std.string(Registry.thrustDelta);
	}	
	
	function maneuverJetThrustButtonDownHandler():Void
	{
		Registry.maneuverJetThrust -= 100;
		maneuverJetThrustText.text = "maneuverJetThrust: " + Std.string(Registry.maneuverJetThrust);
	}	
	function maneuverJetThrustButtonUpHandler():Void
	{
		Registry.maneuverJetThrust += 100;
		maneuverJetThrustText.text = "maneuverJetThrust: " + Std.string(Registry.maneuverJetThrust);
	}
		
	function weldStrengthButtonDownHandler():Void
	{
		Registry.weldStrength -= 1;
		weldStrengthText.text = "weldStrength: " + Std.string(Registry.weldStrength);
	}	
	function weldStrengthButtonUpHandler():Void
	{
		Registry.weldStrength += 1;
		weldStrengthText.text = "weldStrength: " + Std.string(Registry.weldStrength);
	}
	
	private function createStars():Void 
	{
		// Creates 500 "stars" randomly positioned.
		for (i in 0...500) 
		{
			var startX:Float = 0;
			var startY:Float = 0;
			var emptySpace:Bool = false;
			while (emptySpace == false)
			{
				var minX:Int = Std.int(Registry.worldMinX);
				var worldWidth:Int = Std.int(Registry.worldMaxX - Registry.worldMinX);
				startX = minX + 30 + Std.random((worldWidth - 60)); 
				var minY:Int = Std.int(Registry.worldMinY);
				var worldHeight:Int = Std.int(Registry.worldMaxY - Registry.worldMinY);
				startY = minY + 30 + Std.random((worldHeight - 60)); 
				
				emptySpace = !(Registry.landscape.body.contains(Vec2.weak(startX, startY)));
			}
			
			var newSprite:FlxSprite = new FlxSprite(Std.int(startX), Std.int(startY) );
			newSprite.makeGraphic(2, 2, 0xFFFFFFFF);
			add (newSprite);
			newSprite.cameras = [zoomCamera];
		}
	}
}