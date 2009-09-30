'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TSpriteAnimation

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
	
	Method Update:Int(sprite:TSprite) Abstract
	
End Type
