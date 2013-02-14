
Function IntersectMovingCircleAABB:Int (circle:TCircle, direction:TVector2D, box:TAABB2D, t:Float Var)
	
	' Compute AABB resulting from expanding b by the radius of the circle
	Local expandedBB:TAABB2D = box.Copy()
	expandedBB._min.x :- circle.r
	expandedBB._min.y :- circle.r
	expandedBB._max.x :+ circle.r
	expandedBB._max.y :+ circle.r
	
	Local p:TVector2D = New TVector2D
	If (Not IntersectRayAABB (circle.c, direction, expandedBB, t, p)) Or (t > 1.0) Then Return 0
	
End Function


Function IntersectRayAABB (point:TVector2D, direction:TVector2D, box:TAABB2D, tmin:Float Var, q:TVector2D Var)
	tmin = 0.0
	Local tmax:Float = 1.e+38
	
	
End Function