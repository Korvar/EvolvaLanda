package ;

import nape.constraint.WeldJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Polygon;
import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxParticle;
import org.flixel.FlxU;
import org.flixel.nape.FlxPhysSprite;
import org.flixel.FlxText;
import org.flixel.FlxPoint;

/**
 * ...
 * @author Mike Cugley
 */
class NapeLander extends FlxPhysSprite
{
	
	var thrust:Float = 0.0;
	var thrustMax:Float = 2000;
	
	var maneuverJetThrust:Float = 400;
	
	var upperJet:Vec2;
	var lowerJet:Vec2;
	
	var lowerJetEmitter:FlxEmitter;
	var upperJetEmitter:FlxEmitter;
	var mainEngineEmitter:FlxEmitter;
	var multiplier:Float = 3;

	public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null, CreateBody:Bool=true) 
	{
		super(X, Y, SimpleGraphic, CreateBody);
		
		// loadGraphic("assets/data/Lander.png", false); 
		
		makeGraphic(40 * Std.int(multiplier), 40 * Std.int(multiplier), 0x00ffffff);
		
		createBody();
		
		lowerJetEmitter = new FlxEmitter(x + (width / 2), y + (height / 2) + 15 * multiplier);
		upperJetEmitter = new FlxEmitter(x + (width / 2), y + (height / 2) - 25 * multiplier);
		mainEngineEmitter = new FlxEmitter(x + (width / 2), y + (height / 2) + 15 * multiplier);
		
		var particles:Int = 200;
		
		for (emitter in [lowerJetEmitter, upperJetEmitter, mainEngineEmitter])
		{
			for (i in 0...particles)
			{
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(1, 1, 0xffffffff);
				particle.exists = false;
				emitter.add(particle);
			}
			FlxG.state.add(emitter);
			emitter.start(false, 0.5,0.05);
			emitter.on = false;
			// emitter.start(false, 1.0);
		}

	}
	
	public function createBody():Void
	{
		var landerShape:Polygon;
		var waistShape:Polygon;
		var lowerLanderShape:Polygon;
		var pointsArray:Array<Vec2>;
		

		
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

		// body.align();

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
		
		upperJet = new Vec2(0, -25 * multiplier);
		lowerJet = new Vec2(0, 15 * multiplier);
		

		
	}
	
	override public function update():Void
	{
		var upperJetVec:Vec2 = body.localVectorToWorld(upperJet);
		var lowerJetVec:Vec2 = body.localVectorToWorld(lowerJet);
		
		mainEngineEmitter.x = x + (width / 2) + lowerJetVec.x;
		mainEngineEmitter.y = y + (height / 2) + lowerJetVec.y;
		
		lowerJetEmitter.x = x + (width / 2) + lowerJetVec.x;
		lowerJetEmitter.y = y + (height / 2) + lowerJetVec.y;
		
		upperJetEmitter.x = x + (width / 2) + upperJetVec.x;
		upperJetEmitter.y = y + (height / 2) + upperJetVec.y;
		
		
		Registry.debugString.text = "UpperJetVec.X: " + upperJetVec.x + " UpperJetVec.Y: " + upperJetVec.y;
		Registry.debugString.text += "\nUpperJet.X: " + upperJet.x + " UpperJet.Y: " + upperJet.y;
		Registry.debugString.text += "\nX: " + x + " Y: " + y;
		Registry.debugString.text += "\nMouseX: " + FlxG.mouse.x + " MouseY: " + FlxG.mouse.y;
		
		
		mainEngineEmitter.minRotation = angle - 5;
		mainEngineEmitter.maxRotation = angle + 5;
		
		
		if (FlxG.keys.pressed("UP") || FlxG.keys.pressed("W"))
		{
			thrust -= 50;
		}
		
		if (FlxG.keys.pressed("DOWN") || FlxG.keys.pressed("S"))
		{
			thrust += 50;
		}
		
		if (FlxG.keys.pressed("LEFT") || FlxG.keys.pressed("A"))
		{
			body.applyImpulse(body.localVectorToWorld(Vec2.weak(-maneuverJetThrust, 0)), upperJetVec);
			body.applyImpulse(body.localVectorToWorld(Vec2.weak(maneuverJetThrust, 0)), lowerJetVec);
		}
		
		if (FlxG.keys.pressed("RIGHT") || FlxG.keys.pressed("D"))
		{
			body.applyImpulse(body.localVectorToWorld(Vec2.weak(maneuverJetThrust, 0)), upperJetVec);
			body.applyImpulse(body.localVectorToWorld(Vec2.weak(-maneuverJetThrust, 0)), lowerJetVec);
		}		
		
		thrust = FlxU.bound(thrust, -thrustMax, 0);
		Registry.debugString.text += "\nThrust: " + thrust;
		
		var thrustVec:Vec2 = new Vec2(0, thrust);
		var minThrustVec:Vec2 = new Vec2( -20, -thrust / 5); // These vectors are for the exhaust particles, so direction is reversed.
		var maxThrustVec:Vec2 = new Vec2(20, -thrust / 5);
		var minThrustWorldVec:Vec2 = body.localVectorToWorld(minThrustVec);
		var maxThrustWorldVec:Vec2 = body.localVectorToWorld(maxThrustVec);
		var minX:Float = FlxU.min(minThrustWorldVec.x, maxThrustWorldVec.x);
		var maxX:Float = FlxU.max(minThrustWorldVec.x, maxThrustWorldVec.x);
		var minY:Float = FlxU.min(minThrustWorldVec.y, maxThrustWorldVec.y);
		var maxY:Float = FlxU.max(minThrustWorldVec.y, maxThrustWorldVec.y);
			
		mainEngineEmitter.setXSpeed(minX + velocity.x, maxX + velocity.x);
		mainEngineEmitter.setYSpeed(minY + velocity.y, maxY + velocity.y);
		
		
		if (thrust <  0)
		{
			mainEngineEmitter.on = true;
		}
		else
		{
			mainEngineEmitter.on = false;
		}
		body.applyImpulse(body.localVectorToWorld(Vec2.weak(0, thrust)));

		
		if (FlxG.keys.pressed("Z"))
		{
			if (FlxG.camera.zoom == 1)
			{
				FlxG.camera.zoom = 0.5;
			}
			else
			{
				FlxG.camera.zoom = 1;
			}
		}
		
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