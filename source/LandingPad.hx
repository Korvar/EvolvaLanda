package ;

import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import org.flixel.nape.FlxPhysSprite;
import org.flixel.nape.FlxPhysState;

/**
 * ...
 * @author Mike Cugley
 */
class LandingPad extends FlxPhysSprite
{

	public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null, CreateBody:Bool=true) 
	{
		super(X, Y, SimpleGraphic, CreateBody);
		
		body.shapes.clear();
		var thisBox:Polygon = new Polygon(Polygon.box(Registry.platformWidth, 25, true));
		thisBox.material = Material.steel();
		
		// thisBox.filter.collisionGroup = Registry.FILTER_LANDSCAPE;
		// thisBox.filter.collisionMask = ~ (Registry.FILTER_LANDSCAPE);

		body.cbTypes.add(Registry.PLATFORM);
		body.shapes.add(thisBox);
		body.type = BodyType.STATIC;
		body.space = FlxPhysState.space;
		
		
		makeGraphic(100, 25, 0x00000000);
		drawLine(0, 0, width-1, 0, 0xffffffff, 2);
		drawLine(width, 0, width-1, height-1, 0xffffffff, 2);
		drawLine(width-1, height-1, 0, width-1, 0xffffffff, 2);
		drawLine(0, width-1, 0, 0, 0xffffffff, 2);
	}
	
}