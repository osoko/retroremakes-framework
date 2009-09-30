Type TEngineException Extends TBlitzException
	Field error:String
	
	Method ToString$()
		Return error
	End Method
	
	Function Create:TEngineException(error:String)
		Local t:TEngineException = New TEngineException
		t.error=error
		Return t
	End Function
End Type