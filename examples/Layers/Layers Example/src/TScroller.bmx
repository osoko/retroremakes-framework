Rem
	bbdoc: Type description
end rem
Type TScroller Extends TFontActor
	
	Const SCROLL_SPEED:Float = 4.0
	Const MESSAGE:String = "Hello and welcome to Shooty, an example game written " + ..
							"using the RetroRemakes Framework.  This example is designed " + ..
							"to show how to use the Layer system to manage " + ..
							"rendering in a game.....                                 "
	
	Field disabled:Int = 0
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
		
		GetAnimationManager().AddAnimation(anim)
				
		Reset()
	End Method
	
	Method Render(tweening:Double, fixed:Int)
		If Not disabled
			Super.Render(tweening, fixed)
		EndIf
	End Method
	
	Method Update()
		Super.Update()
		Move(-SCROLL_SPEED, 0.0)
		If GetCurrentPosition().x < - messageLength
			Reset()
			disabled = 1
		ElseIf disabled = 1
			disabled = 0
		EndIf
	End Method
	
	Method Reset()
		SetPosition(TGraphicsService.GetInstance().GetWidth(), yPos)
	End Method
	
End Type
