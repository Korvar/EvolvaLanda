package ;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxText;

/**
 * ...
 * @author Mike Cugley
 */
class InstructionState extends FlxState
{

	var backButton:FlxButton;
	var fontPath = "assets/data/fonts/westminster.ttf";

	override public function create():Void
	{
		#if !neko
		FlxG.bgColor = 0xff131c1b;
		#else
		FlxG.camera.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		FlxG.mouse.show();
		
		var titleTextSize:Int = 96;
		var titleText:FlxText = new FlxText(0, 100, FlxG.width, "Instructions");
		titleText.setFormat(fontPath, titleTextSize, 0xFFFFFF, "center");
		titleText.alignment = "center";
		add(titleText);
		
		var keys:Array<String> = [
			"Up / W",
			"Down / S",
			"Left / A",
			"Right / D"
			];
		
		var instructions:Array<String> = [
			"Increase Main Engine Thrust",
			"Decrease Main Engine Thrust",
			"Maneuver Jets: Anti-Clockwise",
			"Maneuver Jets: Clockwise"
			];
			
		// Keys
		var textX:Float = 0;
		var textY:Float = FlxG.height / 3;
		var textHeight:Int = 64;
		var textSpacing:Int = 50;
		for (text in keys)
		{
			var keyText:FlxText = new FlxText(textX, textY, Std.int(FlxG.width / 3), text, textHeight);
			textY += textSpacing;
			keyText.setFormat(fontPath, textHeight, 0xFFFFFF, "center");
			add(keyText);
		}		
		
		textX = FlxG.width / 3;
		textY = FlxG.height / 3;	
		for (text in instructions)
		{
			var instructionText:FlxText = new FlxText(textX, textY, Std.int(FlxG.width * 2 / 3), text, 32);
			textY += textSpacing;
			instructionText.setFormat(fontPath, textHeight, 0xFFFFFF, "center");
			add(instructionText);
		}
		
		var backButonHeight = 84;
		backButton = new FlxButton(0, textY + 100, null, goBack);
		backButton.makeGraphic(Std.int(FlxG.width), backButonHeight, 0x00FFFFFF);
		backButton.label=new FlxText(0, 0, FlxG.width, "Back");
		backButton.label.setFormat(fontPath, backButonHeight, 0xFFFFFF, "center");
		backButton.label.alignment = "center";
		backButton.onOver = backButtonOnOver;
		backButton.onOut = backButtonOnOut;
		add(backButton);		
	}
	
	function backButtonOnOver()
	{
		backButton.label.color = 0xFFFF00;
	}	
	function backButtonOnOut()
	{
		backButton.label.color = 0xFFFFFF;
	}
	
	function goBack()
	{
		FlxG.switchState(new MenuState());
	}
	
}