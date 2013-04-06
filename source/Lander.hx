package ;

/**
 * ...
 * @author Mike Cugley
 */

import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import org.flixel.FlxSprite;
import org.flixel.FlxU;
 
class Lander extends FlxSprite
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
		
		makeGraphic(FlxU.floor(Width), FlxU.floor(Height), 0x00000000);
		
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
		var landerShape:B2PolygonShape = new B2PolygonShape();
		var waistShape:B2PolygonShape = new B2PolygonShape();
		var lowerLanderShape:B2PolygonShape = new B2PolygonShape();
		var pointsArray:Array<B2Vec2>;
		
		// Upper body
		pointsArray = new Array<B2Vec2>();
		
		pointsArray[0] = new B2Vec2(-1.5, -0.5);
		pointsArray[1] = new B2Vec2(-2.0, -1.0);
		pointsArray[2] = new B2Vec2(-2.0, -1.5);
		pointsArray[3] = new B2Vec2(-1.0, -2.5);
		pointsArray[4] = new B2Vec2(1.0, -2.5);
		pointsArray[5] = new B2Vec2(2.0, -1.5);
		pointsArray[6] = new B2Vec2(2.0, -1.0);
		pointsArray[7] = new B2Vec2(1.5, -0.5);
		
		landerShape.setAsVector(pointsArray);
		
		pointsArray = new Array<B2Vec2>();
		pointsArray[0] = new B2Vec2(1.5, 0.0);
		pointsArray[1] = new B2Vec2(1.5, -0.5);
		pointsArray[2] = new B2Vec2(-1.5, -0.5);
		pointsArray[3] = new B2Vec2( -1.5, 0.0);		
		
		waistShape.setAsVector(pointsArray);
		

		
		_fixDef = new B2FixtureDef();
		_fixDef.density = _density;
		_fixDef.restitution = _restitution;
		_fixDef.friction = _friction;
		_fixDef.shape = landerShape;
		
		_bodyDef = new B2BodyDef();
		_bodyDef.position.set((x + (width / 2)) / Registry.ratio, (y + (height / 2)) / Registry.ratio);
		_bodyDef.angle = angle * (Math.PI / 180);
		_bodyDef.type = B2Body.b2_dynamicBody;
		
		_obj = _world.createBody(_bodyDef);
		_obj.createFixture(_fixDef);
		
		_fixDef.shape = waistShape;
		_obj.createFixture(_fixDef);
		
		pointsArray = new Array<B2Vec2>();
		pointsArray[0] = new B2Vec2(2.0, 0.5);
		pointsArray[1] = new B2Vec2(1.0, 1.5);	
		pointsArray[2] = new B2Vec2( -1.0, 1.5);	
		pointsArray[3] = new B2Vec2( -2.0, 0.5);	
		pointsArray[4] = new B2Vec2(-1.5, 0.0);		
		pointsArray[5] = new B2Vec2(1.5, 0.0);

		lowerLanderShape.setAsVector(pointsArray);
		
		_fixDef.shape = lowerLanderShape;
		_obj.createFixture(_fixDef);
		
		// Struts
		pointsArray = new Array<B2Vec2>();
		pointsArray[0] = new B2Vec2( -1.825, 0.625);	
		pointsArray[1] = new B2Vec2( -2.75, 1.5);
		pointsArray[2] = new B2Vec2(-3.0, 1.5);			
		pointsArray[3] = new B2Vec2(-2.0, 0.5);
	
		var strutShape:B2PolygonShape = new B2PolygonShape();
		strutShape.setAsVector(pointsArray);
		_fixDef.shape = strutShape;
		_obj.createFixture(_fixDef);
		
		pointsArray[0] = new B2Vec2(2.0, 0.5);
		pointsArray[1] = new B2Vec2(3.0, 1.5);	
		pointsArray[2] = new B2Vec2(2.75, 1.5);	
		pointsArray[3] = new B2Vec2(1.825, 0.625);	
		
		strutShape.setAsVector(pointsArray);
		_fixDef.shape = strutShape;
		_obj.createFixture(_fixDef);
		
		pointsArray[3] = new B2Vec2(-2.75, 1.5);
		pointsArray[2] = new B2Vec2(-1.0, 1.5);	
		pointsArray[1] = new B2Vec2(-1.25, 1.25);	
		pointsArray[0] = new B2Vec2( -2.5, 1.25);	
		
		strutShape.setAsVector(pointsArray);
		_fixDef.shape = strutShape;
		_obj.createFixture(_fixDef);
		
		pointsArray[0] = new B2Vec2(2.75, 1.5);
		pointsArray[1] = new B2Vec2(1.0, 1.5);	
		pointsArray[2] = new B2Vec2(1.25, 1.25);	
		pointsArray[3] = new B2Vec2(2.5, 1.25);
		
		strutShape.setAsVector(pointsArray);
		_fixDef.shape = strutShape;
		_obj.createFixture(_fixDef);
		
		pointsArray[3] = new B2Vec2(-3.125, 1.5);
		pointsArray[2] = new B2Vec2(-3.125, 2.0);	
		pointsArray[1] = new B2Vec2(-2.825, 2.0);	
		pointsArray[0] = new B2Vec2(-2.825, 1.5);
		
		strutShape.setAsVector(pointsArray);
		_fixDef.shape = strutShape;
		_obj.createFixture(_fixDef);
		
		pointsArray[0] = new B2Vec2(3.125, 1.5);
		pointsArray[1] = new B2Vec2(3.125, 2.0);	
		pointsArray[2] = new B2Vec2(2.825, 2.0);	
		pointsArray[3] = new B2Vec2(2.825, 1.5);
		
		strutShape.setAsVector(pointsArray);
		_fixDef.shape = strutShape;
		_obj.createFixture(_fixDef);	
		
		// Feet!
		var footShape:B2PolygonShape = new B2PolygonShape();
		pointsArray[0] = new B2Vec2(-3.25, 2.0);
		pointsArray[1] = new B2Vec2(-2.75, 2.0);	
		pointsArray[2] = new B2Vec2(-2.5, 2.5);	
		pointsArray[3] = new B2Vec2( -3.5, 2.5);
		
		footShape.setAsVector(pointsArray);
		_fixDef.shape = footShape;
		_obj.createFixture(_fixDef);	
		
		pointsArray[3] = new B2Vec2(3.25, 2.0);
		pointsArray[2] = new B2Vec2(2.75, 2.0);	
		pointsArray[1] = new B2Vec2(2.5, 2.5);	
		pointsArray[0] = new B2Vec2(3.5, 2.5);
		
		footShape.setAsVector(pointsArray);
		_fixDef.shape = footShape;
		_obj.createFixture(_fixDef);	
		
	}
	
	override public function kill():Void
	{
		_world.destroyBody(_obj);
		super.kill();
	}	
	
}