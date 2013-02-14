Function GetMessageCount:Int()
	Return TMessageService.GetInstance().GetMessageCount()
End Function

Function SubscribeToChannel(channel:Int, listener:Object)
	TMessageService.GetInstance().SubscribeToChannel(channel, listener)
End Function

Function UnsubscribeFromChannel(channel:Int, listener:Object)
	TMessageService.GetInstance().UnsubscribeFromChannel(channel, listener)
End Function

Function UnsubscribeAllChannels(listener:Object)
	TMessageService.GetInstance().UnsubscribeAllChannels(listener)
End Function

Function CreateMessageChannel(channel:Int, name:String)
	TMessageService.GetInstance().CreateMessageChannel(channel, name)
End Function

Function DeleteMessageChannel(channel:Int, name:String)
	TMessageService.GetInstance().DeleteMessageChannel(channel, name)
End Function