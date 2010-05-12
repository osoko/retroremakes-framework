Rem
'
' Copyright (c) 2007-2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

rem
	bbdoc: Customizable particle
endrem
Type TParticle Extends TParticleActor

	'id of image in library
	Field _imageID:String

	'image to draw
	Field _image:TImage
	
	'frame from image to draw
	Field _imageFrame:Int
	
	'changeable color over time
	Field _color:TColorValue
	
	'changeable alpha over time
	Field _alpha:TFloatValue

	' length of the array used in import and export settings
	Field settingsLength:Int = 48
	
	
	
	rem
	bbdoc: Default contructor
	endrem	
	Method New()
		_color = New TColorValue
		_alpha = New TFloatValue
	End Method
	
	
	
	rem
	bbdoc: Updates particle
	endrem
	Method Update()

		'run Update() in TParticleActor
		Super.Update()

		_color.Update()
		_alpha.Update()
	End Method
	
	
	
	rem
	bbdoc: Sets reference to image
	about: Called by the library for post processing.
	endrem
	Method SetImage(library:TLibraryConfiguration)
	
		Local i:TParticleImage = TParticleImage(library.GetObject(_imageID))
		_image = i.GetImage()
	End Method

	
	
	rem
	bbdoc: Render particle
	endrem
	Method Render(tweening:Double, fixed:Int = False)
		Interpolate(tweening)

'		Self.SetRenderState()
		brl.max2d.SetAlpha _alpha.GetCurrentValue()
		brl.max2d.SetScale(_sizeX.GetCurrentValue(), _sizeY.GetCurrentValue())
		brl.max2d.SetRotation _rotation.GetCurrentValue()
		brl.max2d.SetBlend _blendMode
		
		_color.Use()

		DrawImage _image, _renderPosition.x, _renderPosition.y, _imageFrame

	End Method
	
	
	
	rem
	bbdoc: Imports particle settings from an string array
	endrem
	Method ImportSettings(settings:String[])
	
		If settings.length <> settingsLength Then Throw "Particle array not complete!"
		If settings[0] <> "particle" Then Throw "Array not a particle array!"
		
		_libraryID = settings[1]
		_editorName = settings[2]
		_description = settings[3]
		_imageID = settings[4]
		_imageFrame = Int(settings[5])
		_friction = Float(settings[6])
		_life = Int(settings[7])
		_blendMode = Int(settings[8])
		
		'slice up array to get float and color arrays
		Local index:Int = 9
		Local slice:String[]
						
		slice = settings[index..index + 7]
		_rotation.ImportSettings(slice)
		
		index:+7
		slice = settings[index..index + 7]
		_alpha.ImportSettings(slice)
		
		index:+7
		slice = settings[index..index + 7]
		_sizeX.ImportSettings(slice)
		
		index:+7
		slice = settings[index..index + 7]
		_sizeY.ImportSettings(slice)
		
		index:+7
		slice = settings[index..index + 11]
		_color.ImportSettings(slice)
	End Method
	
	
	
	rem
	bbdoc: Exports particle settings to string array
	returns: String array
	endrem
	Method ExportSettings:String[] (settings:String[])
		Local array:String[settingsLength]
		array[0] = "particle"
		array[1] = _libraryID
		array[2] = _editorName
		array[3] = _description

		array[4] = String(_imageID)
		array[5] = String(_imageFrame)
		array[6] = String(_friction)
		array[7] = String(_life)
		array[8] = String(_blendMode)
		
		
		Local index:Int = 9
		Local floatSettings:String[] = _rotation.ExportSettings()
		SetArrayValues(floatSettings, array, index)
		
		index:+7
		floatSettings = _alpha.ExportSettings()
		SetArrayValues(floatSettings, array, index)

		index:+7
		floatSettings = _sizeX.ExportSettings()
		SetArrayValues(floatSettings, array, index)
		
		index:+7
		floatSettings = _sizeY.ExportSettings()
		SetArrayValues(floatSettings, array, index)
	
		index:+7
		Local colorSettings:String[] = _color.ExportSettings()
		SetArrayValues(colorSettings, array, index)
	
		Return array

	End Method
	
	
	
	rem
	bbdoc: Passes source array values to destination array, starting at the passed Index
	endrem
	Method SetArrayValues(source:String[], destination:String[], destinationIndex:Int)
		Local sourceIndex:Int
		For sourceIndex = 0 To source.Length - 1
			destination[destinationIndex] = source[sourceIndex]
			destinationIndex:+1
		Next
	End Method

	
	
	rem
	bbdoc: Creates an exact copy of this particle
	returns: TParticle
	endrem
	Method Clone:TParticle()

		Local p:TParticle = New TParticle
		p._description = _description
		p._image = _image
		p._imageID = _imageID
		p._imageFrame = _imageFrame
		
		' -1 is a random frame
		If p._imageFrame = -1 Then p._imageFrame = Rand(0, _image.frames.Length)
		
		p._friction = _friction
		p._life = _life
		p._blendMode = _blendMode
		
		p._rotation = _rotation.Clone()
		p._alpha = _alpha.Clone()
		p._sizeX = _sizeX.Clone()
		p._sizeY = _sizeY.Clone()
		p._color = _color.Clone()
		
		Return p
	End Method
	
End Type

