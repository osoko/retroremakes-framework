Rem
	bbdoc: Class for managing one or more virtual gamepads
End Rem
Type TVirtualGamepadManager Extends TInputDevice

	Global instance_:TVirtualGamepadManager

	Field nextControllerId_:Int = 0
	Field nControllers_:Int = 0
		
	Field controllers_:TVirtualGamepad[]

	Method New()
		If instance_ Throw "Cannot create multiple instances of Singleton Type"
		instance_ = Self
		Self.Initialise()
	EndMethod
	
	Function GetInstance:TVirtualGamepadManager()
		If Not instance_
			Return New TVirtualGamepadManager
		Else
			Return instance_
		EndIf
	EndFunction
		
	Method Initialise()
		name = "Virtual Gamepad Manager"
		TInputManager.GetInstance().RegisterDevice(Self)
	End Method

	Method RegisterGamepad:Int(controller:TVirtualGamepad)
		Local id:Int = GetNextControllerId()
		nControllers_:+1
		If Not controllers_
			controllers_ = New TVirtualGamepad[nControllers_]
		Else
			controllers_ = controllers_[..nControllers_]
		EndIf
		controllers_[id] = controller
		Return id
	EndMethod
	
	Method CountControllers:Int()
		Return nControllers_
	End Method
	
	Method GetNextControllerId:Int()
		Local id:Int = nextControllerId_
		nextControllerId_:+1
		Return id
	End Method
	
	Method GetController:TVirtualGamepad(id:Int)
		If id >= 0 And id < nControllers_
			Return controllers_[id]
		Else
			Return Null
		End If
	End Method
	
End Type

Function rrEnableVirtualControllerInput()
	TVirtualGamepadManager.GetInstance()
End Function

Function rrCountVirtualGamepads:Int()
	Return TVirtualGamepadManager.GetInstance().CountControllers()
End Function

Function rrGetVirtualGamepad:TVirtualGamepad(id:Int)
	Return TVirtualGamepadManager.GetInstance().GetController(id)
End Function