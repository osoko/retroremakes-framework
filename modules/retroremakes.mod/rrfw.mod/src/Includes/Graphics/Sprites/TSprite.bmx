'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TSprite Abstract

	Field animationManager_:TSpriteAnimationManager
	
	Field spriteListLink:TLink

	Field currentPosition_:TVector2D
	Field previousPosition_:TVector2D
	Field renderPosition_:TVector2D

	Field zDepth_:Int
		
	'Field scale_:TVector2D
	
	Field xScale_:Float
	Field yScale_:Float
	
	Field rotation_:Float
	Field colour_:TColourRGB
	Field blendMode_:Int
	
	Field isVisible_:Int
	
	
	Method GetAnimationManager:TSpriteAnimationManager()
		Return animationManager_
	End Method
	
	
	
	Method GetBlendMode:Int()
		Return blendMode_
	End Method
	
	
	
	Method GetColour:TColourRGB()
		Return colour_
	End Method
	
	
	
	Method GetCurrentPosition:TVector2D()
		Return currentPosition_
	End Method
	
	
		
	Method GetPreviousPosition:TVector2D()
		Return previousPosition_
	End Method
	
	
	
	Method GetRenderPosition:TVector2D()
		Return renderPosition_
	End Method
	
	
		
	Method GetRotation:Float()
		Return rotation_
	End Method
	
	
	
	Method GetScale(x:Float Var, y:Float Var)
		x = xScale_
		y = xScale_
	End Method
	
	
	
	Method GetXScale:Float()
		Return xScale_
	End Method
	

	
	Method GetYScale:Float()
		Return yScale_
	End Method

	
	
	Method GetZDepth:Int()
		return zDepth_
	End Method
	
			
	rem
	bbdoc: Interpolate between previous and current positions
	returns:
	about: Uses the tweening value from the TFixedTimeStep service to interpolate
	between the previous and current positions and using that as a render position
	for the sprite.  This has the effect of smoothing out any timing anomalies.
	endrem
	Method Interpolate(tweening:Double)
		renderPosition_.x = double(currentPosition_.x) * tweening + ..
			double(previousPosition_.x) * (1.0:double - tweening)
		
		renderPosition_.y = double(currentPosition_.y) * tweening + ..
			double(previousPosition_.y) * (1.0:double - tweening)
	End Method
	
	
	
	Method IsVisible:Int()
		Return isVisible_
	End Method
	
	
	
	Method MoveSprite(x:Float, y:Float)
		currentPosition_.x:+x
		currentPosition_.y:+y
	End Method
	
	
		
	Method MoveSpriteV(moveVector:TVector2D)
		currentPosition_ = rrVAdd(currentPosition_, moveVector)
	End Method
	
	
			
	Method New()
		currentPosition_ = New TVector2D
		previousPosition_ = New TVector2D
		renderPosition_ = New TVector2D
		colour_ = New TColourRGB
		isVisible_ = True
		blendMode_ = GetBlend()
		xScale_ = 1.0
		yScale_ = 1.0
		
		animationManager_ = New TSpriteAnimationManager
		animationManager_.SetSprite(Self)
	End Method

	
	
	Method Remove()
		animationManager_.Remove()
		animationManager_ = Null
	End Method
	
	
	
	Method Render(tweening:Double, fixed:int) Abstract
				
				
	
	Method SetBlendMode(blendMode:Int)
		If blendMode > 0 And blendMode < 6
			blendMode_ = blendMode
		Else
			Throw "Unsupported Blend Mode: " + blendMode
		End If
	End Method
	
	
	
	Method SetColour(colour:TColourRGB)
		colour_ = colour
	End Method
	
	
	
	Method SetPosition(x:Float, y:Float)
		currentPosition_.x = x
		currentPosition_.y = y
		previousPosition_.x = x
		previousPosition_.y = y
	End Method
	
	

	Method SetPreviousPosition(position:TVector2D)
		previousPosition_ = position
	End Method
	
	
			
	Method SetRenderState()
		colour_.Set()
		brl.max2d.SetScale(xScale_, yScale_)
		brl.max2d.SetRotation(Int(rotation_))
		brl.max2d.SetBlend(blendMode_)
	End Method
	
	
	
	Method SetRotation(rotation:Float)
		rotation_ = rotation		
	End Method
	
	
	
	Method SetScale(x:Float, y:Float)
		xScale_ = x
		yScale_ = y
	End Method
	
	
	
	Method SetVisible(visible:Int = True)
		isVisible_ = visible
	End Method
	
	
	
	Method SetZDepth(zDepth:Int)
		zDepth_ = zDepth
	End Method
	
	
	
	Method Update()
		animationManager_.Update()
	End Method

End Type
