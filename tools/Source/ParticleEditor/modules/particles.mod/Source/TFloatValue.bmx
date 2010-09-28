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

	' length of the array used in import and export settings
	Field settingsLength:Int = 7
			
	rem
		bbdoc: Updates the value
		about: used by TValue.Update(), you shouldn't need to call this
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
		bbdoc: Sets the start value
	endrem
	Method SetStartValue(value:Float)
		_startValue = value
	End Method

	
	
	rem
		bbdoc: Returns the start value
		returns: Float
	endrem
	Method GetStartValue:Float()
		Return _startValue
	End Method

	
	
	rem
		bbdoc: Sets the end value
	endrem
	Method SetEndValue(value:Float)
		_endValue = value
	End Method

	
	
	rem
		bbdoc: Returns the end value
		returns: Float
	endrem
	Method GetEndValue:Float()
		Return _endValue
	End Method

	
		
	rem
		bbdoc: Returns the difference between the current and the previous value
		returns: Float
	endrem
	Method GetChangedAmount:Float()
		Return _currentValue - _previousValue
	End Method

	

	rem
		bbdoc: reverses the start and end values ' and sets the current value
		to the new start value
	endrem
	Method ReverseChange()
		Local temp:Float = _startValue
		_startValue = _endValue
		_endValue = temp
'		Self.ResetValue()
	End Method
	
	
	
	rem
		bbdoc: Sets the current value to its start value
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

	
	
	rem
		bbdoc: scales the range and change amount by passed value
	endrem
	Method ScaleRange(val:Float)
		_startValue:*val
		_endValue:*val
		_changeAmount:*val
'		ResetValue()
	End Method
	
	
	
	rem
		bbdoc: moves the range by passed amount
	endrem
	Method MoveRange(val:Float)
'		_currentValue:+val
		_startValue:+val
		_endValue:+val
	End Method

	
	
	rem
		bbdoc: fixes float on passed value
		about: this basically turns the value into a static float
	endrem
	Method Fix(value:Float)
		_currentValue = value
		_active = False
	End Method
	

	
	rem
		bbdoc: Randomizes value and rotation direction
		about: takes the current range into account
	endrem
	Method Randomize()
		Local range:Float = _endValue - _startValue
		_startValue = Rnd(359)
		_currentValue = _startValue
		_endValue = _startValue + range
		
		'50% chance to rotate the other way
		If Rand(1, 10) < 6 Then _changeAmount = -_changeAmount
	End Method

	

	rem
	bbdoc: Creates a clone of this float value
	returns: TFloatValue
	endrem
	Method Clone:TFloatValue()
		Local f:TFloatValue = New TFloatValue
		f._active = _active
		f._behaviour = _behaviour
		f._countdown_left = _countdown_left
		f._startValue = _startValue
		f._endValue	= _endValue
		f._changeAmount = _changeAmount
		f._mode = _mode
		'f.ResetValue()
		Return f
	End Method	
	

	
	rem
	bbdoc: Imports settings from a stream
	endrem	
	Method ReadPropertiesFromStream:Int(stream:TStream)
	
		Local value:String[]
		Local line:String
		
		line = ReadLine(stream).Trim()
		line.ToLower()
	
		While line <> "[end float]"
		
			value = line.Split("=")
			
			Select value[0]
				Case "active"
					_active = Int(value[1])
				Case "behaviour"
					_behaviour = Int(value[1])
				Case "countdown"
					_countdown_left = Int(value[1])
				Case "start"
					_startValue = Float(value[1])
				Case "end"
					_endValue = Float(value[1])
				Case "change"
					_changeAmount = Float(value[1])
				Case "", "[float]"
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
		WriteLine(stream, "start=" + String(_startValue))
		WriteLine(stream, "end=" + String(_endValue))
		WriteLine(stream, "change=" + String(_changeAmount))
		WriteLine(stream, "[end float]")
		Return True
	End Method		
		
End Type
