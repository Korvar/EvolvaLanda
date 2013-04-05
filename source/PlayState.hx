package ;

import nme.display.Sprite;
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxU;


import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;

/**
 * ...
 * @author Mike Cugley
 */
class PlayState extends FlxState
{
	
	public var _world:B2World;

	public function new() 
	{
		super();
		
	}
	
	override public function create()
	{
		super.create();
		
		setupWorld();
		
		createLandscape();
		
		createLander();
		
		var floor:B2FlxTileblock = new B2FlxTileblock(0, 400, 640, 80, _world);
		floor.createBody();
		floor.makeGraphic(640, 80, 0xFFFF9900);
		add(floor);
		
		var cube:B2FlxSprite;
		for (i in 1...30)
		{
			var cubeWidth:Float = FlxG.random() * 40 + 10;
			var cubeHeight:Float = FlxG.random() * 40 + 10;
			cube = new B2FlxSprite(FlxG.random() * 640, FlxG.random() * 240, cubeWidth, cubeHeight, _world);
			cube.angle = FlxG.random() * 360;
			cube.createBody();
			cube.makeGraphic(FlxU.floor(cubeWidth), FlxU.floor(cubeHeight), 0xff00cccc);
			
			add(cube);
		}
		
		setupDebugDraw();

	}

	function createLandscape()
	{
		var test:SmoothNoise;
		
		var landscapeArray:Array<Float> = new Array<Float>();
		
		var arrayLength = FlxG.width;
		
		test = new SmoothNoise(10, arrayLength);
		
		for (i in 0...arrayLength - 1)
		{
			landscapeArray[i] = test.noise(i);
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
		debugDraw.setFlags(B2DebugDraw.e_shapeBit | B2DebugDraw.e_jointBit);
		_world.setDebugDraw(debugDraw);
	}
	
	function createLander()
	{
		
	}
	
	private function setupWorld():Void
	{
		var gravity:B2Vec2 = new B2Vec2(0, 9.8);
		_world = new B2World(gravity, true);
		
	}
	
	override public function update():Void
	{
		_world.step(FlxG.elapsed, 10, 10);
		_world.drawDebugData();
		super.update();
	}
}