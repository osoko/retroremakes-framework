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

rem
	bbdoc: Customizable particle
endrem
Type TParticle Extends TParticleActor

	'id of image in library
	Field _imageID:Int

	'image to draw
	Field _image:TImage
	
	'frame from image to draw
	Field _imageFrame:Int
	
	'changeable color over time
	Field _color:TColorValue
	
	'changeable alpha over time
	Field _alpha:TFloatValue

		
	
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
'	Method SetImage(library:TLibraryConfiguration)
'		Local i:TParticleImage = TParticleImage(library.GetObject(_imageID))
'		_image = i.GetImage()
'	End Method

	
	
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
	bbdoc: Imports settings from a stream
	endrem	
	Method ReadPropertiesFromStream:Int(stream:TStream)
	
		Local value:String[]
		Local line:String
		
		line = ReadLine(stream).Trim()
		line.ToLower()
	
		While line <> "[end particle]"
		
			value = line.Split("=")
			
			Select value[0]
				Case "id"
					_libraryID = Int(value[1])
				Case "name"
					_editorName = value[1]
				Case "description"
					_description = value[1]
				Case "imageid"
					_imageID = Int(value[1])
				Case "imageframe"
					_imageFrame = Int(value[1])
				Case "friction"
					_friction = Float(value[1])
				Case "life"
					_life = Int(value[1])
				Case "blendmode"
					_blendMode = Int(value[1])
					
				Case "[rotation]"
					_rotation.ReadPropertiesFromStream(stream)
				Case "[alpha]"
					_alpha.ReadPropertiesFromStream(stream)
				Case "[sizex]"
					_sizeX.ReadPropertiesFromStream(stream)
				Case "[sizey]"
					_sizeY.ReadPropertiesFromStream(stream)
				Case "[color]"
					_color.ReadPropertiesFromStream(stream)

				Case "", "[particle]"
				
					'skip empty lines
				Default
					'Return False
					Throw "" + value[0] + " is not a recognized label"
			End Select
		
			line = ReadLine(stream).Trim()
			line.ToLower()
		Wend
		Return True
	End Method	
	
	
	
	rem
		bbdoc: Exports settings to stream
	endrem	
	Method WritePropertiesToStream:Int(stream:TStream)
		WriteLine(stream, "[particle]")
		WriteLine(stream, "id=" + String(_libraryID))
		WriteLine(stream, "name=" + _editorName)
		WriteLine(stream, "description=" + _description)
		
		WriteLine(stream, "imageid=" + String(_imageID))
		WriteLine(stream, "imageframe=" + String(_imageFrame))
		WriteLine(stream, "friction=" + String(_friction))
		WriteLine(stream, "life=" + String(_life))
		WriteLine(stream, "blendmode=" + String(_blendMode))
		
		_rotation.WritePropertiesToStream(stream, "rotation")
		_alpha.WritePropertiesToStream(stream, "alpha")
		_sizeX.WritePropertiesToStream(stream, "sizeX")
		_sizeY.WritePropertiesToStream(stream, "sizeY")
		_color.WritePropertiesToStream(stream, "color")
		
		WriteLine(stream, "[end particle]")
		Return True
	End Method	
	
	

	rem
	bbdoc: Passes source array values to destination array, starting at the passed Index
	endrem
'	Method SetArrayValues(source:String[], destination:String[], destinationIndex:Int)
'		Local sourceIndex:Int
'		For sourceIndex = 0 To source.Length - 1
'			destination[destinationIndex] = source[sourceIndex]
'			destinationIndex:+1
'		Next
'	End Method

	
	
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

