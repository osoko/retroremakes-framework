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

Const CHANNEL_INPUT:Int = 1000 ' Message channel used to send messages triggered by input devices

Const MSG_CREATE:Int = 1000 ' Create an object
Const MSG_DESTROY:Int = 1001 ' Destroy an object
Const MSG_SHOW:Int = 1002 ' Show an object
Const MSG_HIDE:Int = 1003 ' Hide an object
Const MSG_KEY:Int = 1004 ' Messages sent on a keyboard input event
Const MSG_MOUSE:Int = 1005 ' Messages sent on a mouse input event
Const MSG_JOYSTICK:Int = 1006 ' Messages sent on a joystick input event
Const MSG_VIRTUAL_GAMEPAD:Int = 1007 ' Messages sent on a virtual gamepad input event

rem
	bbdoc: Service for transmitting messages
endrem
Type TMessageService Extends TGameService

	Global instance:TMessageService		' This holds the singleton instance of this Type
	
	Field LMessageQueue:TList = New TList
	Field LChannels:TList = New TList
	
	Field messagesSent:Int
	Field messagesBroadcast:Int
	Field channelsRegistered:Int
		
'#Region Constructors
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		'Make sure we deliver messages before any other services are updated as they may need the messages
		updatePriority = -100
		Self.Initialise()
	EndMethod

	Function Create:TMessageService()
		Return TMessageService.GetInstance()
	End Function
	
	Function GetInstance:TMessageService()
		If Not instance
			Return New TMessageService
		Else
			Return instance
		EndIf
	EndFunction
'#End Region 

	Method Initialise()
		SetName("Message Service")
		Super.Initialise()  'Call TGameService initialisation routines
	End Method

	Method Shutdown()
		TLogger.GetInstance().LogInfo("[" + ToString() + "] " + GetMessageStats())
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method

	Method Send(message:TMessage)
		messagesSent:+1	'some accounting
		LMessageQueue.AddLast(message)
		LMessageQueue.Sort()
	End Method

	Method DeliverMessage(message:TMessage)
		' Send a message to an object 
		
		Local id:TTypeId = TTypeId.ForObject(message.receiver)
		
		' Got an ID, find the method
		Local receiver:TMethod = id.FindMethod("MessageListener")
		If receiver
		
			Local args:TTypeId[] = receiver.ArgTypes()
			
			' One, and only one, argument for the on_message method
			If args.Length <> 1 Then
				rrThrow "Wrong number of arguments for the MessageListener() method!"
			EndIf
			
			' Only a TMessage can be sent to it!
			If args[0].name() <> "TMessage" Then
				rrThrow "MessageListener() should only take a TMessage argument!"
			EndIf
		
			' The object have a valid on_message method, send the message
			receiver.invoke(message.receiver, [message])
		Else
			rrThrow "Recipient has no MessageListener() Method"
		EndIf
		
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
			LMessageQueue.Remove(message)	' Remove message from live queue
			DeliverMessage(message) ' Send it
		Next
		
		' Process channels
		If LChannels.Count() > 0
			For Local channel:TMessageChannel = EachIn LChannels
				channel.Update()
			Next
		EndIf
	End Method
	
	Method GetMessageCount:Int()
		Return LMessageQueue.Count()
	End Method
	
	Method BroadcastMessage(message:TMessage, channelID:Int)
		messagesBroadcast:+1
		For Local channel:TMessageChannel = EachIn LChannels
			If channel.id = channelID
				channel.BroadcastMessage(message)
				Exit
			EndIf
		Next
	End Method
	
	Method CreateMessageChannel(channelID:Int, name:String)
		For Local channel:TMessageChannel = EachIn LChannels
			If channel.id = channelID
				Return 'TODO: Do we want to throw an error?
			End If
		Next
		Local channel:TMessageChannel = New TMessageChannel
		TLogger.getInstance().LogInfo("[" + ToString() + "] Registering channel ~q" + name + "~q with ID: " + channelID)
		channel.id = channelID
		channel.name = name
		LChannels.AddLast(channel)
		channelsRegistered:+1
	End Method
	
	Method DeleteMessageChannel(channelID:Int, name:String)
		For Local channel:TMessageChannel = EachIn LChannels
			If channel.id = channelID
				TLogger.getInstance().LogInfo("[" + ToString() + "] Deleting channel ~q" + name + "~q with ID: " + channelID)
				ListRemove(LChannels, channel)
				channel = Null
				Return
			End If
		Next
	End Method
	
	Method SubscribeToChannel(channelID:Int, listener:Object)
		For Local channel:TMessageChannel = EachIn LChannels
			If channel.id = channelID
				channel.Subscribe(listener)
				Return
			End If
		Next
		'Channel doesn't exist so create it
		CreateMessageChannel(channelID, "[Auto-Generated]")
		SubscribeToChannel(channelID, listener)
	End Method
	
	Method UnsubscribeFromChannel(channelID:Int, listener:Object)
		For Local channel:TMessageChannel = EachIn LChannels
			If channel.id = channelID
				channel.Unsubscribe(listener)
				Return
			End If
		Next		
	End Method
	
	Method UnsubscribeAllChannels(listener:Object)
		For Local channel:TMessageChannel = EachIn LChannels
			channel.Unsubscribe(listener)
		Next
	End Method

	Method GetMessageStats:String()
		Local stats:String
		stats:+"Statistics:  "
		stats:+"Unicast:" + messagesSent + "  "
		stats:+"Broadcast:" + messagesBroadcast + "  "
		stats:+"Channels:" + channelsRegistered
		Return stats
	End Method
EndType

