rem
	bbdoc: WIP: Sprite implemented using polygons
	aboout: TODO: Complete implementation
endrem
Type TPolygonSprite Extends TSprite

	Field vertices:Float[]
	
	Method Render(tweening:Double, fixed:int)
		Interpolate(tweening)
	End Method

End Type
