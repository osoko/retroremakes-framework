rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

rem
'
' This code is based on work originally written by Dave 'Oddball' Williamson.
'
endrem

Rem
bbdoc: Checks For collisions between two transformed polygons
returns: True If a collision occured
EndRem
Function rrTFormPolyToTFormPoly:Int(p1_xy:Float[], p1_x:Float = 0, p1_y:Float = 0,  ..
	p1_rot:Float = 0, p1_scale_x:Float = 1, p1_scale_y:Float = 1,  ..
	p1_handle_x:Float = 0, p1_handle_y:Float = 0,  ..
	p1_origin_x:Float = 0, p1_origin_y:Float = 0,  ..
	p2_xy:Float[], p2_x:Float = 0, p2_y:Float = 0,  ..
	p2_rot:Float = 0, p2_scale_x:Float = 1, p2_scale_y:Float = 1,  ..
	p2_handle_x:Float = 0, p2_handle_y:Float = 0,  ..
	p2_origin_x:Float = 0, p2_origin_y:Float = 0)
	
	If p1_xy.Length < 6 Or (p1_xy.Length & 1) Return False
	If p2_xy.Length < 6 Or (p2_xy.Length & 1) Return False
	
	Local tform1_xy:Float[] = rrTFormPoly(p1_xy, p1_x, p1_y, p1_rot, p1_scale_x, p1_scale_y,  ..
		p1_handle_x, p1_handle_y, p1_origin_x, p1_origin_y)
	
	Local tform2_xy:Float[] = rrTFormPoly(p2_xy, p2_x, p2_y, p2_rot, p2_scale_x, p2_scale_y,  ..
		p2_handle_x, p2_handle_y, p2_origin_x, p2_origin_y)
	
	If rrPolyToPoly(tform1_xy, tform2_xy)
		Return True
	Else
		Return False
	EndIf
	
End Function


Rem
bbdoc: Checks for collisions between a standard polygon and a transformed polygon
returns: True if a collision occured
EndRem
Function rrPolyToTFormPoly:Int(p1_xy:Float[], p2_xy:Float[],  ..
	p2_x:Float = 0, p2_y:Float = 0, rot:Float = 0,  ..
	scale_x:Float = 1, scale_y:Float = 1,  ..
	handle_x:Float = 0, handle_y:Float = 0,  ..
	origin_x:Float = 0, origin_y:Float = 0)
	
	If p1_xy.Length < 6 Or (p1_xy.Length & 1) Return False
	If p2_xy.Length < 6 Or (p2_xy.Length & 1) Return False
	
	Local tform_xy:Float[] = rrTFormPoly(p2_xy, p2_x, p2_y, rot, scale_x, scale_y,  ..
		handle_x, handle_y, origin_x, origin_y)
	
	If rrPolyToPoly(p1_xy, tform_xy)
		Return True
	Else
		Return False
	EndIf
	
End Function


Rem
bbdoc: Checks for collisions between two standard polygons
returns: True if a collision occured
EndRem
Function rrPolyToPoly:Int(p1_xy:Float[], p2_xy:Float[])
	
	If p1_xy.Length < 6 Or (p1_xy.Length & 1) Return False
	If p2_xy.Length < 6 Or (p2_xy.Length & 1) Return False
	
	For Local i:Int = 0 Until p1_xy.Length Step 2
		If rrPointInPoly(p1_xy[i], p1_xy[i + 1], p2_xy) Then Return True
	Next
	For Local i:Int = 0 Until p2_xy.Length Step 2
		If rrPointInPoly(p2_xy[i], p2_xy[i + 1], p1_xy) Then Return True
	Next
	
	Local l1_x1:Float = p1_xy[p1_xy.Length - 2]
	Local l1_y1:Float = p1_xy[p1_xy.Length - 1]
	For Local i1:Int = 0 Until p1_xy.Length Step 2
		Local l1_x2:Float = p1_xy[i1]
		Local l1_y2:Float = p1_xy[i1 + 1]
		
		Local l2_x1:Float = p2_xy[p2_xy.Length - 2]
		Local l2_y1:Float = p2_xy[p2_xy.Length - 1]
		For Local i2:Int = 0 Until p2_xy.Length Step 2
			Local l2_x2:Float = p2_xy[i2]
			Local l2_y2:Float = p2_xy[i2 + 1]
			
			If rrLinesCross(l1_x1, l1_y1, l1_x2, l1_y2, l2_x1, l2_y1, l2_x2, l2_y2)
				Return True
			EndIf
			
			l2_x1 = l2_x2
			l2_y1 = l2_y2
		Next
		l1_x1 = l1_x2
		l1_y1 = l1_y2
	Next
	Return False
