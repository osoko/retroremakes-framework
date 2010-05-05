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
	bbdoc: Animation style for looping image frame animations.
	about: Allows you to loop the animation of frames of an AnimImage
	at a set speed and direction 1 or more times.
End Rem
Type TLoopedFrameAnimation Extends TAnimation

	' Default animation direction. 1 = forwards, -1 = backwards
	Const DEFAULT_DIRECTION:Int = 1

	' Default first frame
	Const DEFAULT_FIRST_FRAME:Float = 0.0
			
	' Default amount of animation loops to perform. A loop count of -1 = forever
	Const DEFAULT_LOOP_COUNT:Int = -1
	
	' Default animation speed in Frames Per Second
	Const DEFAULT_SPEED:Int = 60


	
	' The current image frame the animation is on
	Field _currentFrame:Float
		
	' The direction to animation in. -1 = backwards, 1 = forwards
	Field _direction:Int

	' The first image frame to use
	Field _firstFrame:Float
				
	' The number of frames to animate per update loop
	Field _framesPerUpdate:Float

	' The number of loops to perform		
	Field _loopCount:Int

	' The number of loops remaining
	Field _loopsRemaining:Int
			
	' The speed the image should animate in frames per second
	Field _speed:Int



	rem
		bbdoc: Calculates how many frames to process per update loop
		about: The requested speed for this animation is in FPS, but
		as our update frequency can be variable we need to use the
		update frequency setting to calculate how many frames to animatre
		per update loop to attain the requested animation speed
	endrem
	Method CalculateFramesPerUpdate()
		_framesPerUpdate = _speed / TFixedTimestep.GetInstance().GetUpdateFrequency()
		If _direction = -1
			_framesPerUpdate = -_framesPerUpdate
		End If
	End Method

	
	
	Rem
		bbdoc:Returns a copy of the animation
	End Rem
	Method Copy:TAnimation()
		Local animation:TLoopedFrameAnimation = New TLoopedFrameAnimation
		animation._direction = _direction
		animation._firstFrame = _firstFrame
		animation._loopCount = _loopCount
		animation._speed = _speed
		animation.Reset()
		Return animation
	End Method

	
	
	rem
		bbdoc: Loops the animation
		about: If there are still loops remaining to be performed
		this will loop the frame count. Returns True if the animation
		has finished
	endrem	
	Method LoopAnimation:Int(actor:TActor)
		Local finished:Int = False

		If _loopsRemaining > 0
			_loopsRemaining:-1
		ElseIf _loopsRemaining = 0
			finished = True
		End If

		If _direction = 1
			_currentFrame:-TImageActor(actor).FrameCount()
		ElseIf _direction = -1
			_currentFrame:+TImageActor(actor).FrameCount()
		End If

		Return finished
	End Method
		
	
	
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		_currentFrame = DEFAULT_FIRST_FRAME
		_direction = DEFAULT_DIRECTION
		_firstFrame = DEFAULT_FIRST_FRAME
		_loopsRemaining = DEFAULT_LOOP_COUNT
		_loopCount = DEFAULT_LOOP_COUNT
		_speed = DEFAULT_SPEED
	End Method

	
	
	rem
		bbdoc: Resets the animation to starting values
	endrem
	Method Reset()
		_currentFrame = _firstFrame
		_loopsRemaining = _loopCount
		Super.Reset()
	End Method
	
	
	
	rem
		bbdoc: Sets the direction the animation should loop in
		about: 1 = forwards, -1 = backwards
	endrem
	Method SetDirection(value:Int)
		If Abs(value) = 1
			_direction = value
		EndIf
	End Method

	
	
	rem
		bbdoc: Sets the first image frame to use when the animation starts
	endrem
	Method SetFirstFrame(frame:Float)
		_firstFrame = frame
		_currentFrame = frame
	End Method
	
	
	
	rem
		bbdoc: Set the number of times to loop the animation
		about: A value of -1 will loop the animation forever
	endrem		
	Method SetLoopCount(count:Int)
		If count > 0 Or count = -1
			_loopCount = count
			_loopsRemaining = _loopCount
		Else
			Throw "Loop count must be -1 or > 0"
		EndIf
	End Method

	
	
	rem
		bbdoc: Set the animation speed
		about: This value is in actual frames per second
	endrem
	Method SetSpeed(fps:Int)
		_speed = fps
	End Method
	
	
	
	rem
		about: Update the animation
	endrem
	Method Update:Int(actor:TActor)
	
		If Not _framesPerUpdate
			CalculateFramesPerUpdate()
		EndIf
		
		_currentFrame:+_framesPerUpdate
		
		If _currentFrame >= TImageActor(actor).FrameCount() Or _currentFrame < 0
			SetFinished(LoopAnimation(actor))
		End If
		
		TImageActor(actor).SetCurrentFrame(_currentFrame)
		
		Return IsFinished()
	End Method

End Type
