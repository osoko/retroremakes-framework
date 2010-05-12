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
	bbdoc: A virtualised gamepad input device
End Rem
Type TVirtualGamepad

	'A map containing all assigned controls
	Field _controls:TMap
	
	' The unique id of this virtual gamepad
	Field _id:Int
	
	' The number of controls attached to this virtual gamepad
	Field _nControls:Int
	
	
	
	rem
		bbdoc: Adds a new control to the virtual gamepad
	endrem
	Method AddControl(name:String)
		If Not GetControl(name)
			Local control:TVirtualControl = New TVirtualControl
			control.SetGamepad(Self)
			control.SetId(AllocateNextControlId())
			control.SetName(name)
			_controls.Insert(name, control)
		EndIf
	End Method
	
	
		
	rem
		bbdoc: Allocates the next available ID for a new control
	endrem
	Method AllocateNextControlId:Int()
		Local id:Int = _nControls
		_nControls:+1
		Return id
	End Method
	
	

	rem
		bbdoc: Enable/Disable programming mode for a control
		about: When in programming mode a control will assign the next
		joystick, keyboard or mouse control to be seen on the CHANNEL_INPUT
		message channel.  The only exception is the "Escape" key which, when
		pressed, will reset the control to its default assignment.
	endrem
	Method EnableControlProgramming(name:String, enable:Int = True)
		If GetControl(name)
			GetControl(name).EnableProgrammingMode(enable)
		EndIf
	End Method
	
	
		
	rem
		bbdoc: Returns the analogue status of the specified control
		about: Analogue status is a float in the range 0.0 to 1.0.  Purely
		digital input devices assigned to a virtual control will always
		return analogue values of 1.0 for pressed and 0.0 for not-pressed
	endrem
	Method GetAnalogueControlStatus:Float(name:String)
		Local control:TVirtualControl = TVirtualControl(_controls.ValueForKey(name))
		If Not control
			Throw "Attempt to access undefined Virtual Control: " + name
		EndIf
		local status:Float = control.GetAnalogueStatus()
		Return status
	End Method
	
	
		
	rem
		bbdoc: Returns the specified virtual control
	endrem	
	Method GetControl:TVirtualControl(control:String)
		Return TVirtualControl(_controls.ValueForKey(control))
	End Method
	
	
	
	rem
		bbdoc: Returns the hits count for the specified virtual control
		about: The hits count is the number of times the control has been pressed
		since the last time it was queried.
	endrem
	Method GetControlHitsStatus:Int(name:String)
		Local control:TVirtualControl = TVirtualControl(_controls.ValueForKey(name))
		If Not control
			Throw "Attempt to access undefined Virtual Control: " + name
		EndIf
		Return control.GetHits()
	End Method
	
	
		
	rem
		bbdoc: Returns an array containing all registered control names
	endrem
	Method GetControlNames:String[] ()
		Local names:String[]
		Local i:Int = 1
		Local controls_:TMapEnumerator = _controls.Values()
		For Local control:TVirtualControl = EachIn controls_
			names = names[..i]
			names[i - 1] = control.GetName()
			i:+1
		Next
		Return names
	End Method
	
	
	
	rem
		bbdoc: Returns the digital status of the specified control
		about: Digital status is 0 for not-pressed and 1 for pressed
	endrem	
	Method GetDigitalControlStatus:Int(name:String)
		Local control:TVirtualControl = TVirtualControl(_controls.ValueForKey(name))
		If Not control
			Throw "Attempt to access undefined Virtual Control: " + name
		EndIf
		local status:int = control.GetDigitalStatus()
		Return status
	End Method
	
	
	
	rem
		bbdoc: Get the combined digital status of all virtual controls
		about: Useful to see if any control is being held down
	endrem
	Method GetDigitalStatus:Int()
		Local status:Int = 0
		Local controls_:TMapEnumerator = _controls.Values()
		For Local control:TVirtualControl = EachIn controls_
			status:+control.GetDigitalStatus()
		Next
		Return status
	End Method
	
	
		
	rem
		bbdoc: Get the combined hits count for all virtual controls
		about: Useful for "Press any Button" type situations
	endrem
	Method GetHits:Int()
		Local hits:Int = 0
		Local controls_:TMapEnumerator = _controls.Values()
		For Local control:TVirtualControl = EachIn controls_
			hits:+control.GetHits()
		Next
		Return hits
	End Method
	
	
			
	rem
		bbdoc: Get the ID of this virtual gamepad
	endrem	
	Method GetId:Int()
		Return _id
	End Method
	
	
	
	rem
		bbdoc: Returns a string version of the virtual gamepad's ID, padded to
		three digits
	endrem
	Method GetPaddedId:String()
		Local digits:String = String(GetId())
		While digits.Length < 3
			digits = "0" + digits
		Wend
		Return digits
	End Method
	
	

	rem
		bbdoc: Returns the current programming status of the supplied control
		returns: True if the control is in programming mode, otherwise False
	endrem
	Method GetProgrammingStatus:Int(name:String)
		If GetControl(name)
			Return GetControl(name).GetProgrammingStatus()
		End If
	End Method
	
	
		
	rem
		bbdoc: Attempt to load the configuration for this virtual gamepad
		about: virtual gamepad configurations are stored in the application INI file
	endrem
	Method LoadSettings()
		Local iniFile:TINIFile = TGameSettings.GetInstance().iniFile

		Local id:String = GetPaddedId()

		Local section:String = "VirtualGamepad" + id

		Local controls:String[] = iniFile.GetSectionParameters(section)

		For Local control:String = EachIn controls
			Local controlSettings:String[] = iniFile.GetStringValues(section, control)
			Local nValues:Int = controlSettings.Length
			If nValues > 1
				Local controlName:String = controlSettings[0]
				Select controlSettings[1].ToLower()
					Case "keyboard"
						If nValues = 3
							Local buttonId:Int = Int(controlSettings[2])
							AddControl(controlName)
							SetKeyboardControl(controlName, buttonId)
						End If
					Case "joystick"
						If nValues > 2
							Select controlSettings[2].ToLower()
								Case "axis"
									If nValues = 6
										Local port:Int = Int(controlSettings[3])
										Local axis:String = controlSettings[4]
										Local direction:Int = Int(controlSettings[5])
										AddControl(controlName)
										SetJoystickAxisControl(controlName, port, axis, direction)
									EndIf
								Case "button"
									If nValues = 5
										Local port:Int = Int(controlSettings[3])
										Local buttonId:Int = Int(controlSettings[4])
										AddControl(controlName)
										SetJoystickButtonControl(controlName, port, buttonId)
									End If
								Case "hat"
									If nValues = 5
										Local port:Int = Int(controlSettings[3])
										Local hatId:Float = Float(controlSettings[4])
										AddControl(controlName)
										SetJoystickHatControl(controlName, port, hatId)
									End If
							End Select
						End If
					Case "mouse"
						If nValues > 2
							Select controlSettings[2].ToLower()
								Case "axis"
									If nValues = 5
										Local axis:String = controlSettings[3]
										Local direction:Int = Int(controlSettings[4])
										AddControl(controlName)
										SetMouseAxisControl(controlName, axis, direction)
									End If
								Case "button"
									If nValues = 4
										Local button:String = controlSettings[3]
										AddControl(controlName)
										SetMouseButtonControl(controlName, button)
									End If
							EndSelect
						EndIf
				End Select
			End If
		Next
	End Method

	
	
	rem
		bbdoc: Received messages broadcast on the CHANNEL_INPUT channel
		about: Acts as a message pump for all assigned virtual controls
	endrem	
	Method MessageListener(message:TMessage)
		Local controls_:TMapEnumerator = _controls.Values()
		For Local control:TVirtualControl = EachIn controls_
			control.Update(message:TMessage)
		Next
	End Method
	
	
		
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		_controls = New TMap
		_nControls = 0
			
		SetId(TVirtualGamepadManager.GetInstance().RegisterGamepad(Self))

		LoadSettings()
		
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
	End Method
	
	
	
	rem
		bbdoc: Sets a default joystick axis mapping for a control
		about: This default mapping is used if a custom mapping has not been chosen
		by the user and saved to the INI file
	endrem	
	Method SetDefaultJoystickAxisControl(name:String, port:Int, axis:String, direction:Int)
		If GetControl(name) And TJoystickManager.GetInstance().GetJoystickCount() > port
			GetControl(name).SetDefaultJoystickAxisControl(port, axis, direction)
		End If
	End Method
	
	
	
	rem
		bbdoc: Sets a default joystick button mapping for a control
		about: This default mapping is used if a custom mapping has not been chosen
		by the user and saved to the INI file
	endrem	
	Method SetDefaultJoystickButtonControl(name:String, port:Int, buttonId:Int)
		If GetControl(name) And TJoystickManager.GetInstance().GetJoystickCount() > port
			GetControl(name).SetDefaultJoystickButtonControl(port, buttonId)
		End If
	End Method
	
	
	
	rem
		bbdoc: Sets a default joystick hat mapping for a control
		about: This default mapping is used if a custom mapping has not been chosen
		by the user and saved to the INI file
	endrem		
	Method SetDefaultJoystickHatControl(name:String, port:Int, hatId:Float)
		If GetControl(name) And TJoystickManager.GetInstance().GetJoystickCount() > port
			GetControl(name).SetDefaultJoystickHatControl(port, hatId)
		End If
	End Method
	
	
		
	rem
		bbdoc: Sets a default keyboard mapping for a control
		about: This default mapping is used if a custom mapping has not been chosen
		by the user and saved to the INI file
	endrem
	Method SetDefaultKeyboardControl(name:String, keyId:Int)
		If GetControl(name)
			GetControl(name).SetDefaultKeyboardControl(keyId)
		End If
	End Method
	
	
	
	rem
		bbdoc: Sets a default mouse axis mapping for a control
		about: This default mapping is used if a custom mapping has not been chosen
		by the user and saved to the INI file
	endrem		
	Method SetDefaultMouseAxisControl(name:String, axis:String, direction:Int)
		If GetControl(name)
			GetControl(name).SetDefaultMouseAxisControl(axis, direction)
		End If
	End Method
	
	
	
	rem
		bbdoc: Sets a default mouse button mapping for a control
		about: This default mapping is used if a custom mapping has not been chosen
		by the user and saved to the INI file
	endrem		
	Method SetDefaultMouseButtonControl(name:String, button:String)
		If GetControl(name)
			GetControl(name).SetDefaultMouseButtonControl(button)
		End If
	End Method		

	
		
	rem
		bbdoc: Set the ID of this virtual gamepad
	endrem
	Method SetId(value:Int)
		_id = value
	End Method

	
	
	rem
		bbdoc: Sets a joystick axis mapping for a control
	endrem		
	Method SetJoystickAxisControl(name:String, port:Int, axis:String, direction:Int)
		If GetControl(name) And TJoystickManager.GetInstance().GetJoystickCount() > port
			GetControl(name).SetJoystickAxisControl(port, axis, direction)
		End If		
	End Method	

	
	
	rem
		bbdoc: Sets a joystick button mapping for a control
	endrem	
	Method SetJoystickButtonControl(name:String, port:Int, buttonId:Int)
		If GetControl(name) And TJoystickManager.GetInstance().GetJoystickCount() > port
			GetControl(name).SetJoystickButtonControl(port, buttonId)
		End If
	End Method
	

	
	rem
		bbdoc: Sets a joystick hat mapping for a control
	endrem	
	Method SetJoystickHatControl(name:String, port:Int, hatId:Float)
		If GetControl(name) And TJoystickManager.GetInstance().GetJoystickCount() > port
			GetControl(name).SetJoystickHatControl(port, hatId)
		End If
	End Method			
	
	
	
	rem
		bbdoc: Sets a keyboard mapping for a control
	endrem		
	Method SetKeyboardControl(name:String, keyId:Int)
		If GetControl(name)
			GetControl(name).SetKeyboardControl(keyId)
		End If
	End Method
	
	rem
		bbdoc: Sets a mouse axis mapping for a control
	endrem		
	Method SetMouseAxisControl(name:String, axis:String, direction:Int)
		If GetControl(name)
			GetControl(name).SetMouseAxisControl(axis, direction)
		End If
	End Method
	
	
	rem
		bbdoc: Sets a mouse button mapping for a control
	endrem	
	Method SetMouseButtonControl(name:String, button:String)
		If GetControl(name)
			GetControl(name).SetMouseButtonControl(button)
		End If
	End Method	

End Type
