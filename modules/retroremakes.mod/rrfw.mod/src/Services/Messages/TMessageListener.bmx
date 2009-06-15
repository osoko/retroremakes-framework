'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TMessageListener
	Field receiver:Object
	Field typeID:TTypeId
	Field listenerMethod:TMethod
	Field channelLink:TLink
	
	Function Create:TMessageListener(listener:Object)
		Local newListener:TMessageListener = New TMessageListener
		newListener.receiver = listener
		newListener.typeID = TTypeId.ForObject(listener)
		newListener.listenerMethod = newListener.typeID.FindMethod("MessageListener")
		If Not newListener.listenerMethod Then Throw "Object does not have the required MessageListener() method"
		Return newListener
	End Function
	
	Method DeliverMessage(message:TMessage)
		listenerMethod.Invoke(receiver, [message])
	End Method
	
End Type
