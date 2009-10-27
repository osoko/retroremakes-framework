' This is the type we will use to derive our game screens from.
' These screens will set up and control different modes of the
' game, such as "Title Screen", "High-Score Table", "Gameplay", etc.
Type TScreenBase Extends TRenderable Abstract

	Field theLayerManager:TLayerManager
	
	
	
	' This method sends a message to the game manager to say we're finished.
	' Until it receives this message the game manager won't remove the
	' screen from the render layer it is assigned to. This means that
	' even if a new screen has been activated we can still do some updates
	' such as fades, wipes, animations, etc.
	Method Finished()
		Local message:TMessage = New TMessage
		message.sender = Self
		message.messageId = MSG_SCREEN_FINISHED
		
		message.Broadcast(GAME_MANAGER_CHANNEL)
	End Method
	
	
	
	' This method tells the game manager to change to the Title Screen
	' mode, and has been added here as more than one child of TScreenBase
	' needs to do this, so having it here avoids code duplication (and extra
	' typing)	
	Method GoBackToTitleScreen()
		Local message:TMessage = New TMessage
		message.SetMessageId(MSG_CHANGE_MODE)
		
		Local data:TModeMessageData = New TModeMessageData
		data.modeId = TModeMessageData.MODE_TITLE_SCREEN
		
		message.SetData(data)
		message.Broadcast(GAME_MANAGER_CHANNEL)
	End Method
	
	
	
	' We want to make sure that all children of TScreenBase implement
	' their own message handling, so we make this method abstract	
	Method MessageListener(message:TMessage) Abstract

	
	
	' Default constructor
	Method New()
		' The layer manager will be frequently accessed, so here's a
		' shortcut to it
		theLayerManager = TLayerManager.GetInstance()
	End Method

	
	
	' As TScreenBase is derived from a TRenderable object, we need to
	' implement a Render method.  It's unlikely we'll need this though
	' so we'll just leave it as an empty method that our children can
	' override should they need to.
	Method Render(tweening:Double, fixed:Int = False)
	End Method

	
	
	' All children need to implement this method as the game manager will
	' call it to tell the screen that it needs to start
	Method Start() Abstract

	
	
	' All children need to implement this method as the game manager will
	' call it to tell the screen that it needs to stop
	Method Stop() Abstract

	
	
	' As TScreenBase is derived from a TRenderable object, we need to
	' implement an Update method.  It's unlikely we'll need this though
	' so we'll just leave it as an empty method that our children can
	' override should they need to.
	Method Update()
	End Method
	
End Type