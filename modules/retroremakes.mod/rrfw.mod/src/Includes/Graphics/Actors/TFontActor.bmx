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
	bbdoc: Sprite class using an internal BlitzMax #TImageFont
End Rem
Type TFontActor Extends TActor

	Field font:TImageFont
	
	Field text:String
	Field width:Float
	Field height:Float
	Field midWidth:Float
	Field midHeight:Float
	Field midHandle:Int

	Method SetFont(font:TImageFont)
		Self.font = font
	End Method
	
	Method SetText(value:String)
		text = value
		midWidth = 0.0
		midHeight = 0.0
	End Method
	
	Method SetMidHandle(bool:Int)
		midHandle = bool
	End Method
	
	Method Render(tweening:Double, fixed:int)
		Interpolate(tweening)
		SetRenderState()
		If font And IsVisible()
			Local xOffset:Float = 0.0
			Local yOffset:Float = 0.0
			SetImageFont(font)
			If midHandle
				If midWidth = 0.0 And midHeight = 0.0
					midWidth = (TextWidth(text) * xScale) / 2.0
					midHeight = (TextHeight(text) * yScale) / 2.0
				End If
				xOffset = midWidth * GetXScale()
				yOffset = midHeight * GetYScale()
			End If
			If fixed
				DrawText(text, Int(renderPosition.x - xOffset), Int(renderPosition.y - yOffset))
			Else
				DrawText(text, renderPosition.x - xOffset, renderPosition.y - yOffset)
			EndIf
		EndIf
	End Method

End Type
