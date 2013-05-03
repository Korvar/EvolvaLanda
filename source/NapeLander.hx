package ;

import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.ConstraintCallback;
import nape.callbacks.ConstraintListener;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.Listener;
import nape.constraint.Constraint;
import nape.constraint.WeldJoint;
import nape.geom.Vec2;
import nape.geom.Vec3;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.shape.Shape;
import org.flixel.FlxButton;
import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxParticle;
import org.flixel.FlxU;
import org.flixel.nape.FlxPhysSprite;
import org.flixel.FlxText;
import org.flixel.FlxPoint;
import org.flixel.nape.FlxPhysState;

/**
 * ...
 * @author Mike Cugley
 */
class NapeLander extends FlxPhysSprite
{
	
	var multiplier:Float = 1;
	
	var thrust:Float = 0.0;
	var thrustMax:Float = 1500;
	
	var maneuverJetThrust:Float = 50;
	var thrustDelta:Float = 20;
	
	var upperJet:Vec2;
	var lowerJet:Vec2;
	var mainEngineJet:Vec2;
	
	var lowerJetEmitter:FlxEmitter;
	var upperJetEmitter:FlxEmitter;
	var mainEngineEmitter:FlxEmitter;
	
	var fuel:Float = 0;
	
	var crewStatus:Int = 0;
	
	var crewStatusString:Array<String>;

	var mainEngineEmitterWidth = 6;
	
	var STRUTWELD:CbType;

	
	var proximityDetector:Body;
	
	
	#if debug
	
	var maxImpulse:Vec3;
	var minImpulse:Vec3;
	var maxImpulseMagnitude:Float;
	
	#end

