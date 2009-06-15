SuperStrict

Import retroremakes.rrfw

rrUseExeDirectoryForData()

rrEngineInitialise()

Local joystickExample:TJoystickExample = New TJoystickExample

rrAddGameState(joystickExample)

rrEnableKeyboardInput(True)

rrEngineRun()


Type TJoystickExample Extends TGameState

	Field nJoysticks:Int
	Field displayJoystick:Int
	Field displayData:TJoystickMessageData
	Field t:Int = 0
	Field deadzones:Float[]
	
	Method Initialise()
		nJoysticks = rrGetJoystickCount()
		If nJoysticks = 0
			Notify("ERROR: No joysticks found.  Terminating.", True)
			rrEngineStop()
		EndIf
		deadzones = New Float[nJoysticks]
		Local i:Int
		For i = 0 To nJoysticks - 1
			deadzones[i] = TJoystickManager.GetInstance().GetJoystickDeadzone(i)
		Next
	End Method
	
	Method Enter()
		rrSubscribeToChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Leave()
		rrUnsubscribeFromChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Update()
		Local i:Int
		For i = 0 To nJoysticks - 1
			deadzones[i] = TJoystickManager.GetInstance().GetJoystickDeadzone(i)
		Next	
	End Method
	
	Method Render()
		Local i:Int
		SetColor(255, 255, 255)
		DrawText "Select Joystick:", 0, 20
		For i = 0 To nJoysticks - 1
			SetColor(255, 255, 255)
			If i = displayJoystick
				SetColor(255, 255, 0)
			End If
			DrawText i + 1, 150 + (i * 25), 20
		Next
		
		DrawText "Use Left/Right Cursor Keys to Modify Joystick Deadzone", 0, 50

		SetColor 255, 255, 255
		DrawText "JoyName(" + displayData.port + ") = " + JoyName(displayData.port), 0, 80
		DrawText "JoyButtonCaps(" + displayData.port + ") = " + Bin(JoyButtonCaps(displayData.port)), 0, 100
		DrawText "JoyAxisCaps(" + displayData.port + ") = " + Bin(JoyAxisCaps(displayData.port)), 0, 120
		DrawText "JoyDeadzone(" + displayData.port + ") = " + deadzones[displayData.port], 0, 140
		
		For i = 0 To displayData.nButtons - 1
			SetColor 255, 255, 255
			If displayData.buttonDown[i] Then SetColor 255, 0, 0
			DrawOval i * 16, 160, 14, 14
		Next

		Local drawY:Int = 200
		If displayData.availableAxis & RR_JOY_X
			drawprop("JoyX=", displayData.joystickX, drawY)
			DrawDeadzone(drawY)
			drawY:+20
		EndIf
		If displayData.availableAxis & RR_JOY_Y
			drawprop("JoyY=", displayData.joystickY, drawY)
			DrawDeadzone(drawY)
			drawY:+20
		EndIf
		If displayData.availableAxis & RR_JOY_Z
			drawprop("JoyZ=", displayData.joystickZ, drawY)
			DrawDeadzone(drawY)
			drawY:+20
		EndIf
		If displayData.availableAxis & RR_JOY_R
			drawprop("JoyR=", displayData.joystickR, drawY)
			DrawDeadzone(drawY)
			drawY:+20
		EndIf
		If displayData.availableAxis & RR_JOY_U
			drawprop("JoyU=", displayData.joystickU, drawY)
			DrawDeadzone(drawY)
			drawY:+20
		EndIf
		If displayData.availableAxis & RR_JOY_V
			drawprop("JoyV=", displayData.joystickV, drawY)
			DrawDeadzone(drawY)
			drawY:+20
		EndIf
		If displayData.availableAxis & RR_JOY_YAW
			drawprop("JoyYaw=", displayData.joystickYaw, drawY)
			DrawDeadzone(drawY)
			drawY:+20
		EndIf
		If displayData.availableAxis & RR_JOY_PITCH
			drawprop("JoyPitch=", displayData.joystickPitch, drawY)
			DrawDeadzone(drawY)
			drawY:+20
		EndIf
		If displayData.availableAxis & RR_JOY_ROLL
			drawprop("JoyRoll=", displayData.joystickRoll, drawY)
			DrawDeadzone(drawY)
			drawY:+20
		EndIf
		If displayData.availableAxis & RR_JOY_HAT
			drawprop("JoyHat=", displayData.joystickHat, drawY)
			drawY:+20
		EndIf
		If displayData.availableAxis & RR_JOY_WHEEL
			drawprop("JoyWheel=", displayData.joystickWheel, drawY)
			DrawDeadzone(drawY)
			drawY:+20
		EndIf					
		
	End Method
	
	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardInput(message)
			Case MSG_JOYSTICK
				HandleJoystickInput(message)
		EndSelect
	End Method

	Method HandleKeyboardInput(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		For Local i:Int = 0 To nJoysticks - 1
			If data.key = KEY_1 + i
				If data.keyHits
					displayJoystick = i
				End If
			End If
		Next
		Select data.key
			Case KEY_LEFT
				If displayData
					Local deadzone:Float = TJoystickManager.GetInstance().GetJoystickDeadzone(displayData.port)
					TJoystickManager.GetInstance().SetJoystickDeadzone(displayData.port, deadzone - 0.01)
				EndIf
			Case KEY_RIGHT
				If displayData
					Local deadzone:Float = TJoystickManager.GetInstance().GetJoystickDeadzone(displayData.port)
					TJoystickManager.GetInstance().SetJoystickDeadzone(displayData.port, deadzone + 0.01)
				EndIf
		End Select
	End Method
	
	Method HandleJoystickInput(message:TMessage)
		Local data:TJoystickMessageData = TJoystickMessageData(message.data)
		deadzones[data.port] = TJoystickManager.GetInstance().GetJoystickDeadzone(data.port)
		If data.port = displayJoystick
			displayData = data
		End If
	End Method
	
	Method drawprop(n:String, p:Float, y:Int)
		Local w:Int
		SetColor 255, 255, 255
		DrawText n, 0, y
		DrawText p, 600, y
		w = Abs(p) * 256
		DrawLine 320, y, 320, y + 16
		SetColor 255, 255, 0
		If p < 0
			DrawRect 320 - w, y, w, 16
		Else
			DrawRect 320, y, w, 16
		EndIf
	End Method
	
	Method DrawDeadzone(y:Int)
		If displayData
			Local w:Int
			SetColor 255, 0, 0
			w = deadzones[displayData.port] * 256
			DrawLine 320 - w, y, 320 - w, y + 16
			DrawLine 320 + w, y, 320 + w, y + 16
		EndIf
	End Method
End Type

