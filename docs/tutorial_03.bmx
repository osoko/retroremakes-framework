SuperStrict ' Not required, but very useful!
Import retroremakes.rrfw ' Import the framework
Global state:PlayState = New PlayState ' Create our state 
rrAddGameState(state) ' register it with the GameStateManager
rrEngineRun() ' Run the game

Type PlayState Extends TGameState
	Field star_time:Double
	Field stars:TList
	' This is the ship
	Field ship_x:Float = 400, ship_y:Float = 300, ship_angle:Float, ship_speed:Float
	Field ship_image:TImage, star_image:timage
	
	Method Initialise()
		stars = CreateList();
	EndMethod
	
	Method Enter()
		If Not star_image Then star_image = LoadImage( "star.png" )
		If Not star_image Then RuntimeError("Unable to load star image")
		MidHandleImage( star_image ) ' Rotate around the center
	
		If Not ship_image Then ship_image = LoadImage( "ship.png" )
		If Not ship_image Then RuntimeError("Unable to load image")
		MidHandleImage( ship_image ) ' Rotate around the center
		
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
	EndMethod
	
	Method Leave()
		TMessageService.GetInstance().UnsubscribeFromChannel(CHANNEL_INPUT, Self)
	EndMethod

	' Render the game
	Method Render()
		SetRotation( ship_angle )
		DrawImage ship_image, ship_x, ship_y
		SetRotation( 0 )
		For Local s:TStar = EachIn stars
			DrawImage( star_image, s.x, s.y )
		Next		
	EndMethod

	' Update the ship
	Method Update()
		star_time :+ rrGetDeltaTime()
		If star_time > 3000
			stars.addlast( TStar.Create() )
			star_time = 0
		EndIf
		
		' The new position
		ship_x :+ Cos(ship_angle) * ship_speed
		ship_y :+ Sin(ship_angle) * ship_speed
		' Warp if outside the screen
		If ship_x < 0 Then ship_x :+ 800
		If ship_x >= 800 Then ship_x :- 800
		If ship_y < 0 Then ship_y :+ 600
		If ship_y >= 600 Then ship_y :- 600
		
		' Collision with star?
		For Local s:TStar = EachIn stars
			If (s.x-ship_x)*(s.x-ship_x)+(s.y-ship_y)*(s.y-ship_y) < (16*16) Then
				stars.remove(s)
			EndIf
		Next
	EndMethod

	Method HandleKeyboardInput(message:TMessage)
		Local data:TKeyboardMessageData 
		data = TKeyboardMessageData(message.data)
		Select data.key
			Case KEY_LEFT
				ship_angle :- 2
			Case KEY_RIGHT
				ship_angle :+ 2
			Case KEY_UP
				ship_speed :+ 0.2
				ship_speed = Min(ship_speed, 5) ' Limit the speed
			Case KEY_DOWN
				ship_speed :- 0.1
				ship_speed = Max(ship_speed, 0)' We don't want to
										' go backwards
			
		End Select
	EndMethod

	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardInput(message)
		EndSelect
	End Method
EndType


Type TStar
	Function Create:TStar()
		Local s:TStar = New TStar
		s.x = Rand(800)
		s.y = Rand(600)
		Return s
	EndFunction
	Field x:Int, y:Int ' Their position
EndType
