Rem
'
' Copyright (c) 2007-2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Type TColorValue Extends TValue

	Field _currentColor:Trgb
	Field _startColor:Trgb
	Field _endColor:Trgb

	' length of the array used in import and export settings
	Field settingsLength:Int = 11

		
	
	rem
		bbdoc: default constructor
	endrem
	Method New()
		_currentColor = New Trgb
		_startColor = New Trgb
		_endColor = New Trgb
	End Method
	
	
		
	rem
		bbdoc:
		about: called by TValue.Update(). No need to call this from your program.
		returns: True if the current color has reached the end value
	endrem
	Method UpdateValue:Int()
		_currentColor.ChangeTo(_endColor, _changeAmount)
		Return _currentColor.Same(_endColor)
	End Method	
	
	
	
	rem
		bbdoc: resets the current color to the start color values
	endrem
	Method ResetValue()
		_currentColor.Set(_startColor.r, _startColor.g, _startColor.b)
	End Method	
	
	
	
	rem
		bbdoc: uses the current color
	endrem
	Method Use()
		SetColor _currentColor.r, _currentColor.g, _currentColor.b
	End Method
	
	
	
	rem
		bbdoc:  reverses the start and end colors 
	endrem
	Method ReverseChange()
		Local temp:Trgb = _startColor
		_startColor = _endColor
		_endColor = temp
	End Method

	
		
	rem
		bbdoc: sets the current color values
	endrem
	Method SetCurrentColorValue(r:Float, g:Float, b:Float)
		_currentColor.Set(r, g, b)
	End Method

	
	
	rem
		bbdoc: returns the current color
	endrem
	Method GetCurrentColor:Trgb()
		Return _currentColor
	End Method
	
	
	
	rem
		bbdoc: sets the start color values
	endrem
	Method SetStartColorValue(r:Float, g:Float, b:Float)
		_startColor.Set(r, g, b)
	End Method
	
	
	
	rem
		bbdoc: returns the starting color
	endrem
	Method GetStartColor:Trgb()
		Return _startColor
	End Method

	
	
	rem
		bbdoc: sets the end color values
	endrem
	Method SetEndColorValue(r:Float, g:Float, b:Float)
		_endColor.Set(r, g, b)
	End Method
	
	
	
	rem
		bbdoc: returns the end color
	endrem
	Method GetEndColor:Trgb()
		Return _endColor
	End Method

	
		
	rem
		bbdoc: creates a clone of this color value
		returns: TColorValue
	endrem
	Method Clone:TColorValue()
		Local c:TColorValue = New TColorValue
		c._active = _active
		c._behaviour = _behaviour
		c._countdown_left = _countdown_left
		
		c._startColor = _startColor.Clone()
		c._endColor = _endColor.Clone()
		c._changeAmount = _changeAmount
		c.ResetValue()
		Return c
	End Method
	
	
	
	rem
	bbdoc: Imports Color settings from a string array
	endrem	
	Method ImportSettings(settings:String[])
		If settings.length <> settingsLength Then Throw "Color array not complete!"
		If settings[0] <> "color" Then Throw "Array not a color array!"
		_active = Int(settings[1])
		_behaviour = Int(settings[2])
		_countdown_left = Int(settings[3])
		_changeAmount = Float(settings[4])
		_startColor.Set(Float(settings[5]), Float(settings[6]), Float(settings[7]))
		_endColor.Set(Float(settings[8]), Float(settings[9]), Float(settings[10]))
	End Method
	
	
	
	rem
	bbdoc: Exports Color settings to a string array
	returns: String array
	endrem	
	Method ExportSettings:String[] ()
		Local settings:String[settingsLength]
		settings[0] = "color"
		settings[1] = String(_active)
		settings[2] = String(_behaviour)
		settings[3] = String(_countdown_left)
		settings[4] = String(_changeAmount)
		settings[5] = String(_startColor.r)
		settings[6] = String(_startColor.g)
		settings[7] = String(_startColor.b)
		settings[8] = String(_endColor.r)
		settings[9] = String(_endColor.g)
		settings[10] = String(_endColor.b)
		Return settings
	End Method
	
End Type


rem
bbdoc: Changeable RGB color value
endrem
Type Trgb

	Field r:Float, g:Float, b:Float

	
	
	rem
	bbdoc: Default contructor
	endrem
	Method New()
		r = 255
		g = 255
		b = 255
	End Method

	
	
	rem
	bbdoc: Sets the color RGB values
	endrem
	Method Set(red:Float, green:Float, blue:Float)
		r = red
		g = green
		b = blue
	End Method

	
	
	rem
	bbdoc: Change RGB values from start to end color
	endrem
	Method ChangeTo(col:Trgb, amount:Float)
		If r < col.r
			r:+amount
			If r > col.r Then r = col.r
			ElseIf r > col.r
				r:-amount
				If r < col.r Then r = col.r
		End If
		If g < col.g
			g:+amount
			If g > col.g Then g = col.g
			ElseIf g > col.g
				g:-amount
				If g < col.g Then g = col.g
		End If
		If b < col.b
			b:+amount
			If b > col.b Then b = col.b
			ElseIf b > col.b
				b:-amount
				If b < col.b Then b = col.b
		End If
	End Method
	
	

	rem
	bbdoc: Compares color to passed color type
	Returns: True if RBG values are the same
	endrem
	Method Same:Int(col:Trgb)
		Local red:Int = False, green:Int = False, blue:Int = False
		If r = col.r Then red = True
		If g = col.g Then green = True
		If b = col.b Then blue = True
		If red And green And blue Then Return True
		Return False
	End Method

	
	
	rem
	bbdoc: Creates an exact copy of this RGB value
	returns: Trgb
	endrem
	Method Clone:Trgb()
		Local c:Trgb = New Trgb
		c.r = r
		c.g = g
		c.b = b
		Return c
	End Method

End Type