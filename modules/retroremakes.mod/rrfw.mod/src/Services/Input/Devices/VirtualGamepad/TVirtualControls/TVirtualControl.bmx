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
	bbdoc: A control attached to a virtual gamepad
	about: A virtual control is a mapping between a logical control belonging
	to a virtual gamepad and a real input such as keyboard key, joystick axis,
	mouse button, etc.
End Rem
Type TVirtualControl
	
	' The default key to use for cancelling programming mode
	Const DEFAULT_PROGRAMMING_CANCEL_KEY:Int = KEY_ESCAPE
	
	' A reference to the input that is mapped to this control
	Field _controlMap:TVirtualControlMapping
	
	' A reference to the default input for this control
	Field _defaultControlMap:TVirtualControlMapping

	' A reference to the gamepad this control belongs to
	Field _gamepad:TVirtualGamepad
	
	' The id of this control
	Field _id:Int
	
	' The name of this control
	Field _name:String
	
	' The key to use for cancelling programming mode
	Field _programmingCancelKey:Int
		
	' The current programming status of this control.  
	Field _programmingStatus:Int
	

		

	
	
	rem
		bbdoc: Enable or Disable programming mode for this control.
		about: When programming mode is enabled the control will listen for the next
		input from all supported devices and then use it for this control's input
	endrem	
	Method EnableProgrammingMode(enable:Int = True)
		SetProgrammingStatus(enable)
		If GetProgrammingStatus()
			SetControlMap(Null)
		Else
			If Not GetControlMap()
				SetControlMap(GetDefaultControlMap())
			End If
			GetControlMap().Save(Self)
		End If
	End Method
	
	
	
	rem
		bbdoc: Work out which joystick axis has changed and in which direction it moved
		from the provided message data
	endrem	
	Function FindJoystickAxis(data:TJoystickMessageData, axis:Int Var, direction:Int Var)
		axis = 0
		direction = 0

		Local value:Float = 0.0

		If Abs(data.joystickX) > Abs(value)
			axis = RR_JOY_X
			value = data.joystickX
		EndIf
		If Abs(data.joystickY) > Abs(value)
			axis = RR_JOY_Y
			value = data.joystickY
		EndIf
		If Abs(data.joystickZ) > Abs(value)
			axis = RR_JOY_Z
			value = data.joystickZ
		EndIf				
		If Abs(data.joystickR) > Abs(value)
			axis = RR_JOY_R
			value = data.joystickR
		EndIf
		If Abs(data.joystickU) > Abs(value)
			axis = RR_JOY_U
			value = data.joystickU
		EndIf
		If Abs(data.joystickV) > Abs(value)
			axis = RR_JOY_V
			value = data.joystickV
		EndIf
		If Abs(data.joystickYaw) > Abs(value)
			axis = RR_JOY_YAW
			value = data.joystickYaw
		EndIf
		If Abs(data.joystickPitch) > Abs(value)
			axis = RR_JOY_PITCH
			value = data.joystickPitch
		EndIf				
		If Abs(data.joystickRoll) > Abs(value)
			axis = RR_JOY_ROLL
			value = data.joystickRoll
		EndIf
		If Abs(data.joystickWheel) > Abs(value)
			axis = RR_JOY_WHEEL
			value = data.joystickWheel
		EndIf						
		
		If axis <> 0
			If value < 0.0 Then direction = -1
			If value > 0.0 Then direction = 1
		End If
	End Function



	rem
		bbdoc: Work out which mouse axis has changed and in which direction it moved
		from the provided message data
	endrem
	Function FindMouseAxis(data:TMouseMessageData, axis:Int Var, direction:Int Var)
		axis = 0
		direction = 0

		Local value:Float = 0.0

		If Abs(data.mousePosX - data.lastMousePosX) > Abs(value)
			axis = RR_MOUSE_X
			value = data.mousePosX - data.lastMousePosX
		EndIf
		If Abs(data.mousePosY - data.lastMousePosY) > Abs(value)
			axis = RR_MOUSE_Y
			value = data.mousePosY - data.lastMousePosY
		EndIf
		If Abs(data.mousePosZ - data.lastMousePosZ) > Abs(value)
			axis = RR_MOUSE_Z
			value = data.mousePosZ - data.lastMousePosZ
		EndIf				
		
		If axis <> 0
			If value < 0.0 Then direction = -1
			If value > 0.0 Then direction = 1
		End If
	End Function
	
	
		
	rem
		bbdoc: Get the analogue status of this control
		returns: Float in the range 0.0 to 1.0
	endrem
	Method GetAnalogueStatus:Float()
		If Not GetControlMap()
			Return Null
		Else
			Return GetControlMap().GetAnalogueStatus()
		End If
	End Method

	
		
	rem
		bbdoc: Gets the input mapped to this control
	endrem	
	Method GetControlMap:TVirtualControlMapping()
		Return _controlMap
	End Method

	
	
	rem
		bbdoc: Get the reference to the default input for this control
	endrem
	Method GetDefaultControlMap:TVirtualControlMapping()
		Return _defaultControlMap
	End Method	
	
	
	
	rem
		bbdoc: Get the digital status of this control
		returns: 1 if the control is down, otherwise 0
	endrem	
	Method GetDigitalStatus:Int()
		If Not GetControlMap()
			Return Null
		Else
			Return GetControlMap().GetDigitalStatus()
		End If
	End Method

		
	
	rem
		bbdoc: Get a reference to the instance of TVirtualGamepad this TVirtualControl
		is attached to.
	endrem
	Method GetGamepad:TVirtualGamepad()
		Return _gamepad
	End Method
	
	
	
	rem
		bbdoc: Get the number of times this control has been pressed
		about: The value returned is the amount of times the control has been
		pressed since the last time this method was called.  Calling this method
		also resets the hit counter to 0
	endrem
	Method GetHits:Int()
		If Not GetControlMap()
			Return Null
		Else
			Return GetControlMap().GetHits()
		End If
	End Method
	
	
		
	rem
		bbdoc: Get the id of this control
	endrem
	Method GetId:Int()
		Return _id
	End Method


	
	rem
		bbdoc: Translate a string representation of a joystick axis into the
		relavant constant
	endrem
	Function GetJoystickAxisId:Int(axis:String)
		Select axis.ToLower()
			Case "x"
				Return RR_JOY_X
			Case "y"
				Return RR_JOY_Y
			Case "z"
				Return RR_JOY_Z
			Case "r"
				Return RR_JOY_R
			Case "u"
				Return RR_JOY_U
			Case "v"
				Return RR_JOY_V
			Case "yaw"
				Return RR_JOY_YAW
			Case "pitch"
				Return RR_JOY_PITCH
			Case "roll"
				Return RR_JOY_ROLL
			Case "wheel"
				Return RR_JOY_WHEEL
			Default
				Return Null
		End Select
	End Function
	
	
	
	rem
		bbdoc: Translate a string representation of a mouse axis into the
		relavant constant
	endrem	
	Function GetMouseAxisId:Int(axis:String)
		Select axis.ToLower()
			Case "x"
				Return RR_MOUSE_X
			Case "y"
				Return RR_MOUSE_Y
			Case "z"
				Return RR_MOUSE_Z
			Default
				Return Null
		End Select
	End Function
	
	
	
	rem
		bbdoc: Translate a string representation of a mouse button into the
		relavant constant
	endrem	
	Function GetMouseButtonId:Int(button:String)
		Select button.ToLower()
			Case "left"
				Return RR_MOUSE_LEFT
			Case "right"
				Return RR_MOUSE_RIGHT
			Case "middle"
				Return RR_MOUSE_MIDDLE
			Default
				Return Null
		End Select
	End Function

	

	rem
		bbdoc: Get the name of the control
	endrem
	Method GetName:String()
		Return _name
	End Method
	
	

	rem
		bbdoc: Create a control identifier using a padded id value
		about: This is used to identify a control when gamepad settings are
		saved to a configuration file
	endrem
	Method GetPaddedControlId:String()
		Local digits:String = String(GetId())
		While digits.Length < 3
			digits = "0" + digits
		Wend
		Return "CONTROL" + digits
	End Method
	
	
			
	rem
		bbdoc: Get the key to use for cancelling programming mode
	endrem
	Method GetProgrammingCancelKey:Int()
		Return _programmingCancelKey
	End Method
	
	

	rem
		bbdoc: Get the programming status of the control.
		returns: True if it is being programmed, otherwise False.
	endrem
	Method GetProgrammingStatus:Int()
		Return _programmingStatus
	End Method
	
	
	
	rem
		bbdoc: Process joystick input messages during programming mode
	endrem
	Method HandleJoystickInput(message:TMessage)
		Local data:TJoystickMessageData = TJoystickMessageData(message.data)
	
		' Check buttons first
		For Local i:Int = 0 To data.nButtons - 1
			If data.buttonHit[i]
				SetControlMap(New TJoystickButtonMapping)
				TJoystickButtonMapping(GetControlMap()).SetButtonId(i)
				TJoystickButtonMapping(GetControlMap()).SetJoystickId(data.port)
				EnableProgrammingMode(False)
			End If
		Next
		
		' Check hats
		If data.joystickHat <> - 1.000 ' -1.000 seems to be the default unpressed state of joystick hats
			SetControlMap(New TJoystickHatMapping)
			TJoystickHatMapping(GetControlMap()).SetHatId(data.joystickHat)
			TJoystickHatMapping(GetControlMap()).SetJoystickId(data.port)
			EnableProgrammingMode(False)
		End If
		
		' Check axis
		Local axis:Int
		Local direction:Int
		FindJoystickAxis(data, axis, direction)
		If axis <> 0
			SetControlMap(New TJoystickAxisMapping)
			TJoystickAxisMapping(GetControlMap()).SetAxis(axis, direction)
			TJoystickAxisMapping(GetControlMap()).SetJoystickId(data.port)
			EnableProgrammingMode(False)
		End If
	End Method
	
	
		
	rem
		bbdoc: Process keyboard input messages during programming mode
	endrem
	Method HandleKeyboardInput(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)

		If data.key = GetProgrammingCancelKey()
			If data.keyHits
				EnableProgrammingMode(False)
				Return
			EndIf
		End If

		If data.keyHits	'Not interested unless key has been released
			SetControlMap(New TKeyboardMapping)
			TKeyboardMapping(GetControlMap()).SetButton(data.key)
			EnableProgrammingMode(False)
		EndIf
	End Method
	
	
		
	rem
		bbdoc: Process mouse input messages during programming mode
	endrem	
	Method HandleMouseInput(message:TMessage)
		Local data:TMouseMessageData = TMouseMessageData(message.data)
		
		' Check buttons first
		For Local i:Int = 1 To 3
			If data.mouseStates[i]
				SetControlMap(New TMouseButtonMapping)
				TMouseButtonMapping(GetControlMap()).SetButtonId(i)
				EnableProgrammingMode(False)
				Exit
			End If
		Next
		
		' Now check axis
		Local axis:Int
		Local direction:Int
		FindMouseAxis(data, axis, direction)
		If axis <> 0
			SetControlMap(New TMouseAxisMapping)
			TMouseAxisMapping(GetControlMap()).SetAxis(axis, direction)
			EnableProgrammingMode(False)
		End If		
	End Method
	
	
	
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		SetProgrammingMode(False)
		SetProgrammingCancelKey(DEFAULT_PROGRAMMING_CANCEL_KEY)
	End Method
	
	
	
	rem
		bbdoc: Handler for input messages in programming mode
	endrem
	Method Program(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardInput(message)
			Case MSG_JOYSTICK
				HandleJoystickInput(message)
			Case MSG_MOUSE
				HandleMouseInput(message)
		End Select
	End Method
	
	
						
	rem
		bbdoc: Sets the inpu mapped to this control
	endrem	
	Method SetControlMap(controlMap:TVirtualControlMapping)
		_controlMap = controlMap
	End Method

	
	
	rem
		bbdoc: Set the default input for this control
	endrem	
	Method SetDefaultControlMap(defaultControlMap:TVirtualControlMapping)
		_defaultControlMap = defaultControlMap
	End Method	

	
	
	rem
		bbdoc: Set the default mapping for this control to the specified joystick axis and direction
	endrem
	Method SetDefaultJoystickAxisControl(port:Int, axis:String, direction:Int)
		Local axisId:Int = GetJoystickAxisId(axis)
		If axisId And (direction = -1 Or direction = 1)
			SetDefaultControlMap(New TJoystickAxisMapping)
			TJoystickAxisMapping(GetDefaultControlMap()).SetAxis(axisId, direction)
			TJoystickAxisMapping(GetDefaultControlMap()).SetJoystickId(port)
			If Not GetControlMap()
				SetControlMap(GetDefaultControlMap())
			End If
		EndIf
	End Method
	
	
	
	rem
		bbdoc: Set the default mapping for this control to the specified joystick button
	endrem	
	Method SetDefaultJoystickButtonControl(port:Int, buttonId:Int)
		If buttonId < TJoystickManager.GetInstance().GetJoystick(port).CountButtons()
			SetDefaultControlMap(New TJoystickButtonMapping)
			TJoystickButtonMapping(GetDefaultControlMap()).SetButtonId(buttonId)
			TJoystickButtonMapping(GetDefaultControlMap()).SetJoystickId(port)
			If Not GetControlMap()
				SetControlMap(GetDefaultControlMap())
			End If
		End If
	End Method
	
	
		
	rem
		bbdoc: Set the default mapping for this control to the specified joystick hat direction
	endrem	
	Method SetDefaultJoystickHatControl(port:Int, hatId:Float)
		SetDefaultControlMap(New TJoystickHatMapping)
		TJoystickHatMapping(GetDefaultControlMap()).SetHatId(hatId)
		TJoystickHatMapping(GetDefaultControlMap()).SetJoystickId(port)
		If Not GetControlMap()
			SetControlMap(GetDefaultControlMap())
		End If
	End Method
	
	
		
	rem
		bbdoc: Set the default mapping for this control to the specified key
	endrem		
	Method SetDefaultKeyboardControl(keyId:Int)
		If keyId >= 0 And keyId < 256
			SetDefaultControlMap(New TKeyboardMapping)
			TKeyboardMapping(GetDefaultControlMap()).SetButton(keyId)
			If Not GetControlMap()
				SetControlMap(GetDefaultControlMap())
			End If
		End If
	End Method
	
	
		
	rem
		bbdoc: Set the default for this control to the specified mouse axis and direction
	endrem	
	Method SetDefaultMouseAxisControl(axis:String, direction:Int)
		Local axisId:Int = GetMouseAxisId(axis)
		If axisId And (direction = -1 Or direction = 1)
			SetDefaultControlMap(New TMouseAxisMapping)
			TMouseAxisMapping(GetDefaultControlMap()).SetAxis(axisId, direction)
			If Not GetControlMap()
				SetControlMap(GetDefaultControlMap())
			End If			
		End If
	End Method
		
	
	
	rem
		bbdoc: Set the default mapping for this control to the specified mouse button
	endrem	
	Method SetDefaultMouseButtonControl(button:String)
		Local buttonId:Int = GetMouseButtonId(button)
		If buttonId
			SetDefaultControlMap(New TMouseButtonMapping)
			TMouseButtonMapping(GetDefaultControlMap()).SetButtonId(buttonId)
			If Not GetControlMap()
				SetControlMap(GetDefaultControlMap())
			End If			
		End If
	End Method
	
	
		
	rem
		bbdoc: Set the instance of TVirtualGamepad this TVirtualControl is attached to.
	endrem	
	Method SetGamepad(gamepad:TVirtualGamepad)
		_gamepad = gamepad
	End Method	


	
	rem
		bbdoc: Set the id of this control.
		about: This should only be used by the gamepad this control belongs to
	endrem
	Method SetId(id:Int)
		_id = id
	End Method	
	
	
	
	rem
		bbdoc: Map this control to the specified joystick axis and direction
	endrem	
	Method SetJoystickAxisControl(port:Int, axis:String, direction:Int)
		Local axisId:Int = GetJoystickAxisId(axis)
		If axisId And (direction = -1 Or direction = 1)
			SetControlMap(New TJoystickAxisMapping)
			TJoystickAxisMapping(GetControlMap()).SetAxis(axisId, direction)
			TJoystickAxisMapping(GetControlMap()).SetJoystickId(port)
		EndIf
	End Method
	
	
	
	rem
		bbdoc: Map this control to the specified joystick button
	endrem	
	Method SetJoystickButtonControl(port:Int, buttonId:Int)
		If buttonId < TJoystickManager.GetInstance().GetJoystick(port).CountButtons()
			SetControlMap(New TJoystickButtonMapping)
			TJoystickButtonMapping(GetControlMap()).SetButtonId(buttonId)
			TJoystickButtonMapping(GetControlMap()).SetJoystickId(port)
		End If
	End Method
	
	
	
	rem
		bbdoc: Map this control to the specified joystick hat direction
	endrem			
	Method SetJoystickHatControl(port:Int, hatId:Float)
		SetControlMap(New TJoystickHatMapping)
		TJoystickHatMapping(GetControlMap()).SetHatId(hatId)
		TJoystickHatMapping(GetControlMap()).SetJoystickId(port)
	End Method
	
	
		
	rem
		bbdoc: Map this control to the specified key
	endrem		
	Method SetKeyboardControl(keyId:Int)
		If keyId >= 0 And keyId < 256
			SetControlMap(New TKeyboardMapping)
			TKeyboardMapping(GetControlMap()).SetButton(keyId)
		End If
	End Method
	
	
		
	rem
		bbdoc: Map this control to the specified mouse axis and direction
	endrem		
	Method SetMouseAxisControl(axis:String, direction:Int)
		Local axisId:Int = GetMouseAxisId(axis)
		If axisId And (direction = -1 Or direction = 1)
			SetControlMap(New TMouseAxisMapping)
			TMouseAxisMapping(GetControlMap()).SetAxis(axisId, direction)
		End If
	End Method

	
		
	rem
		bbdoc: Map this control to the specified mouse button
	endrem		
	Method SetMouseButtonControl(button:String)
		Local buttonId:Int = GetMouseButtonId(button)
		If buttonId
			SetControlMap(New TMouseButtonMapping)
			TMouseButtonMapping(GetControlMap()).SetButtonId(buttonId)
		End If
	End Method
	
	
		
	rem
		bbdoc: Set the name of the control
	endrem	
	Method SetName(name:String)
		_name = name
	End Method

	
	
	Rem
		bbdoc: Set the key to use for cancelling programming mode
	End Rem
	Method SetProgrammingCancelKey(keycode:Int)
		_programmingCancelKey = keycode
	End Method	

	
	
	rem
		bbdoc: Set the programming status of the control.
	endrem
	Method SetProgrammingStatus(bool:Int)
		_programmingStatus = bool
	End Method


			
	rem
		bbdoc: Update this control
		about: This is where the control receives raw input messages from the gamepad
		it belongs to.  If programming mode is enable for this control, the message is
		used to program the control.  Otherwise the message is passed on to the mapped
		control for processing
	endrem
	Method Update(message:TMessage)
		If GetControlMap()
			GetControlMap().Update(message)
		Else
			Program(message)
		End If
	End Method
	
End Type
