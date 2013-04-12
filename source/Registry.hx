package ;
import nme.display.Sprite;
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

	public function new() 
	{
		
	}
	
}