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
		
		var multiplier:Float = 3;
		
		var landerMaterial:Material = Material.steel();
		
		// Remove the default shape
		body.shapes.clear();
		
		// Upper body
		pointsArray = new Array<Vec2>();
		
		pointsArray[0] = new Vec2(-15 * multiplier, -5 * multiplier);
		pointsArray[1] = new Vec2(-20 * multiplier, -10 * multiplier);
		pointsArray[2] = new Vec2(-20 * multiplier, -15 * multiplier);
		pointsArray[3] = new Vec2(-10 * multiplier, -25 * multiplier);
		pointsArray[4] = new Vec2(10 * multiplier, -25 * multiplier);
		pointsArray[5] = new Vec2(20 * multiplier, -15 * multiplier);
		pointsArray[6] = new Vec2(20 * multiplier, -10 * multiplier);
		pointsArray[7] = new Vec2(15 * multiplier, -5 * multiplier);

		landerShape = new Polygon(pointsArray);
		landerShape.material = landerMaterial;
		body.shapes.add(landerShape);
		
		pointsArray = new Array<Vec2>();
		pointsArray[0] = new Vec2(15 * multiplier, 0.0 * multiplier);
		pointsArray[1] = new Vec2(15 * multiplier, -5 * multiplier);
		pointsArray[2] = new Vec2(-15 * multiplier, -5 * multiplier);
		pointsArray[3] = new Vec2( -15 * multiplier, 0.0 * multiplier);		
		
		waistShape = new Polygon(pointsArray);
		waistShape.material = landerMaterial;
		body.shapes.add(waistShape);

		pointsArray = new Array<Vec2>();
		pointsArray[0] = new Vec2(20 * multiplier, 5 * multiplier);
		pointsArray[1] = new Vec2(10 * multiplier, 15 * multiplier);	
		pointsArray[2] = new Vec2( -10 * multiplier, 15 * multiplier);	
		pointsArray[3] = new Vec2( -20 * multiplier, 5 * multiplier);	
		pointsArray[4] = new Vec2(-15 * multiplier, 0.0 * multiplier);		
		pointsArray[5] = new Vec2(15 * multiplier, 0.0 * multiplier);

		lowerLanderShape = new Polygon(pointsArray);
		lowerLanderShape.material = landerMaterial;
		body.shapes.add(lowerLanderShape);

		// Struts
		pointsArray = new Array<Vec2>();
		pointsArray[0] = new Vec2( 6.25 * multiplier, -3.85 * multiplier);	
		pointsArray[1] = new Vec2( -2.5 * multiplier, 5 * multiplier);
		pointsArray[2] = new Vec2(-5 * multiplier, 5 * multiplier);			
		pointsArray[3] = new Vec2( 5 * multiplier, -5 * multiplier);
		var strut1:FlxPhysSprite = createStrut(x - (25 * multiplier), y + (10 * multiplier), pointsArray, landerMaterial);
		weldStrut(body, strut1.body, Vec2.weak( -20 * multiplier, 5 * multiplier), Vec2.weak(5 * multiplier, -5 * multiplier));
		
		pointsArray[3] = new Vec2( -6.25 * multiplier, -3.85 * multiplier);	
		pointsArray[2] = new Vec2( 2.5 * multiplier, 5 * multiplier);
		pointsArray[1] = new Vec2(5 * multiplier, 5 * multiplier);			
		pointsArray[0] = new Vec2( -5 * multiplier, -5 * multiplier);
		var strut2:FlxPhysSprite = createStrut(x + (25 * multiplier) , y + (10 * multiplier), pointsArray, landerMaterial);
		weldStrut(body, strut2.body, Vec2.weak( 20 * multiplier, 5 * multiplier), Vec2.weak(-5 * multiplier, -5 * multiplier));

		pointsArray[0] = new Vec2(7.5 * multiplier, -2.5 * multiplier);
		pointsArray[1] = new Vec2(-5 * multiplier,  -2.5 * multiplier);	
		pointsArray[2] = new Vec2(-7.5 * multiplier, 0.0 * multiplier);	
		pointsArray[3] = new Vec2(10.0 * multiplier, 0.0 * multiplier);	
		var strut3:FlxPhysSprite = createStrut(x - (20 * multiplier), y + (15 * multiplier), pointsArray, landerMaterial);
		weldStrut(body, strut3.body, Vec2.weak( -12.5 * multiplier, 12.5 * multiplier), Vec2.weak(7.5 * multiplier, -2.5 * multiplier));
		weldStrut(strut1.body, strut3.body, Vec2.weak( -2.5 * multiplier, 5 * multiplier), Vec2.weak( -7.5 * multiplier, 0.0 * multiplier));
		
		pointsArray[3] = new Vec2(-7.5 * multiplier, -2.5 * multiplier);
		pointsArray[2] = new Vec2(5 * multiplier,  -2.5 * multiplier);	
		pointsArray[1] = new Vec2(7.5 * multiplier, 0.0 * multiplier);	
		pointsArray[0] = new Vec2(-10.0 * multiplier, 0.0 * multiplier);	
		var strut4:FlxPhysSprite = createStrut(x + (20 * multiplier), y + (15 * multiplier), pointsArray, landerMaterial);
		weldStrut(body, strut4.body, Vec2.weak( 12.5 * multiplier, 12.5 * multiplier), Vec2.weak(-7.5 * multiplier, -2.5 * multiplier));
		weldStrut(strut2.body, strut4.body, Vec2.weak( 2.5 * multiplier, 5 * multiplier), Vec2.weak( 7.5 * multiplier, 0.0 * multiplier));		
		
		pointsArray[0] = new Vec2(2.5 * multiplier, -2.5 * multiplier);
		pointsArray[1] = new Vec2(-1.0 * multiplier,  -2.5 * multiplier);	
		pointsArray[2] = new Vec2(-1.0 * multiplier, 2.5 * multiplier);	
		pointsArray[3] = new Vec2(2.5 * multiplier, 2.5 * multiplier);	
		var strut5:FlxPhysSprite = createStrut(x - (30 * multiplier), y + (17.5 * multiplier), pointsArray, landerMaterial);
		weldStrut(strut1.body, strut5.body, Vec2.weak( -5.0 * multiplier, 5.0 * multiplier), Vec2.weak(0 * multiplier, -2.5 * multiplier));		
		weldStrut(strut3.body, strut5.body, Vec2.weak( -7.5 * multiplier, 0.0 * multiplier), Vec2.weak(2.5 * multiplier, -2.5 * multiplier));		
		
		
		
		pointsArray[0] = new Vec2(1 * multiplier, -2.5 * multiplier);
		pointsArray[1] = new Vec2(-2.5 * multiplier,  -2.5 * multiplier);	
		pointsArray[2] = new Vec2(-2.5 * multiplier, 2.5 * multiplier);	
		pointsArray[3] = new Vec2(1 * multiplier, 2.5 * multiplier);		
		var strut6:FlxPhysSprite = createStrut(x + (30 * multiplier), y + (17.5 * multiplier), pointsArray, landerMaterial);
		weldStrut(strut2.body, strut6.body, Vec2.weak( 5.0 * multiplier, 5.0 * multiplier), Vec2.weak( 0 * multiplier, -2.5 * multiplier));		
		weldStrut(strut4.body, strut6.body, Vec2.weak( 7.5 * multiplier, 0.0 * multiplier), Vec2.weak(-2.5 * multiplier, -2.5 * multiplier));		

	
		//Feet!
		pointsArray[0] = new Vec2(2.5 * multiplier, -2.5 * multiplier);
		pointsArray[1] = new Vec2(-2.5 * multiplier,  -2.5 * multiplier);	
		pointsArray[2] = new Vec2(-5.0 * multiplier, 2.5 * multiplier);	
		pointsArray[3] = new Vec2(5.0 * multiplier, 2.5 * multiplier);		
		var foot1:FlxPhysSprite = createStrut(x - (30 * multiplier), y + (22.5 * multiplier), pointsArray, landerMaterial);
		weldStrut(strut5.body, foot1.body, Vec2.weak( 0.75 * multiplier, 2.5 * multiplier), Vec2.weak( 0 * multiplier, -2.5 * multiplier));		

		pointsArray[0] = new Vec2(2.5 * multiplier, -2.5 * multiplier);
		pointsArray[1] = new Vec2(-2.5 * multiplier,  -2.5 * multiplier);	
		pointsArray[2] = new Vec2(-5.0 * multiplier, 2.5 * multiplier);	
		pointsArray[3] = new Vec2(5.0 * multiplier, 2.5 * multiplier);			
		var foot2:FlxPhysSprite = createStrut(x + (30 * multiplier), y + (22.5 * multiplier), pointsArray, landerMaterial);
		weldStrut(strut6.body, foot2.body, Vec2.weak( -0.75 * multiplier, 2.5 * multiplier), Vec2.weak( 0 * multiplier, -2.5 * multiplier));		


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
	
	private function createStrut(X, Y, pointsArray:Array<Vec2>, material):FlxPhysSprite
	{
		var strut = new FlxPhysSprite(X, Y);
		strut.body.shapes.clear();
		strut.body.shapes.add(new Polygon(pointsArray, material));
		strut.makeGraphic(1, 1, 0xffffffff);
		strut.width = 1;
		strut.height = 1;
		FlxG.state.add(strut);
		
		return (strut);
	}
	
	private function weldStrut(body1:Body, body2:Body, weldjoin1:Vec2, weldjoin2:Vec2):Void 
	{
		var strutWeld:WeldJoint = new WeldJoint(body1, body2, weldjoin1, weldjoin2);
		strutWeld.active = true;
		strutWeld.stiff = true;
		strutWeld.frequency = 20.0;
		strutWeld.damping = 1.0;
		strutWeld.space = body.space;
	}
}