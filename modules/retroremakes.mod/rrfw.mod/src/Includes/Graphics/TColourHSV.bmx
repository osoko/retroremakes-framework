Rem
bbdoc: Colour class to handle HSV format colours
about: Extends #TColour
End Rem
Type TColourHSV Extends TColour
	
	rem
	bbdoc: Hue component
	endrem
	Field h:Float
	
	
	rem
	bbdoc: Saturation component
	endrem
	Field s:Float

	rem
	bbdoc: ? component
	endrem
	Field v:Float

	rem
	bbdoc: Alpha component
	endrem
	Field a:Float = 1.0
	
	rem
	bbdoc: Converts the HSV colour to RGB format
	returns: #TColourRGB
	endrem
	Method toRGB:TColourRGB()

		Local temph:Float = self.h
		Local temps:Float = self.s
		Local tempv:Float = self.v
	
		Local rgb:TColourRGB = New TColourRGB
	
		If temph=>360.0 Or temph<0.0 Then temph = 0.0
	
		If temps = 0 Then
			rgb.r = v
			rgb.g = v
			rgb.b = v
		Else
			temph = temph / 60.0
			
			Local i:Int   = Floor(temph)
			Local f:Float = temph - i
			Local p:Float = tempv * (1 - temps)
			Local q:Float = tempv * (1 - temps * f)
			Local t:Float = tempv * (1 - temps * (1 - f))

			Select i
				Case 0
					rgb.r = v
					rgb.g = t
					rgb.b = p
				Case 1
					rgb.r = q
					rgb.g = v
					rgb.b = p
				Case 2
					rgb.r = p
					rgb.g = v
					rgb.b = t
				Case 3
					rgb.r = p
					rgb.g = q
					rgb.b = v
				Case 4
					rgb.r = t
					rgb.g = p
					rgb.b = v
				Default
					rgb.r = v
					rgb.g = p
					rgb.b = q
			End Select		
		EndIf

		rgb.a = a

		Return rgb
	
	EndMethod
	
	rem
	bbdoc: Creates a new #TColourHSV colour from a packed ARGB Int
	returns: #TColourHSV
	endrem
	Function fromARGB:TColourHSV(argb:Int)
		
		Return TColourRGB.fromARGB(argb).toHSV()
		
	EndFunction
	
	rem
	bbdoc: Converts the #TColourHSV colour to a packed ARGB Int
	returns: a packed ARGB Int
	endrem
	Method toARGB:Int()
		
		Return self.toRGB().toARGB()

	EndMethod
	
	rem
	bbdoc: Sets the current draw colour to this colour
	endrem
	Method Set()
		Self.toRGB().Set()
	End Method

	rem
	bbdoc: Sets the current draw colour to this colour, but ignore the alpha
	endrem		
	Method SetWithoutAlpha()
		Self.toRGB().SetWithoutAlpha()
	End Method
EndType
