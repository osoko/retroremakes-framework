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

Rem
	bbdoc: Class for managing joystick devices
End Rem
Type TJoystickManager Extends TInputDevice

	' The Singleton instance of this class
	Global _instance:TJoystickManager

	' The number of joysticks attached to the system
	Field _nJoysticks:Int
	
	' All the joysticks attached to the system
	Field _joysticks:TJoystick[]

	
	
	rem
		bbdoc: Broadcasts a joystick state message on the input channel
	endrem
	Method BroadcastJoystickStateMessage(data:TJoystickMessageData)
		Local message:TMessage = New TMessage
		message.SetData(data)
		message.SetMessageID(MSG_JOYSTICK)
		message.Broadcast(CHANNEL_INPUT)
	End Method
	
	
		
	rem
		bbdoc: Returns the Singleton instance of this class
	endrem
	Function GetInstance:TJoystickManager()
		If Not _instance
			Return New TJoystickManager
		Else
			Return _instance
		EndIf
	EndFunction
	
	
	
	rem
		bbdoc: Get the joystick attached to the specified port
	endrem
	Method GetJoystick:TJoystick(port:Int)
		If port >= 0 And port < _joysticks.Length
			Return _joysticks[port]
		End If
	End Method
	
	
		
	rem
		bbdoc: Get the number of joysticks attached to the system
	endrem
	Method GetJoystickCount:Int()
		Return _nJoysticks
	End Method
	
	
	
	rem
		bbdoc: Get the deadzone value for the joystick attached to the specified port
	endrem
	Method GetJoystickDeadzone:Float(port:Int)
		If port >= 0 And port < _joysticks.Length
			Return _joysticks[port].GetDeadzone()
		End If
	End Method
	
	
		
	rem
		bbdoc: Initialise the joystick manager
	endrem
	Method Initialise()
		SetName("Joystick Manager")
		
		' Register ourselves with the input manager
		TInputManager.GetInstance().RegisterDevice(Self)
		
		' Discover and profile all attached joysticks
		SetJoystickCount(JoyCount())
		
		If GetJoystickCount() = 1
			LogInfo("[" + ToString() + "] Found " + GetJoystickCount() + " Joystick")
		Else
			LogInfo("[" + ToString() + "] Found " + GetJoystickCount() + " Joysticks")
		EndIf
		
		ProfileJoysticks()
	End Method
	
	
		
	rem
		bbdoc: Default Constructor
	endrem
	Method New()
		If _instance Throw "Cannot create multiple instances of Singleton Type"
		_instance = Self
		Self.Initialise()
	EndMethod
	

		
	rem
		bbdoc: Profile all joysticks attached to the system
	endrem
	Method ProfileJoysticks()
		Local nJoysticks:Int = GetJoystickCount()
		
		If Not nJoysticks > 0 Then Return
		
		_joysticks = New TJoystick[nJoysticks]
		
		For Local i:Int = 0 To nJoysticks - 1
			_joysticks[i] = New TJoystick
			_joysticks[i].Profile(i)
		Next
	End Method
	
	
	
	rem
		bbdoc: Polls all joysticks
		about: Once a joystick has been polled, its current state is broadcast
		on the CHANNEL_INPUT message channel
	endrem
	Method Update()
		For Local joystick:TJoystick = EachIn _joysticks
			BroadcastJoystickStateMessage(joystick.Poll())
		Next
	End Method


	
	rem
		bbdoc: Sets the number of joysticks attached to the system
	endrem
	Method SetJoystickCount(nJoysticks:Int)
		_nJoysticks = nJoysticks
	End Method
	
	
	
	rem
		bbdoc: Sets the deadzone value for the joystick attached to the specified port
	endrem
	Method SetJoystickDeadzone(port:Int, deadzone:Float)
		If port >= 0 And port < _joysticks.Length
			_joysticks[port].SetDeadzone(deadzone)
		End If
	End Method
	
End Type



rem
	bbdoc: Enables joystick input
endrem
Function rrEnableJoystickInput()
	TJoystickManager.GetInstance()
End Function



rem
	bbdoc: Get the number of joysticks attached to the system
endrem
Function rrGetJoystickCount:Int()
	Return TJoystickManager.GetInstance().GetJoystickCount()
End Function
