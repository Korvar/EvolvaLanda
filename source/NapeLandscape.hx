package ;

import nape.dynamics.InteractionFilter;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;
import nape.geom.Vec2;
import nape.phys.BodyType;
import nape.shape.Polygon;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxU;
import org.flixel.nape.FlxPhysSprite;

/**
 * ...
 * @author Mike Cugley
 */
class NapeLandscape extends FlxPhysSprite
{

	public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null, CreateBody:Bool=true) 
	{
		super(X, Y, SimpleGraphic, CreateBody);
		createLandscape();		
	}
	
	
	function createLandscape()
	{
		var octave1:SmoothNoise;
		var octave2:SmoothNoise;
		var octave3:SmoothNoise;
		var octave4:SmoothNoise;
		
		var arrayLength = 120; // FlxG.width;
		
		makeGraphic(Std.int(Registry.worldMaxX), Std.int(Registry.worldMaxY), 0x00000000, true);
		offset = new FlxPoint(-Registry.worldMaxX / 2, -Registry.worldMaxY / 2);
		
		var landscapeArray:Array<Float> = new Array<Float>();
		
		var pointsArray:Array<Vec2> = new Array<Vec2>();
		
		octave1 = new SmoothNoise(6, arrayLength);
		
		var minValue:Float = 2;
		var maxValue:Float = -2;
		for (value in octave1.values)
		{
			if (value > maxValue) maxValue = value;
			if (value < minValue) minValue = value;
		}
		
		for (i in 0...octave1.values.length)
		{
			octave1.values[i] = ((octave1.values[i] - minValue) / (maxValue - minValue));
		}
		
		
		
		#if debug
		trace("minValue: " + minValue + " maxValue: " + maxValue);
		trace(octave1.values.toString());
		#end
		
		octave2 = new SmoothNoise(12, arrayLength);
		octave3 = new SmoothNoise(24, arrayLength);
		octave4 = new SmoothNoise(48, arrayLength);
		
		var landscapeLength = Registry.worldMaxX;
		var landscapeHeight = Registry.worldMaxY / 2;
		
		var lengthRatio:Float = cast(landscapeLength, Float) / cast(arrayLength, Float);
		var heightRatio:Float = landscapeHeight;
		
		for (i in 0...arrayLength)
		{
			var noiseValue = (octave1.noise(i) * 0.8) + (octave2.noise(i) / 8) + (octave3.noise(i) / 16) + (octave4.noise(i) / 32);
			noiseValue = (noiseValue * 2) - 1;
			noiseValue = FlxU.abs(noiseValue);
			landscapeArray[i] = FlxU.roundDecimal(noiseValue, 3); 
			pointsArray[i] = new Vec2(i * lengthRatio, (noiseValue * heightRatio) + Registry.worldMaxY / 2);
			
			if (i > 0)
			{
				drawLine(pointsArray[i - 1].x, pointsArray[i - 1].y, pointsArray[i].x, pointsArray[i].y, 0xffffffff, 2);
			}
		}
		
		#if debug
				
		for (i in 0...octave1.values.length)
		{
			octave1.values[i] = FlxU.roundDecimal(octave1.values[i], 3);
		}
		// Registry.debugString.text += messageString;
		
		#end
		
		pointsArray.push(new Vec2(landscapeLength, Registry.worldMaxY + 100));
		pointsArray.push(new Vec2(0, Registry.worldMaxY + 100));
		
		pointsArray.reverse();
		

		makeLandscapeBody(pointsArray);
	}
	
	
	function makeLandscapeBody(pointsArray:Array<Vec2>)
	{

		var polygonShape:Polygon;
		var polys:GeomPoly;
		
		body.shapes.clear();

		polys = new GeomPoly(pointsArray);
		
		if (polys != null)
		{
			for (poly in polys.convexDecomposition())
			{
				body.shapes.add(new Polygon(poly));
			}
		}
		
		body.type = BodyType.STATIC;
		
		var interaction:InteractionFilter = new InteractionFilter();
		interaction.collisionGroup = Registry.FILTER_LANDSCAPE;
		interaction.collisionMask = ~ (Registry.FILTER_PLATFORM);
		
		body.setShapeFilters(interaction);
		
	}
	
	
}