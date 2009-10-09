rem
	bbdoc: Type description
end rem
Type TRenderable Abstract
	
	Field layer:Int
	Field zDepth:Int
	
	Method Compare:Int(withObject:Object)
		Return zDepth - TRenderable(withObject).zDepth
	End Method
		
	Method GetLayer:Int()
		Return layer
	End Method
	
	Method GetZDepth:Int()
		Return zDepth
	End Method
	
	Method New()
		zDepth = 0
	End Method
	
	Method Render(tweening:Double, fixed:Int = False) Abstract
	
	Method SetLayer(value:Int)
		layer = value
	End Method
	
	Method SetZDepth(value:Int)
		zDepth = value
	End Method

	Method Update() Abstract
	
End Type
