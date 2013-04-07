package ;

import nme.display.Sprite;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;


import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;

import src.utils.PolygonTool;

/**
 * ...
 * @author Mike Cugley
 */
class PlayState extends FlxState
{
	
	#if debug
	var messageString:String;
	#end
	
	public var _world:B2World;
	var landerBody:B2Body;

	public function new() 
	{
		super();
		
	}
	
	override public function create()
	{
		#if debug
		FlxG.watch(this, "messageString");

		
		var debugString:FlxText = new FlxText(0, 0, FlxG.width, "test");
		debugString.color = 0xFFFFFF;
		Registry.debugString = debugString;
		debugString.scrollFactor = (new FlxPoint(0, 0));
		add(debugString);
		#end
		
		super.create();
		
		setupWorld();
		
		// createLandscape();
		
	
		createLander();
		// FlxG.camera.setBounds( -1000, -1000, 1000, 1000, true);			
		
		
		var floor:B2FlxTileblock = new B2FlxTileblock(0, FlxG.height - 10, FlxG.width, 10, _world);
		floor.createBody();
		floor.makeGraphic(FlxU.floor(floor.width), FlxU.floor(floor.height), 0xFFFF9900);
		add(floor);
		
		// addCubes();
		

		
		setupDebugDraw();
		


	}

	function createLandscape()
	{
		var octave1:SmoothNoise;
		var octave2:SmoothNoise;
		var octave3:SmoothNoise;
		var octave4:SmoothNoise;
		
		var arrayLength = 120; // FlxG.width;
		
		var landscapeArray:Array<Float> = new Array<Float>();
		
		var pointsArray:Array<FlxPoint> = new Array<FlxPoint>();
		
		octave1 = new SmoothNoise(6, arrayLength);
		octave2 = new SmoothNoise(12, arrayLength);
		octave3 = new SmoothNoise(24, arrayLength);
		octave4 = new SmoothNoise(48, arrayLength);
		
		var landscapeLength = FlxG.width;
		var landscapeHeight = FlxG.height;
		
		var lengthRatio:Float = cast(landscapeLength, Float) / cast(arrayLength, Float);
		var heightRatio:Float = landscapeHeight;
		
		for (i in 0...arrayLength)
		{
			var noiseValue = (octave1.noise(i) / 2) + (octave2.noise(i) / 4) + (octave3.noise(i) / 8) + (octave4.noise(i) / 16);
			noiseValue = (noiseValue * 2) - 1;
			noiseValue = FlxU.abs(noiseValue);
			landscapeArray[i] = FlxU.roundDecimal(noiseValue, 3); 
			pointsArray[i] = new FlxPoint(i * lengthRatio, noiseValue * heightRatio);
		}
		
		#if debug
				
		for (i in 0...octave1.values.length)
		{
			octave1.values[i] = FlxU.roundDecimal(octave1.values[i], 3);
		}
		messageString = "\n" + landscapeArray.toString() + "\n\n" + octave1.values.toString();
		// Registry.debugString.text += messageString;
		
		#end

		makeLandscapeBody(pointsArray);
	}
	
	
	function makeLandscapeBody(pointsArray:Array<FlxPoint>)
	{
		var body:B2Body;
		var bodyDef:B2BodyDef;
		var polygonShape:B2PolygonShape;
		var fixtureDef:B2FixtureDef;
		
		bodyDef = new B2BodyDef();
		bodyDef.type = B2Body.b2_staticBody;
		
		body = _world.createBody(bodyDef);	
		body.setPositionAndAngle(new B2Vec2(0 / Registry.ratio, 100 / Registry.ratio), 0);
		
		for (i in 0...pointsArray.length -2)
		{
			fixtureDef = new B2FixtureDef();
			polygonShape = new B2PolygonShape();
			var p1:B2Vec2 = new B2Vec2(pointsArray[i].x / Registry.ratio, pointsArray[i].y / Registry.ratio);
			var p2:B2Vec2 = new B2Vec2(pointsArray[i + 1].x / Registry.ratio, pointsArray[i + 1].y / Registry.ratio);
			polygonShape.setAsEdge(p1, p2);
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 1.0;
			fixtureDef.friction = 0.3;
			body.createFixture(fixtureDef);
		}
	}
	
