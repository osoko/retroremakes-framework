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
	
	Field _position:TVector2D


		
	Rem
		bbdoc:Returns a copy of the animation
	End Rem
	Method Copy:TAnimation()
		Local animation:TSetPositionAnimation = New TSetPositionAnimation
		animation._position = _position.Copy()
		animation.Reset()
		Return animation
	End Method

	
	
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		_position = New TVector2D
	End Method
	
	
	
	rem
		bbdoc: Set the position to use for this animation
	endrem
	Method SetPosition(x:Float, y:Float)
		_position.x = x
		_position.y = y
	End Method
	
	
	
	rem
		bbdoc: Set the position to use for this animation
	endrem
	Method SetPositionV(position:TVector2D)
		_position.x = position.x
		_position.y = position.y
	End Method
	
	
		
	rem
		bbdoc: Update the animation
	endrem
	Method Update:Int(actor:TActor)
		actor.SetPosition(_position.x, _position.y)
		
		SetFinished(True)
		
		Return IsFinished()
	End Method

End Type
