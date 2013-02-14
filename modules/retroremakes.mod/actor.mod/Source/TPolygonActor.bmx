rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

rem
	bbdoc: WIP: Actor implemented using polygons
	about: TODO: Complete implementation
endrem
Type TPolygonActor Extends TActor

	Field vertices:TVector2D[]
	
	Method Render(tweening:Double, fixed:Int)
		Interpolate(tweening)
	End Method
	
	Method SetVertices (vertices:TVector2D[])
		Local numVertices:Int = vertices.Length
		Assert (numVertices >= 3), "Not enough vertices provided (" + numVertices + ")"
		Self.vertices = New TVector2D[numVertices] 
		For Local i:Int = 0 Until numVertices
			Self.vertices[i] = vertices[i].Copy() 
		Next
	End Method

End Type
