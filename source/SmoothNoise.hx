package ;
import org.flixel.FlxG;

/**
 * ...
 * @author Mike Cugley
 */
class SmoothNoise
{
	var values:Array<Float>;  // the actual values in the array
	var width:Int; // The number of entries
	var octave:Int; // The octave
	var frequency:Int;
	
	var lengthOfFullArray:Int;
	
	public function new(Width, LengthOfFullArray) 
	{
		width = Width;
		lengthOfFullArray = LengthOfFullArray;
		values = new Array<Float>();
		
		for (i in 0...width - 1)
		{
			values[i] = FlxG.random();
		}
	}
	
	public function noise(X:Float):Float
	{
		// X is from 0 to LengthOfFullArray - 1
		// Or it can be essentially %'ed into that range.
		var xMin:Int;
		var xMax:Int;
		var x:Float;
		var t:Float;
		
		x = X / lengthOfFullArray / width;
		
		xMin = Math.floor(x);
		xMax = xMin + 1;
		
		t = x - xMin;
		
		return interpolate(t, xMin, xMax);
	}
	
	function interpolate(t: Float, xMin:Int, xMax:Int):Float
	{
		t = map(t);
		
		return(values[xMin] * (1 - t) + (values[xMax] * t));
		
	}
	
	function map(t:Float):Float
	{
		// Mapping function.  By changing the mapping here, 
		// we effect how smooth the curve is
		
		// Linear 
		return(t);
	}
	
	function toString():String
	{
		return values.toString();
	}
}