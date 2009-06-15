Rem
	bbdoc: #TKeyboardMessageData
	about: The #TKeyboardMessageData object is used by the #TKeyboard input device handler
	to pass messages about keystate changes via the #TMessageService Service
End Rem
Type TKeyboardMessageData Extends TMessageData
	
	rem
	bbdoc: The ASCII number of the @key that this message is related to
	endrem
	Field key:Int

	rem
	bbdoc: The current state of the @key.  True if the @key is currently down
	endrem
	Field keyState:Int

	rem
	bbdoc: The number of the times @key has been hit since the last update
	endrem
	Field keyHits:Int
End Type