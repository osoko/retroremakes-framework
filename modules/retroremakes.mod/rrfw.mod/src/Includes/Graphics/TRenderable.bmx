rem
	bbdoc: Type description
end rem
Type TRenderable Abstract
	
	Field zDepth:Int
	
	Method Compare:Int(withObject:Object)
		Return zDepth - TActor(withObject).zDepth
	End Method
		
	Method GetZDepth:Int()
		Return zDepth
	End Method
	
	Method New()
		zDepth = 0
	End Method
	
	Method Render(tweening:Double, fixed:Int = False) Abstract
	
	Method SetZDepth(value:Int)
		zDepth = value
	End Method

	Method Update() Abstract
	
End Type
