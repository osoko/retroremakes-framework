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

	Field animationManager:TAnimationManager

	Field currentPosition:TVector2D
	Field previousPosition:TVector2D
	Field renderPosition:TVector2D
	
	Field xScale:Float
	Field yScale:Float
	
	Field rotation:Float
	Field colour:TColourRGB
	Field blendMode:Int
	
	Field visible:Int
	
	
	Method GetAnimationManager:TAnimationManager()
		Return animationManager
	End Method
	
	
	
	Method GetBlendMode:Int()
		Return blendMode
	End Method
	
	
	
	Method GetColour:TColourRGB()
		Return colour
	End Method
	
	
	
	Method GetCurrentPosition:TVector2D()
		Return currentPosition
	End Method
	
	
		
	Method GetPreviousPosition:TVector2D()
		Return previousPosition
	End Method
	
	
	
	Method GetRenderPosition:TVector2D()
		Return renderPosition
	End Method
	
	
		
	Method GetRotation:Float()
		Return rotation
	End Method
	
	
	
	Method GetScale(x:Float Var, y:Float Var)
		x = xScale
		y = xScale
	End Method
	
	
	
	Method GetXScale:Float()
		Return xScale
	End Method
	

	
	Method GetYScale:Float()
		Return yScale
	End Method

	
	

	
			
	rem
	bbdoc: Interpolate between previous and current positions
	returns:
	about: Uses the tweening value from the TFixedTimeStep service to interpolate
	between the previous and current positions and using that as a render position
	for the sprite.  This has the effect of smoothing out any timing anomalies.
	endrem
	Method Interpolate(tweening:Double)
		renderPosition.x = Double(currentPosition.x) * tweening + ..
			Double(previousPosition.x) * (1.0:Double - tweening)
		
		renderPosition.y = Double(currentPosition.y) * tweening + ..
			Double(previousPosition.y) * (1.0:Double - tweening)
	End Method
	
	
	
	Method IsVisible:Int()
		Return visible
	End Method
	
	
	
	Method Move(x:Float, y:Float)
		currentPosition.x:+x
		currentPosition.y:+y
	End Method
	
	
		
	Method MoveV(moveVector:TVector2D)
		currentPosition = rrVAdd(currentPosition, moveVector)
	End Method
	
	
			
	Method New()
		currentPosition = New TVector2D
		previousPosition = New TVector2D
		renderPosition = New TVector2D
		colour = New TColourRGB
		visible = True
		blendMode = brl.max2d.GetBlend()
		xScale = 1.0
		yScale = 1.0
		
		animationManager = New TAnimationManager
		animationManager.SetActor(Self)
	End Method

	
	
	Method Remove()
		animationManager.Remove()
		animationManager = Null
	End Method
	
	
	
	Method Render(tweening:Double, fixed:int) Abstract
				
				
	
	Method SetBlendMode(value:Int)
		If value > 0 And value < 6
			blendMode = value
		Else
			Throw "Unsupported Blend Mode: " + value
		End If
	End Method
	
	
	
	Method SetColour(value:TColourRGB)
		colour = value
	End Method
	
	
	
	Method SetPosition(x:Float, y:Float)
		currentPosition.x = x
		currentPosition.y = y
		previousPosition.x = x
		previousPosition.y = y
	End Method
	
	

	Method SetPreviousPosition(position:TVector2D)
		previousPosition = position
	End Method
	
	
			
	Method SetRenderState()
		colour.Set()
		brl.max2d.SetScale(xScale, yScale)
		brl.max2d.SetRotation(Int(rotation))
		brl.max2d.SetBlend(blendMode)
	End Method
	
	
	
	Method SetRotation(value:Float)
		rotation = value		
	End Method
	
	
	
	Method SetScale(x:Float, y:Float)
		xScale = x
		yScale = y
	End Method
	
	
	
	Method SetVisible(value:Int = True)
		visible = value
	End Method
	
	
	Method Update()
		previousPosition.x = currentPosition.x
		previousPosition.y = currentPosition.y
		animationManager.Update()
	End Method

End Type
