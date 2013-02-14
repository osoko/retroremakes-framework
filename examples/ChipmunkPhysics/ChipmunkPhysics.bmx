SuperStrict

Framework retroremakes.rrfw

Import bah.chipmunk

Include "includes\TGameState.bmx"
Include "includes\TIntroState.bmx"
Include "includes\TDemoState1.bmx"
Include "includes\TDemoState2.bmx"
Include "includes\TDemoState3.bmx"
Include "includes\TDemoState4.bmx"
Include "includes\TDemoState5.bmx"
Include "includes\TDemoState6.bmx"
Include "includes\TDemoState7.bmx"
Include "includes\TDemoState8.bmx"

Incbin "media\ball.png"
Incbin "media\crate.png"
Incbin "media\VeraMono.ttf"

rrUseExeDirectoryForData()

rrEngineInitialise()

TGameEngine.GetInstance().SetGameManager(New GameManager)

rrSetGraphicsWidth(640)
rrSetGraphicsHeight(480)
rrSetGraphicsDriver("OpenGL")

rrDisableProjectionMatrix()

rrEngineRun()


Type GameManager Extends TGameManager

	Field layerManager:TLayerManager
	
	Field currentState:Int
	Field states:TGameState[]
	
	Method Start()
		InitChipmunk()
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
		
		layerManager = TLayerManager.GetInstance()
		layerManager.CreateLayer(0, "myLayer")
		
		states = New TGameState[9]
		
		states[0] = New TIntroState
		states[1] = New TDemoState1
		states[2] = New TDemoState2
		states[3] = New TDemoState3
		states[4] = New TDemoState4
		states[5] = New TDemoState5
		states[6] = New TDemoState6
		states[7] = New TDemoState7
		states[8] = New TDemoState8
		
		currentState = 0
		
		' Start the first state
		layerManager.AddRenderableToLayerById(states[currentState], 0)
		states[currentState].Start()
	End Method
	
	Method Stop()
		TMessageService.GetInstance().UnsubscribeFromChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Render(tweening:Double, fixed:Int = False)
		' Nothing needed here
	End Method
	
	Method Update()
		' Nothing needed here
	End Method
	
	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardInput(message)
		End Select
	End Method
	
	Method MoveForwards()
		states[currentState].Stop()
		layerManager.RemoveRenderable(states[currentState])
		
		currentState:+1
		
		If currentState >= states.Length Then currentState = 0
		
		If currentState < states.Length
			layerManager.AddRenderableToLayerById(states[currentState], 0)
			states[currentState].Start()
		EndIf
		
	End Method
	
	Method HandleKeyboardInput(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		Select data.key
			Case KEY_SPACE
				If data.keyHits Then MoveForwards()
			Case KEY_ESCAPE
				TGameEngine.GetInstance().Stop()
		End Select
	End Method	
	
End Type