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

rem
	bbdoc: Float value which can be manipulated over time
endrem
Type TFloatValue Extends TValue

	Field _startValue:Float
	Field _endValue:Float
	Field _currentValue:Float
	Field _previousValue:Float

		
		
	rem
		bbdoc: Updates the value according to the 
		about: 
		returns: True if the value has reached its end value
	endrem
	Method UpdateValue:Int()
		If _currentValue < _endValue
			_currentValue:+_changeAmount
			If _currentValue > _endValue Then _currentValue = _endValue
			ElseIf _currentValue > _endValue
				_currentValue:-_changeAmount
				If _currentValue < _endValue Then _currentValue = _endValue
		EndIf
		If _currentValue = _endValue Then Return True
		Return False
	End Method
	
	
	
	rem
		bbdoc: Returns the current value
		returns: Float
	endrem
	Method GetCurrentValue:Float()
		Return _currentValue
	End Method
	
	

	rem
		bbdoc: Sets the current value
		about: does not change the start and end values
	endrem
	Method SetCurrentValue(value:Float)
		_currentValue = value
		_previousValue = value
	End Method

		
		
	rem
		bbdoc: Returns the difference between the current and the previous value
		returns: Float
	endrem
	Method GetChangedAmount:Float()
		Return _currentValue - _previousValue
	End Method

	

	rem
		bbdoc: reverses the start and end values and sets the current value
		to the new start value
	endrem
	Method ReverseChange()
		Local temp:Float = _startValue
		_startValue = _endValue
		_endValue = temp
		Self.ResetValue()
	End Method
	
	
	
	rem
		bbdoc: Sets the current value to the start value
	endrem
	Method ResetValue()
		_currentValue = _startValue
		_previousValue = _currentValue
	End Method

	
	
	rem
		bbdoc: Sets previous value to the current value
	endrem	
	Method SetPrevious()
		_previousValue = _currentValue
	End Method

	

	Method Scale(val:Float)
		_startValue:*val
		_endValue:*val
		_changeAmount:*val
		ResetValue()
	End Method

	Method Slide(val:Float)
		_currentValue:+val
		_startValue:+val
		_endValue:+val
	End Method

	
	
	rem
		bbdoc: freezes float on passed value
	endrem
	Method Freeze(value:Float)
		_currentValue = value
		_active = False
	End Method
	

	rem
		bbdoc: Randomizes float and its rotation direction
		about: Does not touch the _active flag so if this is set to false,
		then no rotation will happen
	endrem
	Method Randomize()
		Local range:Float = _endValue - _startValue
		_startValue = Rnd(359)
		_currentValue = _startValue
		_endValue = _startValue + range
		
		'50% chance to rotate the other way
		If Rand(1, 10) < 6 Then _changeAmount = -_changeAmount
	End Method
	

	Method LoadConfiguration(s:TStream)
		Local l:String, a:String[]
		l = s.ReadLine()
		l.Trim()
		While l <> "#endfloat"
			a = l.split("=")
			Select a[0].ToLower()
				Case "active" _active = Int(a[1])
				Case "behaviour" _behaviour = Int(a[1])
				Case "countdown" _countdown_left = Int(a[1])
				Case "start" _startValue = Float(a[1])
				Case "end" _endValue = Float(a[1])
				Case "change" _changeAmount = Float(a[1])
				Case "random"
				Default Throw l
			End Select
			l = s.ReadLine()
			l.Trim()
		Wend
		ResetValue()
	End Method

	Method Clone:TFloatValue()
		Local f:TFloatValue = New TFloatValue
		f._active = _active
		f._behaviour = _behaviour
		f._countdown_left = _countdown_left
		f._startValue = _startValue
		f._endValue	= _endValue
		f._changeAmount = _changeAmount
		f.ResetValue()
		Return f
	End Method	

End Type
