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

	public function new() 
	{
		
	}
	
}