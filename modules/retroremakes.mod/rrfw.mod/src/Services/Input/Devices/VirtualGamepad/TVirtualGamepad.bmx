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
	bbdoc: A virtualised gamepad input device
End Rem
Type TVirtualGamepad
	Field id:Int
	
	'A list containing all assigned controls
	'Field LControls_:TList = New TList
	Field MControls_:TMap = New TMap
	
	Field nControls:Int = 0
	
	field getControlStatus:TProfilerSample
	
	Method New()
		SetId(TVirtualGamepadManager.GetInstance().RegisterGamepad(Self))
		LoadSettings()
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
		getControlStatus = rrCreateProfilerSample("Gamepad" + id + ": GetControlStatus")
	End Method
	
	Method SetId(value:Int)
		id = value
	End Method
	
	Method GetId:Int()
		Return id
	End Method
	
	Method GetNextControlId:Int()
		Local id:Int = nControls
		nControls:+1
		Return id
	End Method
	
	Method LoadSettings()
		'attempt to load the gamepad configuration from the settings file
		Local id:String = GetPaddedId()
		
		Local section:String = "VirtualGamepad" + id
		Local iniFile:TINIFile = TGameSettings.GetInstance().iniFile
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
	
	Method GetPaddedId:String()
		Local digits:String = String(id)
		While digits.Length < 3
			digits = "0" + digits
		Wend
		Return digits
	End Method
	
	Method AddControl(name:String)
		If Not GetControl(name)
			Local control:TVirtualControl = New TVirtualControl
			control.SetGamepad(Self)
			control.SetId(GetNextControlId())
			control.SetName(name)
			MControls_.Insert(name, control)
		EndIf
	End Method
	
	Method GetControl:TVirtualControl(control:String)
		Return TVirtualControl(MControls_.ValueForKey(control))
	End Method
	
	Method GetControlNames:String[] ()
		Local names:String[]
		Local i:Int = 1
		Local controls_:TMapEnumerator = MControls_.Values()
		For Local control:TVirtualControl = EachIn controls_
			names = names[..i]
			names[i - 1] = control.GetName()
			i:+1
		Next
		Return names
	End Method
	
	Method GetAnalogueControlStatus:Float(name:String)
		rrStartProfilerSample(getControlStatus)
		Local control:TVirtualControl = TVirtualControl(MControls_.ValueForKey(name))
		If Not control
			Throw "Attempt to access undefined Virtual Control: " + name
		EndIf
		local status:Float = control.GetAnalogueStatus()
		rrStopProfilerSample(getControlStatus)
		Return status
	End Method
	
	Method GetDigitalControlStatus:Int(name:String)
		rrStartProfilerSample(getControlStatus)
		Local control:TVirtualControl = TVirtualControl(MControls_.ValueForKey(name))
		If Not control
			Throw "Attempt to access undefined Virtual Control: " + name
		EndIf
		local status:int = control.GetDigitalStatus()
		rrStopProfilerSample(getControlStatus)
		Return status
	End Method
	
	Method GetControlHitsStatus:Int(name:String)
		Local control:TVirtualControl = TVirtualControl(MControls_.ValueForKey(name))
		If Not control
			Throw "Attempt to access undefined Virtual Control: " + name
		EndIf
		Return control.GetHits()
	End Method
	
	Method GetHits:Int()
		Local hits:Int = 0
		Local controls_:TMapEnumerator = MControls_.Values()
		For Local control:TVirtualControl = EachIn controls_
			hits:+control.GetHits()
		Next
		Return hits
	End Method
	
	Method GetDigitalStatus:Int()
		Local status:Int = 0
		Local controls_:TMapEnumerator = MControls_.Values()
		For Local control:TVirtualControl = EachIn controls_
			status:+control.GetDigitalStatus()
		Next
		Return status
	End Method	
	
	Method MessageListener(message:TMessage)
		Local controls_:TMapEnumerator = MControls_.Values()
		For Local control:TVirtualControl = EachIn controls_
			control.Update(message:TMessage)
		Next
	End Method
	
	Method SetDefaultKeyboardControl(name:String, keyId:Int)
		If GetControl(name)
			GetControl(name).SetDefaultKeyboardControl(keyId)
		End If
	End Method
	
	Method SetDefaultJoystickButtonControl(name:String, port:Int, buttonId:Int)
		If GetControl(name) And TJoystickManager.GetInstance().GetJoystickCount() > port
			GetControl(name).SetDefaultJoystickButtonControl(port, buttonId)
		End If
	End Method
	
	Method SetJoystickButtonControl(name:String, port:Int, buttonId:Int)
		If GetControl(name) And TJoystickManager.GetInstance().GetJoystickCount() > port
			GetControl(name).SetJoystickButtonControl(port, buttonId)
		End If
	End Method
	
	Method SetDefaultJoystickHatControl(name:String, port:Int, hatId:Float)
		If GetControl(name) And TJoystickManager.GetInstance().GetJoystickCount() > port
			GetControl(name).SetDefaultJoystickHatControl(port, hatId)
		End If
	End Method
	
	Method SetJoystickHatControl(name:String, port:Int, hatId:Float)
		If GetControl(name) And TJoystickManager.GetInstance().GetJoystickCount() > port
			GetControl(name).SetJoystickHatControl(port, hatId)
		End If
	End Method			

	Method SetDefaultJoystickAxisControl(name:String, port:Int, axis:String, direction:Int)
		If GetControl(name) And TJoystickManager.GetInstance().GetJoystickCount() > port
			GetControl(name).SetDefaultJoystickAxisControl(port, axis, direction)
		End If
	End Method	
		
	Method SetJoystickAxisControl(name:String, port:Int, axis:String, direction:Int)
		If GetControl(name) And TJoystickManager.GetInstance().GetJoystickCount() > port
			GetControl(name).SetJoystickAxisControl(port, axis, direction)
		End If		
	End Method
	
	Method SetKeyboardControl(name:String, keyId:Int)
		If GetControl(name)
			GetControl(name).SetKeyboardControl(keyId)
		End If
	End Method
	
	Method SetMouseAxisControl(name:String, axis:String, direction:Int)
		If GetControl(name)
			GetControl(name).SetMouseAxisControl(axis, direction)
		End If
	End Method
	
	Method SetDefaultMouseAxisControl(name:String, axis:String, direction:Int)
		If GetControl(name)
			GetControl(name).SetDefaultMouseAxisControl(axis, direction)
		End If
	End Method	

	Method SetMouseButtonControl(name:String, button:String)
		If GetControl(name)
			GetControl(name).SetMouseButtonControl(button)
		End If
	End Method
	
	Method SetDefaultMouseButtonControl(name:String, button:String)
		If GetControl(name)
			GetControl(name).SetDefaultMouseButtonControl(button)
		End If
	End Method	
	
	Method EnableControlProgramming(name:String, enable:Int = True)
		If GetControl(name)
			GetControl(name).EnableProgrammingMode(enable)
		EndIf
	End Method
	
	Method GetProgrammingStatus:Int(name:String)
		If GetControl(name)
			Return GetControl(name).GetProgrammingStatus()
		End If
	End Method
End Type
