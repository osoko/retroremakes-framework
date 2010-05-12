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
	bbdoc: Class for managing one or more virtual gamepads
End Rem
Type TVirtualGamepadManager Extends TInputDevice

	' The Singleton instance of this class
	Global _instance:TVirtualGamepadManager

	' All the controllers registered with the manager
	Field _controllers:TVirtualGamepad[]
	
	' The number of registered controllers
	Field _nControllers:Int
	
	' The next available controller ID
	Field _nextControllerId:Int
	

	
	rem
		bbdoc: Allocates the next available controller ID
	endrem
	Method AllocateNextControllerId:Int()
		Local id:Int = _nextControllerId
		_nextControllerId:+1
		Return id
	End Method
	
	
	
	rem
		bbdoc: Returns the number of registered virtual gamepads
	endrem
	Method CountControllers:Int()
		Return _nControllers
	End Method
	
	

	rem
		bbdoc: Returns the gamepad with the specified ID
	endrem
	Method GetController:TVirtualGamepad(id:Int)
		If id >= 0 And id < _nControllers
			Return _controllers[id]
		Else
			Return Null
		End If
	End Method
	
	
		
	rem
		bbdoc: Returns the Singleton instance of this class
	endrem
	Function GetInstance:TVirtualGamepadManager()
		If Not _instance
			Return New TVirtualGamepadManager
		Else
			Return _instance
		EndIf
	End Function
	
	
	
	rem
		bbdoc: Initialises this input device
	endrem
	Method Initialise()
		SetName("Virtual Gamepad Manager")
		TInputManager.GetInstance().RegisterDevice(Self)
	End Method
	
	
	
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		If _instance Throw "Cannot create multiple instances of Singleton Type"
		
		_instance = Self
		_nControllers = 0
		_nextControllerId = 0
		
		Self.Initialise()
	End Method
	

		
	rem
		bbdoc: Registers a virtual gamepad with the manager
	endrem
	Method RegisterGamepad:Int(controller:TVirtualGamepad)
		Local id:Int = AllocateNextControllerId()
		_nControllers:+1
		If Not _controllers
			_controllers = New TVirtualGamepad[_nControllers]
		Else
			_controllers = _controllers[.._nControllers]
		EndIf
		_controllers[id] = controller
		Return id
	End Method
	
End Type
