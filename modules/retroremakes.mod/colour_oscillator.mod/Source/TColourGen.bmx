rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.

' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Type TColourGen
	Field r:Float	'Red speed
	Field g:Float	'Green speed
	Field b:Float	'Blue speed
	Field a:Float	'Alpha speed
	Field r_lo:Int	'Lowest Red setting
	Field g_lo:Int	'Lowest Green setting
	Field b_lo:Int	'Lowest Blue setting
	Field a_lo:Int	'Lowest Alpha setting
	Field r_hi:Int	'Highest Red setting
	Field g_hi:Int	'Highest Green setting
	Field b_hi:Int	'Highest Blue setting
	Field a_hi:Int	'Highest Alpha setting
	
	Method New()
		' some defaults
		SetRedSpeed(2.0)
		SetGreenSpeed(4.0)
		SetBlueSpeed(2.0)
		SetAlphaSpeed(0.0)
		SetRedLow(128)
		SetGreenLow(128)
		SetBlueLow(128)
		SetAlphaLow(255)
		SetRedHigh(255)
		SetGreenHigh(255)
		SetBlueHigh(255)
		SetAlphaHigh(255)
	End Method
	
	Method GetRedSpeed:Float()
		Return r
	End Method
	
	Method GetGreenSpeed:Float()
		Return g
	End Method

	Method GetBlueSpeed:Float()
		Return b
	End Method

	Method GetAlphaSpeed:Float()
		Return a
	End Method
	
	Method GetRedLow:Int()
		Return r_lo
	End Method
	
	Method GetGreenLow:Int()
		Return g_lo
	End Method

	Method GetBlueLow:Int()
		Return b_lo
	End Method

	Method GetAlphaLow:Int()
		Return a_lo
	End Method
	
	Method GetRedHigh:Int()
		Return r_hi
	End Method
	
	Method GetGreenHigh:Int()
		Return g_hi
	End Method

	Method GetBlueHigh:Int()
		Return b_hi
	End Method

	Method GetAlphaHigh:Int()
		Return a_hi
	End Method		

	Method Save:Int(path:String)
		Local colourFile:TINIFile = TINIFile.Create(path)
		colourFile.CreateMissingEntries(True)
		colourFile.SetIntValue("ColourGen", "ALPHA_HIGH", GetAlphaHigh())
		colourFile.SetIntValue("ColourGen", "RED_HIGH", GetRedHigh())
		colourFile.SetIntValue("ColourGen", "GREEN_HIGH", GetGreenHigh())
		colourFile.SetIntValue("ColourGen", "BLUE_HIGH", GetBlueHigh())
		colourFile.SetIntValue("ColourGen", "ALPHA_LOW", GetAlphaLow())
		colourFile.SetIntValue("ColourGen", "RED_LOW", GetRedLow())
		colourFile.SetIntValue("ColourGen", "GREEN_LOW", GetGreenLow())
		colourFile.SetIntValue("ColourGen", "BLUE_LOW", GetBlueLow())
		colourFile.SetFloatValue("ColourGen", "ALPHA_SPEED", GetAlphaSpeed())
		colourFile.SetFloatValue("ColourGen", "RED_SPEED", GetRedSpeed())
		colourFile.SetFloatValue("ColourGen", "GREEN_SPEED", GetGreenSpeed())
		colourFile.SetFloatValue("ColourGen", "BLUE_SPEED", GetBlueSpeed())
		
		If Not colourFile.Save()
			Throw "Unable to save TColourGen INI File: " + path
		End If
		
		' dispose of the INI file
		colourFile = Null
		Return True
	End Method
		
	Method SetRedSpeed(speed:Float)
		r = speed
	End Method
	
	Method SetGreenSpeed(speed:Float)
		g = speed
	End Method

	Method SetBlueSpeed(speed:Float)
		b = speed
	End Method

	Method SetAlphaSpeed(speed:Float)
		a = speed
	End Method
	
	Method SetRedLow(low:Int)
		r_lo = CapValueToByte(low)
	End Method
	
	Method SetGreenLow(low:Int)
		g_lo = CapValueToByte(low)
	End Method

	Method SetBlueLow(low:Int)
		b_lo = CapValueToByte(low)
	End Method

	Method SetAlphaLow(low:Int)
		a_lo = CapValueToByte(low)
	End Method
	
	Method SetRedHigh(high:Int)
		r_hi = CapValueToByte(high)
	End Method
	
	Method SetGreenHigh(high:Int)
		g_hi = CapValueToByte(high)
	End Method

	Method SetBlueHigh(high:Int)
		b_hi = CapValueToByte(high)
	End Method

	Method SetAlphaHigh(high:Int)
		a_hi = CapValueToByte(high)
	End Method			

	Function Load:TColourGen(path:String)
		Local colours:TColourGen = New TColourGen
		Local colourFile:TINIFile = TINIFile.Create(path)
		If colourFile.Load()
			colours.SetAlphaHigh(colourFile.GetIntValue("ColourGen", "ALPHA_HIGH", 255))
			colours.SetRedHigh(colourFile.GetIntValue("ColourGen", "RED_HIGH", 255))
			colours.SetGreenHigh(colourFile.GetIntValue("ColourGen", "GREEN_HIGH", 255))
			colours.SetBlueHigh(colourFile.GetIntValue("ColourGen", "BLUE_HIGH", 255))
			colours.SetAlphaLow(colourFile.GetIntValue("ColourGen", "ALPHA_LOW", 255))
			colours.SetRedLow(colourFile.GetIntValue("ColourGen", "RED_LOW", 128))
			colours.SetGreenLow(colourFile.GetIntValue("ColourGen", "GREEN_LOW", 128))
			colours.SetBlueLow(colourFile.GetIntValue("ColourGen", "BLUE_LOW", 128))
			colours.SetAlphaSpeed(colourFile.GetFloatValue("ColourGen", "ALPHA_SPEED", 0.0))
			colours.SetRedSpeed(colourFile.GetFloatValue("ColourGen", "RED_SPEED", 2.0))
			colours.SetGreenSpeed(colourFile.GetFloatValue("ColourGen", "GREEN_SPEED", 4.0))
			colours.SetBlueSpeed(colourFile.GetFloatValue("ColourGen", "BLUE_SPEED", 2.0))
			colourFile.Save()
		Else
			Throw "Unable to load TColourGen INI File: " + path
		End If
		
		' dispose of the INI file
		colourFile = Null
		
		Return colours
	End Function
	
End Type
