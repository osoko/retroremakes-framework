rem
	bbdoc: Type description
end rem
Type TScroller Extends TFontActor
	
	Const SCROLL_SPEED:Float = 4.0
	Const MESSAGE:String = "Hello and welcome to Shooty, an example game written " + ..
							"using the RetroRemakes Framework.  This example is designed " + ..
							"to show how to use the Layer system to manage " + ..
							"rendering in a game.....                                 "
	
	Field messageLength:Int
	Field yPos:Int
		
	Method New()
		Local font:TImageFont = rrGetResourceImageFont("resources/ArcadeClassic.ttf", 36)
		SetFont(font)
		SetImageFont(font)
		messageLength = TextWidth(MESSAGE)
		SetText(MESSAGE)
		yPos = TProjectionMatrix.GetInstance().GetHeight() - font.Height() - 10
		
		Local anim:TColourOscillatorAnimation = New TColourOscillatorAnimation
		anim.SetColourGen(rrGetResourceColourGen("resources/QuickerThrob.ini"))
		
		animationManager.AddAnimation(anim)
				
		Reset()
	End Method
	
	Method Render(tweening:Double, fixed:Int)
		Super.Render(tweening, fixed)
	End Method
	
	Method Update()
		Super.Update()
		Move(-SCROLL_SPEED, 0.0)
		If Self.currentPosition.x < - messageLength Then Reset()
	End Method
	
	Method Reset()
		SetPosition(TGraphicsService.GetInstance().width, yPos)
	End Method
	
End Type
