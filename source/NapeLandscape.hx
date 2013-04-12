package ;

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
		
		var landscapeArray:Array<Float> = new Array<Float>();
		
		var pointsArray:Array<Vec2> = new Array<Vec2>();
		
		octave1 = new SmoothNoise(6, arrayLength);
		octave2 = new SmoothNoise(12, arrayLength);
		octave3 = new SmoothNoise(24, arrayLength);
		octave4 = new SmoothNoise(48, arrayLength);
		
		var landscapeLength = FlxG.width;
		var landscapeHeight = FlxG.height;
		
		var lengthRatio:Float = cast(landscapeLength, Float) / cast(arrayLength, Float);
		var heightRatio:Float = landscapeHeight;
		
		for (i in 0...arrayLength)
		{
			var noiseValue = (octave1.noise(i) / 2) + (octave2.noise(i) / 4) + (octave3.noise(i) / 8) + (octave4.noise(i) / 16);
			noiseValue = (noiseValue * 2) - 1;
			noiseValue = FlxU.abs(noiseValue);
			landscapeArray[i] = FlxU.roundDecimal(noiseValue, 3); 
			pointsArray[i] = new Vec2(i * lengthRatio, noiseValue * heightRatio);
		}
		
		#if debug
				
		for (i in 0...octave1.values.length)
		{
			octave1.values[i] = FlxU.roundDecimal(octave1.values[i], 3);
		}
		// Registry.debugString.text += messageString;
		
		#end
		
		pointsArray.push(new Vec2(landscapeLength, landscapeHeight));
		pointsArray.push(new Vec2(0, landscapeHeight));
		
		pointsArray.reverse();
		

		makeLandscapeBody(pointsArray);
	}
	
	
	function makeLandscapeBody(pointsArray:Array<Vec2>)
	{

		var polygonShape:Polygon;
		var polys:GeomPoly;
		
		body.shapes.clear();

		// polygonShape = new Polygon(pointsArray);
		
		polys = new GeomPoly(pointsArray);
		
		if (polys != null)
		{
			for (poly in polys.convexDecomposition())
			{
				body.shapes.add(new Polygon(poly));
			}
		}
		
		body.type = BodyType.STATIC;
		
	}
	
	
}