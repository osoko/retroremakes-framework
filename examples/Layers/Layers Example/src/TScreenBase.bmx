' This is the type we will use to derive our game screens from.
' These screens will set up and control different modes of the
' game, such as "Title Screen", "High-Score Table", "Gameplay", etc.
Type TScreenBase Extends TRenderable Abstract

	Method Render(tweening:Double, fixed:Int = False) Abstract

	Method Start() Abstract
		
	Method Stop() Abstract
	
	Method Update() Abstract

	Method MessageListener(message:TMessage) Abstract
	
End Type