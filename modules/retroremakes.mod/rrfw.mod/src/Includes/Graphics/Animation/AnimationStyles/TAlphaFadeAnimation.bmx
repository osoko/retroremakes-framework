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
	bbdoc: Sprite animation style for performing alpha channel fades.
	about: Allows you to fade a sprite in or out using its alpha channel.
End Rem
Type TAlphaFadeAnimation Extends TAnimation

	' The amount that the alpha value changes by each update
	Field _change:Float
	
	' The current alpha value
	Field _currentAlpha:Float

	' The alpha value the animation finishes at
	Field _endAlpha:Float

	' The alpha value the animation starts at
	Field _startAlpha:Float
	


	rem
		bbdoc: Resets the animation to starting values
	endrem
	Method Reset()
		_currentAlpha = _startAlpha
		Super.Reset()
	End Method
	
	
	
	rem
		bbdoc: Set the value that alpha value is changed by each update
	endrem
	Method SetChange(value:Float)
		_change = value
	End Method
	
	
	
	rem
		bbdoc: Sets the ending alpha value
	endrem	
	Method SetEndAlpha(value:Float)
		_endAlpha = value
	End Method
	
	
	
	rem
		bbdoc: Sets the starting alpha value
	endrem
	Method SetStartAlpha(value:Float)
		_startAlpha = value
		_currentAlpha = _startAlpha
	End Method
	
	
	
	rem
		bbdoc: Set the length of time the animation should take in millisecs
		about: The value specified is used to calculate the rate of change so
		that the animation completes in the requested timescale
	endrem
	Method SetTime(ms:Float)
		SetChange(Abs((_startAlpha - _endAlpha) / ms * (1000 / TFixedTimestep.GetInstance().GetUpdateFrequency())))
	End Method

	

	rem
		bbdoc: Updates the animation
	endrem	
	Method Update:Int(actor:TActor)
		If _endAlpha > _startAlpha
			_currentAlpha:+_change			
			If _currentAlpha > _endAlpha
				_currentAlpha = _endAlpha
				SetFinished(True)
			End If
		Else
			_currentAlpha:-_change
			If _currentAlpha < _endAlpha
				_currentAlpha = _endAlpha
				SetFinished(True)
			End If
		End If
		
		actor.GetColour().a = _currentAlpha
		
		Return IsFinished()
	End Method
	
End Type
