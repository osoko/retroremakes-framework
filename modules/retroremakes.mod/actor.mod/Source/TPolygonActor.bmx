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

	Field vertices:Float[]
	
	Method Render(tweening:Double, fixed:int)
		Interpolate(tweening)
	End Method

End Type
