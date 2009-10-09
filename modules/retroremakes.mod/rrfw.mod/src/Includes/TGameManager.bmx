rem
	bbdoc: Type description
end rem
Type TGameManager Extends TRenderable Abstract

	Method MessageListener(message:TMessage) Abstract
	
	Method Render(tweening:Double, fixed:Int = False) Abstract
	
	Method Start() Abstract
	
	Method Stop() Abstract

	Method Update() Abstract
		
End Type
