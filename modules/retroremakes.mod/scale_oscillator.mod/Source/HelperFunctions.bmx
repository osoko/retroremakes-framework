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