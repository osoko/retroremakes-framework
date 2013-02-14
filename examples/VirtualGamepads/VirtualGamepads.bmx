SuperStrict

Framework retroremakes.rrfw

Incbin "media/crate.png"

rrUseExeDirectoryForData()
rrEngineInitialise()

TGameEngine.GetInstance().SetGameManager(New GameManager)

'Mouse input isn't enabled by default
rrEnableMouseInput()

TGameEngine.GetInstance().Run()

Type GameManager Extends TGameManager

	Const boxSpeed:Float = 20.0
	Const rotateSpeed:Int = 10
	Const zoomSpeed:Float = 0.8
	
	Field boxX:Float = 400.0
	Field boxY:Float = 300.0
	Field boxAngle:Int = 0
	Field boxZoom:Float = 1.0
	
	Field programmingControl:Int
	
	' This is our Virtual Gamepad
	Field gamepad:TVirtualGamepad

	Field controlNames:String[]
	
	Field activeControl:Int = 0
	Field controlDelay:Int
	Field box:TImage
	
	Method Initialise()
		'Create a new Virtual Gamepad
		gamepad = New TVirtualGamepad
		
		' We then add the controls we want to it (no limit)
		gamepad.AddControl("Analogue Horizontal")
		gamepad.AddControl("Analogue Vertical")
		gamepad.AddControl("Left")
		gamepad.AddControl("Right")
		gamepad.AddControl("Up")
		gamepad.AddControl("Down")
		gamepad.AddControl("Fire")
		gamepad.AddControl("Left Rotate")
		gamepad.AddControl("Right Rotate")
		gamepad.AddControl("Zoom In")
		gamepad.AddControl("Zoom Out")

		' We then need to specify what the default control mappings are
		
		'control direction of 2 indicates that the following mappings
		'must return values from -0.1 to 1.0
		gamepad.SetDefaultJoystickAxisControl("Analogue Horizontal", 0, "X", 2)
		gamepad.SetDefaultJoystickAxisControl("Analogue Vertical", 0, "Y", 2)

		gamepad.SetDefaultKeyboardControl("Left", KEY_O)
		gamepad.SetDefaultKeyboardControl("Right", KEY_P)
		gamepad.SetDefaultKeyboardControl("Up", KEY_Q)
		gamepad.SetDefaultKeyboardControl("Down", KEY_A)
		gamepad.SetDefaultKeyboardControl("Fire", KEY_SPACE)
		gamepad.SetDefaultKeyboardControl("Left Rotate", KEY_LEFT)
		gamepad.SetDefaultKeyboardControl("Right Rotate", KEY_RIGHT)
		gamepad.SetDefaultKeyboardControl("Zoom In", KEY_NUMADD)
		gamepad.SetDefaultKeyboardControl("Zoom Out", KEY_NUMSUBTRACT)
		
		' Cache the Gamepad's Control Names
		controlNames = gamepad.GetControlNames()
		AutoMidHandle(True)
		box = LoadImage("incbin::media/crate.png")
	End Method

	Method Start()
		Initialise()
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Stop()
		TMessageService.GetInstance().UnsubscribeFromChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Update()
		' Check gamepad to see if programming mode is finished.  If so it's safe
		' to start listening to the input channel again
		CheckProgrammingStatus()
		
		' Now we check the inputs on our virtual gamepad and do the necessary
		
		boxX:+ gamepad.GetAnalogueControlStatus("Analogue Horizontal") * 4
		boxY:+ gamepad.GetAnalogueControlStatus("Analogue Vertical") *  4
		
		If gamepad.GetDigitalControlStatus("Up") Then boxY:-boxSpeed
		If gamepad.GetDigitalControlStatus("Down") Then boxY:+boxSpeed
		If gamepad.GetDigitalControlStatus("Left") Then boxX:-boxSpeed
		If gamepad.GetDigitalControlStatus("Right") Then boxX:+boxSpeed

		If gamepad.GetDigitalControlStatus("Left Rotate")
			boxAngle:-rotateSpeed
			If boxAngle < 0 Then boxAngle:+360			
		EndIf
		
		If gamepad.GetDigitalControlStatus("Right Rotate")
			boxAngle:+rotateSpeed
			If boxAngle > 360 Then boxAngle:-360
		EndIf
		
		If gamepad.GetDigitalControlStatus("Zoom In")
			boxZoom:+zoomSpeed
			If boxZoom > 15.0 Then boxZoom = 15.0
		EndIf
		
		If gamepad.GetDigitalControlStatus("Zoom Out")
			boxZoom:-zoomSpeed
			If boxZoom < 0.1 Then boxZoom = 0.1
		EndIf
		
		If boxY < 0 Then boxY = 0
		If boxY > 600 Then boxY = 600
		If boxX > 800 Then boxX = 800
		If boxX < 0 Then boxX = 0

		
		
	End Method
	
	
	Method Render(tweening:Double, fixed:Int = False)
		SetColor 255, 255, 255
		SetRotation 0
		SetScale 1.0, 1.0
		DrawText "Virtual Gamepad Example", 0, 20
		DrawText "Cursor Up/Down to select control", 0, 50
		DrawText "Enter to start programming selected control, next key press is programmed", 0, 70
		DrawText "Escape cancels programming mode and reverts to default setting", 0, 90
		Local y:Int = 150
		Local i:Int = 0
		
		' Loop through all the controls
		For Local name:String = EachIn controlNames
			SetColor 255, 255, 255
			
			' Get the human readable name of the Control Mapping (will add helpers to speed this up)
			Local controlMapping:TVirtualControlMapping = gamepad.GetControl(name).GetControlMap()
			Local mappedControl:String
			If controlMapping
				mappedControl = controlMapping.GetName()
			EndIf
			If activeControl = i Then SetColor 255, 255, 0
			If gamepad.GetDigitalControlStatus(name)
				SetColor 255, 0, 0
			EndIf
			If gamepad.GetAnalogueControlStatus(name)
				SetColor 255, 0, 0
			EndIf			
			
			DrawText(name + " : " + mappedControl, 50, y)
			y:+20
			i:+1
		Next
		SetColor 255, 255, 255
		SetRotation boxAngle
		SetScale boxZoom, boxZoom
		DrawImage(box, boxX, boxY)
		SetRotation 0
		SetScale 0, 0
	End Method
	
	'Standard Message Listener
	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardInput(message)
		EndSelect
	End Method
	
	Method HandleKeyboardInput(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		Select data.key
			Case KEY_UP
				If data.keyHits
					activeControl:-1
					If activeControl < 0 Then activeControl = controlNames.Length - 1
				End If
			Case KEY_DOWN
				If data.keyHits
					activeControl:+1
					If activeControl > controlNames.Length - 1 Then activeControl = 0
				End If
			Case KEY_ENTER
				If data.keyHits
					' User has hit Enter, so we'll enable programming on the currently
					' selected Control.  When programming is enabled on a Control, it listens
					' for the next Input message and programs itself accordingly.  This could
					' be a Key, a Joystick Axis or Button or a Mouse Button or movement.
					'
					' Once the control has programmed itself, it automagically disables
					' programming mode for itself.
					ProgramControl()
				End If
			Case KEY_ESCAPE
				TGameEngine.GetInstance().Stop()
		End Select
	End Method
	
	Method ProgramControl()
		programmingControl = True
		' If we don't unsubscribe from the input channel, then we won't be able
		' to program a control with the key that activates programming mode
		TMessageService.GetInstance().UnsubscribeFromChannel(CHANNEL_INPUT, Self)
		gamepad.EnableControlProgramming(controlNames[activeControl])
	End Method
	
	Method CheckProgrammingStatus()
		If programmingControl
			Local listenAgain:Int = False
			For Local control:String = EachIn controlNames
				If Not gamepad.GetProgrammingStatus(controlNames[activeControl])
					listenAgain = True
				End If
			Next
			If listenAgain
				' Programming is finished, so we can listen to the input channel again
				TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
			End If
		EndIf		
	End Method
End Type