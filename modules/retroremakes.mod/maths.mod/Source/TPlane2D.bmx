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
Type TPlane2D

	Field distance :Float	
	Field normal   :TVector2D
	
	Function Create:TPlane2D (normal :TVector2D, distance :Float = 0.0)
		Local plane :TPlane2D = New TPlane2D

		plane.distance = distance		
		plane.normal   = normal.Copy()
		
		Return plane
	End Function
	
End Type
