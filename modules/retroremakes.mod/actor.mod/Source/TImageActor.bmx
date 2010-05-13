rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Rem
	bbdoc: Actor class using an internal BlitzMax #TImage
End Rem
Type TImageActor Extends TActor

	' The current frame we will display
	Field _currentFrame:Int
	
	' The actual TImage to use for this actor
	Field _texture:TImage


	
	rem
		bbdoc: Get the number of frames this image actor has
	endrem		
	Method FrameCount:Int()
		If _texture
			Return _texture.frames.Length
		Else
			Return Null
		End If
	End Method
	
	
	
	rem
		bbdoc: Get the current frame
	endrem
	Method GetCurrentFrame:Int()
		Return _currentFrame
	End Method
	
	
	
	rem
		bbdoc: Get the TImage that this image actor is using
	endrem
	Method GetTexture:TImage()
		If _texture
			Return _texture
		Else
			Return Null
		End If
	End Method
	

	
	' Default constructor	
	Method New()
		_currentFrame = 0
		_texture = Null
	End Method
	
	

	rem
		bbdoc: Pick a random first image frame that this actor will use
	endrem	
	Method RandomFirstFrame()
		If _texture
			_currentFrame = Rnd(0, FrameCount() - 1)
		End If
	End Method
	
	
	
	rem
		bbdoc: Render this image actor
	endrem
	Method Render(tweening:Double, fixed:int)
		Interpolate(tweening)
		SetRenderState()
		If _texture And IsVisible()
			Local renderPosition:TVector2D = GetRenderPosition()
			If fixed
				DrawImage(_texture, Int(renderPosition.x), Int(renderPosition.y), _currentFrame)
			else
				DrawImage(_texture, renderPosition.x, renderPosition.y, _currentFrame)
			endif
		EndIf
	End Method
		
	
	
	rem
		bbdoc: Set the current image frame this actor will use
	endrem
	Method SetCurrentFrame(frame:Int)
		If Not _texture Then Return
		
		If frame >= 0 And frame < FrameCount()
			_currentFrame = frame
		EndIf
	End Method

	
	
	rem
		bbdoc: Set the TImage texture this image actor will use
	endrem
	Method SetTexture(texture:TImage)
		_texture = texture
	End Method
	
End Type
