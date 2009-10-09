rem
	TODO: Viewport disabled as it was messing with the projection matrix for some
	reason. Need to find out why
endrem

rem
bbdoc: Save and restore various render settings
about: Simple stack based method of saving and restoring various render settings
endrem
Type TRenderState

	rem
	bbdoc: Stack used to store render states
	endrem
	Global renderStateStack:TStack = New TStack
	
	Field alpha:Float
	Field blend:Int
	Field clsColourR:Int, clsColourG:Int, clsColourB:Int
	Field colourR:Int, colourG:Int, colourB:Int
	Field handleX:Float, handleY:Float
	Field imageFont:TImageFont
	Field maskColourR:Int, maskColourG:Int, maskColourB:Int
	Field originX:Float, originY:Float
	Field rotation:Float
	Field scaleX:Float, scaleY:Float
'	Field viewportX:Int, viewportY:Int, viewportWidth:Int, viewportHeight:Int

	rem
	bbdoc: Push the current render state onto the stack
	returns:
	about: Stores the values retrieved from @GetAlpha, @GetBlend, @GetClsColor,
	@GetColor, @GetHandle, @GetImageFont, @GetMaskColor, @GetOrigin, @GetRotation
	and @GetScale
	endrem
	Function Push()
		Local state:TRenderState = New TRenderState
		state.alpha = GetAlpha()
		state.blend = GetBlend()
		GetClsColor(state.clsColourR, state.clsColourG, state.clsColourB)
		GetColor(state.colourR, state.colourG, state.colourB)
		GetHandle(state.handleX, state.handleY)
		state.imageFont = GetImageFont()
		GetMaskColor(state.maskColourR, state.maskColourG, state.maskColourB)
		GetOrigin(state.originX, state.originY)
		state.rotation = GetRotation()
		GetScale(state.scaleX, state.scaleY)
'		GetViewport(state.viewportX, state.viewportY, state.viewportWidth, state.viewportHeight)
		renderStateStack.Push(state)
	End Function

	rem
	bbdoc: Pop the last render state off the stack
	returns:
	about: Takes the values from the #TRenderState popped off the stack and resets the
	render state using the @SetAlpha, @SetBlend, @SetClsColor,
	@SetColor, @SetHandle, @SetImageFont, @SetMaskColor, @SetOrigin, @SetRotation
	and @SetScale functions
	endrem
	Function Pop()
		If Not renderStateStack.Count() > 0 Then Return
		Local State:TRenderState = TRenderState(renderStateStack.Pop())
		If State
			SetAlpha(State.Alpha)
			SetBlend(state.blend)
			SetClsColor(state.clsColourR, state.clsColourG, state.clsColourB)
			SetColor(state.colourR, state.colourG, state.colourB)
			SetHandle(state.handleX, state.handleY)
			SetImageFont(state.imageFont)
			SetMaskColor(state.maskColourR, state.maskColourG, state.maskColourB)
			SetOrigin(state.originX, state.originY)
			SetRotation(state.rotation)
			SetScale(state.scaleX, state.scaleY)
	'		SetViewport(state.viewportX, state.viewportY, state.viewportHeight, state.viewportWidth)			
		End If
	End Function

End Type

rem
bbdoc: Push the current render state onto the stack
returns:
about: Stores the values retrieved from @GetAlpha, @GetBlend, @GetClsColor,
@GetColor, @GetHandle, @GetImageFont, @GetMaskColor, @GetOrigin, @GetRotation
and @GetScale
endrem
Function rrPushRenderState()
	TRenderState.Push()
End Function

rem
bbdoc: Pop the last render state off the stack
returns:
about: Takes the values from the #TRenderState popped off the stack and resets the
render state using the @SetAlpha, @SetBlend, @SetClsColor,
@SetColor, @SetHandle, @SetImageFont, @SetMaskColor, @SetOrigin, @SetRotation
and @SetScale functions
endrem
Function rrPopRenderState()
	TRenderState.Pop()
End Function
