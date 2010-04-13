SuperStrict

Import retroremakes.rrfw

rrUseExeDirectoryForData()

rrEngineInitialise()

TGameEngine.GetInstance().SetGameManager(New GameManager)

rrEngineRun()

Type GameManager Extends TGameManager

	Const KEY_DELAY_MS:Int = 100
	
	Field activeOptionColour:TColourGen
	Field activeOption:Int = 0
	Field colours:TColourGen = New TColourGen
	
	Field controlFont:TImageFont
	Field exampleFont:TImageFont
	
	Field keyDelay:Int
	
	Method Initialise()
		' Load the colourgen used for the active option
		rrLoadResourceColourGen("resources/colours/FastWhiteThrob.ini")
		activeOptionColour = rrGetResourceColourGen("resources/colours/FastWhiteThrob.ini")
		
		rrLoadResourceImageFont("resources/fonts/VeraMoBd.ttf", 14)
		controlFont = rrGetResourceImageFont("resources/fonts/VeraMoBd.ttf", 14)
		
		rrLoadResourceImageFont("resources/fonts/VeraMoBd.ttf", 52)
		exampleFont = rrGetResourceImageFont("resources/fonts/VeraMoBd.ttf", 52)
	End Method
	
	Method Stop()
		' Unsubscribe from the input channel
		TMessageService.GetInstance().UnsubscribeFromChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Start()
		Initialise()
		' Subscribe to the input channel
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Update()
	End Method
	
	Method Render(tweening:Double, fixed:Int = False)
		SetImageFont(controlFont)
		SetBlend(ALPHABLEND)
		SetColor(255, 255, 255)
		SetAlpha(1.0)
		DrawText("Up/Down arrows to select setting", 0, 20)
		DrawText("Left/Right/Page Up/Page Down keys to modify values", 0, 40)
		DrawText("Press 'S' to save current oscillator settings", 0, 60)
		
		Local startY:Int = 100
		Local i:Int = 0
		SetColours(i)
		DrawText("    Red Low: " + colours.GetRedLow(), 2, startY + (15 * i))
		i:+1
		SetColours(i)
		DrawText("   Red High: " + colours.GetRedHigh(), 2, startY + (15 * i))
		i:+1
		SetColours(i)
		DrawText("  Red Speed: " + colours.GetRedSpeed(), 2, startY + (15 * i))
		i:+1
		SetColours(i)
		DrawText("  Green Low: " + colours.GetGreenLow(), 2, startY + (15 * i))
		i:+1
		SetColours(i)
		DrawText(" Green High: " + colours.GetGreenHigh(), 2, startY + (15 * i))
		i:+1
		SetColours(i)
		DrawText("Green Speed: " + colours.GetGreenSpeed(), 2, startY + (15 * i))
		i:+1		
		SetColours(i)
		DrawText("   Blue Low: " + colours.GetBlueLow(), 2, startY + (15 * i))
		i:+1
		SetColours(i)
		DrawText("  Blue High: " + colours.GetBlueHigh(), 2, startY + (15 * i))
		i:+1
		SetColours(i)
		DrawText(" Blue Speed: " + colours.GetBlueSpeed(), 2, startY + (15 * i))
		i:+1
		SetColours(i)
		DrawText("  Alpha Low: " + colours.GetAlphaLow(), 2, startY + (15 * i))
		i:+1
		SetColours(i)
		DrawText(" Alpha High: " + colours.GetAlphaHigh(), 2, startY + (15 * i))
		i:+1
		SetColours(i)
		DrawText("Alpha Speed: " + colours.GetAlphaSpeed(), 2, startY + (15 * i))
		i:+1
		
		TColourOscillator.GetInstance().SetColours(colours)
		DrawRect(400 - 100, 300 - 100, 200, 200)
		
		SetImageFont(exampleFont)
		
		TColourOscillator.GetInstance().SetColours(colours, 100.0)
		DrawText("Example Text", 400 - (TextWidth("Example Text") / 2), 420)
		
		SetImageFont(controlFont)
	End Method
	
	Method Shutdown()
	End Method

	Method HandleKeyboardInput(message:TMessage)
			Local i:Int
			Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
			Select data.key
				Case KEY_UP
					If data.keyHits
						activeOption:-1
						If activeOption < 0 Then activeOption = 11
					EndIf
				Case KEY_DOWN
					If data.keyHits
						activeOption:+1
						If activeOption > 11 Then activeOption = 0
					EndIf
				Case KEY_LEFT
					If data.KeyState
						DecrementValue(1)
					End If
				Case KEY_RIGHT
					If data.keyState
						IncrementValue(1)
					End If
				Case KEY_PAGEUP
					If data.keyState
						IncrementValue(10)
					End If
				Case KEY_PAGEDOWN
					If data.keyState
						DecrementValue(10)
					End If
				Case KEY_S
					If data.keyHits
						Save()
					End If
				Case KEY_ESCAPE
					TGameEngine.GetInstance().Stop()
			End Select
	EndMethod

	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardInput(message)
		EndSelect
	End Method
			
	Method SetColours(Current:Int)
		If Current = activeOption
			TColourOscillator.GetInstance().SetColours(activeOptionColour)
		Else
			SetColor(255, 255, 255)
			SetAlpha(1.0)
		End If
	End Method
	
	Method DecrementValue(amount:Int)
		If MilliSecs() < keyDelay Then Return
		Select activeOption
			Case 0	'red low
				colours.SetRedLow(DecrementInt(colours.GetRedLow(), amount * 1))
			Case 1	'red high
				colours.SetRedHigh(DecrementInt(colours.GetRedHigh(), amount * 1))
			Case 2	'red speed
				colours.SetRedSpeed(DecrementFloat(colours.GetRedSpeed(), amount * 0.1))
			Case 3	'green low
				colours.SetGreenLow(DecrementInt(colours.GetGreenLow(), amount * 1))
			Case 4	'green high
				colours.SetGreenHigh(DecrementInt(colours.GetGreenHigh(), amount * 1))
			Case 5	'green speed
				colours.SetGreenSpeed(DecrementFloat(colours.GetGreenSpeed(), amount * 0.1))
			Case 6	'blue low
				colours.SetBlueLow(DecrementInt(colours.GetBlueLow(), amount * 1))
			Case 7	'blue high
				colours.SetBlueHigh(DecrementInt(colours.GetBlueHigh(), amount * 1))
			Case 8	'blue speed
				colours.SetBlueSpeed(DecrementFloat(colours.GetBlueSpeed(), amount * 0.1))
			Case 9	'alpha low
				colours.SetAlphaLow(DecrementInt(colours.GetAlphaLow(), amount * 1))
			Case 10	'alpha high
				colours.SetAlphaHigh(DecrementInt(colours.GetAlphaHigh(), amount * 1))
			Case 11	'alpha speed
				colours.SetAlphaSpeed(DecrementFloat(colours.GetAlphaSpeed(), amount * 0.1))
		End Select
		keyDelay = MilliSecs() + KEY_DELAY_MS
	End Method
	
	Method DecrementInt:Int(Current:Int, amount:Int)
		Current:-amount
		If Current < 0 Then Current = 0
		Return Current
	End Method
	
	Method DecrementFloat:Float(Current:Float, amount:Float)
		Current:-amount
		If Current < 0.0 Then Current = 0.0
		Return Current
	End Method	
	
	Method IncrementValue(amount:Int)
		If MilliSecs() < keyDelay Then Return
		Select activeOption
			Case 0	'red low
				colours.SetRedLow(IncrementInt(colours.GetRedLow(), amount * 1))
			Case 1	'red high
				colours.SetRedHigh(IncrementInt(colours.GetRedHigh(), amount * 1))
			Case 2	'red speed
				colours.SetRedSpeed(IncrementFloat(colours.GetRedSpeed(), amount * 0.1))
			Case 3	'green low
				colours.SetGreenLow(IncrementInt(colours.GetGreenLow(), amount * 1))
			Case 4	'green high
				colours.SetGreenHigh(IncrementInt(colours.GetGreenHigh(), amount * 1))
			Case 5	'green speed
				colours.SetGreenSpeed(IncrementFloat(colours.GetGreenSpeed(), amount * 0.1))
			Case 6	'blue low
				colours.SetBlueLow(IncrementInt(colours.GetBlueLow(), amount * 1))
			Case 7	'blue high
				colours.SetBlueHigh(IncrementInt(colours.GetBlueHigh(), amount * 1))
			Case 8	'blue speed
				colours.SetBlueSpeed(IncrementFloat(colours.GetBlueSpeed(), amount * 0.1))
			Case 9	'alpha low
				colours.SetAlphaLow(IncrementInt(colours.GetAlphaLow(), amount * 1))
			Case 10	'alpha high
				colours.SetAlphaHigh(IncrementInt(colours.GetAlphaHigh(), amount * 1))
			Case 11	'alpha speed
				colours.SetAlphaSpeed(IncrementFloat(colours.GetAlphaSpeed(), amount * 0.1))
		End Select
		keyDelay = MilliSecs() + KEY_DELAY_MS
	End Method
	
	Method IncrementInt:Int(Current:Int, amount:Int)
		Current:+amount
		If Current > 255 Then Current = 255
		Return Current
	End Method
	
	Method IncrementFloat:Float(Current:Float, amount:Float)
		Current:+amount
		If Current < 0.0 Then Current = 0.0
		Return Current
	End Method
	
	Method Save()
		Local path:String = RequestFile("Save As...", "INI File:ini", True)
		colours.Save(path)
	End Method
End Type