End Function


Rem
bbdoc: Checks for collisions between a circle and a transformed polygon
returns: True if a collision occured
EndRem
Function rrCircleToTFormPoly:Int(circle_x:Float, circle_y:Float, radius:Float,  ..
	xy:Float[], poly_x:Float = 0, poly_y:Float = 0, rot:Float = 0,  ..
	scale_x:Float = 1, scale_y:Float = 1,  ..
	handle_x:Float = 0, handle_y:Float = 0,  ..
	origin_x:Float = 0, origin_y:Float = 0)
	
	If xy.Length < 6 Or (xy.Length & 1) Return False
	
	Local tform_xy:Float[] = rrTFormPoly(xy, poly_x, poly_y, rot, scale_x, scale_y,  ..
		handle_x, handle_y, origin_x, origin_y)
	
	Return rrCircleToPoly(circle_x, circle_y, radius, tform_xy)
End Function


Rem
bbdoc: Checks for collisions between a circle and a standard polygon
returns: True if a collision occured
EndRem
Function rrCircleToPoly:Int(circle_x:Float, circle_y:Float, radius:Float, xy:Float[])
	
	If xy.Length < 6 Or (xy.Length & 1) Return False
	
	If rrPointInPoly(circle_x, circle_y, xy) Then Return True
	
	Local x1:Float = xy[xy.Length - 2]
	Local y1:Float = xy[xy.Length - 1]
	
	For Local i:Int = 0 Until Len xy Step 2
		Local x2:Float = xy[i]
		Local y2:Float = xy[i + 1]
		
		If rrLineToCircle(x1, y1, x2, y2, circle_x, circle_y, radius) Then Return True
		x1 = x2
		y1 = y2
	Next
	
	Return False
End Function


Rem
bbdoc: Checks for collisions between a line and a transformed polygon
returns: True if a collision occured
EndRem
Function rrLineToTFormPoly:Int(line_x1:Float, line_y1:Float, line_x2:Float, line_y2:Float,  ..
	xy:Float[], poly_x:Float = 0, poly_y:Float = 0,  ..
	rot:Float = 0, scale_x:Float = 1, scale_y:Float = 1,  ..
	handle_x:Float = 0, handle_y:Float = 0,  ..
	origin_x:Float = 0, origin_y:Float = 0,  ..
	checkInside:Int = True)
	
	If xy.Length < 6 Or (xy.Length & 1) Return False
	
	rrTFormGlobalToLocal(line_x1, line_y1, poly_x, poly_y, rot, scale_x,  ..
		scale_y, handle_x, handle_y, origin_x, origin_y)
	
	rrTFormGlobalToLocal(line_x2, line_y2, poly_x, poly_y, rot, scale_x,  ..
		scale_y, handle_x, handle_y, origin_x, origin_y)
	
	Return rrLineToPoly(line_x1, line_y1, line_x2, line_y2, xy, checkInside)
End Function

Rem
bbdoc: Checks for collisions between a line and a normal polygon
returns: True if a collision occured
EndRem
Function rrLineToPoly:Int(line_x1:Float, line_y1:Float, line_x2:Float, line_y2:Float, xy:Float[], checkInside:Int = True)
	
	If xy.Length < 6 Or (xy.Length & 1) Return False
	
	If checkInside
		If rrPointInPoly(line_x1, line_y1, xy) Then Return True
	EndIf
	
	Local poly_x1:Float = xy[xy.Length - 2]
	Local poly_y1:Float = xy[xy.Length - 1]
	
	For Local i:Int = 0 Until Len xy Step 2
		Local poly_x2:Float = xy[i]
		Local poly_y2:Float = xy[i + 1]
		
		If rrLinesCross(line_x1, line_y1, line_x2, line_y2,  ..
			poly_x1, poly_y1, poly_x2, poly_y2) Then Return True
		poly_x1 = poly_x2
		poly_y1 = poly_y2
	Next
	
	Return False
	
