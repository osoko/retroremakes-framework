rem
	bbdoc: Type description
end rem
Type TGameplayScreen Extends TScreenBase

	Field player:TPlayer
	Field scoreDisplay:TFontActor
	
	Method HandleKeyboardMessage(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		Select data.key
			Case KEY_ENTER
				If data.keyHits Then GoBackToTitleScreen()
		End Select
	End Method
	
	Method MessageListener(message:TMessage)
		Select message.messageId
			Case MSG_KEY
				HandleKeyboardMessage(message)
		End Select
	End Method

	Method New()
		player = New TPlayer
		scoreDisplay = New TFontActor
		scoreDisplay.SetMidHandle(True)
		scoreDisplay.SetPosition(TProjectionMatrix.GetInstance().GetWidth() / 2.0, 30)
		scoreDisplay.SetFont(rrGetResourceImageFont("resources/ArcadeClassic.ttf", 36))
	End Method
	
	Method Start()
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
		theLayerManager.AddRenderableToLayerByName(player, "front")
		theLayerManager.AddRenderableToLayerByName(scoreDisplay, "front")
		player.Reset()
	End Method
	
	Method Stop()
		TMessageService.GetInstance().UnsubscribeAllChannels(Self)
		theLayerManager.RemoveRenderable(player)
		theLayerManager.RemoveRenderable(scoreDisplay)
	End Method

	Method Update()
		scoreDisplay.SetText(player.score.GetDisplayScore())
		If Rand(1, 10) = 1
			player.score.Add(20)
		End If
	End Method
	
End Type
