class ApplicationMain
{

	#if waxe
	static public var frame : wx.Frame;
	static public var autoShowFrame : Bool = true;
	#if nme
	static public var nmeStage : wx.NMEStage;
	#end
	#end
	
	public static function main()
	{
		#if nme
		nme.Lib.setPackage("Zaphod", "EvolvaLanda", "com.example.myapp", "0.0.1");
		
		#end
		
		#if waxe
		wx.App.boot(function()
		{
			
			frame = wx.Frame.create(null, null, "EvolvaLanda", null, { width: 1280, height: 800 });
			
			#if nme
			var stage = wx.NMEStage.create(frame, null, null, { width: 1280, height: 800 });
			#end
			
			Main.main();
			
			if (autoShowFrame)
			{
				wx.App.setTopWindow(frame);
				frame.shown = true;
			}
		});
		#else
		
		nme.Lib.create(function()
			{ 
				//if ((1280 == 0 && 800 == 0) || true)
				//{
					nme.Lib.current.stage.align = nme.display.StageAlign.TOP_LEFT;
					nme.Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
				//}
				
				var hasMain = false;
				
				for (methodName in Type.getClassFields(Main))
				{
					if (methodName == "main")
					{
						hasMain = true;
						break;
					}
				}
				
				if (hasMain)
				{
					Reflect.callMethod (Main, Reflect.field (Main, "main"), []);
				}
				else
				{
					var instance = Type.createInstance(Main, []);
					#if nme
					if (Std.is (instance, nme.display.DisplayObject)) {
						nme.Lib.current.addChild(cast instance);
					}
					#end
				}
			},
			1280, 800, 
			30, 
			16777215,
			(true ? nme.Lib.HARDWARE : 0) |
			(false ? nme.Lib.ALLOW_SHADERS : 0) |
			(false ? nme.Lib.REQUIRE_SHADERS : 0) |
			(false ? nme.Lib.DEPTH_BUFFER : 0) |
			(false ? nme.Lib.STENCIL_BUFFER : 0) |
			(true ? nme.Lib.RESIZABLE : 0) |
			(false ? nme.Lib.BORDERLESS : 0) |
			(false ? nme.Lib.VSYNC : 0) |
			(true ? nme.Lib.FULLSCREEN : 0) |
			(0 == 4 ? nme.Lib.HW_AA_HIRES : 0) |
			(0 == 2 ? nme.Lib.HW_AA : 0),
			"EvolvaLanda"
			
		);
		#end
		
	}
	
	
	#if neko
	public static function __init__ () {
		
		untyped $loader.path = $array ("@executable_path/", $loader.path);
		
	}
	#end
	
	
	public static function getAsset(inName:String):Dynamic
	{
		#if nme
		
		if (inName == "Beep")
		{
			
			return nme.Assets.getSound ("Beep");
			
		}
		
		if (inName == "assets/data/autotiles.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/autotiles.png");
			
		}
		
		if (inName == "assets/data/autotiles_alt.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/autotiles_alt.png");
			
		}
		
		if (inName == "assets/data/base.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/base.png");
			
		}
		
		if (inName == "assets/data/beep.mp3")
		{
			
			return nme.Assets.getSound ("assets/data/beep.mp3");
			
		}
		
		if (inName == "assets/data/beep.wav")
		{
			
			return nme.Assets.getSound ("assets/data/beep.wav");
			
		}
		
		if (inName == "assets/data/button.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/button.png");
			
		}
		
		if (inName == "assets/data/button_a.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/button_a.png");
			
		}
		
		if (inName == "assets/data/button_b.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/button_b.png");
			
		}
		
		if (inName == "assets/data/button_c.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/button_c.png");
			
		}
		
		if (inName == "assets/data/button_down.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/button_down.png");
			
		}
		
		if (inName == "assets/data/button_left.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/button_left.png");
			
		}
		
		if (inName == "assets/data/button_right.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/button_right.png");
			
		}
		
		if (inName == "assets/data/button_up.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/button_up.png");
			
		}
		
		if (inName == "assets/data/button_x.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/button_x.png");
			
		}
		
		if (inName == "assets/data/button_y.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/button_y.png");
			
		}
		
		if (inName == "assets/data/courier.ttf")
		{
			
			return nme.Assets.getFont ("assets/data/courier.ttf");
			
		}
		
		if (inName == "assets/data/cursor.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/cursor.png");
			
		}
		
		if (inName == "assets/data/default.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/default.png");
			
		}
		
		if (inName == "assets/data/fontData10pt.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/fontData10pt.png");
			
		}
		
		if (inName == "assets/data/fontData11pt.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/fontData11pt.png");
			
		}
		
		if (inName == "assets/data/handle.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/handle.png");
			
		}
		
		if (inName == "assets/data/Lander.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/Lander.png");
			
		}
		
		if (inName == "assets/data/LanderTemplate.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/LanderTemplate.png");
			
		}
		
		if (inName == "assets/data/logo.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/logo.png");
			
		}
		
		if (inName == "assets/data/logo_corners.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/logo_corners.png");
			
		}
		
		if (inName == "assets/data/logo_light.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/logo_light.png");
			
		}
		
		if (inName == "assets/data/nokiafc22.ttf")
		{
			
			return nme.Assets.getFont ("assets/data/nokiafc22.ttf");
			
		}
		
		if (inName == "assets/data/stick.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/stick.png");
			
		}
		
		if (inName == "assets/data/vcr/flixel.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/vcr/flixel.png");
			
		}
		
		if (inName == "assets/data/vcr/open.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/vcr/open.png");
			
		}
		
		if (inName == "assets/data/vcr/pause.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/vcr/pause.png");
			
		}
		
		if (inName == "assets/data/vcr/play.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/vcr/play.png");
			
		}
		
		if (inName == "assets/data/vcr/record_off.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/vcr/record_off.png");
			
		}
		
		if (inName == "assets/data/vcr/record_on.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/vcr/record_on.png");
			
		}
		
		if (inName == "assets/data/vcr/restart.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/vcr/restart.png");
			
		}
		
		if (inName == "assets/data/vcr/step.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/vcr/step.png");
			
		}
		
		if (inName == "assets/data/vcr/stop.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/vcr/stop.png");
			
		}
		
		if (inName == "assets/data/vis/bounds.png")
		{
			
			return nme.Assets.getBitmapData ("assets/data/vis/bounds.png");
			
		}
		
		if (inName == "assets/HaxeFlixel.svg")
		{
			
			return nme.Assets.getText ("assets/HaxeFlixel.svg");
			
		}
		
		#end
		return null;
	}
	
	
}
