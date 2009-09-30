Type TCommand

	Method Execute:Int() Abstract
	
	Method Unexecute() Abstract
	
	Method CanBeUndone:Int() Abstract
	
	Method Merge:Int(command:TCommand) Abstract
	
	Method ToString:String()
		Return "Command Pattern function object."
	End Method

End Type

