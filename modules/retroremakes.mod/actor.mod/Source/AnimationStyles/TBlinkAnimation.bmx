rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Rem
	bbdoc: Sprite animation style for blinking sprites.
	about: Allows you to blink a sprite on and off at a specified speed.
End Rem
Type TBlinkAnimation Extends TAnimation

	' Default blink speed in ms
	Const DEFAULT_SPEED:Int = 1000

	' The time that the animation will next hide/show the actor
	Field _blinkTime:Int
		
	' The speed to blink at in milliseconds
	Field _speed:Int
	
	' The time that the animation last hid/showed the actor
	Field _startTime:Int

	
	
	Rem
		bbdoc:Returns a copy of the animation
	End Rem
	Method Copy:TAnimation()
		Local animation:TBlinkAnimation = New TBlinkAnimation
		animation._speed = _speed
		animation.Reset()
		Return animation
	End Method

	
	
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		_speed = DEFAULT_SPEED
	End Method

	
	
	rem
		bbdoc: Reset the animation
	endrem
	Method Reset()
		_startTime = Null
		_blinkTime = Null
		Super.Reset()
	End Method
			
	
	
	rem
		bbdoc: Set the blink speed in milliseconds
	endrem
	Method SetSpeed(value:Int)
		_speed = value
	End Method



	rem
		bbdoc: Updates the animation
	endrem
	Method Update:Int(actor:TActor)
		If Not _startTime Then _startTime = MilliSecs()
		
		Local time:Int = MilliSecs()
		
		If _blinkTime - time <= 0
			_startTime = time
			_blinkTime = _startTime + _speed

			actor.SetVisible(Not actor.IsVisible())
		End If
		
		Return IsFinished()
	End Method

End Type
