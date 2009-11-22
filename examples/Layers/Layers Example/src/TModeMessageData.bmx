' This is a simple data payload for sending mode change messages
' to the game manager, the payload basically contains the Id of
' the mode you wish the manager to change to
Type TModeMessageData Extends TMessageData

	' These are the modes
	Const MODE_START_GAME:Int = 0
	Const MODE_HIGH_SCORES:Int = 1
	Const MODE_QUIT:Int = 2
	Const MODE_TITLE_SCREEN:Int = 3
	
	Field modeId:Int
	
End Type
