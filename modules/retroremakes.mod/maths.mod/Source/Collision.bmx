
Function CircleToPolygon :Int (circle :TCircle, vertices:TVector2D[])
	Assert (vertices.Length >= 3)
	
	If PointInPolygon (circle._center, vertices) Then Return True

	Local v1 :TVector2D = vertices[vertices.Length - 1]
	
	For Local v2 :TVector2D = EachIn vertices
		If LineToCircle (v1, v2, circle) Then Return True
		v1 = v2
	Next

	Return False	
End Function


Function GetQuad :Int (axis :TVector2D, v: TVector2d)
	If v.x < axis.x
		If v.y < axis.y
			Return 1
		Else
			Return 4
		EndIf
	Else
		If v.y < axis.y
			Return 2
		Else
			Return 3
		EndIf
	EndIf
End Function


Function LineToCircle :Int (v1 :TVector2D, v2: TVector2D, circle: TCircle)
	Local f1 :Float = (circle._center.x - v1.x) * (v2.x - v1.x)
	Local f2 :Float = (circle._center.y - v1.y) * (v2.y - v1.y)
	Local q :Float = (f1 + f2) / v2.Distance2 (v1)
	
	If q < 0.0 Then q = 0.0
	If q > 1.0 Then q = 1.0
	
	Local cx :Float = (1.0 - q) * v1.x + q * v2.x
	Local cy :Float = (1.0 - q) * v1.y + q * v2.y
	
	Local dx :Float = circle._center.x - cx
	Local dy :Float = circle._center.y - cy
	
	If (dx * dx + dy * dy) < (circle._radius * circle._radius)
		Return True
	Else
		Return False
	EndIf
End Function


Function PointInPolygon :Int (point :TVector2D, vertices :TVector2D[])
	Assert (vertices.Length >= 3)
	
	Local v1 :TVector2D = vertices[vertices.Length - 1]
	Local currentQuad :Int = GetQuad (point, v1) 
	Local nextQuad :Int
	Local total :Int
	
	For Local v2: TVector2D = EachIn vertices
		nextQuad = GetQuad (point, v2)
		Local diff :Int = nextQuad - currentQuad
		
		Select diff
			Case 2, -2
				If (v2.x - (((v2.y - point.y) * (v1.x - v2.x)) / (v1.y - v2.y))) < point.x
					diff = -diff
				EndIf
			Case 3
				diff = -1
			Case -3
				diff = 1
		End Select
		
		total :+ diff
		currentQuad = nextQuad
		v1 = v2
	Next
	
	Return (Abs (total) = 4)
End Function


Function LinesIntersect (