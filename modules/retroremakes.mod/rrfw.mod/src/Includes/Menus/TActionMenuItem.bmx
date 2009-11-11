
'
'an actionmenitem sends a message to CHANNEL_MENU channel
'game managers should listen to this channel

' _action values are defined in TMenuMessageData

Type TActionMenuItem Extends TMenuItem

	Field _action:Int

	Method Update()
	End Method
	
	Method SetAction(action:Int)
		_action = action
	End Method
	
	Method Activate()
		Local message:TMessage = New TMessage
		message.SetMessageID(MSG_MENU)
		Local data:TMenuMessageData = New TMenuMessageData
		message.SetData(data)
		data.action = _action
		message.Broadcast(CHANNEL_MENU)
	End Method

End Type