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
	bbdoc: Sprite animation style for setting XY position.
	about: Allows you to set the sprite to a specified position as part
	of an animation.
End Rem
Type TSetPositionAnimation Extends TAnimation
	
	Field x_:Float
	Field y_:Float
	
	Method SetPosition(x:Float, y:Float)
		x_ = x
		y_ = y
	End Method
	
	Method Update:Int(sprite:TActor)
		sprite.SetPosition(x_, y_)
		SetFinished(True)
		Return IsFinished()
	End Method

End Type
