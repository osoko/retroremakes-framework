'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TSpriteAnimation

	Field isFinished:Int
	Field callBackFunction()
	
	Method New()
		Self.isFinished = False
	End Method
	
	Method Initialse()
		Reset()
	End Method
	
	Method remove()
	End Method
	
	Method Reset()
		Self.isFinished = False
	End Method
	
	Method Update:Int(sprite:TSprite) Abstract
	
	Method SetCallBack(func())
		callBackFunction = func
	End Method
	
	Method Finished:Int()
		If callBackFunction And isFinished
			callBackFunction()
		EndIf
		Return isFinished
	End Method
	
End Type
