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

'Based on the Pub.Color module by Mikkel Fredborg

rem
bbdoc: Base class for colour formats.
about: Base class extended by the #TColourHSV and #TColourRGB colour classes.
endrem
Type TColour
	
	rem
	bbdoc: Convert the colour to a packed ARGB Int
	returns: packed ARGB Int
	endrem
	Method toArgb:Int() Abstract
		
End Type