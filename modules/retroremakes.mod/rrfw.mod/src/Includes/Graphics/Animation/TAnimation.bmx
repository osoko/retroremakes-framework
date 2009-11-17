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
	bbdoc: Base class for animations
End Rem
Type TAnimation

	' A callback function that can be called when an animation has completed
	Field _callbackFunction()
	
	' Whether the animation has finished or not
	Field _finished:Int
	
	
	
	rem
		bbdoc: Initialise the animation
		about: This should be overridden where required
	endrem
	Method Initialise()
		Reset()
	End Method

	
	
	rem
		bbdoc: Return whether the animation is finished or not
		about: If the animation is finished and a callback function has been set
		the function will be called here
	endrem
	Method IsFinished:Int()
		If _finished And _callbackFunction
			_callbackFunction()
		EndIf
		
		Return _finished
	End Method
	
	
	
	' Default constructor
	Method New()
		_finished = False
	End Method
	
	
	
	rem
		bbdoc: Does any work required to remove this animation
		about: This should be overriden where needed
	endrem
	Method Remove()
	End Method
	
	
	
	rem
		bbdoc: Resets the animation
		about: This should be overriden where needed and Super.Reset() called as
		part of the overriden version
	endrem
	Method Reset()
		SetFinished(False)
	End Method
	
	
	
	rem
		bbdoc: Sets a callback function for the animation
		about: This callback function is called when the animation has completed
		as part of the IsFinished() method
	endrem
	Method SetCallBack(callbackFunction())
		_callbackFunction = callbackFunction
	End Method

	
	
	rem
		bbdoc: Set whether this animation is finished or not
	endrem
	Method SetFinished(bool:Int = True)
		_finished = bool
	End Method
		
	
	
	rem
		bbdoc: Update the animation
		about: Child classes need to override this abstract method to perform
		their animation updates
	endrem
	Method Update:Int(sprite:TActor) Abstract
	
End Type
