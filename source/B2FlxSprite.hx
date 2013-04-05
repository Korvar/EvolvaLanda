package ;

import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import org.flixel.FlxSprite;

/**
 * ...
 * @author Mike Cugley
 */
class B2FlxSprite extends FlxSprite
{
	private var _fixDef:B2FixtureDef;
	private var _bodyDef:B2BodyDef;
	private var _obj:B2Body;
	
	private var _world:B2World;
	
	public var _friction:Float = 0.8;
	public var _restitution:Float = 0.3;
	public var _density:Float = 0.7;
	
	public var _angle:Float = 0;
	
	public function new(X:Float=0, Y:Float=0, Width:Float, Height:Float, w:B2World, SimpleGraphic:Dynamic=null) 
	{
		super(X, Y, SimpleGraphic);
		
		width = Width;
		height = Height;
		_world = w;
		
	}
	
	override public function update():Void
	{
		x = (_obj.getPosition().x * Registry.ratio) -width / 2;
		y = (_obj.getPosition().y * Registry.ratio) -height / 2;
		angle = _obj.getAngle() * (180 / Math.PI);
		
		super.update();
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
		_bodyDef.angle = angle * (Math.PI / 180);
		_bodyDef.type = B2Body.b2_dynamicBody;
		
		_obj = _world.createBody(_bodyDef);
		_obj.createFixture(_fixDef);
	}
	
	override public function kill():Void
	{
		_world.destroyBody(_obj);
		super.kill();
	}
}