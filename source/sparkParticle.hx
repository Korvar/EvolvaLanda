package ;

import org.flixel.FlxParticle;
import org.flixel.FlxTimer;
import org.flixel.FlxU;

typedef GradientEntry = { timeVal:Float, colour:Int }

/**
 * ...
 * @author Mike Cugley
 */
class SparkParticle extends FlxParticle
{
	var lifeTimer:FlxTimer;
	

	var gradient:Array<GradientEntry>;

	
	public function new() 
	{
		super();
		lifeTimer = new FlxTimer();
		
		gradient = [ { timeVal: 0.0,  colour:0xffffffff },
					{timeVal: 0.25, colour: 0xffffff00 },
					{timeVal: 0.5 , colour: 0xffff0000 },
					{timeVal: 0.9, colour: 0x00000000 } ];
					
		
	}
	
	override public function onEmit()
	{
		lifeTimer.start(lifespan);
		color = gradient[0].colour;
		
	}
	
	override public function update()
	{
		var timeleft:Float = lifeTimer.timeLeft;
		var timeRatio:Float = lifeTimer.progress;
		
		for (i in 0...gradient.length -1)
		{
			if (timeRatio == gradient[i].timeVal)
				color = gradient[i].colour;
			if (timeRatio > gradient[i].timeVal && timeRatio < gradient[i+1].timeVal)
			{
				var delta:Float = gradient[i + 1].timeVal - gradient[i].timeVal;
				var ratio = (timeRatio - gradient[i].timeVal) / delta;
				var col1:Array<Float> = FlxU.getRGBA(gradient[i].colour);
				var col2:Array<Float> = FlxU.getRGBA(gradient[i + 1].colour);
				var col3:Array<Float> = new Array<Float>();
				for (j in 0...col1.length)
				{
					col3[j] = col1[j] + (ratio * (col2[j] - col1[j]));
				}
				color = FlxU.makeColor(Std.int(col3[0]), Std.int(col3[1]), Std.int(col3[2]), col3[4]);
				//trace("Timeleft: " + timeleft + " timeRatio: " + timeRatio);
				//trace("i: " + i + " delta: " + delta + " ratio: " + ratio);
				//trace("col1: " + col1.toString() + " col2: " + col2.toString() + " col3: " + col3.toString());
			}
		}
	
		super.update();
		
	}
	
}