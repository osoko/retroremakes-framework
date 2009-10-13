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
	bbdoc: Sprite animation style for looping image frame animations.
	about: Allows you to loop the animation of frames of an AnimImage
	at a set speed and direction 1 or more times.
End Rem
Type TLoopedFrameAnimation Extends TAnimation
	Const DEFAULT_LOOP_COUNT:Int = -1 '-1 = forever
	Const DEFAULT_SPEED:Int = 60
	Const DEFAULT_FIRST_FRAME:Float = 0
	Const DEFAULT_DIRECTION:Int = 1 ' 1 = forwards, -1 = backwards
	
	Field nLoops:Int
	
	Field direction:Int
	Field speed:Int ' in fps
	Field firstFrame:Float
	Field currentFrame:Float
	Field framesPerUpdate:Float
	
	Field animations:TList
	Field finishedAnimations:TList
	
	Field loopsRemaining:Int
	
	Method New()
		nLoops = DEFAULT_LOOP_COUNT
		speed = DEFAULT_SPEED
		direction = DEFAULT_DIRECTION
		firstFrame = DEFAULT_FIRST_FRAME
		currentFrame = firstFrame
		loopsRemaining = nLoops
	End Method
	
	Method SetLoops(nLoops:Int)
		Self.nLoops = nLoops
		Self.loopsRemaining = nLoops
	End Method

	Method SetSpeed(speed:Int)
		Self.speed = speed
	End Method
	
	Method SetDirection(direction:Int)
		Self.direction = direction
	End Method
	
	Method SetFirstFrame(frame:Float)
		firstFrame = frame
		currentFrame = frame
	End Method
	
	Method LoopAnimation:Int(sprite:TActor)
		Local finished:Int = False
		If loopsRemaining > 0
			loopsRemaining:-1
		ElseIf loopsRemaining = 0
			'We're finished
			finished = True
		End If
		If direction = 1
			currentFrame:-TImageActor(sprite).GetFrameCount()
		ElseIf direction = -1
			currentFrame:+TImageActor(sprite).GetFrameCount()
		End If
		Return finished
	End Method
			
	Method Reset()
		currentFrame = firstFrame
		loopsRemaining = nLoops
		Super.Reset()
	End Method
	
	Method Update:Int(sprite:TActor)
		If Not framesPerUpdate
			CalculateFramesPerUpdate()
		EndIf
		currentFrame:+framesPerUpdate
		If currentFrame >= TImageActor(sprite).GetFrameCount() Or currentFrame < 0
			isFinished = LoopAnimation(sprite)
		End If
		TImageActor(sprite).SetCurrentFrame(currentFrame)
		Return Finished()
	End Method

	Method CalculateFramesPerUpdate()
		framesPerUpdate = speed / TFixedTimestep.GetInstance().GetUpdateFrequency()
		If direction = -1
			framesPerUpdate = -framesPerUpdate
		End If
	End Method
End Type
