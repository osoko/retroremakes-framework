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


	Method New()
		_color = New TColorValue
		_alpha = New TFloatValue
		_scale = New TFloatValue
		
	End Method

	Method Destroy()
		If _parent Then TEmitter(_parent).RemoveChild(Self)
	End Method

	Method Update()
'		UpdateBase()
		_color.Update()
		_alpha.Update()
	End Method

	Method Render(tweening:Double, fixed:Int = False)
		Interpolate(tweening)
	
		Self.SetRenderState()
	
'		SetAlpha _alpha.GetValue()
'		SetScale( _sizeX.GetValue(), _sizeY.GetValue() )
'		SetRotation _angle.GetValue()
'		SetBlend _blendType
		_color.Use()
		Interpolate( tween )
		DrawImage _image, _renderPosition.x, _renderPosition.y, _frame
	End Method

	'***** PRIVATE *****

	Field _image:TImage
	Field _frame:Int
	Field _blendType:Int
	Field _color:TColorValue
	Field _alpha:TFloatValue
	
	
	Method New()
		_color = New TLibraryColor
		_alpha = New TLibraryFloat
		_angle = New TLibraryFloat
		_sizeX = New TLibraryFloat
		_sizeY = New TLibraryFloat
		RemoveFromList()				'not to be seen in engine
	End Method

	Method SettingsFromStream( s:TStream, library:Object )
		Local lib:TLibrary = TLibrary(library)
		Local l:String, a:String[]
		l = s.ReadLine()
		l.Trim()
		While l <> "#endparticle"
			a = l.split("=")
			Select a[0]
				Case "id"			_id = a[1]
				Case "imageid"
					If a[1] = "none"
						_image = Null
					Else
						_image = TLibraryImage( lib.GetObject( a[1] ))
					End If
				Case "frame"	_frame = Int( a[1] )
				Case "friction"	SetFriction( Float( a[1] ) )
				Case "life"		_life = Int( a[1] )
				Case "blend"	_blendType = Int( a[1] )
				Case "#color"	_color.SettingsFromStream( s )
				Case "#angle"	_angle.SettingsFromStream( s )
				Case "#alpha"	_alpha.SettingsFromStream( s )
				Case "#sizex"	_sizeX.SettingsFromStream( s )
				Case "#sizey"	_sizeY.SettingsFromStream( s )

'				Default				DebugLog l
			End Select
			l = s.ReadLine()
			l.Trim()
		Wend
	End Method

	Method CloneToEngine:TParticle(parent:TEmitter)
		'
		'create a engine particle; copy settings from this library item
		Local p:TParticle = New TParticle
		p.SetParent( parent )
		p._image = _image.GetImage()
		p._frame = _frame
		If p._frame = -1 Then p._frame = Rand( 0, _image._frameCount - 1 )		' -1 is a random frame
		p.SetFriction( GetFriction() )
		p._life = _life
		p._blendType = _blendType
		_color.SettingsToEngineColor(p._color)
		_angle.SettingsToEngineFloat(p._angle)
		_alpha.SettingsToEngineFloat(p._alpha)
		_sizeX.SettingsToEngineFloat(p._sizeX)
		_sizeY.SettingsToEngineFloat(p._sizeY)
		Return p
	End Method

	'***** PRIVATE *****

	Field _id:String
'	Field _image:TLibraryImage
'	Field _color:TLibraryColor
'	Field _angle:TLibraryFloat
'	Field _alpha:TLibraryFloat
'	Field _sizeX:TLibraryFloat
'	Field _sizeY:TLibraryFloat	
	

End Type

