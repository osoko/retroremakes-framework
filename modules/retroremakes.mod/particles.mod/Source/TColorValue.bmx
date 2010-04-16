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
		_currentColor.Set(_startColor._r, _startColor._g, _startColor._b)
	End Method	
	
	
	
	rem
		bbdoc: uses the current color
	endrem
	Method Use()
		SetColor _currentColor._r, _currentColor._g, _currentColor._b
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
	
	

	Method LoadConfiguration(s:TStream)
		Local l:String, a:String[], b:String[2]
		l = s.ReadLine()
		l.Trim()
		While l <> "#endcolor"
			a = l.split("=")
			Select a[0].ToLower()
				Case "active"		_active = Int(a[1])
				Case "behaviour"	_behaviour = Int(a[1])
				Case "countdown"	_countdown_left = Int(a[1])
				Case "start"
					b = a[1].split(",")
					_startColor.Set(Float(b[0]), Float(b[1]), Float(b[2]))
				Case "end"
					b = a[1].split(",")
					_endColor.Set(Float(b[0]), Float(b[1]), Float(b[2]))
				Case "change" _changeAmount = Int(a[1])
				Case "random"
				Default Throw l
			End Select
			l = s.ReadLine()
			l.Trim()
		Wend
		ResetValue()
	End Method
	
End Type


'RGB color type
Type Trgb

	Field _r:Float, _g:Float, _b:Float

	Method New()
		_r = 255
		_g = 255
		_b = 255
	End Method

	Method Set(r:Float, g:Float, b:Float)
		_r = r
		_g = g
		_b = b
	End Method

	Method ChangeTo(col:Trgb, amount:Float)
		If _r < col._r
			_r:+amount
			If _r > col._r Then _r = col._r
			ElseIf _r > col._r
				_r:-amount
				If _r < col._r Then _r = col._r
		End If
		If _g < col._g
			_g:+amount
			If _g > col._g Then _g = col._g
			ElseIf _g > col._g
				_g:-amount
				If _g < col._g Then _g = col._g
		End If
		If _b < col._b
			_b:+amount
			If _b > col._b Then _b = col._b
			ElseIf _b > col._b
				_b:-amount
				If _b < col._b Then _b = col._b
		End If
	End Method

	Method Same:Int(col:Trgb)
		Local r:Int = False, g:Int = False, b:Int = False
		If _r = col._r Then r = True
		If _g = col._g Then g = True
		If _b = col._b Then b = True
		If r And g And b Then Return True
		Return False
	End Method

	Method Clone:Trgb()
		Local c:Trgb = New Trgb
		c._r = _r
		c._g = _g
		c._b = _b
		Return c
	End Method

End Type