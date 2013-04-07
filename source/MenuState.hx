package;

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
	
	override public function create():Void
	{
		#if !neko
		FlxG.bgColor = 0xff131c1b;
		#else
		FlxG.camera.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		FlxG.mouse.show();
		
		titleText = new FlxText(0, FlxG.height / 3, FlxG.width, "EvolvaLanda", 32 );
		titleText.color = 0xFFFFFF;
		titleText.alignment = "center";
		add(titleText);
		
		menuText = new FlxText(0, FlxG.height / 2 + 50, FlxG.width, "Click to start!", 20);
		menuText.color = 0xFFFFFF;
		menuText.alignment = "center";
		add(menuText);
		
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
		
		if (FlxG.mouse.justPressed())
		{
			FlxG.switchState(new NapePlayState());
		}
	}	
}