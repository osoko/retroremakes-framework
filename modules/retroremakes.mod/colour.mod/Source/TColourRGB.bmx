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
bbdoc: Colour class to handle RGB format colours
about: Extends #TColour
endrem
Type TColourRGB Extends TColour

	rem
	bbdoc: Red component
	endrem
	Field r:Float = 255.0

	rem
	bbdoc: Green component
	endrem
	Field g:Float = 255.0

	rem
	bbdoc: Blue component
	endrem
	Field b:Float = 255.0

	rem
	bbdoc: Alpha component
	endrem
	Field a:Float = 1.0
	
	
	
	rem
	bbdoc: Convert the RGB colour to HSV format
	returns: #TColourHSV
	endrem
	Method toHSV:TColourHSV()
		
		Local tempr:Float = Min(1.0,Max(0.0,self.r))
		Local tempg:Float = Min(1.0,Max(0.0,self.g))
		Local tempb:Float = Min(1.0,Max(0.0,self.b))

		Local minVal:Float = Min(Min(tempr,tempg),tempb)
		Local maxVal:Float = Max(Max(tempr,tempg),tempb)
		
		Local diff:Float = maxVal - minVal
	
		Local hsv:TColourHSV = New TColourHSV
		hsv.v = maxVal
	
		If maxVal = 0.0 Then
			hsv.s = 0.0
			hsv.h = 0.0
		Else
			hsv.s = diff / maxVal
	
			If tempr = maxVal
				hsv.h = (tempg - tempb) / diff
			ElseIf tempg = maxVal
				hsv.h = 2.0 + (tempb - tempr) / diff
			Else
				hsv.h = 4.0 + (tempr - tempg) / diff
			EndIf
	
			hsv.h = hsv.h * 60.0
			If hsv.h < 0 Then hsv.h = hsv.h + 360.0
		EndIf

		If hsv.h<  0.0 Then hsv.h = 0.0
		If hsv.h>360.0 Then hsv.h = 0.0
		
		hsv.a = a
		
		Return hsv
	End Method

	
	
	rem
	bbdoc: Creates a new #TColourRGB colour from a packed ARGB Int
	returns: #TColourHSV
	endrem
	Function fromARGB:TColourRGB(argb:Int, alpha:Int = True)
	
		Local rgb:TColourRGB = New TColourRGB
	
		If alpha	
			rgb.a = ((argb Shr 24) & $FF)/255.0
		EndIf
		
		rgb.r = ((argb Shr 16) & $FF)/255.0
		rgb.g = ((argb Shr 8) & $FF)/255.0
		rgb.b = (argb & $FF)/255.0
	
		Return rgb
		
	EndFunction

	

	rem
	bbdoc: Creates a new #TColourRGB colour from a packed BGR Int
	returns: #TColourHSV
	endrem
	Function fromBGR:TColourRGB(argb:Int)
	
		Local rgb:TColourRGB = New TColourRGB
	
		rgb.r = (argb & $000000FF)/255.0
		rgb.g = ((argb Shr 8) & $000000FF)/255.0
		rgb.b = ((argb Shr 16) & $000000FF)/255.0
	
		Return rgb
		
	EndFunction

	
	
	rem
	bbdoc: Converts the #TColourRGB colour to a packed ARGB Int
	returns: A packed ARGB Int
	endrem	
	Method toARGB:Int()
		
		Local tempr:Int = Min(255, Max(0, Int(Self.r * 255)))
		Local tempg:Int = Min(255, Max(0, Int(Self.g * 255)))
		Local tempb:Int = Min(255, Max(0, Int(Self.b * 255)))
		Local tempa:Int = Min(255, Max(0, Int(Self.a * 255)))
						
		Return (tempa Shl 24) | (tempr Shl 16) | (tempg Shl 8) | tempb

	EndMethod

	
		
	rem
	bbdoc: Sets the current draw colour to this colour
	endrem	
	Method Set()
		SetColor r, g, b
		SetAlpha a
	End Method

	
	rem
	bbdoc: Sets this colour RGB and A values
	endrem
	Method SetComponents(red:Int, green:Int, blue:Int, alpha:Float)
		r = red
		g = green
		b = blue
		a = alpha
	End Method
	
	
	rem
	bbdoc: Sets the current draw colour to this colour, ignoring the alpha
	endrem		
	Method SetWithoutAlpha()
		SetColor r, g, b
	End Method
EndType