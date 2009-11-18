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

rem
	bbdoc: Save and restore various render settings
	about: Simple stack based method of saving and restoring various render
	settings.
endrem
Type TRenderState

	' Stack used to store render states
	Global g_renderStates:TStack = TStack.Create(5, 5)
	
	' The alpha value
	Field _alpha:Float
	
	' The blend mode value
	Field _blend:Int
	
	' The RGB Cls Colour values
	Field _clsColourR:Int
	Field _clsColourG:Int
	Field _clsColourB:Int
	
	' The RGB Colour values
	Field _colourR:Int
	Field _colourG:Int
	Field _colourB:Int
	
	' The drawing handle values
	Field _handleX:Float
	Field _handleY:Float
	
	' The TImageFont used
	Field _imageFont:TImageFont
	
	' The RGB Mask values
	Field _maskColourR:Int
	Field _maskColourG:Int
	Field _maskColourB:Int
	
	' The origin position values
	Field _originX:Float
	Field _originY:Float
	
	' The rotation value
	Field _rotation:Float
	
	' The scale values
	Field _scaleX:Float
	Field _scaleY:Float
	
	' The viewport values
	Field _viewportX:Int
	Field _viewportY:Int
	Field _viewportWidth:Int
	Field _viewportHeight:Int


	
	rem
		bbdoc: Clears the stack
	endrem
	Function Clear()
		If g_renderStates Then g_renderStates.Clear()
	End Function
	
	
	
	rem
		bbdoc: Pop the last render state off the stack
		about: Takes the values from the #TRenderState popped off the stack and resets the
		render state using the @SetAlpha, @SetBlend, @SetClsColor,
		@SetColor, @SetHandle, @SetImageFont, @SetMaskColor, @SetOrigin, @SetRotation
		and @SetScale functions
	endrem
	Function Pop()
		If Not TRenderState.g_renderStates Then Return

		If Not TRenderState.g_renderStates.GetSize() > 0 Then Return
		
		Local renderState:TRenderState = TRenderState(TRenderState.g_renderStates.Pop())
		
		If renderState
			SetAlpha(renderState._alpha)
			
			SetBlend(renderState._blend)
			
			SetClsColor(renderState._clsColourR, renderState._clsColourG, renderState._clsColourB)
			
			SetColor(renderState._colourR, renderState._colourG, renderState._colourB)
			
			SetHandle(renderState._handleX, renderState._handleY)
			
			SetImageFont(renderState._imageFont)
			
			SetMaskColor(renderState._maskColourR, renderState._maskColourG, renderState._maskColourB)
			
			SetOrigin(renderState._originX, renderState._originY)
			
			SetRotation(renderState._rotation)
			
			SetScale(renderState._scaleX, renderState._scaleY)
			
			SetViewport(renderState._viewportX, renderState._viewportY, renderState._viewportWidth, renderState._viewportHeight)
		End If
	End Function

	
		
	rem
		bbdoc: Push the current render state onto the stack
		about: Stores the values retrieved from @GetAlpha, @GetBlend, @GetClsColor,
		@GetColor, @GetHandle, @GetImageFont, @GetMaskColor, @GetOrigin, @GetRotation
		and @GetScale
	endrem
	Function Push()
		Local renderState:TRenderState = New TRenderState
		
		renderState._alpha = GetAlpha()
		
		renderState._blend = GetBlend()
		
		GetClsColor(renderState._clsColourR, renderState._clsColourG, renderState._clsColourB)
		
		GetColor(renderState._colourR, renderState._colourG, renderState._colourB)
		
		GetHandle(renderState._handleX, renderState._handleY)
		
		renderState._imageFont = GetImageFont()
		
		GetMaskColor(renderState._maskColourR, renderState._maskColourG, renderState._maskColourB)
		
		GetOrigin(renderState._originX, renderState._originY)
		
		renderState._rotation = GetRotation()
		
		GetScale(renderState._scaleX, renderState._scaleY)
		
		GetViewport(renderState._viewportX, renderState._viewportY, renderState._viewportWidth, renderState._viewportHeight)

		TRenderState.g_renderStates.Push(renderState)
	End Function

End Type



rem
	bbdoc: Pop the last render state off the stack
	about: Takes the values from the #TRenderState popped off the stack and resets the
	render state using the @SetAlpha, @SetBlend, @SetClsColor,
	@SetColor, @SetHandle, @SetImageFont, @SetMaskColor, @SetOrigin, @SetRotation
	and @SetScale functions
endrem
Function rrPopRenderState()
	TRenderState.Pop()
End Function



rem
	bbdoc: Push the current render state onto the stack
	about: Stores the values retrieved from @GetAlpha, @GetBlend, @GetClsColor,
	@GetColor, @GetHandle, @GetImageFont, @GetMaskColor, @GetOrigin, @GetRotation
	and @GetScale
endrem
Function rrPushRenderState()
	TRenderState.Push()
End Function
