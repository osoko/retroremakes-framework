Type TStack Extends TList
	
	Method Push(entry:Object)
		AddLast(entry)
	End Method
	
	Method Pop:Object()
		Return RemoveLast()
	End Method
	
	Method Peek:Object()
		Return Last()
	End Method
	
End Type
