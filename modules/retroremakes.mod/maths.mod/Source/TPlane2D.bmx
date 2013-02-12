rem
'
' Copyright (c) 2007-2013 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem
rem
	bbdoc: A plane defined via a unit length normal and the distance from the origin
end rem
Type TPlane2D

	Field _distance :Float	
	Field _normal   :TVector2D
	
	
	rem
		bbdoc: Create a new plane from a TVector2D normal and a point on the plane
		returns: TPlane2D
	endrem	
	Function Create :TPlane2D (normal :TVector2D, point :TVector2D)
		Local plane :TPlane2D = New TPlane2D

		plane._normal.SetV (normal).Normalise()
		plane._distance = -plane._normal.Dot (point)
		
		Return plane
	End Function
	
	
	
	rem
		bbdoc: Returns the side which the specified point lies relative to the planes normal
		about: TPlaneSide.FRONT is the side the plane's normal points to
		returns: Int
	endrem		
	Method CheckSide :Int (point :TVector2D)
		Local pointDistance :Float = Distance (point)
		
		If pointDistance = 0
			Return TPlaneSide.ON_PLANE
		ElseIf pointDistance < 0
			Return TPlaneSide.BACK
		Else
			Return TPlaneSide.FRONT
		EndIf
	End Method
	
	
	rem
		bbdoc: Calculates the shortest distance between the specified point and the plane
		returns: Float
	endrem	
	Method Distance :Float (point :TVector2D)
		Return _normal.Dot (point) + _distance
	End Method
	
	
	rem
		bbdoc: Returns whether the plane is facing the specified direction vector
		returns: Int
	endrem		
	Method IsFacing :Int (direction :TVector2D) 
		Local dot :Float = _normal.Dot (direction)
		Return dot <= 0 
	End Method
	
	
	Method New()
		_normal   = New TVector2D
		_distance = 0.0
	End Method
	
End Type
