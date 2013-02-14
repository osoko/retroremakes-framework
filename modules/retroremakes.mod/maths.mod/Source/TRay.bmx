rem
	bbdoc: Type description
end rem
Type TRay
	Field _origin    :TVector2D
	Field _direction :TVector2D
	
	Function Create:TRay (origin :TVector2D, direction :TVector2D)
		Local ray :TRay = New TRay
		ray._origin    = origin
		ray._direction = direction
		Return ray  
	End Function 
	
	Method GetEndPoint :TVector2D (distance :Float)
		Local vector:TVector2D = _origin.Copy().AddV (_direction.Copy().MulF (distance))
		Return vector
	End Method
	
	
End Type