End Function


Rem
bbdoc: Checks if the given point is in a transformed polygon
returns: True if a collision occured
EndRem
Function rrPointInTFormPoly:Int(POINT_X:Float, POINT_Y:Float, xy:Float[],  ..
	poly_x:Float = 0, poly_y:Float = 0, rot:Float = 0,  ..
	scale_x:Float = 1, scale_y:Float = 1,  ..
	handle_x:Float = 0, handle_y:Float = 0,  ..
	origin_x:Float = 0, origin_y:Float = 0)
	
	If xy.Length < 6 Or (xy.Length & 1) Return False
	
	rrTFormGlobalToLocal(POINT_X, POINT_Y, poly_x, poly_y, rot, scale_x,  ..
		scale_y, handle_x, handle_y, origin_x, origin_y)
	
	Return rrPointInPoly(POINT_X, POINT_Y, xy)
End Function


Rem
bbdoc: Checks If the given point is in a normal polygon
returns: True If a collision occured
EndRem
Function rrPointInPoly:Int(POINT_X:Float, POINT_Y:Float, xy:Float[])
	
	If xy.Length < 6 Or (xy.Length & 1) Return False
	
	Local x1:Float = xy[xy.Length - 2]
	Local y1:Float = xy[xy.Length - 1]
	Local cur_quad:Int = rrGetQuad(POINT_X, POINT_Y, x1, y1)
	Local next_quad:Int
	Local total:Int
	
	For Local i:Int = 0 Until Len xy Step 2
		Local x2:Float = xy[i]
		Local y2:Float = xy[i + 1]
		next_quad = rrGetQuad(POINT_X, POINT_Y, x2, y2)
		Local diff:Int = next_quad - cur_quad
		
		Select diff
			Case 2, - 2
				If (x2 - (((y2 - POINT_Y) * (x1 - x2)) / (y1 - y2))) < POINT_X
					diff = -diff
				EndIf
			Case 3
				diff = -1
			Case - 3
				diff = 1
		End Select
		
		total:+diff
		cur_quad = next_quad
		x1 = x2
		y1 = y2
	Next
	
	If Abs(total) = 4 Then Return True Else Return False
End Function


Rem
bbdoc:Returns a transformed polygon from a standard polygon
returns:A Float array containing the transformed polygon
EndRem
Function rrTFormPoly:Float[] (xy:Float[], tform_x:Float = 0, tform_y:Float = 0, rot:Float = 0,  ..
	scale_x:Float = 1, scale_y:Float = 1,  ..
	handle_x:Float = 0, handle_y:Float = 0,  ..
	origin_x:Float = 0, origin_y:Float = 0)
	
	If xy.Length < 6 Or (xy.Length & 1) Return Null
	
	Local tform_xy:Float[] = xy[..]
	
	For Local i:Int = 0 Until tform_xy.Length Step 2
		rrTFormLocalToGlobal(tform_xy[i], tform_xy[i + 1], tform_x, tform_y, rot,  ..
			scale_x, scale_y, handle_x, handle_y, origin_x, origin_y)
	Next
	

	Return tform_xy
End Function

Rem
bbdoc:Transforms a point from Global / screen coordinates To Local / polygon / image coordinates.
returns:
EndRem
Function rrTFormGlobalToLocal(POINT_X:Float Var, POINT_Y:Float Var,  ..
	tform_x:Float = 0, tform_y:Float = 0, rot:Float = 0,  ..
	scale_x:Float = 1, scale_y:Float = 1,  ..
	handle_x:Float = 0, handle_y:Float = 0,  ..
	origin_x:Float = 0, origin_y:Float = 0)
		
	POINT_X:-origin_x
	POINT_Y:-origin_y
	
	POINT_X:-tform_x
	POINT_Y:-tform_y
	
	Local mag:Float = Sqr(POINT_X * POINT_X + POINT_Y * POINT_Y)
	Local ang:Float = ATan2(POINT_Y, POINT_X)
	POINT_X = Cos(ang - rot) * mag
	POINT_Y = Sin(ang - rot) * mag
	
	POINT_X:/scale_x
	POINT_Y:/scale_y
	
	POINT_X:+handle_x
	POINT_Y:+handle_y
