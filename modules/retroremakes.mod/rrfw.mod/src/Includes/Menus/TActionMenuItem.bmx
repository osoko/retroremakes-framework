
'
'an actionmenitem sends a message to CHANNEL_MENU channel
'game managers should listen to this channel

Type TActionMenuItem Extends TMenuItem

	Field _action:Int

	Method Update()
	End Method
	
	Method SetAction(action:Int)
		_action = action
	End Method
	
	Method Activate()
		Local message:TMessage = New TMessage
		Local data:TMenuMessageData = New TMenuMessageData
		data.action = _action
		message.SetData(data)
		message.SetMessageID(MSG_MENU)
		message.Broadcast(CHANNEL_MENU)
	End Method

End Type