	public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null, CreateBody:Bool=true) 
	{
		crewStatusString = ["Fine", "Shaken", "Need New Trousers", "Injured", "Dead", "Jam"];
		super(X, Y, SimpleGraphic, CreateBody);

		STRUTWELD = new CbType();	

		var listener:Listener = new ConstraintListener(CbEvent.BREAK, STRUTWELD, breakListener);
		listener.space = body.space;
		
		var proximityListener = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR,
			Registry.PROXIMITYDETECTOR,
			Registry.LANDSCAPE,
			proximityEnterCallback);
		proximityListener.space = body.space;
		
		var proximityListener2 = new InteractionListener(CbEvent.END, InteractionType.SENSOR,
			Registry.PROXIMITYDETECTOR,
			Registry.LANDSCAPE,
			proximityExitCallback);
		proximityListener2.space = body.space;		
		
		// loadGraphic("assets/data/Lander.png", false); 
		
		makeGraphic(40 * Std.int(multiplier), 50 * Std.int(multiplier), 0x00000000);

		createBody();
		
		var particles:Int = 200;
		
		lowerJetEmitter = new FlxEmitter(x + (width / 2), y + (height / 2) + 15 * multiplier, particles);
		upperJetEmitter = new FlxEmitter(x + (width / 2), y + (height / 2) - 25 * multiplier, particles);
		mainEngineEmitter = new FlxEmitter(x + (width / 2), y + (height / 2) + 15 * multiplier, particles);
		
		for (emitter in [lowerJetEmitter, upperJetEmitter, mainEngineEmitter])
		{
			for (i in 0...particles)
			{
				var particle:SparkParticle = new SparkParticle();
				particle.makeGraphic(2, 2, 0xffffffff);
				particle.exists = false;
				particle.cameras = [Registry.zoomCamera];
				emitter.add(particle);
			}
			FlxG.state.add(emitter);
			emitter.start(false, 0.5, 0.005);
			emitter.on = false;
			// emitter.start(false, 1.0);
		}
		mainEngineEmitter.width = mainEngineEmitterWidth;
		mainEngineEmitter.height = mainEngineEmitterWidth;

		thrustMax *= (multiplier * multiplier);
		thrustDelta *= (multiplier * multiplier);
		maneuverJetThrust *= (multiplier * multiplier);
		
		#if debug
		maxImpulse = new Vec3();
		minImpulse = new Vec3();
		maxImpulseMagnitude = 0;
		#end
		
		var proximityDetectorShape:Shape = new Circle(150 * multiplier);
		body.shapes.add(proximityDetectorShape);
		proximityDetectorShape.sensorEnabled = true;
		proximityDetectorShape.cbTypes.add(Registry.PROXIMITYDETECTOR);
		
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
		drawArray(this, pointsArray);
		landerShape.material = landerMaterial;
		body.shapes.add(landerShape);
		
		pointsArray = new Array<Vec2>();
		pointsArray[0] = new Vec2(15 * multiplier, 0.0 * multiplier);
		pointsArray[1] = new Vec2(15 * multiplier, -5 * multiplier);
		pointsArray[2] = new Vec2(-15 * multiplier, -5 * multiplier);
		pointsArray[3] = new Vec2( -15 * multiplier, 0.0 * multiplier);		
		
		waistShape = new Polygon(pointsArray);
		drawArray(this, pointsArray);
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
		drawArray(this, pointsArray);
		lowerLanderShape.material = landerMaterial;
		body.shapes.add(lowerLanderShape);

		// body.align();

		// Struts
		#if debug
		//trace("======Strut1======");
		#end
		pointsArray = new Array<Vec2>();
		pointsArray[3] = new Vec2( 5.625 * multiplier, -3.75 * multiplier);	
		pointsArray[2] = new Vec2( -3.125 * multiplier, 5 * multiplier);
		pointsArray[1] = new Vec2(-5.625 * multiplier, 5 * multiplier);			
		pointsArray[0] = new Vec2( 4.375 * multiplier, -5 * multiplier);
		var strut1:FlxPhysSprite = new FlxPhysSprite();
		// strut1 = createStrut(x - (24.375 * multiplier), y + (10 * multiplier), pointsArray, landerMaterial);
		strut1 = createStrut(x - (24.375 * multiplier), y + (10 * multiplier), pointsArray, landerMaterial);
		weldStrut(body, strut1.body, Vec2.weak( -20 * multiplier, 5 * multiplier), Vec2.weak(4.375 * multiplier, -5 * multiplier));
		
		#if debug
		//trace("======Strut2======");
		#end	
		pointsArray = new Array<Vec2>();		
		pointsArray[0] = new Vec2( -5.625 * multiplier, -3.75 * multiplier);	
		pointsArray[1] = new Vec2( 3.125 * multiplier, 5 * multiplier);
		pointsArray[2] = new Vec2(5.625 * multiplier, 5 * multiplier);			
		pointsArray[3] = new Vec2( -4.375 * multiplier, -5 * multiplier);
		var strut2:FlxPhysSprite = new FlxPhysSprite();
		strut2 = createStrut(x + (24.375 * multiplier), y + (10 * multiplier), pointsArray, landerMaterial);
		weldStrut(body, strut2.body, Vec2.weak( 20 * multiplier, 5 * multiplier), Vec2.weak( -4.375 * multiplier, -5 * multiplier));
		
		#if debug
		//trace("======Strut3======");
		#end		
		pointsArray[0] = new Vec2(6.75 * multiplier, -1.0 * multiplier);
		pointsArray[1] = new Vec2(-6.75 * multiplier,  -1.0 * multiplier);	
		pointsArray[2] = new Vec2(-8.75 * multiplier, 1.0 * multiplier);	
		pointsArray[3] = new Vec2(8.75 * multiplier, 1.0 * multiplier);	
		var strut3:FlxPhysSprite = createStrut(x - (18.75 * multiplier), y + (14 * multiplier), pointsArray, landerMaterial);
		weldStrut(body, strut3.body, Vec2.weak( -12 * multiplier, 13 * multiplier), pointsArray[0]);
		weldStrut(body, strut3.body, Vec2.weak( -10 * multiplier, 15 * multiplier), pointsArray[3]);
		weldStrut(strut1.body, strut3.body, Vec2.weak( -3.125 * multiplier, 5 * multiplier), pointsArray[2]);
		
		#if debug
		//trace("======Strut4======");
		#end		
		pointsArray[0] = new Vec2(6.75 * multiplier, -1.0 * multiplier);
		pointsArray[1] = new Vec2(-6.75 * multiplier,  -1.0 * multiplier);	
		pointsArray[2] = new Vec2(-8.75 * multiplier, 1.0 * multiplier);	
		pointsArray[3] = new Vec2(8.75 * multiplier, 1.0 * multiplier);		
		var strut4:FlxPhysSprite = createStrut(x + (18.75 * multiplier), y + (14 * multiplier), pointsArray, landerMaterial);
		weldStrut(body, strut4.body, Vec2.weak( 12 * multiplier, 13 * multiplier), pointsArray[1]);
		weldStrut(body, strut4.body, Vec2.weak( 10 * multiplier, 15 * multiplier), pointsArray[2]);
		weldStrut(strut2.body, strut4.body, Vec2.weak( 3.125 * multiplier, 5 * multiplier), pointsArray[3]);	
		
		#if debug
		//trace("======Strut5======");
		#end		
		pointsArray[0] = new Vec2(1.25 * multiplier, -2.5 * multiplier);
		pointsArray[1] = new Vec2(-1.25 * multiplier,  -2.5 * multiplier);	
		pointsArray[2] = new Vec2(-1.25 * multiplier, 2.5 * multiplier);	
		pointsArray[3] = new Vec2(1.25 * multiplier, 2.5 * multiplier);	
		var strut5:FlxPhysSprite = createStrut(x - (28.75 * multiplier), y + (17.5 * multiplier), pointsArray, landerMaterial);
		weldStrut(strut1.body, strut5.body, Vec2.weak( -5.625 * multiplier, 5 * multiplier), Vec2.weak(-1.25 * multiplier, -2.5 * multiplier));		
		weldStrut(strut1.body, strut5.body, Vec2.weak( -3.125 * multiplier, 5.0 * multiplier), Vec2.weak(1.25 * multiplier, -2.5 * multiplier));		
		weldStrut(strut3.body, strut5.body, Vec2.weak(-8.75 * multiplier, 1.0 * multiplier), Vec2.weak(1.25 * multiplier, -2.5 * multiplier));		
	
		#if debug
		//trace("======Strut6======");
		#end		
		pointsArray[3] = new Vec2(-1.25 * multiplier, -2.5 * multiplier);
		pointsArray[2] = new Vec2(1.25 * multiplier,  -2.5 * multiplier);	
		pointsArray[1] = new Vec2(1.25 * multiplier, 2.5 * multiplier);	
		pointsArray[0] = new Vec2(-1.25 * multiplier, 2.5 * multiplier);			
		var strut6:FlxPhysSprite = createStrut(x + (28.75 * multiplier), y + (17.5 * multiplier), pointsArray, landerMaterial);
		weldStrut(strut2.body, strut6.body, Vec2.weak( 5.625 * multiplier, 5 * multiplier), Vec2.weak( 1.25 * multiplier, -2.5 * multiplier));		
		weldStrut(strut2.body, strut6.body, Vec2.weak( 3.125 * multiplier, 5.0 * multiplier), Vec2.weak(-1.25 * multiplier, -2.5 * multiplier));		

		//Feet!
		#if debug
		//trace("======Foot1======");
		#end
		pointsArray[0] = new Vec2(1.25 * multiplier, -2.5 * multiplier);
		pointsArray[1] = new Vec2(-1.25 * multiplier,  -2.5 * multiplier);	
		pointsArray[2] = new Vec2(-3.75 * multiplier, 2.5 * multiplier);	
		pointsArray[3] = new Vec2(3.75 * multiplier, 2.5 * multiplier);		
		var foot1:FlxPhysSprite = createStrut(x - (28.75 * multiplier), y + (22.5 * multiplier), pointsArray, landerMaterial);
		weldStrut(strut5.body, foot1.body, Vec2.weak( -1.25 * multiplier, 2.5 * multiplier), Vec2.weak( -1.25 * multiplier, -2.5 * multiplier));		

		
		#if debug
		//trace("======Foot2======");
		#end		
		pointsArray[0] = new Vec2(1.25 * multiplier, -2.5 * multiplier);
		pointsArray[1] = new Vec2(-1.25 * multiplier,  -2.5 * multiplier);	
		pointsArray[2] = new Vec2(-3.75 * multiplier, 2.5 * multiplier);	
		pointsArray[3] = new Vec2(3.75 * multiplier, 2.5 * multiplier);		
		var foot2:FlxPhysSprite = createStrut(x + (28.75 * multiplier), y + (22.5 * multiplier), pointsArray, landerMaterial);
		weldStrut(strut6.body, foot2.body, Vec2.weak( 1.25 * multiplier, 2.5 * multiplier), Vec2.weak( 1.25 * multiplier, -2.5 * multiplier));		
		
		upperJet = new Vec2(0, -25 * multiplier);
		lowerJet = new Vec2(0, 15 * multiplier);
		mainEngineJet = new Vec2(lowerJet.x - (mainEngineEmitterWidth / 2), lowerJet.y);
		

		
	}
	
	override public function update():Void
	{
		var upperJetVec:Vec2 = body.localVectorToWorld(upperJet);
		var lowerJetVec:Vec2 = body.localVectorToWorld(lowerJet);
		
		var mainEngineJetVec:Vec2 = body.localVectorToWorld(lowerJet);
		
		mainEngineEmitter.x = x + (width / 2) + mainEngineJetVec.x - (mainEngineEmitter.width / 2);
		mainEngineEmitter.y = y + (height / 2) + mainEngineJetVec.y - (mainEngineEmitter.height / 2);
		
		lowerJetEmitter.x = x + (width / 2) + lowerJetVec.x;
		lowerJetEmitter.y = y + (height / 2) + lowerJetVec.y;
		
		upperJetEmitter.x = x + (width / 2) + upperJetVec.x;
		upperJetEmitter.y = y + (height / 2) + upperJetVec.y;
		
		#if debug
		Registry.debugString.text = "";
		Registry.debugString.text += "LanderX: " + FlxU.roundDecimal(x, 3) + " LanderY: " + FlxU.roundDecimal(y, 3);
		
		var totalImpulse:Vec3 = body.totalImpulse();
		
		Registry.debugString.text += "\nImpulse: " + FlxU.roundDecimal(totalImpulse.x, 3) + " " 
			+ FlxU.roundDecimal(totalImpulse.y, 3) + " " + FlxU.roundDecimal(totalImpulse.z, 3);
			
		if (totalImpulse.x > maxImpulse.x) maxImpulse.x = totalImpulse.x;
		if (totalImpulse.y > maxImpulse.y) maxImpulse.y = totalImpulse.y;
		if (totalImpulse.z > maxImpulse.z) maxImpulse.z = totalImpulse.z;
		if (totalImpulse.x < minImpulse.x) minImpulse.x = totalImpulse.x;
		if (totalImpulse.y < minImpulse.y) minImpulse.y = totalImpulse.y;
		if (totalImpulse.z < minImpulse.z) minImpulse.z = totalImpulse.z;
		
		if (totalImpulse.length > maxImpulseMagnitude) maxImpulseMagnitude = totalImpulse.length;
		

		if (maxImpulseMagnitude > Registry.THRESHOLD_JAM && crewStatus < 5) 
		{ 
			FlxG.flash(0xffff0000);
			crewStatus = 5;
		}
		if (maxImpulseMagnitude > Registry.THRESHOLD_DEAD && crewStatus < 4) 
		{ 
			FlxG.flash(0xffff0000);
			crewStatus = 4;
		}
		if (maxImpulseMagnitude > Registry.THRESHOLD_INJURED && crewStatus < 3) 
		{ 
			FlxG.flash(0xffff0000);
			crewStatus = 3;
		}
		if (maxImpulseMagnitude > Registry.THRESHOLD_TROUSERS && crewStatus < 2) 
		{ 
			FlxG.flash(0xffff0000);
			crewStatus = 2;
		}
		if (maxImpulseMagnitude > Registry.THRESHOLD_SHAKEN && crewStatus < 1) 
		{
			FlxG.flash(0xffff0000);
			crewStatus = 1;
		}


		
		Registry.debugString.text += "\nMax Impulse: " + FlxU.roundDecimal(maxImpulse.x, 3) + " " 
			+ FlxU.roundDecimal(maxImpulse.y, 3) + " " + FlxU.roundDecimal(maxImpulse.z, 3);	
		Registry.debugString.text += "\nMin Impulse: " + FlxU.roundDecimal(minImpulse.x, 3) + " " 
			+ FlxU.roundDecimal(minImpulse.y, 3) + " " + FlxU.roundDecimal(minImpulse.z, 3);
		Registry.debugString.text += "\nMaxImpuseMagnitude: " + FlxU.roundDecimal(maxImpulseMagnitude, 3) + 
			" Crew Status: " + crewStatusString[crewStatus];
		
		#end
		
		mainEngineEmitter.minRotation = angle - 5;
		mainEngineEmitter.maxRotation = angle + 5;
		
		
		if (FlxG.keys.pressed("UP") || FlxG.keys.pressed("W") || Registry.buttonUp.status == FlxButton.PRESSED)
		{
			thrust -= Registry.thrustDelta;
		}
		
		if (FlxG.keys.pressed("DOWN") || FlxG.keys.pressed("S") || Registry.buttonDown.status == FlxButton.PRESSED)
		{
			thrust += Registry.thrustDelta;
		}
		
		if (FlxG.keys.pressed("LEFT") || FlxG.keys.pressed("A") || Registry.buttonLeft.status == FlxButton.PRESSED)
		{
			body.applyImpulse(body.localVectorToWorld(Vec2.weak(-Registry.maneuverJetThrust, 0)), upperJetVec);
			body.applyImpulse(body.localVectorToWorld(Vec2.weak(Registry.maneuverJetThrust, 0)), lowerJetVec);
			fuel = fuel - Registry.maneuverJetThrust;
		}
		
		if (FlxG.keys.pressed("RIGHT") || FlxG.keys.pressed("D") || Registry.buttonRight.status == FlxButton.PRESSED)
		{
			body.applyImpulse(body.localVectorToWorld(Vec2.weak(Registry.maneuverJetThrust, 0)), upperJetVec);
			body.applyImpulse(body.localVectorToWorld(Vec2.weak( -Registry.maneuverJetThrust, 0)), lowerJetVec);
			fuel = fuel - Registry.maneuverJetThrust;
		}		
		
		thrust = FlxU.bound(thrust, -Registry.thrustMax, 0);
		#if debug
		Registry.debugString.text += "\nThrust: " + thrust;
		#end
		
		fuel = fuel + thrust;  // Remember, thrust is negative
		
		var thrustVecMagnitude = (thrust / thrustMax) * 100 * multiplier;
		
		var thrustVec:Vec2 = new Vec2(0, thrustVecMagnitude);
		var minThrustVec:Vec2 = new Vec2( -20, -thrustVecMagnitude); // These vectors are for the exhaust particles, so direction is reversed.
		var maxThrustVec:Vec2 = new Vec2(20, -thrustVecMagnitude);
		var minThrustWorldVec:Vec2 = body.localVectorToWorld(minThrustVec);
		var maxThrustWorldVec:Vec2 = body.localVectorToWorld(maxThrustVec);
		var minX:Float = FlxU.min(minThrustWorldVec.x, maxThrustWorldVec.x);
		var maxX:Float = FlxU.max(minThrustWorldVec.x, maxThrustWorldVec.x);
		var minY:Float = FlxU.min(minThrustWorldVec.y, maxThrustWorldVec.y);
		var maxY:Float = FlxU.max(minThrustWorldVec.y, maxThrustWorldVec.y);
			
		mainEngineEmitter.setXSpeed(minX + body.velocity.x, maxX + body.velocity.x);
		mainEngineEmitter.setYSpeed(minY + body.velocity.y, maxY + body.velocity.y);
		
		#if debug
		Registry.debugString.text += "\nXV: " + FlxU.roundDecimal(body.velocity.x, 3) 
			+ " YV: " + FlxU.roundDecimal(body.velocity.y, 3) + " AV: " + FlxU.roundDecimal(body.angularVel, 3);
			
		Registry.debugString.text += "\nFuel: " + FlxU.roundDecimal(fuel, 3);
		#end
		
		if (thrust <  0)
		{
			mainEngineEmitter.on = true;
		}
		else
		{
			mainEngineEmitter.on = false;
		}
		body.applyImpulse(body.localVectorToWorld(Vec2.weak(0, thrust)));

		#if debug
		Registry.debugString.text += "\nScore: " + FlxG.score;
		#end
		
		super.update();
	}
	
	private function createStrut(X, Y, pointsArray:Array<Vec2>, material):FlxPhysSprite
	{
		var strut:FlxPhysSprite;
		
		strut = new FlxPhysSprite(X, Y);
		strut.body.shapes.clear();
		strut.body.shapes.add(new Polygon(pointsArray, material));
		
		#if debug
		// trace(pointsArray.length);
		#end
		
		var maxX:Float=-2000;
		var minX:Float = 2000;
		var minY:Float = 2000;
		var maxY:Float = -2000;		
		for (i in 0...pointsArray.length)
		{
			if (pointsArray[i].x > maxX)
			{
				maxX = pointsArray[i].x;
			}
			if (pointsArray[i].x < minX)
			{
				minX = pointsArray[i].x;
			}
			if (pointsArray[i].y > maxY)
			{
				maxY = pointsArray[i].y;
			}
			if (pointsArray[i].y < minY)
			{
				minY = pointsArray[i].y;
			}
		}	
		#if debug
		// trace("MinX: " + minX + " MaxX: " + maxX + " MinY: " + minY +  " MaxY: " + maxY);	
		#end
		
		var strutWidth:Int;
		var strutHeight:Int;
		
		strutWidth = FlxU.floor(FlxU.max(FlxU.abs(minX), FlxU.abs(maxX)) * 2);
		strutHeight = FlxU.floor(FlxU.max(FlxU.abs(minY), FlxU.abs(maxY)) * 2);
		strut.makeGraphic(strutWidth, strutHeight, 0x00000000,true);
		
		drawArray(strut, pointsArray);
		#if debug
		// trace("----");
		#end

		#if debug
		// strut.drawLine(0, 0, 0, strutHeight - 1, 0xffff0000);
		//strut.drawLine(0, strutHeight - 1, strutWidth - 1, strutHeight - 1, 0xffff0000);
		//strut.drawLine(strutWidth - 1, strutHeight - 1, strutWidth - 1, 0, 0xffff0000);
		//strut.drawLine(strutWidth - 1, 0, 0, 0, 0xffff0000);
		#end
		FlxG.state.add(strut);
		strut.cameras = [Registry.zoomCamera];
		
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
		strutWeld.maxError = Registry.weldStrength;
		strutWeld.breakUnderError = true;
		strutWeld.cbTypes.add(STRUTWELD);
		
	}
	
	private function drawArray(sprite:FlxPhysSprite, pointsArray:Array<Vec2>):Void 
	{
		#if debug
		//trace("X: " + sprite.x + " Y: " + sprite.y);
		//trace("Width: " + sprite.width + " Height: " + sprite.height);
		#end
		for (i in 0...pointsArray.length)
		{
			var fromX:Float;
			var fromY:Float;
			var toX:Float;
			var toY:Float;
			
			fromX = Registry.clamp(pointsArray[i].x + (sprite.width / 2), 0, sprite.width - 1);
			fromY = Registry.clamp(pointsArray[i].y + (sprite.height / 2), 0, sprite.height - 1);
			toX = Registry.clamp(pointsArray[(i + 1) % pointsArray.length].x + (sprite.width / 2), 0, sprite.width - 1);	
			toY = Registry.clamp(pointsArray[(i + 1) % pointsArray.length].y + (sprite.height / 2), 0, sprite.height - 1);
			
			sprite.drawLine(fromX, fromY, toX, toY, 0xffffffff, 1);
			#if debug
			//trace(i + " " + pointsArray[i].x + "(" + fromX + ")" + ", " + pointsArray[i].y + "(" + fromY + ")" + " -> " 
			//	+ pointsArray[(i + 1) % pointsArray.length].x + "(" + toX + ")" + ", " + pointsArray[(i + 1) % pointsArray.length].y + "(" + toY + ")");
			#end
		}
	}
	
	/**
	 * Called when a weld gets broken.  Creates pretty sparks!
	 * @param	cb	The constraint callback.
	 */
	
	public function breakListener(cb:ConstraintCallback):Void 
	{
		var brokenWeld:WeldJoint = cast(cb.constraint, WeldJoint);
		#if debug
		Registry.debugString.text += "\nBroken constraint! " + brokenWeld.toString();
		trace("Broken constraint! ");
		#end
		FlxG.score -= 100;
		
		var sparks1Vec:Vec2 = brokenWeld.body1.localPointToWorld(brokenWeld.anchor1);
		var sparks2Vec:Vec2 = brokenWeld.body2.localPointToWorld(brokenWeld.anchor2);
		
		#if debug
		trace(brokenWeld.anchor1.toString() + " " + brokenWeld.anchor2.toString());
		#end
		
		var sparks1:FlxEmitter = new FlxEmitter(sparks1Vec.x, sparks1Vec.y);	
		var sparks2:FlxEmitter = new FlxEmitter(sparks2Vec.x, sparks2Vec.y);	
		FlxG.state.add(sparks1);
		FlxG.state.add(sparks2);
		for (i in 0...20)
			{
				var spark1:SparkParticle = new SparkParticle();
				var spark2:SparkParticle = new SparkParticle();
				spark1.makeGraphic(2, 2, 0xffffffff);
				spark2.makeGraphic(2, 2, 0xffffffff);
				spark1.exists = spark2.exists = false;
				spark1.cameras = spark2.cameras = [Registry.zoomCamera];
				sparks1.add(spark1);
				sparks2.add(spark2);
			}
		sparks1.start(true,1.0);
		sparks2.start(true, 1.0);
	}
	
	function proximityEnterCallback(cb:InteractionCallback)
	{
		Registry.zoomCamera.targetZoom = 3.0;
	}
	
	function proximityExitCallback(cb:InteractionCallback)
	{
		Registry.zoomCamera.targetZoom = 0.6;
	}
	
	
}