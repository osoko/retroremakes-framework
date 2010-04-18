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
	bbdoc:customizable particle
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
	Field settingsLength:Int = 9
		
	
	
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
		_color.Update()
		_alpha.Update()

		'run Update() in TParticleActor
		Super.Update()
		
	End Method
	
	
	
	rem
	bbdoc: Sets reference to image
	about: Called by the library for post processing.
	endrem
	Method SetImage()
	
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
				
		slice = settings[index..index + 6]
		_rotation.ImportSettings(slice)
		
		index:+7
		slice = settings[index..index + 6]
		_alpha.ImportSettings(slice)
		
		index:+7
		slice = settings[index..index + 6]
		_sizeX.ImportSettings(slice)
		
		index:+7
		slice = settings[index..index + 6]
		_sizeY.ImportSettings(slice)
		
		index:+7
'		_color.ImportSettings(slice)
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
		If p._imageFrame = -1 Then p._imageFrame = Rand(0, _image.frames.Length)		' -1 is a random frame
		p._friction = _friction
		p._life = _life
		p._blendMode = _blendMode
		
		p._color = _color.Clone()
		p._rotation = _rotation.Clone()
		p._alpha = _alpha.Clone()
		p._sizeX = _sizeX.Clone()
		p._sizeY = _sizeY.Clone()
		
		Return p
	End Method
	
End Type

