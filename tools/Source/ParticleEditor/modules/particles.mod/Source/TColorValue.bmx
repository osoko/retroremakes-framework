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
		bbdoc: Imports settings from a stream
	endrem	
	Method ReadPropertiesFromStream:Int(stream:TStream)
	
		Local value:String[2]
		Local colors:String[3]
		Local line:String
		
		line = ReadLine(stream).Trim()
		line.ToLower()
	
		While line <> "[end color]"
		
			value = line.Split("=")
			
			Select value[0]
				Case "active"
					_active = Int(value[1])
				Case "behaviour"
					_behaviour = Int(value[1])
				Case "countdown"
					_countdown_left = Int(value[1])
				Case "change"
					_changeAmount = Float(value[1])
				Case "start"
					colors = value[1].Split(",")
					_startColor.set(Float(colors[0]), Float(colors[1]), Float(colors[2]))
				Case "end"
					colors = value[1].Split(",")
					_endColor.set(Float(colors[0]), Float(colors[1]), Float(colors[2]))
				Case "", "[color]"
					'skip empty lines
				Default

'					Return False
					Throw "" + value[0] + " is not a recognized label"
			End Select
		
			line = ReadLine(stream).Trim()
			line.ToLower()
		Wend
		Return True
	End Method	

	
	
	rem
		bbdoc: Exports settings to stream
	endrem	
	Method WritePropertiesToStream:Int(stream:TStream, label:String)
		WriteLine(stream, "[" + label + "]")
		WriteLine(stream, "active=" + String(_active))
		WriteLine(stream, "behaviour=" + String(_behaviour))
		WriteLine(stream, "countdown=" + String(_countdown_left))
		WriteLine(stream, "start=" + String(_startColor.r) + "," + String(_startColor.g) + "," + String(_startColor.b))
		WriteLine(stream, "end=" + String(_endColor.r) + "," + String(_endColor.g) + "," + String(_endColor.b))
		WriteLine(stream, "change=" + String(_changeAmount))
		WriteLine(stream, "[end color]")
		Return True
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