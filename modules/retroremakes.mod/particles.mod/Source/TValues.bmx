Rem
'
' Copyright (c) 2007-2009 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem


'
'values that can be controlled and manipulated over time
'values are color and float.
'possibly change to animations in a later release. for now, straight port 

Const BEHAVIOUR_ONCE:Int = 10
Const BEHAVIOUR_REPEAT:Int = 11
Const BEHAVIOUR_PINGPONG:Int = 12

Type TValue Abstract

	Method New()
		_mode = COUNTDOWN					'TODO: move to editor value
		_active = False
		_behaviour = BEHAVIOUR_ONCE
	End Method

	Method Update()
		SetPrevious()
		If _active = False Then Return
		
		Select _mode
			Case COUNTDOWN
				_countdown_left:-1
				If _countdown_left < 0 Then _mode = RUNNING
			Case RUNNING
				If Self.UpdateValue() = True Then _mode = ENDED
			Case ENDED
				Select _behaviour
					Case BEHAVIOUR_ONCE
						_mode = STOPPED
					Case BEHAVIOUR_REPEAT
						Self.ResetValue()
						_mode = RUNNING
					Case BEHAVIOUR_PINGPONG
						Self.ReverseValue()
						_mode = RUNNING
				End Select
		End Select
	End Method

	Method SetBehaviour(value:Int)
		_behaviour = value
	End Method

	Method Enable()
		_active = True
	End Method

	Method Disable()
		_active = False
	End Method

	Method SetMode(value:Int)
		_mode = value
	End Method

	Method SetChangeValue(value:Float)
		_changeValue = value
	End Method

	Method UpdateValue:Int() Abstract
	Method ResetValue() Abstract
	Method ReverseValue() Abstract
	Method SetPrevious() Abstract

	Const COUNTDOWN:Int = 1				' 1st pause, optional
	Const RUNNING:Int = 2				' control type is running
	Const ENDED:Int = 3					' control type has ended
	Const STOPPED:Int = 4				' control has stopped or never needs to run

	'***** PRIVATE *****

	Field _active:Int
	Field _behaviour:Int
	Field _mode:Int
	Field _countdown_left:Int
	Field _changeValue:Float			' the value gets changed by this amount per tick
End Type

Type TFloatValue Extends TValue

	Field _startValue:Float
	Field _endValue:Float
	Field _currentValue:Float
	Field _previousValue:Float

	Method GetValue:Float()
		Return _currentValue
	End Method

	Method GetChanged:Float()
		Return _currentValue - _previousValue
	End Method

	Method SetValue(value:Float)
		_currentValue = value
		_previousValue = value
	End Method

	Method ReverseValue()
		Local temp:Float = _startValue
		_startValue = _endValue
		_endValue = temp
		Self.ResetValue()
	End Method

	Method ResetValue()
		_currentValue = _startValue
		_previousValue = _currentValue
	End Method

	Method SetPrevious()
		_previousValue = _currentValue
	End Method

	Method UpdateValue:Int()
		If _currentValue < _endValue
			_currentValue:+_changeValue
			If _currentValue > _endValue Then _currentValue = _endValue
			ElseIf _currentValue > _endValue
				_currentValue:-_changeValue
				If _currentValue < _endValue Then _currentValue = _endValue
		EndIf
		If _currentValue = _endValue Then Return True
		Return False
	End Method

	Method Scale(val:Float)
		_startValue:*val
		_endValue:*val
		_changeValue:*val
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
		about: Does not touch the _active flag so if this is set to false, then no rotation will happen
	endrem
	Method Randomize()
		Local range:Float = _endValue - _startValue
		_startValue = Rnd(359)
		_currentValue = _startValue
		_endValue = _startValue + range
		If Rand(1, 10) < 6 Then _changeValue = -_changeValue	'50% chance to rotate the other way
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
				Case "change" _changeValue = Float(a[1])
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
		f._changeValue = _changeValue
		f.ResetValue()
		Return f
	End Method	

End Type

Type TColorValue Extends TValue

	Field _currentValue:Trgb
	Field _startValue:Trgb
	Field _endValue:Trgb

	Method New()
		_currentValue = New Trgb
		_startValue = New Trgb
		_endValue = New Trgb
		
'		_mode = COUNTDOWN					'TODO: move to editor value??
'		_active = False
'		_behaviour = BEHAVIOUR_ONCE		
	End Method

	Method Use()
		SetColor _currentValue._r, _currentValue._g, _currentValue._b
	End Method

	Method ResetValue()
		_currentValue.Set(_startValue._r, _startValue._g, _startValue._b)
	End Method

	Method ReverseValue()
		Local temp:Trgb = _startValue
		_startValue = _endValue
		_endValue = temp
		_currentValue = _startValue.Clone()'.SettingsTo(_startValue)
	End Method

	Method UpdateValue:Int()
		_currentValue.ChangeTo(_endValue, _changeValue)
		Return _currentValue.Same(_endValue)				' returns true if currentvalue is identical to endvalue (done)
	End Method

	Method SetPrevious()
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
					_startValue.Set( Float(b[0]), Float(b[1]), Float(b[2]) )
				Case "end"
					b = a[1].split(",")
					_endValue.Set( Float(b[0]), Float(b[1]), Float(b[2]) )
				Case "change"		_changeValue = Int(a[1])
				Case "random"
				Default Throw l
			End Select
			l = s.ReadLine()
			l.Trim()
		Wend
		ResetValue()
	End Method

	Method Clone:TColorValue()
		Local c:TColorValue = New TColorValue
		c._active = _active
		c._behaviour = _behaviour
		c._countdown_left = _countdown_left
		
		c._startValue = _startValue.Clone()
		c._endValue = _endValue.Clone()
'		_startValue.SettingsTo( c._startValue )
'		_endValue.SettingsTo( c._endValue )
		c._changeValue = _changeValue
		c.ResetValue()
		Return c
	End Method

	Method SetCurrentValue(r:Float, g:Float, b:Float)
		_currentValue.Set(r,g,b)
	End Method

	Method SetStartValue(r:Float, g:Float, b:Float)
		_startValue.Set(r,g,b)
	End Method

	Method SetEndValue(r:Float, g:Float, b:Float)
		_endValue.Set(r,g,b)
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

	Method ChangeTo(col:Trgb, speed:Float)
		If _r < col._r
			_r:+speed
			If _r > col._r Then _r = col._r
			ElseIf _r > col._r
				_r:-speed
				If _r < col._r Then _r = col._r
		End If
		If _g < col._g
			_g:+speed
			If _g > col._g Then _g = col._g
			ElseIf _g > col._g
				_g:-speed
				If _g < col._g Then _g = col._g
		End If
		If _b < col._b
			_b:+speed
			If _b > col._b Then _b = col._b
			ElseIf _b > col._b
				_b:-speed
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