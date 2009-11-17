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

rem
	bbdoc: Class representing a message
endrem
Type TMessage

	Field messageId:Int
	Field dispatchTime:Int ' Millisecs() when the message should be sent
	Field sender:Object
	Field receiver:Object
	Field data:TMessageData
	
	Method SetMessageId(id:Int)
		messageId = id
	EndMethod
	
	Method SendTo(recipient:Object, from:Object = Null)
		' Who is this message for?
		receiver = recipient
		sender = from ' Default is null, anonymous.
	EndMethod

	Method SetData(payload:TMessageData)
		data = payload	'optional payload
	EndMethod
	
	Method SendAt( time:Int )
		' When Millisecs() equals this, it's time to send it
		dispatchTime = time
	EndMethod
	
	Method SendIn( delayed:Int )
		' Get the current Millisecs() and add a delay
		dispatchTime = MilliSecs() + delayed
	EndMethod
	
	Method Send()
		If Not receiver Then Throw "Unable to send message to undefined recipient"
		TMessageService.GetInstance().Send(Self)
	End Method
	
	' Used by TMessageManager.Send() to sort the messages
	Method Compare:Int(o:Object)
		If Not TMessage(o) Return - 1
		Return dispatchTime - TMessage(o).dispatchTime
	EndMethod

	Method Broadcast(channel:Int)
		TMessageService.GetInstance().BroadcastMessage(Self, channel)
	End Method
EndType
