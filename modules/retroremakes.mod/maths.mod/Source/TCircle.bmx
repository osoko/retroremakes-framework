rem
	bbdoc: Basic 2D circle primitive with a center and a radius
end rem
Type TCircle
	
	Field _center :TVector2D
	Field _radius :Float
	
	
	Method Create :TCircle (center :TVector2D, radius: Float)
		Local circle :TCircle = New TCircle
		circle._center = center
		circle._radius = radius
		Return circle
	End Method
	
	
	Method New()
		_center = New TVector2D
		_radius = 0.0
	End Method

	
	Method Overlaps :Int (circle :TCircle)
		Local radius2 :Float = (_radius + circle._radius) * (_radius + circle._radius)
		Return _center.Distance2 (circle._center) < radius2
	End Method
		
End Type
