Type TIntroState Extends TGameState

	Const spacing:Float = 2.0
	Field text:String[] = ["Chipmunk Physics Examples", "using the", "RetroRemakes Game Framework", "Press Space to Move Through Examples", "Press Escape to Exit", "Press Space To Start"]
	Field fontHeight:Int
	Field lineSpacing:Int
	Field textY:Int
	Field finished_:Int = False
	
	Field font:TImageFont
	
	Method Initialise()
		font = LoadImageFont("incbin::media\VeraMono.ttf", 14)
		SetImageFont(font)
		fontHeight = TextHeight("")
		lineSpacing = fontHeight * spacing
		textY = (rrGetGraphicsHeight() / 2) - (text.Length * fontHeight / 2) - ((text.Length - 1) * fontHeight * 0.5)	
	End Method
	
	Method Leave()
		rrUnsubscribeFromChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Enter()
		rrSubscribeToChannel(CHANNEL_INPUT, Self)
		finished_ = False
	End Method
	
	Method Update()
		If finished_ Then rrNextGameState()
	End Method
	
	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardInput(message)
		End Select
	End Method
	
	Method HandleKeyboardInput(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		
		If data.key = KEY_SPACE And data.keyHits
			finished_ = True
		End If
	End Method
	
	Method Render()
		SetColor 255, 255, 0
		For Local i:Int = 0 To text.Length - 1
			DrawText text[i], (rrGetGraphicsWidth() / 2) - (TextWidth(text[i]) / 2), textY + (lineSpacing * i)
		Next
	End Method
	
	Method Shutdown()
	End Method
	
End Type

