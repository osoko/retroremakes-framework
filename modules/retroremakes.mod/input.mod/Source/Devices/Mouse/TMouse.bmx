rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Const RR_MOUSE_X:Int = 1
Const RR_MOUSE_Y:Int = 2
Const RR_MOUSE_Z:Int = 3

Const RR_MOUSE_LEFT:Int = 1
Const RR_MOUSE_RIGHT:Int = 2
Const RR_MOUSE_MIDDLE:Int = 3

rem
	bbdoc: Class representing a mouse input device.
endrem
Type TMouse Extends TInputDevice

	' The Singletone instance of this class
	Global _instance:TMouse
	
	' The last mouse location values for all axis
	Field _lastMouseLocation:Int[4]
	
	' The last mouse state values for all buttons
	Field _lastMouseStates:Int[4]
	
	' The mouse hits values for all mouse buttons
	Field _mouseHits:Int[4]
	
	' The mouse location values for all axis
	Field _mouseLocation:Int[4]
	
	' The mouse state values for all buttons
	Field _mouseStates:Int[4]
	
	
	
	rem
		bbdoc: Broadcasts a mouse state message on the CHANNEL_INPUT message
		channel
		about: The message is sent with an ID of MSG_MOUSE and contains a data
		payload of TMouseMessageData which holds the current mouse state
		information
	endrem
	Method BroadcastMouseStateMessage()
		Local data:TMouseMessageData = New TMouseMessageData

		data.mousePosX = _mouseLocation[0]
		data.mousePosY = _mouseLocation[1]
		data.mousePosZ = _mouseLocation[2]

		data.lastMousePosX = _lastMouseLocation[0]
		data.lastMousePosY = _lastMouseLocation[1]
		data.lastMousePosZ = _lastMouseLocation[2]
		
		For Local i:Int = 0 To 3
			data.mouseHits[i] = _mouseHits[i]
			data.mouseStates[i] = _mouseStates[i]
		Next
		
		Local message:TMessage = New TMessage

		message.SetData(data)
		message.SetMessageID(MSG_MOUSE)
		message.Broadcast(CHANNEL_INPUT)
	End Method
	
	
		
	rem
		bbdoc: Returns the Singleton instance of this class
	endrem
	Function GetInstance:TMouse()
		If Not _instance
			Return New TMouse
		Else
			Return _instance
		EndIf		
	End Function
	
	
	
	rem
		bbdoc: Hook that listens for mouse events
	endrem
	Function Hook:Object(id:Int, data:Object, context:Object)
		Local ev:TEvent = TEvent(data)
		If Not ev Return data
		
		Local mouse:TMouse = TMouse.GetInstance()

		Select ev.id
			Case EVENT_MOUSEDOWN
				If Not mouse._mouseStates[ev.data]
					mouse._mouseStates[ev.data] = 1
					mouse._mouseHits[ev.data]:+1
				EndIf
			Case EVENT_MOUSEUP
				mouse._mouseStates[ev.data] = 0
			Case EVENT_MOUSEMOVE
				mouse._mouseLocation[0] = Int(TProjectionMatrix.GetInstance().ProjectMouseX(ev.x))
				mouse._mouseLocation[1] = Int(TProjectionMatrix.GetInstance().ProjectMouseY(ev.y))
			Case EVENT_MOUSEWHEEL
				mouse._mouseLocation[2]:+ev.data
		EndSelect

		Return data
	End Function
	
	
		
	rem
		bbdoc: Initialises the input device
	endrem
	Method Initialise()
		SetName("Mouse Input")
		
		TInputManager.GetInstance().RegisterDevice(Self)
		
		AddHook(EmitEventHook, Self.Hook, Null, 0)
	End Method
	
	
			
	rem
		bbdoc: Default Constructor
	endrem
	Method New()
		If _instance Throw "Cannot create multiple instances of Singleton Type"
		
		_instance = Self
		
		Self.Initialise()
	End Method



	rem
		bbdoc: Updates the mouse input device
	endrem
	Method Update()
		BroadcastMouseStateMessage()

		For Local i:Int = 0 To 3
			_lastMouseStates[i] = _mouseStates[i]
			_mouseStates[i] = 0
			_mouseHits[i] = 0
			_lastMouseLocation[i] = _mouseLocation[i]
		Next				
	End Method

End Type



rem
	bbdoc: Tell the input manager to enable mouse input when it starts up
endrem
Function rrEnableMouseInput(bool:Int = True)
	TInputManager.GetInstance().EnableMouse(bool)
End Function
