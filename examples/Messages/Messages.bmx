SuperStrict

' Import the framework
Import retroremakes.rrfw

rrUseExeDirectoryForData()

rrEngineInitialise()

rrSetProjectionMatrixResolution(640, 480)
rrEnableProjectionMatrix()

rrEnableMouseInput()

' Create the GameState and register it with the GameStateManager
TGameEngine.GetInstance().SetGameManager(New MsgExample)

' Run the game
rrEngineRun()


' Custom messages for this example
Const MSG_HIT:Int = 2000 ' Send a message to a bug that it have been hit by the player
Const MSG_SPAWN:Int = 2001 ' Used by MsgExample to spawn a new bug


Type Bug

	Global list:TList = CreateList() ' List of bugs
	Global bug:TImage ' Image of a bug

	Function update_all()
		For Local b:Bug = EachIn list
			b.Update()
		Next
	EndFunction
	
	Function draw_all()
		For Local b:Bug = EachIn list
			b.Draw()
		Next
	EndFunction
	
	
	Function Click( x:Int, y:Int )
	
		' The player clicked, a bug under the cursor?
	
		For Local b:Bug = EachIn list
		
			If Abs(b.pos.x - x) < 16 And Abs(b.pos.y - y) < 16 Then
			
				' We got one, notify it that we clicked it.
				Local hmsg:TMessage = New TMessage
				
				hmsg.SetMessageID( MSG_HIT ) ' a HIT message
				hmsg.SendTo( b ) ' To the bug
				hmsg.Send() ' Send it
				' We didn't call SendIn or SendAt here, so the message will arrive
				' without any delay
			
				Return ' Return now. The player cannor kill two or more bugs in one click.
			EndIf
		
		Next
	
	EndFunction
	
	


	Field pos:TVector2D
	Field vel:TVector2D
	Field near_death:Int ' It got clicked?
	
	Method New()
	
		near_death = False
		
		pos = New TVector2D
		vel = New TVector2D
		
		pos.Set( 320,240 )
		vel.Set( 1,0 )
		vel.Rotate( Rand(0,360) )
		
		If Not bug Then
			Bug = LoadImage("media/bug.png")
			MidHandleImage( bug )
		EndIf
		
		list.addlast(Self)
		
	EndMethod


	Method remove_me()
		list.remove( Self )
	EndMethod

	
	Method MessageListener( message:TMessage )

		Select message.messageID
		
			Case MSG_HIT 
				' Our custom message, this will stop the bug and send a delayed
				' message to itself that it should remove itself from the game
				
				If near_death Then Return ' Already dying. No need for a new DESTROY message
				
				Local dmsg:TMessage = New TMessage
				dmsg.SendTo( Self ) ' Send it to itself
				dmsg.SetMessageID( MSG_DESTROY ) ' The destroy message
				dmsg.SendIn( Rand(1000,3000) ) ' A random delay
				dmsg.Send() ' Send the message
				
				near_death = True ' Spin it while we wait for the grim reaper
			
			Case MSG_DESTROY
				remove_me() ' Remove self from the list
		
		EndSelect
	
	EndMethod
	
	
	Method Update()
	
		If near_death Then 
			' The bug have been clicked. Rotate it and return
			vel.Rotate(32)
			Return
		EndIf
		
		pos.AddV( vel ) ' Move bug
		vel.Rotate( Rand(-2,2) ) ' Randomly alter the direction
		
		' Warp if outside the screen
		If pos.x > 640 Then pos.x = 0
		If pos.x < 0 Then pos.x = 640
		If pos.y > 480 Then pos.y = 0
		If pos.y < 0 Then pos.y = 480
	EndMethod
	
	
	Method Draw()
		SetRotation vel.GetRotation() ' Where are we facing?
		DrawImage bug, pos.x, pos.y
		SetRotation 0 ' Restore rotation
	EndMethod


EndType




Type MsgExample Extends TGameManager

	Field bugnest:TImage ' The bugs nest

	Method Initialise()

		' Send a delayed message to self telling it to create a bug
		Local dmsg:TMessage = New TMessage
		dmsg.SetMessageID( MSG_SPAWN )
		dmsg.SendTo( Self ) ' Send it to self
		dmsg.SendIn( 3000 ) ' Delayed message 
		dmsg.Send()	' And off it goes	
		
		' Load graphics
		bugnest = LoadImage("media/bugnest.png")
'		If Not bugnest Return False ' Error loading the graphics
		MidHandleImage( bugnest )
		
		' Show the mouse
		ShowMouse()	
	End Method
	
	Method Start()
		Initialise()
		' Register with input channel
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Stop()
		' Unsubscribe from channels if the GameState is suspended to ensure
		' that we don't receive messages if we're not active.
		TMessageService.GetInstance().UnsubscribeFromChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method MessageListener( message:TMessage )
	
		' We are only interested in one kind of message	
		Select message.messageID
			Case MSG_SPAWN
		
				' Create a bug
				New Bug
			
				' Send a delayed message to self telling it to create another bug later
				Local dmsg:TMessage = New TMessage
				dmsg.SetMessageID( MSG_SPAWN )
				dmsg.SendTo( Self ) ' Send it to self
				dmsg.SendIn( Rand(100,3000) ) ' a randomly ammount of milliseconds to wait
				dmsg.Send()			
			Case MSG_MOUSE
				HandleMouseInput(message)
			Case MSG_KEY
				HandleKeyboardInput(message)
		End Select
	
	EndMethod

	Method HandleKeyboardInput(message:TMessage)
			Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
			
			Select data.key
				Case KEY_ESCAPE
					If data.keyHits Then TGameEngine.GetInstance().Stop()
			End Select
		
	EndMethod	
	
	Method HandleMouseInput(message:TMessage)
			Local data:TMouseMessageData = TMouseMessageData(message.data)
			
			' We're only interested in the left mouse button, but also use the current mouse location information
			If data.mouseHits[1]
				Bug.Click(data.mousePosX, data.mousePosY)
			EndIf
		
	EndMethod	

	
		
	Method Render(tweening:Double, fixed:Int = False)
		DrawImage(bugnest, 320, 240)
		bug.draw_all()
		
		DrawText "Bugs: "+Bug.list.count(), 0,0
		DrawText "Messages in queue: " + TMessageService.GetInstance().GetMessageCount(), 0, 12
	EndMethod


	
	Method Update()
	
		' Move bugs
		Bug.update_all()
	
	EndMethod


EndType



