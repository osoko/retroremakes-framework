Rem
	bbdoc: Message data that contains the current state of a mouse.
End Rem
Type TMouseMessageData Extends TMessageData
	Field mousePosX:Int
	Field mousePosY:Int
	Field mousePosZ:Int

	Field lastMousePosX:Int
	Field lastMousePosY:Int
	Field lastMousePosZ:Int
		
	Field mouseHits:Int[4]
	Field mouseStates:Int[4]
End Type
