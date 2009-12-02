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
	bbdoc: Base class for implementing actors
End Rem
Type TActor Extends TRenderable Abstract

	' The animation manager for the actor
	Field _animationManager:TAnimationManager

	' The actors blend mode for rendering
	Field _blendMode:Int
	
	' The actors colour
	Field _colour:TColourRGB

	' The current position of the actor
	Field _currentPosition:TVector2D
	
	' The previous position of the actor
	Field _previousPosition:TVector2D
	
	' The tweened render position of the actor
	Field _renderPosition:TVector2D

	' The rotation of the actor in degrees
	Field _rotation:Float

	' Whether the actor should be visible or not
	Field _visible:Int
	
	' The x-axis scale factor of the actor
	Field _xScale:Float
	
	' The y-axis scale factor of the actor
	Field _yScale:Float

	
	
	rem
		bbdoc: Get the actors animation manager
		returns: TAnimationManager
	endrem
	Method GetAnimationManager:TAnimationManager()
		Return _animationManager
	End Method
	
	
	
	rem
		bbdoc: Get the actors blend mode
	endrem
	Method GetBlendMode:Int()
		Return _blendMode
	End Method
	
	
	
	rem
		bbdoc: Get the actors colour
		returns: TColourRGB
	endrem
	Method GetColour:TColourRGB()
		Return _colour
	End Method
	
	

	rem
		bbdoc: Get a vector of the actors current position
	endrem	
	Method GetCurrentPosition:TVector2D()
		Return _currentPosition
	End Method
	
	

	rem
		bbdoc: Get a vector of the actors previous position
		about: Previous position was the actors position during the last update loop
	endrem	
	Method GetPreviousPosition:TVector2D()
		Return _previousPosition
	End Method
	
	

	rem
		bbdoc: Get a vector of the actors render position
		about: The render position is calculated from the actors current
		and previous positions using the fixed timestep tweening value
	endrem	
	Method GetRenderPosition:TVector2D()
		Return _renderPosition
	End Method
	
	
		
	rem
		bbdoc: Get the actors rotation value
	endrem
	Method GetRotation:Float()
		Return _rotation
	End Method
	
	
	
	rem
		bbdoc: Populate the provided variables with the actors axis scale values
	endrem
	Method GetScale(x:Float Var, y:Float Var)
		x = _xScale
		y = _yScale
	End Method
	
	
	
	rem
		bbdoc: Get the actors x-axis scale value
	endrem
	Method GetXScale:Float()
		Return _xScale
	End Method
	

	
	rem
		bbdoc: Get the actors y-axis scale value
	endrem
	Method GetYScale:Float()
		Return _yScale
	End Method

	
	
	rem
	bbdoc: Interpolate between previous and current positions
	returns:
	about: Uses the tweening value from the TFixedTimeStep service to interpolate
	between the previous and current positions and using that as a render position
	for the sprite.  This has the effect of smoothing out any timing anomalies.
	endrem
	Method Interpolate(tweening:Double)
		_renderPosition.x = Double(_currentPosition.x) * tweening + ..
			Double(_previousPosition.x) * (1.0:Double - tweening)
		
		_renderPosition.y = Double(_currentPosition.y) * tweening + ..
			Double(_previousPosition.y) * (1.0:Double - tweening)
	End Method
	
	

	rem
		bbdoc: Returns whether this actor is set to be visible or not
	endrem	
	Method IsVisible:Int()
		Return _visible
	End Method
	
	
	
	rem
		bbdoc: Move the actor by the specified amounts
	endrem
	Method Move(x:Float, y:Float)
		_currentPosition.x:+x
		_currentPosition.y:+y
	End Method
	
	
	
	rem
		bbdoc: Move the actor by the specified 2D vector
	endrem	
	Method MoveV(moveVector:TVector2D)
		_currentPosition = rrVAdd(_currentPosition, moveVector)
	End Method
	
	
	
	' Default constructor		
	Method New()
		_animationManager = New TAnimationManager
		_animationManager.SetActor(Self)

		_blendMode = brl.max2d.GetBlend()
		_colour = New TColourRGB
		_currentPosition = New TVector2D
		_previousPosition = New TVector2D
		_renderPosition = New TVector2D
		_visible = True
		_xScale = 1.0
		_yScale = 1.0
	End Method

	

	rem
		bbdoc: Render the actor
		about: This abstract method needs to be overriden by derived classes
	endrem
	Method Render(tweening:Double, fixed:Int) Abstract
				
				

	rem
		bbdoc: Set the blend mode to use for the actor
		about: Uses standard BlitzMax blend mode values
	endrem	
	Method SetBlendMode(value:Int)
		If value > 0 And value < 6
			_blendMode = value
		Else
			rrThrow "Unsupported Blend Mode: " + value
		End If
	End Method
	
	
	
	rem
		bbdoc: Set the actors colour
	endrem
	Method SetColour(value:TColourRGB)
		_colour = value
	End Method
	
	
	
	rem
		bbdoc: Resets the actors position to that specified
		about: This also updates the actors previous position to avoid
		flickers caused by the render tweening and possibly large changes
		in position. Use this if you are, for example, wrapping an actor
		from one side of the screen to another
	endrem
	Method ResetPosition(x:Float, y:Float)
		_currentPosition.x = x
		_currentPosition.y = y
		_previousPosition.x = x
		_previousPosition.y = y
	End Method
		
	
	
	rem
		bbdoc: Update the current position of the actor
	endrem
	Method SetPosition(x:Float, y:Float)
		_currentPosition.x = x
		_currentPosition.y = y
	End Method

	
	
	rem
		bbdoc: Sets the actors render state prior to drawing it
	endrem			
	Method SetRenderState()
		_colour.Set()
		brl.max2d.SetScale(_xScale, _yScale)
		brl.max2d.SetRotation(_rotation)
		brl.max2d.SetBlend(_blendMode)
	End Method
	
	
	
	rem
		bbdoc: Set the rotation for the actor in degrees
	endrem
	Method SetRotation(value:Float)
		_rotation = value		
	End Method
	
	
	
	rem
		bbdoc: Set the x and y-axis scale values for the actor
	endrem
	Method SetScale(x:Float, y:Float)
		_xScale = x
		_yScale = y
	End Method
	
	
	
	rem
		bbdoc: Set whether this actor should be visible or not
		about: True = visible, False = invisible
	endrem
	Method SetVisible(value:Int = True)
		_visible = value
	End Method
	
	
	
	rem
		bbdoc: Updates the actors previous position and animation manager
	endrem
	Method Update()
		UpdatePreviousPosition()
		_animationManager.Update()
	End Method
	
	
	
	rem
		bbdoc: Updates the actors previous position with its current position
	endrem
	Method UpdatePreviousPosition()
		_previousPosition.x = _currentPosition.x
		_previousPosition.y = _currentPosition.y
	End Method

End Type
