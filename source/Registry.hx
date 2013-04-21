package ;
import nme.display.Sprite;
import org.flixel.FlxButton;
import org.flixel.FlxText;

/**
 * ...
 * @author Mike Cugley
 */
class Registry
{
	public static var ratio:Float = 10.0;
	
	public static var debugSprite:Sprite;
	
	
	#if debug
	public static var debugString:FlxText;
	#end
	
	public static var worldMinX:Float = 0;
	public static var worldMaxX:Float = 2000;
	public static var worldMinY:Float = 0;
	public static var worldMaxY:Float = 2000;
	
	public static var buttonUp:FlxButton;
	public static var buttonDown:FlxButton;
	public static var buttonLeft:FlxButton;
	public static var buttonRight:FlxButton;
	
	public static var thrust:Float = 0.0;
	public static var thrustMax:Float = 1500;
	
	public static var maneuverJetThrust:Float = 50;
	public static var thrustDelta:Float = 20;

	public function new() 
	{
		
	}
	
	public static function clamp(value:Float, min:Float, max:Float):Float
	{
		if(value < min) return min;
		if(value > max) return max;
		return value;
	}
	
}