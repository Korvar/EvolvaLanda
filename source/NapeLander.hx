package ;

import nape.constraint.WeldJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Polygon;
import org.flixel.FlxG;
import org.flixel.FlxU;
import org.flixel.nape.FlxPhysSprite;

/**
 * ...
 * @author Mike Cugley
 */
class NapeLander extends FlxPhysSprite
{
	
	var thrust:Float = 0.0;

	public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null, CreateBody:Bool=true) 
	{
		super(X, Y, SimpleGraphic, CreateBody);
		
		// loadGraphic("assets/data/Lander.png", false); 
		
		makeGraphic(70, 50, 0x00000000);
		
		createBody();
	}
	
	public function createBody():Void
	{
		var landerShape:Polygon;
		var waistShape:Polygon;
		var lowerLanderShape:Polygon;
		var pointsArray:Array<Vec2>;
		
		var landerMaterial:Material = Material.steel();
		
		// Upper body
		pointsArray = new Array<Vec2>();
		
		pointsArray[0] = new Vec2(-15, -5);
		pointsArray[1] = new Vec2(-20, -10);
		pointsArray[2] = new Vec2(-20, -15);
		pointsArray[3] = new Vec2(-10, -25);
		pointsArray[4] = new Vec2(10, -25);
		pointsArray[5] = new Vec2(20, -15);
		pointsArray[6] = new Vec2(20, -10);
		pointsArray[7] = new Vec2(15, -5);

		landerShape = new Polygon(pointsArray);
		landerShape.material = landerMaterial;
		body.shapes.add(landerShape);
		
		pointsArray = new Array<Vec2>();
		pointsArray[0] = new Vec2(15, 0.0);
		pointsArray[1] = new Vec2(15, -5);
		pointsArray[2] = new Vec2(-15, -5);
		pointsArray[3] = new Vec2( -15, 0.0);		
		
		waistShape = new Polygon(pointsArray);
		waistShape.material = landerMaterial;
		body.shapes.add(waistShape);

		pointsArray = new Array<Vec2>();
		pointsArray[0] = new Vec2(20, 5);
		pointsArray[1] = new Vec2(10, 15);	
		pointsArray[2] = new Vec2( -10, 15);	
		pointsArray[3] = new Vec2( -20, 5);	
		pointsArray[4] = new Vec2(-15, 0.0);		
		pointsArray[5] = new Vec2(15, 0.0);

		lowerLanderShape = new Polygon(pointsArray);
		lowerLanderShape.material = landerMaterial;
		body.shapes.add(lowerLanderShape);

		// Struts
		pointsArray = new Array<Vec2>();
		pointsArray[0] = new Vec2( 6.25, -3.85);	
		pointsArray[1] = new Vec2( -2.5, 5);
		pointsArray[2] = new Vec2(-5, 5);			
		pointsArray[3] = new Vec2( 5, -5);
		createStrut(x - 25 , y + 10, pointsArray, landerMaterial, Vec2.weak( -20, 5), Vec2.weak(5, -5));
		
		// createStrut(X, Y, pointsArray:Array<Vec2>, material, weldjoin1:Vec2, weldjoin2:Vec2):Void
		
		pointsArray[3] = new Vec2( -6.25, -3.85);	
		pointsArray[2] = new Vec2( 2.5, 5);
		pointsArray[1] = new Vec2(5, 5);			
		pointsArray[0] = new Vec2( -5, -5);
		createStrut(x + 25 , y + 10, pointsArray, landerMaterial, Vec2.weak( 20, 5), Vec2.weak(-5, -5));
		
	
		//var strutShape:B2PolygonShape = new B2PolygonShape();
		//strutShape.setAsVector(pointsArray);
		//_fixDef.shape = strutShape;
		//_obj.createFixture(_fixDef);
		//
		//pointsArray[0] = new Vec2(2.0, 0.5);
		//pointsArray[1] = new Vec2(3.0, 1.5);	
		//pointsArray[2] = new Vec2(2.75, 1.5);	
		//pointsArray[3] = new Vec2(1.825, 0.625);	
		//
		//strutShape.setAsVector(pointsArray);
		//_fixDef.shape = strutShape;
		//_obj.createFixture(_fixDef);
		//
		//pointsArray[3] = new Vec2(-2.75, 1.5);
		//pointsArray[2] = new Vec2(-1.0, 1.5);	
		//pointsArray[1] = new Vec2(-1.25, 1.25);	
		//pointsArray[0] = new Vec2( -2.5, 1.25);	
		//
		//strutShape.setAsVector(pointsArray);
		//_fixDef.shape = strutShape;
		//_obj.createFixture(_fixDef);
		//
		//pointsArray[0] = new Vec2(2.75, 1.5);
		//pointsArray[1] = new Vec2(1.0, 1.5);	
		//pointsArray[2] = new Vec2(1.25, 1.25);	
		//pointsArray[3] = new Vec2(2.5, 1.25);
		//
		//strutShape.setAsVector(pointsArray);
		//_fixDef.shape = strutShape;
		//_obj.createFixture(_fixDef);
		//
		//pointsArray[3] = new Vec2(-3.125, 1.5);
		//pointsArray[2] = new Vec2(-3.125, 2.0);	
		//pointsArray[1] = new Vec2(-2.825, 2.0);	
		//pointsArray[0] = new Vec2(-2.825, 1.5);
		//
		//strutShape.setAsVector(pointsArray);
		//_fixDef.shape = strutShape;
		//_obj.createFixture(_fixDef);
		//
		//pointsArray[0] = new Vec2(3.125, 1.5);
		//pointsArray[1] = new Vec2(3.125, 2.0);	
		//pointsArray[2] = new Vec2(2.825, 2.0);	
		//pointsArray[3] = new Vec2(2.825, 1.5);
		//
		//strutShape.setAsVector(pointsArray);
		//_fixDef.shape = strutShape;
		//_obj.createFixture(_fixDef);	
		//
		// Feet!
		//var footShape:B2PolygonShape = new B2PolygonShape();
		//pointsArray[0] = new Vec2(-3.25, 2.0);
		//pointsArray[1] = new Vec2(-2.75, 2.0);	
		//pointsArray[2] = new Vec2(-2.5, 2.5);	
		//pointsArray[3] = new Vec2( -3.5, 2.5);
		//
		//footShape.setAsVector(pointsArray);
		//_fixDef.shape = footShape;
		//_obj.createFixture(_fixDef);	
		//
		//pointsArray[3] = new Vec2(3.25, 2.0);
		//pointsArray[2] = new Vec2(2.75, 2.0);	
		//pointsArray[1] = new Vec2(2.5, 2.5);	
		//pointsArray[0] = new Vec2(3.5, 2.5);
		//
		//footShape.setAsVector(pointsArray);
		//_fixDef.shape = footShape;
		//_obj.createFixture(_fixDef);	
		//
		//return(_obj);
		
	}
	
	override public function update():Void
	{
		if (FlxG.keys.pressed("UP") || FlxG.keys.pressed("W"))
		{
			thrust -= 10;
		}
		
		if (FlxG.keys.pressed("DOWN") || FlxG.keys.pressed("S"))
		{
			thrust += 10;
		}
		
		thrust = FlxU.bound(thrust, -1000, 0);
		
		body.applyImpulse(body.localVectorToWorld(Vec2.weak(0, thrust))/*, body.localVectorToWorld(Vec2.weak(0, 15))*/);
		
		super.update();
	}
	
	private function createStrut(X, Y, pointsArray:Array<Vec2>, material, weldjoin1:Vec2, weldjoin2:Vec2):Void
	{
		var strut = new FlxPhysSprite(X, Y);
		strut.body.shapes.add(new Polygon(pointsArray, material));
		strut.makeGraphic(5, 5, 0xffffffff);
		FlxG.state.add(strut);
		
		var strutWeld:WeldJoint = new WeldJoint(body, strut.body, weldjoin1, weldjoin2);
		strutWeld.active = true;
		strutWeld.stiff = true;
		strutWeld.frequency = 20.0;
		strutWeld.damping = 1.0;
		strutWeld.space = body.space;
	}
}