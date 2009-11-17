rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Rem
	bbdoc: Wrapper class for objects that can receive messages.
	about: Allows direct message passing to Objects that implement
	a valid MessageListener() method.
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
