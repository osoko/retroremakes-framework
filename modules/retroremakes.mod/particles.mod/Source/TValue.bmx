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


'
'values that can be controlled and manipulated over time
'values are color and float.
'possibly change to animations in a later release. for now, straight port 

Const BEHAVIOUR_ONCE:Int = 10			' value does its change once
Const BEHAVIOUR_REPEAT:Int = 11			' value repeats its change
Const BEHAVIOUR_PINGPONG:Int = 12		' back and forth

Const MODE_COUNTDOWN:Int = 1			' 1st pause, optional
Const MODE_RUNNING:Int = 2				' control type is running
Const MODE_ENDED:Int = 3				' control type has ended
Const MODE_STOPPED:Int = 4				' control has stopped or never needs to run


rem
	bbdoc: base object for particle engine values
endrem
Type TValue Abstract

	Field _active:Int
	Field _behaviour:Int
	Field _mode:Int
	Field _countdown_left:Int
	Field _changeAmount:Float

	Method UpdateValue:Int() Abstract
	Method ResetValue() Abstract
	Method ReverseChange() Abstract
	Method SetPrevious() Abstract	

	Method New()
		_mode = MODE_COUNTDOWN
		_active = False
		_behaviour = BEHAVIOUR_ONCE
	End Method

	Method Update()
		SetPrevious()
		If _active = False Then Return
		
		Select _mode
			Case MODE_COUNTDOWN
				_countdown_left:-1
				If _countdown_left < 0 Then _mode = MODE_RUNNING
			Case MODE_RUNNING
				If Self.UpdateValue() = True Then _mode = MODE_ENDED
			Case MODE_ENDED
				Select _behaviour
					Case BEHAVIOUR_ONCE
						_mode = MODE_STOPPED
					Case BEHAVIOUR_REPEAT
						Self.ResetValue()
						_mode = MODE_RUNNING
					Case BEHAVIOUR_PINGPONG
						Self.ReverseChange()
						_mode = MODE_RUNNING
				End Select
		End Select
	End Method

	
	
	rem
		bbdoc: Set value change behaviour
	endrem	
	Method SetBehaviour(value:Int)
		_behaviour = value
	End Method
	
	
	
	rem
		bbdoc: Returns change behaviour
		returns: BEHAVIOUR_ONCE, BEHAVIOUR_REPEAT or BEHAVIOUR_PINGPONG
	endrem
	Method GetBehaviour:Int()
		Return _behaviour
	End Method
	
	
	
	rem
		bbdoc: Enables or disables the updating of this value
	endrem
	Method SetActive(value:Int)
		_active = value
	End Method

	
	
	rem
		bbdoc: Get the active state of this value
		returns: True or False
	endrem
	Method GetActive:Int()
		Return _active
	End Method
	

	
	rem
		bbdoc: Sets the operation mode of this value
	endrem
	Method SetMode(value:Int)
		_mode = value
	End Method

	
		
	rem
		bbdoc: Returns the operation mode of this value
	endrem
	Method GetMode:Int()
		Return _mode
	End Method

	
	rem
		bbdoc: Sets the amount by which this value changes each update
	endrem	
	Method SetChangeAmount(value:Float)
		_changeAmount = value
	End Method


		
	rem
		bbdoc: Returns the amount by which this value changes each update
		returns: Float
	endrem	
	Method GetChangeAmount:Float()
		Return _changeAmount
	End Method

End Type

