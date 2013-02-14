Type TAABB2D
	Field _min:TVector2D
	Field _max:TVector2D
	
	Method Copy:TAABB2D()
		Local n:TAABB2D = New TAABB2D
		n._min = _min.Copy()
		n._max = _max.Copy()
		Return n
	End Method
	
End Type
