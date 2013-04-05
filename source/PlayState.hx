package ;

import org.flixel.FlxG;
import org.flixel.FlxState;


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
		
		var cube:B2FlxSprite = new B2FlxSprite(320, 240, 20, 20, _world);
		cube.angle = 30;
		cube.createBody();
		cube.makeGraphic(20, 20, 0xff00cccc);
		
		add(cube);

	}

	function createLandscape()
	{
		
		
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
		super.update();
	}
}