	function setupDebugDraw()
	{
		var debugDraw:B2DebugDraw = new B2DebugDraw();
		
		debugDraw.setSprite(Registry.debugSprite);
		debugDraw.setDrawScale(Registry.ratio);
		debugDraw.setLineThickness(1.0);
		debugDraw.setAlpha(1);
		debugDraw.setFillAlpha(0.5);
		debugDraw.setFlags(B2DebugDraw.e_shapeBit | B2DebugDraw.e_jointBit | B2DebugDraw.e_centerOfMassBit);
		_world.setDebugDraw(debugDraw);
	}
	
	function createLander()
	{
		var lander:Lander = new Lander(320, 0, 7 * Registry.ratio, 5 * Registry.ratio, _world);
		landerBody = lander.createBody();
		add(lander);
		FlxG.camera.follow(lander, FlxCamera.STYLE_LOCKON);
	}
	
	private function setupWorld():Void
	{
		var gravity:B2Vec2 = new B2Vec2(0, 9.8);
		_world = new B2World(gravity, true);
		
	}
	
	
	private function addCubes():Void 
	{
		var cube:B2FlxSprite;
		for (i in 1...30)
		{
			var cubeWidth:Float = FlxG.random() * 40 + 10;
			var cubeHeight:Float = FlxG.random() * 40 + 10;
			cube = new B2FlxSprite(FlxG.random() * 640, FlxG.random() * 50, cubeWidth, cubeHeight, _world);
			cube.angle = FlxG.random() * 360;
			cube.createBody();
			cube.makeGraphic(FlxU.floor(cubeWidth), FlxU.floor(cubeHeight), 0xff00cccc);
			
			add(cube);
		}
	}
	
	override public function update():Void
	{
		updateLander();
		
		_world.step(FlxG.elapsed, 10, 10);
		_world.drawDebugData();
		super.update();
		
		if (FlxG.keys.justPressed("R"))
		{
			FlxG.switchState(new PlayState());
		}
		
		if (FlxG.keys.justPressed("N"))
		{
			FlxG.switchState(new NapePlayState());
		}
		
		
	}
	
	function updateLander():Void
	{
		var upperJet:B2Vec2 = new B2Vec2(0, -2.5);
		var lowerJet:B2Vec2 = new B2Vec2(0, -1.5);
		
		
		var B2angle:Float = landerBody.getAngle();
		var upThrustAngle:Float;
		var rightThrustAngle:Float;
		var leftThrustAngle:Float;
		var downThrustAngle:Float;
		
		var upThrustVec:B2Vec2;
		var rightThrustVec:B2Vec2;
		var leftThrustVec:B2Vec2;
		var downThrustVec:B2Vec2;
		
		upThrustAngle = B2angle - (Math.PI / 2);
		rightThrustAngle = B2angle;
		leftThrustAngle = B2angle + Math.PI;
		downThrustAngle = B2angle + (Math.PI / 2);
		
		var upThrustVec:B2Vec2 = new B2Vec2(Math.cos(upThrustAngle), Math.sin(upThrustAngle));
		var rightThrustVec:B2Vec2 = new B2Vec2(Math.cos(rightThrustAngle), Math.sin(rightThrustAngle));
		var leftThrustVec:B2Vec2 = new B2Vec2(Math.cos(leftThrustAngle), Math.sin(leftThrustAngle));
		var downThrustVec:B2Vec2 = new B2Vec2(Math.cos(downThrustAngle), Math.sin(downThrustAngle));
		
		if (FlxG.keys.pressed("SPACE"))
		{
			upThrustVec.multiply(10);
			landerBody.applyForce(upThrustVec, landerBody.getWorldCenter());
			Registry.debugString.text = "Space! " + upThrustVec.length();
		}
		else
		{
			Registry.debugString.text = "No Space! " + upThrustVec.length();
		}
		
		if (FlxG.keys.pressed("A"))
		{
			landerBody.applyForce(leftThrustVec, landerBody.getWorldPoint(upperJet));
			landerBody.applyForce(rightThrustVec, landerBody.getWorldPoint(lowerJet));
		}
		
		if (FlxG.keys.pressed("D"))
		{
			landerBody.applyForce(rightThrustVec, landerBody.getWorldPoint(upperJet));
			landerBody.applyForce(leftThrustVec, landerBody.getWorldPoint(lowerJet));
		}
		
		
	}
}