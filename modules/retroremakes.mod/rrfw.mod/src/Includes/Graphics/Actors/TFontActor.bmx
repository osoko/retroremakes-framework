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
	bbdoc: Actor class using an internal BlitzMax #TImageFont
End Rem
Type TFontActor Extends TActor

	Field _font:TImageFont
	Field _midHeight:Float
	Field _midWidth:Float
	Field _text:String
	Field _midHandle:Int

	
	rem
		bbdoc: Get the font that has been set for this actor
		returns: TImageFont
	endrem
	Method GetFont:TImageFont()
		Return _font
	End Method

	
	
	rem
		bbdoc: Return whether this actor is set to midhandle its text
		returns: true if mid-handle is enabled, otherwise false
	endrem
	Method GetMidHandle:Int()
		Return _midHandle
	End Method



	rem
		bbdoc: Get the text that has been set for this actor
		returns: String
	endrem
	Method GetText:String()
		Return _text
	End Method

	
	
	rem
		bbdoc: Renders this font actor
	endrem
	Method Render(tweening:Double, fixed:Int)
		Interpolate(tweening)
		SetRenderState()
		If _font And IsVisible()
			Local xOffset:Float = 0.0
			Local yOffset:Float = 0.0
			SetImageFont(_font)
			If _midHandle
				If _midWidth = 0.0 And _midHeight = 0.0
					' calculate the middle of the text if it hasn't been already
					_midWidth = (TextWidth(_text) * xScale) / 2.0
					_midHeight = (TextHeight(_text) * yScale) / 2.0
				End If
				' take into account any scaling that is enabled
				xOffset = _midWidth * GetXScale()
				yOffset = _midHeight * GetYScale()
			End If
			If fixed
				DrawText(_text, Int(renderPosition.x - xOffset), Int(renderPosition.y - yOffset))
			Else
				DrawText(_text, renderPosition.x - xOffset, renderPosition.y - yOffset)
			EndIf
		EndIf
	End Method
	
	
	
	rem
		bbdoc: Set the TImageFont to use for this font actor
	endrem	
	Method SetFont(value:TImageFont)
		_font = value
	End Method

	
	
	rem
		bbdoc: Set wether this font actor should be mid-handled or not
		about: If a font actor has mid-handle enabled, the font will be rendered centered
		on its current co-ordinates.
	endrem
	Method SetMidHandle(bool:Int)
		_midHandle = bool
	End Method
		
	
	
	rem
		bbdoc: Set the text string that this font actor should display
	endrem
	Method SetText(value:String)
		_text = value
		_midWidth = 0.0
		_midHeight = 0.0
	End Method

End Type
