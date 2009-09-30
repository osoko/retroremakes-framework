' Various Graphical Helper Functions

rem
bbdoc: Create a packed 32bit RGBA colour value
about:
Takes @red, @green, @blue and @alpha values which should be in the range of 0 to 255
endrem
Function rrMakeRGBA:Int(red:Int, green:Int, blue:Int, alpha:Int)
	Return (red Shl 24 | (green & $ff) Shl 16 | (blue & $ff) Shl 8 | (alpha & $ff))
EndFunction

rem
bbdoc: Unpack a packed 32bit RGBA colour value
about:
Sets the provided @red, @green, @blue and @alpha variables to the values in the 32bit RGBA colour value
endrem
Function rrUnpackRGBA(packedColour:Int Var, red:Int Var, green:Int Var, blue:Int Var, alpha:Float Var)
	red = (packedColour Shr 24) & $ff
	green = (packedColour Shr 16) & $ff
	blue = (packedColour Shr 8) & $ff
	alpha = Float((packedColour) & $ff) / 255.0
EndFunction

rem
bbdoc: Sets the Colour and Alpha values to those in a 32bit RGBA colour value
about:
Sets the Colour and Alpha values to those unpacked from a 32bit RGBA colour value
endrem
Function rrSetRGBA(packedColour:Int)
	Local red:Int
	Local green:Int
	Local blue:Int
	Local alpha:Float
	
	rrUnpackRGBA(packedColour, red, green, blue, alpha)

	SetColor red, green, blue
	SetAlpha alpha
EndFunction

rem
bbdoc: Create a packed 16bit Scale value
about:
Takes @x and @y values which should be in the range of 0 to 255
endrem
Function rrMakePackedScaler:Short(x:Int, y:Int)
	Return ((x Shl 8) | (y))
End Function

rem
bbdoc: Unpack a packed 16bit Scale value
about:
Sets the provided @x and @y variables to those unpacked from a 16bit Scale value
endrem
Function rrUnpackScaler(packedScale:Short, x:Float Var, y:Float Var)
	y = Float((packedScale & 255)) / 128.0
	x = Float(((packedScale Shr 8) & 255)) / 128.0
End Function

rem
bbdoc: Sets the scale to a packed 16bit Scale value
about:
Sets the @x and @y values to those unpacked from a 16bit Scale value
endrem
Function rrSetScaler(packedScale:Short)
	Local x:Float
	Local y:Float
	rrUnpackScaler(packedScale, x, y)
	SetScale x, y
End Function

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