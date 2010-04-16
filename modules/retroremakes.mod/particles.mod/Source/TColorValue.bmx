
Type TColorValue Extends TValue

	Field _currentValue:Trgb
	Field _startValue:Trgb
	Field _endValue:Trgb

	Method New()
		_currentValue = New Trgb
		_startValue = New Trgb
		_endValue = New Trgb
		
'		_mode = MODE_COUNTDOWN					'TODO: move to editor value??
'		_active = False
'		_behaviour = BEHAVIOUR_ONCE		
	End Method

	Method Use()
		SetColor _currentValue._r, _currentValue._g, _currentValue._b
	End Method

	Method ResetValue()
		_currentValue.Set(_startValue._r, _startValue._g, _startValue._b)
	End Method

	Method ReverseChange()
		Local temp:Trgb = _startValue
		_startValue = _endValue
		_endValue = temp
		_currentValue = _startValue.Clone()'.SettingsTo(_startValue)
	End Method

	Method UpdateValue:Int()
		_currentValue.ChangeTo(_endValue, _changeAmount)
		
		' returns true if currentvalue is identical to endvalue (done)
		Return _currentValue.Same(_endValue)
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
				Case "change" _changeAmount = Int(a[1])
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
		c._changeAmount = _changeAmount
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