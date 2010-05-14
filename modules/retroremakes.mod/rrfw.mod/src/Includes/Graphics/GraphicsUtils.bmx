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

' Various Graphical Helper Functions

Rem
bbdoc:Draws a polygon at the specified coordinates.
returns:
EndRem
Function rrDrawPoly(xy:Float[], x:Float = 0, y:Float = 0, fill:Int = True)

	Local origin_x:Float
	Local origin_y:Float
	GetOrigin origin_x, origin_y
	Local handle_x:Float
	Local handle_y:Float
	GetHandle handle_x, handle_y
	
	If fill
		_max2dDriver.DrawPoly xy,  ..
			- handle_x, - handle_y,  ..
			x + origin_x, y + origin_y
	Else
		Local x1:Float = xy[xy.Length - 2]
		Local y1:Float = xy[xy.Length - 1]
		For Local i:Int = 0 Until Len xy Step 2
			Local x2:Float = xy[i]
			Local y2:Float = xy[i + 1]
			_max2dDriver.DrawLine ..
			- handle_x + x1, - handle_y + y1,  ..
			- handle_x + x2, - handle_y + y2,  ..
			x + origin_x - 0.5, y + origin_y - 0.5
			x1 = x2
			y1 = y2
		Next
	EndIf
End Function