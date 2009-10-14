SuperStrict

Framework retroremakes.rrfw

Incbin "media/bmax120.png"

rrUseExeDirectoryForData()

rrEngineInitialise()

'Mouse input isn't enabled by default
rrEnableMouseInput()

TGameEngine.GetInstance().SetGameManager(New GameManager)

rrEngineRun()


Type GameManager Extends TGameManager

	Const boxSpeed:Float = 5.0
	Const rotateSpeed:Int = 2
	Const zoomSpeed:Float = 0.2
	


	
	' This is our Virtual Gamepad
	Field gamepad:TVirtualGamepad

	Field controlNames:String[]
	
	Field playerSprite:TImageActor
	
	Method Initialise()
		AutoMidHandle(True)
		
		' Get the resource manager to load the texture we will use for our sprite
		rrLoadResourceImage("incbin::media/bmax120.png", FILTEREDIMAGE|MIPMAPPEDIMAGE)

		
		' Create our player sprite
		playerSprite = New TImageActor
		playerSprite.SetTexture(rrGetResourceImage("incbin::media/bmax120.png"))
		playerSprite.SetPosition(0,0)


		TLayerManager.GetInstance().AddRenderObjectToLayerById(playerSprite, 0)
		
		'Create a new Virtual Gamepad to control the sprite with
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
	End Method

	Method Start()
		Initialise()
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Stop()
		TMessageService.GetInstance().UnsubscribeFromChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Update()
		
		' First work out how much to move the sprite by
		Local boxX:Float = 0.0
		Local boxY:Float = 0.0
		
		If gamepad.GetDigitalControlStatus("Up")
			boxY = -boxSpeed
		EndIf
		
		If gamepad.GetDigitalControlStatus("Down")
			boxY = boxSpeed
		EndIf
		
		If gamepad.GetDigitalControlStatus("Left")
			boxX = -boxSpeed
		EndIf
		
		If gamepad.GetDigitalControlStatus("Right")
			boxX = boxSpeed
		EndIf				

		' Move the player sprite
		playerSprite.Move(boxX, boxY)
		
		' Check if we're rotating the sprite
		Local boxAngle:Int = Int(playerSprite.GetRotation())
		If gamepad.GetDigitalControlStatus("Left Rotate")
			boxAngle:-rotateSpeed
			If boxAngle < 0 Then boxAngle:+360			
		EndIf
		
		If gamepad.GetDigitalControlStatus("Right Rotate")
			boxAngle:+rotateSpeed
			If boxAngle > 360 Then boxAngle:-360
		EndIf
		
		' Set the player sprite's rotation
		playerSprite.SetRotation(boxAngle)
		
		
		
		' Check if we're zooming the sprite.  We're using the same scale for X and Y
		' so don't need to handle them separately
		Local boxZoom:Float = playerSprite.GetXScale()
		If gamepad.GetDigitalControlStatus("Zoom In")
			boxZoom:+zoomSpeed
			If boxZoom > 15.0 Then boxZoom = 15.0
		EndIf
		
		If gamepad.GetDigitalControlStatus("Zoom Out")
			boxZoom:-zoomSpeed
			If boxZoom < 0.1 Then boxZoom = 0.1
		EndIf
		
		' Set the player sprite's scale
		playerSprite.SetScale(boxZoom, boxZoom)

	End Method
	

	Method Render(tweening:Double, fixed:Int = False)
		SetColor 255, 255, 255
		SetRotation 0
		SetScale 1.0, 1.0
		DrawText "Sprite Example", 0, 20
		DrawText "Use the keys specified below to move the sprite.", 0, 50
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
			If gamepad.GetDigitalControlStatus(name)
				SetColor 255, 0, 0
			EndIf
			DrawText(name + " : " + mappedControl, 50, y)
			y:+20
			i:+1
		Next

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
		
		Select data.Key
			Case KEY_ESCAPE
				If data.keyHits Then rrEngineStop()			
		End Select
	End Method

End Type