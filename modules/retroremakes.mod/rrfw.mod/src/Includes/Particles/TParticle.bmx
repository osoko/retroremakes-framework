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
	
	'parent of this particle. override field from TParticleActor as particles only have emitters as parent
	Field _parent:TParticleEmitter

	rem
		bbdoc:default contructor
	endrem	
	Method New()
		_color = New TColorValue
		_alpha = New TFloatValue
	End Method
	
	rem
		bbdoc:updates particle settings
	endrem
	Method Update()
		_color.Update()
		_alpha.Update()

		'run Update() in TParticleActor
		Super.Update()
		
	End Method

	rem
		bbdoc:draws the particle on its current position
	endrem
	Method Render(tweening:Double, fixed:Int = False)
		Interpolate(tweening)

'		Self.SetRenderState()
		brl.max2d.SetAlpha _alpha.GetValue()
		brl.max2d.SetScale(_sizeX.GetValue(), _sizeY.GetValue())
		brl.max2d.SetRotation _rotation.GetValue()
		brl.max2d.SetBlend _blendMode
		
		_color.Use()

		DrawImage _image, _renderPosition.x, _renderPosition.y, _imageFrame

	End Method
	
	rem
		bbdoc: Loads particle settings from passsed stream
		about: The settings have been saved from the editor into a configuration file
	endrem
	Method LoadConfiguration(s:TStream)
		Local l:String, a:String[]
		l = s.ReadLine()
		l.Trim()
		While l <> "#endparticle"
			a = l.split("=")
			Select a[0].ToLower()
				Case "id" _libraryID = a[1]
				Case "desc" _description = a[1]
				Case "name" _name = a[1]
				Case "imageid" _imageID = a[1]
				Case "frame" _imageFrame = Int(a[1])
				Case "friction" _friction = Float(a[1])
				Case "life" _life = Int(a[1])
				Case "blend" _blendMode = Int(a[1])
				
				Case "#color" _color.LoadConfiguration(s)
				Case "#rotation" _rotation.LoadConfiguration(s)
				Case "#alpha" _alpha.LoadConfiguration(s)
				Case "#sizex" _sizeX.LoadConfiguration(s)
				Case "#sizey" _sizeY.LoadConfiguration(s)

				Default rrThrow "load: particle parameter not known: " + l
			End Select
			l = s.ReadLine()
			l.Trim()
		Wend
	End Method
	
	rem
		bbdoc:creates an exact copy of this particle
		about:mainly used by emitter to create particles
		does not copy libraryID
		returns:TParticle
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

	rem
		bbdoc:returns particle parent
		returns:TParticleEmitter
	endrem
	Method GetParent:TParticleEmitter()
		Return _parent
	End Method
	
End Type

