rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.
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

	Global instance:TJoystickManager
	
	Field pollProfiler:TProfilerSample

	Field nJoysticks:Int
	
	Field joysticks:TJoystick[]

	Method New()
		If instance Throw "Cannot create multiple instances of Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod
	
	Function GetInstance:TJoystickManager()
		If Not instance
			Return New TJoystickManager
		Else
			Return instance
		EndIf
	EndFunction
		
	Method Initialise()
		name = "Joystick Manager"
		TInputManager.GetInstance().RegisterDevice(Self)
		pollProfiler = rrCreateProfilerSample("Joystick Manager: Poll")
		nJoysticks = JoyCount()
		If nJoysticks = 1
			TLogger.getInstance().LogInfo("[" + toString() + "] Found " + nJoysticks + " Joystick")
		Else
			TLogger.getInstance().LogInfo("[" + toString() + "] Found " + nJoysticks + " Joysticks")
		EndIf
		ProfileJoysticks()
	End Method
	
	Method ProfileJoysticks()
		If Not nJoysticks > 0 Then Return
		joysticks = New TJoystick[nJoysticks]
		For Local i:Int = 0 To nJoysticks - 1
			joysticks[i] = New TJoystick
			joysticks[i].Profile(i)
		Next
	End Method
	
	Method Update()
		rrStartProfilerSample(pollProfiler)
		For Local joystick:TJoystick = EachIn joysticks
			SendJoystickStateMessage(joystick.Poll())
		Next
		rrStopProfilerSample(pollProfiler)
	End Method

	Method GetJoystickCount:Int()
		Return nJoysticks
	End Method
	
	Method SendJoystickStateMessage(data:TJoystickMessageData)
		Local message:TMessage = New TMessage
		message.SetData(data)
		message.SetMessageID(MSG_JOYSTICK)
		message.Broadcast(CHANNEL_INPUT)
	End Method
	
	Method GetJoystickDeadzone:Float(port:Int)
		If port >= 0 And port < joysticks.Length
			Return joysticks[port].GetDeadzone()
		End If
	End Method
	
	Method SetJoystickDeadzone(port:Int, deadzone:Float)
		If port >= 0 And port < joysticks.Length
			joysticks[port].SetDeadzone(deadzone)
		End If
	End Method
	
	Method GetJoystick:TJoystick(port:Int)
		If port >= 0 And port < joysticks.Length
			Return joysticks[port]
		End If
	End Method
	
End Type


Function rrEnableJoystickInput()
	TJoystickManager.GetInstance()
End Function

Function rrGetJoystickCount:Int()
	Return TJoystickManager.GetInstance().GetJoystickCount()
End Function