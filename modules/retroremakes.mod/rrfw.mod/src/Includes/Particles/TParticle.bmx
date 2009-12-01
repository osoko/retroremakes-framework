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

Type TParticle Extends TActor
	
	Field _id:String
	Field _name:String
	Field _description:String

	Field _image:TImage
	Field _frame:Int
	Field _blendType:Int
	
	Field _color:TColorValue				'todo merge
	Field _alpha:TFloatValue				'todo ^
	Field _scale:TFloatValue				' or move all these fields to an animation
	Field _sizeX:TFloatValue
	Field _sizeY:TFloatValue
	Field _rotation:TFloatValue
	Field _friction:Float

	Field _velocity:TFloatValue
	Field _acceleration:TFloatValue
	
	Field _life:Int
	
'	Field _parent:TParticleEmitter


	Method New()
		_color = New TColorValue
		_alpha = New TFloatValue
		_scale = New TFloatValue
		_sizeX = New TFloatValue
		_sizeY = New TFloatValue
		_rotation = New TFloatValue
		_velocity = New TVector2D
		_acceleration = New TVector2D
		_color = New TColorValue
	End Method

	Method Destroy()
		If _parent Then _parent.RemoveChild(Self)'TEmitter(_parent).RemoveChild(Self)
	End Method

	Method Update()
		UpdatePosition()	'do basic physics on position
		
		_color.Update()
		_alpha.Update()
		_rotation.Update()
		_sizeX.Update()
		_sizeY.Update()
		_scale.Update()
		
		
		If _life = -1 Then Return

		_life:- 1
		If _life = 0 Then Destroy()
'			RemoveFromList()
'		End If
		
	End Method
		
	Method UpdatePosition()

		'do not use TActor.UpdatePreviousPosition as it also updates the animation manager. which we do not use
		_previousPosition.SetV(_currentPosition)

		_velocity.Multiply(1.0 - _friction, 1.0 - _friction)
		
		Local freq:Double = rrGetUpdateFrequency()
		_velocity.Add(_acceleration.x * freq, _acceleration.y * freq)
		
		_currentPosition.AddV(_velocity)
		_acceleration.Set(0, 0)
	End Method

	Method Render(tweening:Double, fixed:Int = False)
		Interpolate(tweening)

'		Self.SetRenderState()
		SetAlpha _alpha.GetValue()
		SetScale(_sizeX.GetValue(), _sizeY.GetValue())
		SetRotation _rotation.GetValue()
		SetBlend _blendType
		_color.Use()

		DrawImage _image, _renderPosition.x, _renderPosition.y, _frame
	End Method
	
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
						_image = TLibraryImage( lib.GetObject( a[1] ))
					End If
				Case "frame"	_frame = Int( a[1] )
				Case "friction" _friction = Float(a[1])
				Case "life"		_life = Int( a[1] )
				Case "blend"	_blendType = Int( a[1] )
				Case "#color"	_color.SettingsFromStream( s )
				Case "#angle"	_angle.SettingsFromStream( s )
				Case "#alpha"	_alpha.SettingsFromStream( s )
				Case "#sizex"	_sizeX.SettingsFromStream( s )
				Case "#sizey"	_sizeY.SettingsFromStream( s )

				Default rrThrow l
			End Select
			l = s.ReadLine()
			l.Trim()
		Wend
	End Method

	Method Clone:TParticle()'(parent:TEmitter)

		Local p:TParticle = New TParticle
'		p._parent = parent'SetParent( parent )							'TODO: move to emitter
		p._image = _image'.GetImage()
		p._frame = _frame
		If p._frame = -1 Then p._frame = Rand(0, _image.frames - 1)		' -1 is a random frame
		p._friction = _friction
		p._life = _life
		p._blendType = _blendType
		
		p._color = _color.Clone()
		p._rotation = _rotation.Clone()
		p._alpha = _alpha.Clone()
		p._sizeX = _sizeX.Clone()
		p._sizeY = _sizeY.Clone()
		p._scale = _scale.Clone()
		
'		_color.SettingsToEngineColor(p._color)
'		_rotation.SettingsToEngineFloat(p._rotation)
'		_alpha.SettingsToEngineFloat(p._alpha)
'		_sizeX.SettingsToEngineFloat(p._sizeX)
'		_sizeY.SettingsToEngineFloat(p._sizeY)
'		_scale.SettingsToEngineFloat(p._scale)
		
		Return p
	End Method

End Type