End Function

Rem
bbdoc:Transforms a point from Local / polygon / image coordinates To Global / screen coordinates.
returns:
EndRem
Function rrTFormLocalToGlobal(POINT_X:Float Var, POINT_Y:Float Var,  ..
	tform_x:Float = 0, tform_y:Float = 0, rot:Float = 0,  ..
	scale_x:Float = 1, scale_y:Float = 1,  ..
	handle_x:Float = 0, handle_y:Float = 0,  ..
	origin_x:Float = 0, origin_y:Float = 0)
	
	POINT_X:-handle_x
	POINT_Y:-handle_y
	
	POINT_X:*scale_x
	POINT_Y:*scale_y
	
	Local mag:Float = Sqr(POINT_X * POINT_X + POINT_Y * POINT_Y)
	Local ang:Float = ATan2(POINT_Y, POINT_X)
	POINT_X = Cos(ang + rot) * mag
	POINT_Y = Sin(ang + rot) * mag
	
	POINT_X:+tform_x
	POINT_Y:+tform_y
	
	POINT_X:+origin_x
	POINT_Y:+origin_y
End Function

'Adapted from Fredborg's code
Rem
bbdoc:Checks If two lines intersect.
returns True If lines intersect
EndRem
Function rrLinesCross:Int(x0:Float, y0:Float, x1:Float, y1:Float,  ..
	x2:Float, y2:Float, x3:Float, y3:Float)
	  
	Local n:Float = (y0 - y2) * (x3 - x2) - (x0 - x2) * (y3 - y2)
	Local d:Float = (x1 - x0) * (y3 - y2) - (y1 - y0) * (x3 - x2)
	
	If Abs(d) < 0.0001
		' Lines are parallel!
		Return False
	Else
		' Lines might cross!
		Local Sn:Float = (y0 - y2) * (x1 - x0) - (x0 - x2) * (y1 - y0)

		Local AB:Float = n / d
		If AB > 0.0 And AB < 1.0
			Local CD:Float = Sn / d
			If CD > 0.0 And CD < 1.0
				' Intersection Point
				Local X:Float = x0 + AB * (x1 - x0)
				Local Y:Float = y0 + AB * (y1 - y0)
				Return True
			End If
		End If
	
		' Lines didn't cross, because the intersection was beyond the End points of the lines
	EndIf

	' Lines do Not cross!
	Return False

End Function

'Adapted from TomToad's code
Rem
bbdoc:Checks For collision between a line And a circle.
returns:True If a collision has occured
EndRem
Function rrLineToCircle:Int(x1:Float, y1:Float, x2:Float, y2:Float, px:Float, py:Float, r:Float)
	
	Local sx:Float = x2 - x1
	Local sy:Float = y2 - y1
	
	Local q:Float = ((px - x1) * (x2 - x1) + (py - y1) * (y2 - y1)) / (sx * sx + sy * sy)
	
	If q < 0.0 Then q = 0.0
	If q > 1.0 Then q = 1.0
	
	Local cx:Float = (1 - q) * x1 + q * x2
	Local cy:Float = (1 - q) * y1 + q * y2
	
	Local dx:Float = px - cx
	Local dy:Float = py - cy
	
	If (dx * dx + dy * dy) < (r * r)
		
		Return True
		
	Else
		
		Return False
		
	EndIf

	
End Function


Rem
bbdoc:Calculate the Distance between two points
returns:The Distance between the two points as a Float
EndRem
Function rrPointToPointDist:Float(x1:Float, y1:Float, x2:Float, y2:Float)

	Local dx:Float = x1 - x2
	Local dy:Float = y1 - y2
	
	Return Sqr(dx * dx + dy * dy)
End Function


Function rrGetQuad:Int(axis_x:Float, axis_y:Float, vert_x:Float, vert_y:Float)
	If vert_x < axis_x
		If vert_y < axis_y
			Return 1
		Else
			Return 4
		EndIf
	Else
		If vert_y < axis_y
			Return 2
		Else
			Return 3
		EndIf
	EndIf

End Function




