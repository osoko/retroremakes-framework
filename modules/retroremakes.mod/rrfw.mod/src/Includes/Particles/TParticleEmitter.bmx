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


'emitter shape constants
Const STYLE_RADIAL:Int 	 = 20
Const STYLE_BOX:Int 	 = 21
Const STYLE_FOUNTAIN:Int = 22
Const STYLE_LINE:Int 	 = 23

rem
	bbdoc: base object for emitters
	about: TParticleEmitter and TEmitterEmitter are based from this type
endrem
Type TEmitter Extends TParticleActor' Abstract
								
	'emitter shape: oval, square, directional, etc
	Field _shape:Int
	
	'bool. if set,  each object is spawned in a random direction, not using the _angle value
	Field _randomDirection:Int
	
	'the longer a line shaped Emitter, the more particles it spawns. here, lower is move. default = 125
	'todo: this needs work.
	Field _lineDensity:Int
	
	' delay (in ticks) between spawns	
	Field _spawnDelay:Int
	
	'current delay
	Field _currentSpawnDelay:Int
	
	'amount of objects to spawn in the same burst
	Field _spawnAmount:Int

	'starting speed of spawned objects
	Field _acceleration:Float					' initial speed of particles
	
	'a little jitter for _acceleration
	Field _accelerationRND:Float
	
	'can be set to : random, align to Emitter, item setting
	Field _spawnAngle:Int
	
	'spawned item scale. can be changed over time
	Field _spawnScale:TFloatValue
	
	'offset from parent
	Field _offsetX:TFloatValue
	Field _offsetY:TFloatValue
	
	'bool. emitter on or off
	Field _isActive:Int
	
	'bool. if set, then changing an emitter property (rotation, scale, etc) also affects its children	
	Field _isSticky:Int
	
	Method New()
		_childList = New TList
		_spawnScale = New TFloatValue
		_offsetX = New TFloatValue
		_offsetY = New TFloatValue
		
		_lineDensity = 90
	End Method

	Method Destroy()
		For Local o:TParticleActor = EachIn _childList
			o.SetParent( Null )
		Next
		_childList.Clear()
		_life = 1
	End Method

	Method Update()
	
		'update TParticleActor
		Super.Update()

		If _parent
			_currentPosition.SetV(_parent._currentPosition)
'			Local v:TVector = TObjectBase(_parent).GetPosition()
'			SetPosition( v.GetX(), v.GetY() )
		End If

'		If _appearanceParticle
'			_appearanceParticle.SetPosition( _currentPosition.GetX(), _currentPosition.GetY() )
'		End If

		If _isActive = False Then Return

		_offsetX.Update()
		_offsetY.Update()
'		_sizeX.Update()
'		_sizeY.Update()
'		_rotation.Update()

		If _isSticky
			RotateChildren(_rotation.GetChanged())

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
			If TLibraryParticle( _toSpawn ) Then _SpawnParticles( _rotation.GetValue() )
			If TLibraryEmitter( _toSpawn ) Then _SpawnEmitters( _rotation.GetValue() )
		EndIf
	End Method


	Method SetActive(bool:Int)
		_isActive = bool
	End Method

	Method IsActive:Int()
		Return _isActive
	End Method

	Method Render(tweening:Double, fixed:Int)
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
					p._rotation.Lock( angle )
				Case ANGLE_RANDOM
					p._rotation.Lock( Rnd(359) )
					If Rand(1, 10) < 6 Then p._rotation._changeValue = -p._rotation._changeValue	'chance to rotate the other way
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
				o.SetPosition( _currentPosition.GetX() + Sin(angle) * _sizeX.GetValue()/2, _currentPosition.GetY() + -Cos(angle) * _sizeY.GetValue()/2 )
			Case STYLE_LINE
				Local posOnLine:Float = Rnd(1, _sizeY.getValue())
				o.SetPosition( _currentPosition.GetX() + Sin(angle) * posOnLine , _currentPosition.GetY() + -Cos(angle) * posOnLine )
		End Select

		Local accRND:Float = Rnd(_accelerationRND)
		o.SetAcceleration( Sin(angle) * (_acceleration + accRND ), -Cos(angle) * (_acceleration + accRND) )
	End Method

End Type
