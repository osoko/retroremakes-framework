Rem
	bbdoc: Message data showing the current state of a virtual control
End Rem
Type TVirtualControlMessageData Extends TMessageData

	field gamepadId:int
	
	field controlName:string
	
	field analogueStatus:Float
	field digitalStatus:int
	field hits:int
End Type
