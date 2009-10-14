Type TIntroState Extends TGameState

	Const spacing:Float = 2.0
	Field text:String[] = ["Chipmunk Physics Examples", "using the", "RetroRemakes Game Framework", "Press Space to Move Through Examples", "Press Escape to Exit", "Press Space To Start"]
	Field fontHeight:Int
	Field lineSpacing:Int
	Field textY:Int
	
	Field font:TImageFont
	
	Method Initialise()
		font = LoadImageFont("incbin::media\VeraMono.ttf", 14)
		SetImageFont(font)
		fontHeight = TextHeight("A")
		lineSpacing = fontHeight * spacing
		textY = (rrGetGraphicsHeight() / 2) - (Text.Length * fontHeight / 2) - ((Text.Length - 1) * fontHeight * 0.5)
	End Method
	
	Method Stop()
		
	End Method
	
	Method Start()
		Initialise()
	End Method
	
	Method Update()
	End Method
	
	Method Render(tweening:Double, fixed:Int = False)
		SetColor 255, 255, 0
		For Local i:Int = 0 To text.Length - 1
			DrawText text[i], (rrGetGraphicsWidth() / 2) - (TextWidth(text[i]) / 2), textY + (lineSpacing * i)
		Next
	End Method

	
End Type

