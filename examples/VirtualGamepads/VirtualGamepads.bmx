SuperStrict

Import retroremakes.rrfw

Incbin "media/crate.png"

rrUseExeDirectoryForData()

rrEngineInitialise()

'Mouse input isn't enabled by default
rrEnableMouseInput()

rrAddGameState(New TMyState)

rrEngineRun()

Type TMyState Extends TGameState

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
	Field mousePosZ:Int
	Field box:TImage
	
	Method Initialise()
		'Create a new Virtual Gamepad
		gamepad = New TVirtualGamepad
		
		' We then add the controls we want to it (no limit)
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

	Method Enter()
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Leave()
		TMessageService.GetInstance().UnsubscribeFromChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Update()
		' Check gamepad to see if programming mode is finished.  If so it's safe
		' to start listening to the input channel again
		CheckProgrammingStatus()
		
		' Now we check the inputs on our virtual gamepad and do the necessary
		If gamepad.GetDigitalControlStatus("Up")
			boxY:-boxSpeed
			If boxY < 0 Then boxY = 0
		EndIf
		
		If gamepad.GetDigitalControlStatus("Down")
			boxY:+boxSpeed
			If boxY > 600 Then boxY = 600
		EndIf
		
		If gamepad.GetDigitalControlStatus("Left")
			boxX:-boxSpeed
			If boxX < 0 Then boxX = 0
		EndIf
		
		If gamepad.GetDigitalControlStatus("Right")
			boxX:+boxSpeed
			If boxX > 800 Then boxX = 800
		EndIf				

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
	End Method
	
	Method Render()
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
			Local controlMapping:TVirtualControlMapping = gamepad.GetControl(name).GetControlMapping()
			Local mappedControl:String
			If controlMapping
				mappedControl = controlMapping.GetName()
			EndIf
			If activeControl = i Then SetColor 255, 255, 0
			If gamepad.GetDigitalControlStatus(name)
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
	End Method
	
	'Standard Message Listener
	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardInput(message)
			Case MSG_MOUSE
				HandleMouseInput(message)
		EndSelect
	End Method
	
	Method HandleMouseInput(message:TMessage)
		Local data:TMouseMessageData = TMouseMessageData(message.data)
		mousePosZ = data.mousePosZ
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