' This is the type we will use to derive our game screens from.
' These screens will set up and control different modes of the
' game, such as "Title Screen", "High-Score Table", "Gameplay", etc.
Type TScreenBase Extends TRenderable Abstract

	Field theLayerManager:TLayerManager
	
	' Here we send a message to the game manager to say we're finished
	Method Finished()
		Local message:TMessage = New TMessage
		message.sender = Self
		message.messageId = MSG_SCREEN_FINISHED
		
		message.Broadcast(GAME_MANAGER_CHANNEL)
	End Method
		
	Method MessageListener(message:TMessage) Abstract

	Method New()
		theLayerManager = TLayerManager.GetInstance()
	End Method
	
	Method Render(tweening:Double, fixed:Int = False) Abstract

	Method Start() Abstract
		
	Method Stop() Abstract
	
	Method Update() Abstract
	
End Type