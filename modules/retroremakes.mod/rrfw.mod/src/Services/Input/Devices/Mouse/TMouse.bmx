Const RR_MOUSE_X:Int = 1
Const RR_MOUSE_Y:Int = 2
Const RR_MOUSE_Z:Int = 3

Const RR_MOUSE_LEFT:Int = 1
Const RR_MOUSE_RIGHT:Int = 2
Const RR_MOUSE_MIDDLE:Int = 3

Type TMouse Extends TInputDevice

	Global instance_:TMouse
	
	Field lastMouseLocation:Int[4]
	Field mouseLocation:Int[4]
	Field mouseHits:Int[4]
	Field lastMouseStates:Int[4]
	Field mouseStates:Int[4]
	
	Method New()
		If instance_ Throw "Cannot create multiple instances of Singleton Type"
		instance_ = Self
		Self.Initialise()
	End Method
	
	Function GetInstance:TMouse()
		If Not instance_
			Return New TMouse
		Else
			Return instance_
		EndIf		
	End Function

	Method Initialise()
		name = "Mouse Input"
		TInputManager.GetInstance().RegisterDevice(Self)
		AddHook(EmitEventHook, Self.Hook, Null, 0)
	End Method
	
	Function Hook:Object(id:Int, data:Object, context:Object)
		Local ev:TEvent = TEvent(data)
		If Not ev Return data
		
		Local mouse:TMouse = TMouse.GetInstance()

		Select ev.id
			Case EVENT_MOUSEDOWN
				If Not mouse.mouseStates[ev.data]
					mouse.mouseStates[ev.data] = 1
					mouse.mouseHits[ev.data]:+1
				EndIf
			Case EVENT_MOUSEUP
				mouse.mouseStates[ev.data] = 0
			Case EVENT_MOUSEMOVE
				mouse.mouseLocation[0] = Int(TProjectionMatrix.GetInstance().ProjectMouseX(ev.x))
				mouse.mouseLocation[1] = Int(TProjectionMatrix.GetInstance().ProjectMouseY(ev.y))
			Case EVENT_MOUSEWHEEL
				mouse.mouseLocation[2]:+ev.data
		EndSelect

		Return data
	End Function
		
	Method Update()
		SendMouseStateMessage()

		For Local i:Int = 0 To 3
			lastMouseStates[i] = mouseStates[i]
			mouseStates[i] = 0
			mouseHits[i] = 0
			lastMouseLocation[i] = mouseLocation[i]
		Next				
	End Method

	Method SendMouseStateMessage()
		Local message:TMessage = New TMessage
		Local data:TMouseMessageData = New TMouseMessageData
		' Make sure mouse location is projected if a Projection Matrix 
		' is in use.
		data.mousePosX = mouselocation[0]
		data.mousePosY = mouselocation[1]
		data.mousePosZ = mouselocation[2]
		
		data.lastMousePosX = lastMouseLocation[0]
		data.lastMousePosY = lastMouseLocation[1]
		data.lastMousePosZ = lastMouseLocation[2]
		
		For Local i:Int = 0 To 3
			data.mouseHits[i] = mouseHits[i]
			data.mouseStates[i] = mouseStates[i]
		Next
		message.SetData(data)
		message.SetMessageID(MSG_MOUSE)
		message.Broadcast(CHANNEL_INPUT)
	End Method
	

End Type

Function rrEnableMouseInput(enable:Int = True)
	TInputManager.GetInstance().mouseEnabled = True
End Function
