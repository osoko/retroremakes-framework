rem
	bbdoc: WIP: Sprite implemented using polygons
	aboout: TODO: Complete implementation
endrem
Type TPolygonActor Extends TActor

	Field vertices:Float[]
	
	Method Render(tweening:Double, fixed:int)
		Interpolate(tweening)
	End Method

End Type
