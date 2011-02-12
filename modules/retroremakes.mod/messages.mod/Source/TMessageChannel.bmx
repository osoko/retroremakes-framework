rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Rem
	bbdoc: A channel that can be used to broadcast #TMessage instances
End Rem
Type TMessageChannel
	
	Field id:Int
	Field name:String
	
	Field LListeners:TList = New TList
	Field LMessageQueue:TList = New TList

	Method Subscribe(receiver:Object)
		Local listener:TMessageListener
		For listener = EachIn LListeners
			If listener.receiver = receiver Then Return	' object is already subscribed
		Next
		listener = TMessageListener.Create(receiver)
		listener.channelLink = LListeners.AddLast(listener)
	End Method
	
	Method Update()
		' We process a copy of the message queue, as message recipients
		' might add further messages to the list and we don't want to
		' process those until the next update to avoid race conditions
		Local LMessageQueueCopy:TList = LMessageQueue.Copy()
			
		For Local message:TMessage = EachIn LMessageQueueCopy
			If message.dispatchTime > MilliSecs()
				' The message queue is sorted, so we know there are no
				' further messages that need processing			
				Exit
			EndIf
			LMessageQueue.Remove(message) ' Remove message from live queue
			DeliverMessage(message) ' Send it
		Next
	End Method
	
	Method Unsubscribe(receiver:Object)
		For Local listener:TMessageListener = EachIn LListeners
			If listener.receiver = receiver
				RemoveLink(listener.channelLink)
				listener = Null
				Exit
			End If
		Next
	End Method
	
	Method BroadcastMessage(message:TMessage)
		LMessageQueue.AddLast(message)
		LMessageQueue.Sort()
	End Method
	
	Method DeliverMessage(message:TMessage)
		For Local listener:TMessageListener = EachIn LListeners
			listener.DeliverMessage(message)
		Next		
	End Method
		
End Type
