package ;
import nape.callbacks.CbType;
import nme.display.Sprite;
import org.flixel.FlxButton;
import org.flixel.FlxCamera;
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
	public static var worldMaxX:Float = 2560;
	public static var worldMinY:Float = 0;
	public static var worldMaxY:Float = 1600;
	
	public static var buttonUp:FlxButton;
	public static var buttonDown:FlxButton;
	public static var buttonLeft:FlxButton;
	public static var buttonRight:FlxButton;
	
	public static var thrust:Float = 0.0;
	public static var thrustMax:Float = 1500;
	
	public static var maneuverJetThrust:Float = 5500;
	public static var thrustDelta:Float = 150;
	
	public static var landscape:NapeLandscape;
	
	public static var LANDSCAPE:CbType;
	public static var PLATFORM:CbType;
	public static var PROXIMITYDETECTOR:CbType;
	
	public static var zoomCamera:ZoomCamera;
	public static var weldStrength:Float = 20;
	
	// filter groups
	public static var FILTER_LANDERBODY:Int = 1;
	public static var FILTER_LANDERSTRUT:Int = 2;
	public static var FILTER_LANDSCAPE:Int = 4;
	public static var FILTER_PLATFORM:Int = 8;
	public static var FILTER_BORDER:Int = 8;
	
	public static var platformWidth:Int = 100;
	
	
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