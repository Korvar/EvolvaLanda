package ;

import nme.display.Sprite;
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
		add(debugString);
		#end
		
		super.create();
		
		setupWorld();
		
		createLandscape();
		
		createLander();
		
		var floor:B2FlxTileblock = new B2FlxTileblock(0, 400, 640, 80, _world);
		floor.createBody();
		floor.makeGraphic(640, 80, 0xFFFF9900);
		add(floor);
		
		//var cube:B2FlxSprite;
		//for (i in 1...30)
		//{
			//var cubeWidth:Float = FlxG.random() * 40 + 10;
			//var cubeHeight:Float = FlxG.random() * 40 + 10;
			//cube = new B2FlxSprite(FlxG.random() * 640, FlxG.random() * 240, cubeWidth, cubeHeight, _world);
			//cube.angle = FlxG.random() * 360;
			//cube.createBody();
			//cube.makeGraphic(FlxU.floor(cubeWidth), FlxU.floor(cubeHeight), 0xff00cccc);
			//
			//add(cube);
		//}
		
		setupDebugDraw();
		

		
		
		

	}

	function createLandscape()
	{
		var octave1:SmoothNoise;
		var octave2:SmoothNoise;
		
		var arrayLength = 60; // FlxG.width;
		
		var landscapeArray:Array<Float> = new Array<Float>();
		
		var pointsArray:Array<FlxPoint> = new Array<FlxPoint>();
		
		octave1 = new SmoothNoise(10, arrayLength);
		octave2 = new SmoothNoise(20, arrayLength);
		
		var landscapeLength = FlxG.width;
		var landscapeHeight = FlxG.height / 2;
		
		var lengthRatio:Float = cast(landscapeLength, Float) / cast(arrayLength, Float);
		var heightRatio:Float = landscapeHeight;
		
		
		for (i in 0...arrayLength)
		{
			var noiseValue = octave1.noise(i) + (octave2.noise(i) / 2);
			landscapeArray[i] = FlxU.roundDecimal(noiseValue, 3); 
			pointsArray[i] = new FlxPoint(i * lengthRatio, noiseValue * heightRatio);
		}
		
		pointsArray.push(new FlxPoint(arrayLength * lengthRatio, 1.1* heightRatio));
		pointsArray.push(new FlxPoint(arrayLength / 2 * lengthRatio, 1.1* heightRatio));
		pointsArray.push(new FlxPoint(0, 1.1 * heightRatio));
		
		#if debug
				
		for (i in 0...octave1.values.length)
		{
			octave1.values[i] = FlxU.roundDecimal(octave1.values[i], 3);
		}
		messageString = "\n" + landscapeArray.toString() + "\n\n" + octave1.values.toString();
		Registry.debugString.text += messageString;
		
		#end

		makeLandscapeBody(pointsArray);
		

		
		

	}
	
	
	function makeLandscapeBody(pointsArray:Array<Dynamic>)
	{
		var body:B2Body;
		var bodyDef:B2BodyDef;
		var polytool:PolygonTool = new PolygonTool();
		
		bodyDef = new B2BodyDef();
		bodyDef.type = B2Body.b2_dynamicBody;
		
		body = _world.createBody(bodyDef);	
		body.setPositionAndAngle(new B2Vec2(0 / Registry.ratio, 100 / Registry.ratio), 0);
		
		var vertArray = pointsArray.slice(0);
		
		if (!polytool.isPolyClockwise(vertArray))
			vertArray.reverse();
		var polys = polytool.earClip(vertArray);

		if (polys != null) 
		{
			makeComplexBody(body, polys);
		} 
		else 
		{
			vertArray = polytool.getConvexPoly(pointsArray).slice(0);
			polys = polytool.earClip(vertArray);
			makeComplexBody(body, polys);
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
	
	private function makeComplexBody(p_body:B2Body, polys:Array<Array<Dynamic>>):Void 
	{
		if (polys == null)
		{
			//abort!
			Registry.debugString.text += "\n\nAbort!";
			return;
		}
		for(poly in polys) {
			if(poly != null) {
				
				var polyDef:B2FixtureDef;
				var polyShape:B2PolygonShape = new B2PolygonShape();
				polyDef = new B2FixtureDef();
				polyDef.friction = 0.5;
				polyDef.restitution = 0.2;
				
				var polyVerts:Array<B2Vec2> = new Array<B2Vec2>();
				
				polyDef.density = 1.0;
				
				for (vertex in poly) {
					vertex.x = vertex.x / Registry.ratio;
					vertex.y = vertex.y / Registry.ratio;
					polyVerts.push(new B2Vec2(vertex.x, vertex.y));
				}
				
				polyShape.setAsArray(polyVerts);
				
				polyDef.shape = polyShape;
				
				p_body.createFixture(polyDef);
			}
		}
		
		
	}
	
	override public function update():Void
	{
		_world.step(FlxG.elapsed, 10, 10);
		_world.drawDebugData();
		super.update();
	}
}