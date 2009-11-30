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


Const STYLE_RADIAL:Int 	 = 20
Const STYLE_BOX:Int 	 = 21
Const STYLE_FOUNTAIN:Int = 22
Const STYLE_LINE:Int 	 = 23

Type TEmitter Extends TRenderable 'TEngineBase

	Method New()
		_childList = New TList
		_spawnScale = New TFloatValue
		_offsetX = New TFloatValue
		_offsetY = New TFloatValue
		_lineDensity = 90
	End Method

	Method Destroy()
		For Local o:TEngineBase = EachIn _childList
			o.SetParent( Null )
		Next
		_childList.Clear()
		_life = 1
	End Method

	Method Update()

		If _parent
			Local v:TVector = TObjectBase(_parent).GetPosition()
			SetPosition( v.GetX(), v.GetY() )
		End If

		If _appearanceParticle
			_appearanceParticle.SetPosition( _position.GetX(), _position.GetY() )
		End If

		If _isActive = False Then Return

		_offsetX.Update()
		_offsetY.Update()

		If _isSticky
			RotateChildren( _angle.GetChanged() )

			Local v:TVector
			If _parent
				v = TEngineBase(_parent).GetVelocity()
			Else
				v = GetVelocity()
			EndIf
			For Local o:TEngineBase = EachIn _childList
				o.MovePosition( v )
			Next
		End If

		'
		'spawn?
		If _spawnAmount = 0 Then Return
		_spawnScale.Update()
		_currentSpawnDelay:- 1
		If _currentSpawnDelay < 0
			_currentSpawnDelay = _spawnDelay

			If _shape = STYLE_LINE
				_spawnAmount = _sizeY.getValue() / _lineDensity
				If _spawnAmount <= 0 Then _spawnAmount = 1
			End If
			If TLibraryParticle( _toSpawn ) Then _SpawnParticles( _angle.GetValue() )
			If TLibraryEmitter( _toSpawn ) Then _SpawnEmitters( _angle.GetValue() )
		EndIf
	End Method

	Method AddChild( o:Object )
		If _childList.Contains( o ) Then Return
		_childList.AddLast( o )
	End Method

	Method RemoveChild( o:Object )
		_childList.Remove( o )
	End Method

	Method GetChildren:TList()
		Return _childList
	End Method

	Method RotateChildren( amount:Float )
		If _isSticky = False Then Return
		For Local b:TEngineBase = EachIn _childList
			b.RotatePosition( amount, _position )
			b.TurnAngle( amount )
			b.TurnDirection( amount )
			'
			'rotate child emitter children
			If TEmitter(b) Then TEmitter(b).RotateChildren( amount )
		Next
	End Method

	Method Enable()
		_isActive = True
	End Method

	Method Disable()
		_isActive = False
	End Method

	Method IsActive:Int()
		Return _isActive
	End Method

	Method Draw( tween:Float )
	End Method

	'***** PRIVATE *****

	Method _SpawnParticles( angle:Float )
		Local p:TParticle
		Local source:TLibraryParticle = TLibraryParticle( _toSpawn )
		For Local amount:Int = 1 To _spawnAmount
			p = source.CloneToEngine( Self )
			Self.AddChild( p )

			Local val:Float = _spawnScale.GetValue()
			p._sizeX.Scale( val )
			p._sizeY.Scale( val )

			If _randomDirection Then angle = Rnd(360)
			Select _spawnAngle
				Case ANGLE_EMITTER
					p._angle.Lock( angle )
				Case ANGLE_RANDOM
					p._angle.Lock( Rnd(359) )
					If Rand( 1, 10 ) < 6 Then p._angle._changeValue = -p._angle._changeValue	'chance to rotate the other way
			End Select

			_ForceShapeSettings( TEngineBase(p), angle )
		Next
	End Method

	Method _SpawnEmitters( angle:Float )
		Local s:TEmitter
		Local source:TLibraryEmitter = TLibraryEmitter( _toSpawn )
		For Local amount:Int = 1 To _spawnAmount
			s = source.CloneToEngine( Self )
			Self.AddChild(s)

			Local val:Float = _spawnScale.GetValue()
			s._sizeX.Scale(val)
			s._sizeY.Scale(val)

			If _randomDirection Then angle = Rnd( 360 )
			_ForceShapeSettings( TEngineBase(s), angle )
		Next
	End Method

	Method _ForceShapeSettings( o:TEngineBase, angle:Float )
		'
		'placement according to each Emitter type
		Select _shape
			Case STYLE_RADIAL, STYLE_FOUNTAIN
				o.SetPosition( _position.GetX() + Sin(angle) * _sizeX.GetValue()/2, _position.GetY() + -Cos(angle) * _sizeY.GetValue()/2 )
			Case STYLE_LINE
				Local posOnLine:Float = Rnd(1, _sizeY.getValue())
				o.SetPosition( _position.GetX() + Sin(angle) * posOnLine , _position.GetY() + -Cos(angle) * posOnLine )
		End Select

		Local accRND:Float = Rnd(_accelerationRND)
		o.SetAcceleration( Sin(angle) * (_acceleration + accRND ), -Cos(angle) * (_acceleration + accRND) )
	End Method

	Field _id:String							' so editor can find 'live' Emitters
												' Emitters to sync settings to. this is needed for real-time preview and changing settings.
	Field _appearanceParticle:TParticle			' particle to draw at Emitter center... used to visualize Emitter. created during Emitter clone
	Field _shape:Int							' oval, square, directional, etc
	Field _toSpawn:Object
	Field _randomDirection:Int					' if true, each object is spawned in a random direction, not using the _angle value
	Field _lineDensity:Int						' the longer a line Emitter, the more particles it spawns. here, lower is move. default = 125
	Field _spawnDelay:Int						' delay between spawns
	Field _currentSpawnDelay:Int				' timer for delay
	Field _spawnAmount:Int						' how many to spawn when spawndelay is over
	Field _spawnRND:Int							' ^^ jitter
	Field _acceleration:Float					' initial speed of particles
	Field _accelerationRND:Float				' ^^ jitter
	Field _spawnAngle:Int						' random, align to Emitter, item setting
	Field _spawnScale:TFloatValue				' item scale
	Field _offsetX:TFloatValue
	Field _offsetY:TFloatValue
	Field _childList:TList
	Field _isActive:Int
	Field _isSticky:Int
End Type
