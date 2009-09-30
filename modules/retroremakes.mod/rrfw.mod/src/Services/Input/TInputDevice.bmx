Rem
	bbdoc: Base class for input devices that can be used by the engine.
End Rem
Type TInputDevice Abstract

	Field name:String = "Unidentified Input Device"

	Method ToString:String()
		Return name
	End Method
	
	
	
	Method Update()
	End Method
	
End Type
