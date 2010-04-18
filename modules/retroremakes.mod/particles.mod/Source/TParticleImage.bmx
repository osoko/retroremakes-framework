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

'image handle locations            TODO: change to a descriptive string?
Const HANDLE_CENTER:Int = 100
Const HANDLE_TOP:Int = 101
Const HANDLE_BOTTOM:Int = 102
Const HANDLE_LEFT:Int = 103
Const HANDLE_RIGHT:Int = 104

rem
bbdoc: Image type used by particles
about: Not extended from TParticleActor because object is never live in the engine.
endrem
Type TParticleImage

	'id in library
	Field _libraryID:String
	
	'friendly name in editor
	Field _editorName:String
	
	'handy text
	Field _description:String
	
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
	
	' length of the array used in import and export settings
	Field settingsLength:Int = 9

	
	
	rem
	bbdoc: Sets ID of this object
	endrem
	Method SetID(newID:String)
		_libraryID = newID
	End Method
	
	
	
	rem
	bbdoc: Returns this objects' ID
	endrem
	Method GetID:String()
		Return _libraryID
	End Method
	
	
	
	rem
	bbdoc: Sets editor name
	endrem
	Method SetEditorName(name:String)
		_editorName = name
	End Method

		

	rem
	bbdoc: Returns this objects' editorname
	endrem
	Method GetEditorName:String()
		Return _editorName
	End Method

	
	
	rem
	bbdoc: Sets description text
	endrem
	Method SetDescription(name:String)
		_description = name
	End Method

		

	rem
	bbdoc: Returns this objects' description text
	endrem
	Method GetDescription:String()
		Return _description
	End Method	
	
	
	
	rem
	bbdoc: Returns the image contained in this type
	endrem
	Method GetImage:TImage()
		If Not _image Throw "No Image present!"
		Return _image
	End Method
	
	
	
	rem
	bbdoc: Imports image settings from an string array
	endrem
	Method ImportSettings(settings:String[])
		If settings.length <> settingsLength Then Throw "Image array not complete!"
		
		_libraryID = settings[1]
		_editorName = settings[2]
		_description = settings[3]
		_imageFilename = settings[4]
		_frameCount = Int(settings[5])
		_frameDimensionX = Int(settings[6])
		_frameDimensionY = Int(settings[7])
		_handlePoint = Int(settings[8])
	End Method
	
	
	
	rem
	bbdoc: Exports image settings to a string array
	endrem
	Method ExportSettings:String[] ()
		Local settings:String[8]
		settings[0] = "image"
		settings[1] = _libraryID
		settings[2] = _editorName
		settings[3] = _description
		settings[4] = _imageFilename
		settings[5] = String(_frameCount)
		settings[6] = String(_frameDimensionX)
		settings[7] = String(_frameDimensionY)
		settings[8] = String(_handlePoint)
		Return settings
	End Method
	
	
	
	rem
	bbdoc: Loads the image file as configured
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
