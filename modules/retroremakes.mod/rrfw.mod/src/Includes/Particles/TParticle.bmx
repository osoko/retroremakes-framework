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
	bbdoc:custumizable particle
endrem
Type TParticle Extends TParticleActor

	'image to draw
	Field _image:TImage
	
	'frame from image to draw
	Field _frame:Int
	
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
		bbdoc:destroys this particle
		about:also removes the particle from its parent childlist
	end rem
	Method Destroy()
		If _parent Then _parent.RemoveChild(Self)
		life = 1
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
		SetAlpha _alpha.GetValue()
		SetScale(_sizeX.GetValue(), _sizeY.GetValue())
		SetRotation _rotation.GetValue()
		SetBlend _blendMode
		_color.Use()

		DrawImage _image, _renderPosition.x, _renderPosition.y, _frame
	End Method
	
	rem
		bbdoc:loads particle settings from passsed stream
		about:the settings have been saved from the editor into a configuration file
	endrem
	Method SettingsFromStream(s:TStream, library:Object)
		Local lib:TLibrary = TLibrary(library)
		Local l:String, a:String[]
		l = s.ReadLine()
		l.Trim()
		While l <> "#endparticle"
			a = l.split("=")
			Select a[0].ToLower()
				Case "id"			_id = a[1]
				Case "imageid"
					If a[1] = "none"
						rrThrow "no images for this particle!"
						'_image = Null
					Else
						_image = TLibraryImage(lib.GetObject(a[1])).getimage()
					End If
				Case "frame"	_frame = Int( a[1] )
				Case "friction" _friction = Float(a[1])
				Case "life"		_life = Int( a[1] )
				Case "blend" _blendMode = Int(a[1])
				Case "#color"	_color.SettingsFromStream( s )
				Case "#angle" _rotation.SettingsFromStream(s)
				Case "#alpha"	_alpha.SettingsFromStream( s )
				Case "#sizex"	_sizeX.SettingsFromStream( s )
				Case "#sizey"	_sizeY.SettingsFromStream( s )

				Default rrThrow l
			End Select
			l = s.ReadLine()
			l.Trim()
		Wend
	End Method
	
	rem
		bbdoc:creates an exact copy of this particle
		about:mainly used by emitter to create particles
		returns:TParticle
	endrem
	Method Clone:TParticle()

		Local p:TParticle = New TParticle
'		p._parent = parent'SetParent( parent )							'TODO: move to emitter
		p._image = _image'.GetImage()
		p._frame = _frame
		If p._frame = -1 Then p._frame = Rand(0, _image.frames - 1)		' -1 is a random frame
		p._friction = _friction
		p._life = _life
		p._blendMode = _blendMode
		
		p._color = _color.Clone()
		p._rotation = _rotation.Clone()
		p._alpha = _alpha.Clone()
		p._sizeX = _sizeX.Clone()
		p._sizeY = _sizeY.Clone()
'		p._scale = _scale.Clone()
		
'		_color.SettingsToEngineColor(p._color)
'		_rotation.SettingsToEngineFloat(p._rotation)
'		_alpha.SettingsToEngineFloat(p._alpha)
'		_sizeX.SettingsToEngineFloat(p._sizeX)
'		_sizeY.SettingsToEngineFloat(p._sizeY)
'		_scale.SettingsToEngineFloat(p._scale)
		
		Return p
	End Method

	rem
		bbdoc:returns particles parent
		returns:TParticleEmitter
	endrem
	Method GetParent:TParticleEmitter()
		Return _parent
	End Method
	
End Type

