package ;

import org.flixel.FlxTileblock;

import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2World;

import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;

/**
 * ...
 * @author Mike Cugley
 */
class B2FlxTileblock extends FlxTileblock
{
	public var _fixDef:B2FixtureDef;
	public var _bodyDef:B2BodyDef;
	public var _obj:B2Body;
	
	private var _world:B2World;
	
	public var _friction:Float = 0.8;
	public var _restitution:Float = 0.3;
	public var _density:Float = 0.7;
	
	public var _angle:Float = 0;
	
	public function new(X:Int, Y:Int, Width:Int, Height:Int, w:B2World) 
	{
		super(X, Y, Width, Height);
		
		_world = w;
		
	}
	
	public function createBody():Void
	{
		var boxShape:B2PolygonShape = new B2PolygonShape();
		boxShape.setAsBox((width / 2) / Registry.ratio, (height / 2) / Registry.ratio);
		
		_fixDef = new B2FixtureDef();
		_fixDef.density = _density;
		_fixDef.restitution = _restitution;
		_fixDef.friction = _friction;
		_fixDef.shape = boxShape;
		
		_bodyDef = new B2BodyDef();
		_bodyDef.position.set((x + (width / 2)) / Registry.ratio, (y + (height / 2)) / Registry.ratio);
		_bodyDef.angle = _angle * (Math.PI / 180);
		_bodyDef.type = B2Body.b2_staticBody;
		
		_obj = _world.createBody(_bodyDef);
		_obj.createFixture(_fixDef);
	}
	
	override public function kill():Void
	{
		_world.destroyBody(_obj);
		super.kill();
	}
	
}