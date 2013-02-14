Rem
'
' Copyright (c) 2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

'image handle locations
Const HANDLE_CENTER:Int = 0
Const HANDLE_TOP:Int = 1
Const HANDLE_BOTTOM:Int = 2
Const HANDLE_LEFT:Int = 3
Const HANDLE_RIGHT:Int = 4



rem
bbdoc: Image type used by particles
endrem
Type TParticleImage Extends TParticleActor
	
	'the actual image
	Field _image:TImage
	
	'full path to image
	Field _imageFilename:String
	
	'frames in the image
	Field _frameCount:Int
	
	'frame sizes
	Field _frameDimensionX:Int
	Field _frameDimensionY:Int
	
	'image center
	Field _handlePoint:Int

	
	Method Render(tweening:Double, fixed:Int)
	End Method
	
	
	
	rem
	bbdoc: Returns the image contained in this type
	endrem
	Method GetImage:TImage()
		If Not _image Throw "No Image present!"
		Return _image
	End Method
	
	
	
	rem
	bbdoc: Sets image file name path
	endrem	
	Method SetImageFileName(filename:String)
		_imageFilename = filename
	End Method
	
	
	
	rem
	bbdoc: Returns image file name path
	endrem
	Method GetImageFileName:String()
		Return _imageFilename
	End Method
	
	
	
	rem
	bbdoc: Imports settings from a stream
	endrem	
	Method ReadPropertiesFromStream:Int(stream:TStream)
	
		Local value:String[]
		Local line:String
		
		line = ReadLine(stream).Trim()
		line.ToLower()
	
		While line <> "[end image]"
		
			value = line.Split("=")
			
			Select value[0]
				Case "id"
					_libraryID = Int(value[1])
				Case "name"
					_editorName = value[1]
				Case "description"
					_description = value[1]
				Case "filename"
					_imageFilename = value[1]
				Case "framecount"
					_frameCount = Int(value[1])
				Case "framedimensionX"
					_frameDimensionX = Int(value[1])
				Case "framedimensionY"
					_frameDimensionY = Int(value[1])
				Case "handlepoint"
					_handlePoint = Int(value[1])
				Case "", "[image]"
				Default
					Return False
'					Throw "" + value[0] + " is not a recognized label"
			End Select
		
			line = ReadLine(stream).Trim()
			line.ToLower()
		Wend
		
		Return _libraryID
	End Method
	
	
	
	rem
	bbdoc: Exports settings to stream
	endrem	
	Method WritePropertiesToStream:Int(stream:TStream)
		WriteLine(stream, "[image]")
		WriteLine(stream, "id=" + String(_libraryID))
		WriteLine(stream, "name=" + _editorName)
		WriteLine(stream, "description=" + _description)
		WriteLine(stream, "filename=" + _imageFilename)
		WriteLine(stream, "framecount=" + String(_frameCount))
		WriteLine(stream, "framedimensionX=" + String(_frameDimensionX))
		WriteLine(stream, "framedimensionY=" + String(_frameDimensionY))
		WriteLine(stream, "handlepoint=" + String(_handlePoint))
		WriteLine(stream, "[end image]")
		Return True
	End Method	
	
	
	
	rem
	bbdoc: Loads the image file as configured. Name etc. must already be set
	endrem
	Method LoadImageFile()
		If _frameCount > 0
			_image = LoadAnimImage(_imageFilename, _frameDimensionX, _frameDimensionY,  ..
				0, _frameCount)
		Else
			_image = LoadImage(_imageFilename)
		End If
		If _image = Null Then Throw "Cannot load: " + _imageFilename
	End Method

	
	
	rem
	bbdoc: Sets image handle to the configured setting
	endrem
	Method SetHandlePoint()
		If Not _image Then Return
		Select _handlePoint
			Case HANDLE_CENTER SetImageHandle(_image, _image.width / 2, _image.height / 2)
			Case HANDLE_TOP SetImageHandle(_image, _image.width / 2, 0)
			Case HANDLE_BOTTOM SetImageHandle(_image, _image.width / 2, _image.height)
			Case HANDLE_LEFT SetImageHandle(_image, 0, _image.height / 2)
			Case HANDLE_RIGHT SetImageHandle(_image, _image.width, _image.height / 2)
		End Select
	End Method

End Type
