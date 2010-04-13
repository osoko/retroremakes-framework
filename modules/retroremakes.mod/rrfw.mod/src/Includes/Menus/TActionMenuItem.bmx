Rem
'
' Copyright (c) 2007-2009 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

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