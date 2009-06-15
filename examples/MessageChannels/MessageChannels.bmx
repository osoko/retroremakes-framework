SuperStrict

' Import the framework
Import retroremakes.rrfw

rrUseExeDirectoryForData()

rrEngineInitialise()

rrSetProjectionMatrixResolution(640, 480)
rrEnableProjectionMatrix()

rrEnableKeyboardInput()

' Create the GameState and register it with the GameStateManager
Global game:MsgExample = New MsgExample
rrAddGameState(game)

' Run the game
rrEngineRun()


' Custom messages for this example
Const MSG_RED:Int = 1	'Change colour to Red
Const MSG_GREEN:Int = 2	'Change colour to Green
Const MSG_BLUE:Int = 3 'Change colour to Blue

Const CHANNEL_1:Int = 1
Const CHANNEL_2:Int = 2
Const CHANNEL_3:Int = 3
Const CHANNEL_GLOBAL:Int = 4

Type Blob

	Const NUMBER_OF_BLOBS:Int = 100
	
	Global list:TList = New TList
	
	Field channel:Int	'the channel number we have subscribed to
	
	Function update_all()
		For Local b:Blob = EachIn list
			b.Update()
		Next
	EndFunction
	
	Function draw_all()
		For Local b:Blob = EachIn list
			b.Draw()
		Next
	EndFunction
	
	Function CreateAll()
		For Local i:Int = 0 To NUMBER_OF_BLOBS - 1
			New Blob
		Next
	End Function
	
	Field pos:TVector2D
	Field vel:TVector2D
	
	Field col:TColourRGB
	
	Method New()
		pos = New TVector2D
		vel = New TVector2D
		col = New TColourRGB
		
		col.r = 255
		col.g = 255
		col.b = 255
		col.a = 1.0
		
		pos.Set(Rand(10, 630), Rand(10, 470))
		vel.Set(1, 0)
		vel.Rotate( Rand(0,360) )
		
		list.addlast(Self)
		
		channel = Rand(1, 3)
		Select channel
			Case 1
				rrSubscribeToChannel(CHANNEL_1, Self)
				col.r = 255
				col.g = 0
				col.b = 0				
			Case 2
				rrSubscribeToChannel(CHANNEL_2, Self)
				col.r = 0
				col.g = 255
				col.b = 0				
			Case 3
				rrSubscribeToChannel(CHANNEL_3, Self)
				col.r = 0
				col.g = 0
				col.b = 255				
		End Select
		
		rrSubscribeToChannel(CHANNEL_GLOBAL, Self)
	EndMethod

	
	Method MessageListener( message:TMessage )

		Select message.messageID
			Case MSG_RED
				col.r = 255
				col.g = 0
				col.b = 0
			Case MSG_GREEN
				col.r = 0
				col.g = 255
				col.b = 0
			Case MSG_BLUE
				col.r = 0
				col.g = 0
				col.b = 255
		EndSelect
	
	EndMethod
	
	
	Method Update()
	
		pos.AddV(vel) ' Move Blob
		
		' Warp if outside the screen
		If pos.x > 640 Then pos.x = 0
		If pos.x < 0 Then pos.x = 640
		If pos.y > 480 Then pos.y = 0
		If pos.y < 0 Then pos.y = 480
	EndMethod
	
	
	Method Draw()
		col.Set()
		DrawOval(pos.x - 10, pos.y - 10, 20, 20)
		SetColor 0, 0, 0
		DrawText(channel, pos.x - (TextWidth(channel) / 2), pos.y - (TextHeight(channel) / 2))
	EndMethod


EndType




Type MsgExample Extends TGameState

	Field channel1Count:Int = 0
	Field channel2Count:Int = 1
	Field channel3Count:Int = 2
	
	Field messages:Int[] = [MSG_RED, MSG_GREEN, MSG_BLUE]

	Method Initialise()
		Blob.CreateAll()
	End Method
	
	Method Enter()
		rrSubscribeToChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Leave()
		' Unsubscribe from channels if the GameState is suspended to ensure
		' that we don't receive messages if we're not active.
		rrUnsubscribeFromChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Render()
		Blob.draw_all()
		
		SetColor 255, 255, 255
		DrawText "1 - Change Channel 1", 0, 12
		DrawText "2 - Change Channel 2", 0, 24
		DrawText "3 - Change Channel 3", 0, 36
		DrawText "R - Change All to Red", 0, 48
		DrawText "G - Change All to Green", 0, 60
		DrawText "B - Change All to Blue", 0, 72
		
	EndMethod

	Method HandleKeyboardInput(message:TMessage)
			Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
			Select data.key
				Case KEY_1
					If data.keyHits
						channel1Count:+1
						If channel1Count > 2 Then channel1Count = 0
						Local message:TMessage = New TMessage
						message.SetMessageID(messages[channel1Count])
						message.Broadcast(CHANNEL_1)
					EndIf
				Case KEY_2
					If data.keyHits
						channel2Count:+1
						If channel2Count > 2 Then channel2Count = 0
						Local message:TMessage = New TMessage
						message.SetMessageID(messages[channel2Count])
						message.Broadcast(CHANNEL_2)
					EndIf
				Case KEY_3
					If data.keyHits
						channel3Count:+1
						If channel3Count > 2 Then channel3Count = 0
						Local message:TMessage = New TMessage
						message.SetMessageID(messages[channel3Count])
						message.Broadcast(CHANNEL_3)
					EndIf
				Case KEY_R
					If data.keyHits
						channel1Count = 0
						channel2Count = 0
						channel3Count = 0
						Local message:TMessage = New TMessage
						message.SetMessageID(MSG_RED)
						message.Broadcast(CHANNEL_GLOBAL)
					EndIf
				Case KEY_G
					If data.keyHits
						channel1Count = 1
						channel2Count = 1
						channel3Count = 1
						Local message:TMessage = New TMessage
						message.SetMessageID(MSG_GREEN)
						message.Broadcast(CHANNEL_GLOBAL)
					EndIf
				Case KEY_B
					If data.keyHits
						channel1Count = 2
						channel2Count = 2
						channel3Count = 2
						Local message:TMessage = New TMessage
						message.SetMessageID(MSG_BLUE)
						message.Broadcast(CHANNEL_GLOBAL)
					EndIf					
			End Select
	EndMethod

	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardInput(message)
		EndSelect
	End Method

	Method Update()
		Blob.update_all()
	EndMethod

EndType



