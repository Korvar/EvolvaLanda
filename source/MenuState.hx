package;

import nme.Assets;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;

class MenuState extends FlxState
{
	var titleText:FlxText;
	var menuText:FlxText;
	
	var instructionsButton:FlxButton;
	var startButton:FlxButton;
	var fontPath = "assets/data/fonts/westminster.ttf";

	
	override public function create():Void
	{
		#if !neko
		FlxG.bgColor = 0xff131c1b;
		#else
		FlxG.camera.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		FlxG.mouse.show();
		
		titleText = new FlxText(0, FlxG.height / 3, FlxG.width, "EvolvaLanda");
		titleText.setFormat(fontPath, 200, 0xFFFFFF, "center");
		titleText.alignment = "center";
		add(titleText);
		
		var startButtonHeight:Int = 72;
		startButton = new FlxButton(0, FlxG.height / 2, null, startGame);
		startButton.makeGraphic(Std.int(FlxG.width), startButtonHeight, 0x00FFFFFF);
		startButton.label=new FlxText(0, 0, FlxG.width, "Launch Your Lander");
		startButton.label.setFormat(fontPath, startButtonHeight, 0xFFFFFF, "center");
		startButton.onOver = startButtonOnOver;
		startButton.onOut = startButtonOnOut;
		add(startButton);	

		var instructionsButtonHeight:Int = 64;
		instructionsButton = new FlxButton(0, FlxG.height / 2 + 100, null, gotoInstructions);
		instructionsButton.makeGraphic(Std.int(FlxG.width), instructionsButtonHeight, 0x00FFFFFF);
		instructionsButton.label=new FlxText(0, 0, FlxG.width, "Instructions");
		instructionsButton.label.setFormat(fontPath, instructionsButtonHeight, 0xFFFFFF, "center");
		instructionsButton.onOver = instructionsButtonOnOver;
		instructionsButton.onOut = instructionsButtonOnOut;
		add(instructionsButton);
	}
	
	function instructionsButtonOnOver()
	{
		instructionsButton.label.color = 0xFFFF00;
	}	
	function instructionsButtonOnOut()
	{
		instructionsButton.label.color = 0xFFFFFF;
	}	
	
	function startButtonOnOver()
	{
		startButton.label.color = 0xFFFF00;
	}	
	function startButtonOnOut()
	{
		startButton.label.color = 0xFFFFFF;
	}
	
	function gotoInstructions()
	{
		FlxG.switchState(new InstructionState());
	}
	
	private function startGame():Void 
	{
		FlxG.switchState(new NapePlayState());
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
	}	
}