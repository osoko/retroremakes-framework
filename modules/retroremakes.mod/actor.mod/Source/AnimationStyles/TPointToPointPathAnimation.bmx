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

Rem
	bbdoc: Sprite animation style for moving from one XY position to another.
	about: Allows you to set a start and end position for the sprite and a
	transition time, the animation will then move the sprite at the correct
	speed to get from A to B in the specified time.
End Rem
Type TPointToPointPathAnimation Extends TAnimation

	' vector containing the end position of the animation
	Field _endPosition:TVector2D

	' vector containing the start position of the animation
	Field _startPosition:TVector2D

	' current completed time in a scale of 0.0 to 1.0
	Field _time:Float
		
	' how much each to increase completed time each update call
	Field _timeStep:Float

	
	
	Rem
		bbdoc:Returns a copy of the animation
	End Rem
	Method Copy:TAnimation()
		Local animation:TPointToPointPathAnimation = New TPointToPointPathAnimation
		animation._endPosition = _endPosition.Copy()
		animation._startPosition = _startPosition.Copy()
		animation._timeStep = _timeStep
		animation.Reset()
		Return animation
	End Method

	
	
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		_endPosition = New TVector2D
		_startPosition = New TVector2D
	End Method
	
	
	
	rem
		bbdoc: Resets the animation to initial values
		about: This is used when looping animations
	endrem
	Method Reset()
		_time = 0.0
		Super.Reset()
	End Method
	
	
	
	rem
		bbdoc: Set the time to take moving from the start to end positions
		about: Value is in millisecs and uses the games update frequency to calculate
		the correct update speed
	endrem
	Method SetTransitionTime(time:Float)
		_timeStep = (1.0 / time) * (1000.0 / TFixedTimestep.GetInstance().GetUpdateFrequency())
		_time = 0.0
	End Method
	
	
	
	rem
		bbdoc: Set the start position of the animation
	endrem
	Method SetStartPosition(x:Float, y:Float)
		_startPosition.x = x
		_startPosition.y = y
	End Method

	
	
	rem
		bbdoc: Set the end position of the animation
	endrem
	Method SetEndPosition(x:Float, y:Float)
		_endPosition.x = x
		_endPosition.y = y
	End Method	
	
	
	
	rem
		bbdoc: Update the animation
	endrem
	Method Update:Int(actor:TActor)
		_time:+_timeStep
		
		If _time > 1.0
			_time = 1.0
			SetFinished(True)
		EndIf
		
		actor.SetPosition( ..
			_startPosition.x + (_endPosition.x - _startPosition.x) * _time,  ..
			_startPosition.y + (_endPosition.y - _startPosition.y) * _time ..
		)
		
		Return IsFinished()
	End Method

End Type
