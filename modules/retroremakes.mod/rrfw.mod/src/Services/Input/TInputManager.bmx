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

Type TInputManager Extends TGameService

	Global instance:TInputManager		' This holds the singleton instance of this Type
	
	Global LInputDevices:TList = New TList	'all registered input devices
	
	' Whether some of the built in input devices are enabled or not by default
	Field keyboardEnabled:Int = True
	Field mouseEnabled:Int = False
	Field joystickEnabled:Int = True
		
'#Region Constructors
	Method New()
		If instance rrThrow "Cannot create multiple instances of this Singleton Type"
		instance = Self
		updatePriority = -1000		'Check device first in each update loop
		Self.Initialise()
	EndMethod

	Function Create:TInputManager()
		Return TInputManager.GetInstance()
	End Function
	
	Function GetInstance:TInputManager()
		If Not instance
			Return New TInputManager
		Else
			Return instance
		EndIf
	EndFunction
'#End Region 

	Method Initialise()
		SetName("Input Manager")
		Super.Initialise()  'Call TGameService initialisation routines
	End Method

	Method Start()
		rrCreateMessageChannel(CHANNEL_INPUT, "Input Manager")
		
		If keyboardEnabled
			TKeyboard.GetInstance()
		End If
		
		If mouseEnabled
			TMouse.GetInstance()
		End If
		
		If joystickEnabled
			TJoystickManager.GetInstance()
		End If		
	End Method
	
	Method Shutdown()
		'TODO
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method
	
	Method Update()
		If LInputDevices.Count() > 0
			For Local device:TInputDevice = EachIn LInputDevices
				device.Update()
			Next
		EndIf
	End Method
	
	Method RegisterDevice(device:TInputDevice)
		TLogger.getInstance().LogInfo("[" + toString() + "] Registering device handler: " + device.name)
		LInputDevices.AddLast(device)
	End Method
	
	Method UnregisterDevice(device:TInputDevice)
		TLogger.getInstance().LogInfo("[" + toString() + "] Unregistering device handler: " + device.name)
		LInputDevices.Remove(device)
	End Method

EndType