Rem
	bbdoc: Base class for animations
End Rem
Type TAnimation

	Field callBackFunction()
	Field isFinished:Int
	
	Method Finished:Int()
		If isFinished And callBackFunction
			callBackFunction()
		EndIf
		Return isFinished
	End Method
	
	Method Initialise()
		Reset()
	End Method

	Method New()
		Self.isFinished = False
	End Method
	
	Method Remove()
	End Method
	
	Method Reset()
		Self.isFinished = False
	End Method
	
	Method SetCallBack(func())
		callBackFunction = func
	End Method
	
	Method Update:Int(sprite:TActor) Abstract
	
End Type
