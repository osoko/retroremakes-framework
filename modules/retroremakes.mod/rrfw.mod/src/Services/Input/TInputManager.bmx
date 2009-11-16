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

rem
	bbdoc: Service for managing and updating all input devices
endrem
Type TInputManager Extends TGameService

	' This holds the singleton instance of this Type
	Global _instance:TInputManager
	
	' Whether joystick input is enabled or not
	Field _joystickEnabled:Int
			
	' Whether keyboard input is enabled or not
	Field _keyboardEnabled:Int

	' Whether mouse input is enabled or not
	Field _mouseEnabled:Int

	'all registered input devices
	Field _registeredInputDevices:TList

		
	
	rem
		bbdoc: Enable/Disable Joystick input
	endrem
	Method EnableJoystick(bool:Int)
		_joystickEnabled = bool
	End Method
		
	
	
	rem
		bbdoc: Enable/Disable Keyboard input
	endrem	
	Method EnableKeyboard(bool:Int)
		_keyboardEnabled = bool
	End Method
	
	
	
	rem
		bbdoc: Enable/Disable Mouse input
	endrem	
	Method EnableMouse(bool:Int)
		_mouseEnabled = bool
	End Method
		
	
	
	rem
		bbdoc: Get the Singleton instance of this service
	endrem
	Function GetInstance:TInputManager()
		If Not _instance
			Return New TInputManager
		Else
			Return _instance
		EndIf
	End Function
	
	
	
	rem
		bbdoc: Initialises the service
	endrem
	Method Initialise()
		SetName("Input Manager")
		Super.Initialise()  'Call TGameService initialisation routines
	End Method



	rem
		bbdoc: Default Constructor
	endrem
	Method New()
		If _instance rrThrow "Cannot create multiple instances of this Singleton Type"
		
		_instance = Self
		
		'Check devices first in each update loop
		updatePriority = -1000
		
		_registeredInputDevices = New TList
		
		_joystickEnabled = True
		_keyboardEnabled = True
		_mouseEnabled = False
		
		Self.Initialise()
	EndMethod
	


	rem
		bbdoc: Register an input device with the input manager
	endrem
	Method RegisterDevice(device:TInputDevice)
		TLogger.getInstance().LogInfo("[" + toString() + "] Registering device handler: " + device.GetName())
		_registeredInputDevices.AddLast(device)
	End Method
	
	
		
	rem
		bbdoc: Shutdown the service
	endrem
	Method Shutdown()
		'TODO
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method
	
	
		
	rem
		bbdoc: Starts the service
	endrem
	Method Start()
		rrCreateMessageChannel(CHANNEL_INPUT, "Input Manager")
		
		If _keyboardEnabled
			TKeyboard.GetInstance()
		End If
		
		If _mouseEnabled
			TMouse.GetInstance()
		End If
		
		If _joystickEnabled
			TJoystickManager.GetInstance()
		End If		
	End Method



	rem
		bbdoc: Unregister an input device with the input manager
	endrem
	Method UnregisterDevice(device:TInputDevice)
		TLogger.getInstance().LogInfo("[" + toString() + "] Unregistering device handler: " + device.GetName())
		_registeredInputDevices.Remove(device)
	End Method
	
	
			
	rem
		bbdoc: Updates all registered input devices
	endrem
	Method Update()
		If _registeredInputDevices.Count() > 0
			For Local device:TInputDevice = EachIn _registeredInputDevices
				device.Update()
			Next
		EndIf
	End Method

EndType
