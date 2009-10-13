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

	Field startAlpha_:Float
	Field endAlpha_:Float
	Field currentAlpha_:Float
	Field speed_:Float
	Field time:Float
	
	Method Initialse()
		Reset()
	End Method
	
	Method Reset()
		currentAlpha_ = startAlpha_
		Super.Reset()
	End Method
	
	Method SetStartAlpha(startAlpha:Float)
		startAlpha_ = startAlpha
		currentAlpha_ = startAlpha_
	End Method
	
	Method SetEndAlpha(endAlpha:Float)
		endAlpha_ = endAlpha
	End Method
	
	Method SetTime(t:Float)
		time = t
		SetSpeed(Abs((startAlpha_ - endAlpha_) / time * (1000 / TFixedTimestep.GetInstance().GetUpdateFrequency())))
	End Method
	
	Method SetSpeed(speed:Float)
		speed_ = speed
	End Method
	
	Method Update:Int(sprite:TActor)
		If endAlpha_ > startAlpha_
			currentAlpha_:+speed_
			If currentAlpha_ > endAlpha_
				currentAlpha_ = endAlpha_
				isFinished = True
			End If
		Else
			currentAlpha_:-speed_
			If currentAlpha_ < endAlpha_
				currentAlpha_ = endAlpha_
				isFinished = True
			End If
		End If
		sprite.GetColour().a = currentAlpha_
		Return Finished()
	End Method
	
End Type
