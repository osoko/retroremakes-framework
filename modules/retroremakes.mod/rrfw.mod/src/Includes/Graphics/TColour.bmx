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