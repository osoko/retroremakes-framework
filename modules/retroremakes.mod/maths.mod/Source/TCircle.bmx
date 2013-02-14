rem
	bbdoc: Basic 2D circle primitive with a center and a radius
end rem
Type TCircle
	
	Field c:TVector2D
	Field r:Float
	
	
	Function Create :TCircle (center:TVector2D, radius: Float)
		Local circle :TCircle = New TCircle
		circle.c = center
		circle.r = radius
		Return circle
	End Function
	
	
	Method New()
		c = New TVector2D
		r = 0.0
	End Method

	
	Method Overlaps :Int (circle :TCircle)
		Local radius2 :Float = (r + circle.r) * (r + circle.r)
		Local distance:Float = c.Distance2 (circle.c)
		Return distance < radius2
	End Method
		
End Type
