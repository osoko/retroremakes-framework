Rem
'
' Copyright (c) 2007-2009 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Const HANDLE_CENTER:Int = 100
Const HANDLE_TOP:Int = 101
Const HANDLE_BOTTOM:Int = 102
Const HANDLE_LEFT:Int = 103
Const HANDLE_RIGHT:Int = 104

Type TParticleImage

	'#region ENGINE
	
	Method SettingsFromStream(s:TStream)
		Local l:String, a:String[]
		l = s.ReadLine()
		l.Trim()
		While l <> "#endimage"
			a = l.split("=")
			Select a[0]
				Case "id"			_id = a[1]
				Case "imagepath"	_imageFilename = a[1]
				Case "framex"		_frameDimensionX = Int( a[1] )
				Case "framey"		_frameDimensionY = Int( a[1] )
				Case "count"		_frameCount = Int( a[1] )
				Case "handle"		_handlePoint = Int( a[1] )

			End Select
			l = s.ReadLine()
			l.Trim()
		Wend
		_LoadImageFile()
	End Method

	Method GetImage:TImage()
		Return _image
	End Method

	Method SetHandlePoint()
		Select _handlePoint
			Case HANDLE_CENTER	SetImageHandle( _image, _image.width/2, _image.height/2)
			Case HANDLE_TOP 	SetImageHandle( _image, _image.width/2, 0)
			Case HANDLE_BOTTOM	SetImageHandle( _image, _image.width/2, _image.height)
			Case HANDLE_LEFT	SetImageHandle( _image, 0, _image.height/2)
			Case HANDLE_RIGHT	SetImageHandle( _image, _image.width, _image.height/2)
		End Select
	End Method

	Method _LoadImageFile()
 		If _frameCount > 0
			_image = LoadAnimImage( _imageFilename, _frameDimensionX, _frameDimensionY, 0, _frameCount )
		Else
			_image = LoadImage( _imageFilename )
 		End If
		If _image = Null Then RuntimeError _imageFilename
		Self.SetHandlePoint()
	End Method
	
'	Method Draw(x:Float, y:Float)
'		DrawImage(_image, x, y)
'	End Method

	Field _id:String
	Field _image:TImage
	Field _imageFilename:String
	Field _frameCount:Int
	Field _frameDimensionX:Int
	Field _frameDimensionY:Int
	Field _handlePoint:Int
End Type
