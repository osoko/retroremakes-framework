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
Const STYLE_RADIAL:Int = 20
Const STYLE_BOX:Int = 21
Const STYLE_FOUNTAIN:Int = 22
Const STYLE_LINE:Int = 23

Const SPAWN_ROTATION_EMITTER:Int = 25
Const SPAWN_ROTATION_RND:Int = 26

rem
	bbdoc: emitter that can spawn particles and emitters
endrem
Type TParticleEmitter Extends TParticleActor
	
	'emitter shape: oval, square, directional or line
	Field _shape:Int
	
	
	'the longer a line shaped Emitter, the more particles it spawns. here, lower is more. default = 125
	'todo: this seriously needs work.
	Field _lineDensity:Int
	
	' delay (in ticks) between spawns	
	Field _spawnDelay:Int
	
	'current delay left
	Field _currentSpawnDelay:Int
	
	'amount of objects to spawn in the same burst
	Field _spawnAmount:Int

	'determines the direction the object is spawned into
	'can be set to random or emitter rotation
	Field _spawnDirection:Int
		
	'determines the rotation of the spawned object
	'can be set to : random, align to Emitter, use item setting
	Field _spawnRotation:Int

	'starting speed of spawned objects
	Field _acceleration:Float					' initial speed of particles
	
	'a little jitter for _acceleration
	Field _accelerationRND:Float
		
	'spawned item scale. can be changed over time
	Field _spawnSize:TFloatValue
	
	'offset from center
	Field _offSetX:TFloatValue
	Field _offSetY:TFloatValue
	'Field _positionOffset:TVector2D 'FloatValue		' object is moved into the emitter
	
	'bool. emitter on or off
	Field _isActive:Int
	
	'bool. if set, then changing an emitter property (rotation and movement) also affects its children	
	Field _isSticky:Int
	
	'reference to object to spawn.
	Field _toSpawn:TParticleActor
	
	'id of spawn object in library. used during post processing after loading the library configuration
	Field _spawnID:String
	
	Method New()
		_childList = New TList
		_spawnSize = New TFloatValue
		_offsetX = New TFloatValue
		_offsetY = New TFloatValue
		
		_lineDensity = 90			'needs work!
	End Method

	Method Update()
	
		'update TParticleActor
		Super.Update()
		

		
		'force emitter position to parent
		If _parent
			_currentPosition.SetV(_parent._currentPosition)
			'			Local v:TVector = TObjectBase(_parent).GetPosition()
			'			SetPosition( v.GetX(), v.GetY() )
		End If

		If _isActive = False Then Return

		_offsetX.Update()
		_offsetY.Update()
		_rotation.Update()

		If _isSticky
			RotateChildren(_rotation.GetChanged())

			Local v:TVector2D
			If _parent
				v = TParticleActor(_parent).GetVelocity()
			Else
				v = GetVelocity()
			EndIf
			For Local o:TParticleActor = EachIn _childList
				o.MovePosition(v)
			Next
		End If

		'spawn?
		If _spawnAmount = 0 Then Return
		
		_spawnSize.Update()
		
		_currentSpawnDelay:-1
		If _currentSpawnDelay < 0
			_currentSpawnDelay = _spawnDelay

			If _shape = STYLE_LINE
				_spawnAmount = _sizeY.getValue() / _lineDensity
				If _spawnAmount <= 0 Then _spawnAmount = 1
			End If
			If TParticle(_toSpawn) Then _SpawnParticles()
			If TParticleEmitter(_toSpawn) Then _SpawnEmitters()
		EndIf
	End Method

	Method LoadConfiguration(s:TStream)
		Local l:String, a:String[]
		l = s.ReadLine()
		l.Trim()
		While l <> "#endemitter"
			a = l.split("=")
			Select a[0].ToLower()
			
				Case "id" _libraryID = a[1]
				Case "name" _name = a[1]
				Case "gamename" _gameName = a[1]
				Case "desc" _description = a[1]
				Case "spawndelay" _spawnDelay = Int(a[1])
				Case "spawnamount" _spawnAmount = Int(a[1])
				Case "acceleration" _acceleration = Float(a[1])
				Case "accelerationrnd" _accelerationRND = Float(a[1])
				Case "active" _isActive = Int(a[1])
				Case "sticky" _isSticky = Int(a[1])
				Case "spawndirection" _spawnDirection = Int(a[1])			'CHANGED!
				Case "spawnrotation" _spawnRotation = Int(a[1])				'CHANGED!
				Case "life" _life = Int(a[1])
				Case "shape" _shape = Int(a[1])
				Case "friction" _friction = Float(a[1])
				Case "spawn" _spawnID = a[1]					' store id. after loading, we get the objects for this. see TParticleLibrary.bmx
				Case "#rotation" _rotation.LoadConfiguration(s)
				Case "#sizex" _sizeX.LoadConfiguration(s)
				Case "#sizey" _sizeY.LoadConfiguration(s)
				Case "#spawnscale" _spawnSize.LoadConfiguration(s)
				Case "#offsetx" _offsetX.LoadConfiguration(s)
				Case "#offsety" _offsetY.LoadConfiguration(s)
				Default rrThrow "emitter parameter not found: " + l
			End Select
			l = s.ReadLine()
			l.Trim()
		Wend
	End Method

	Method Clone:TParticleEmitter()
		Local e:TParticleEmitter = New TParticleEmitter
'		e._libraryID = _libraryID
		e._toSpawn = _toSpawn
		e._gameName = _gameName
		e._spawnDelay = _spawnDelay
		e._currentSpawnDelay = 0
		e._spawnAmount = _spawnAmount
		e._shape = _shape
		e._acceleration = _acceleration
		e._accelerationRND = _accelerationRND
		e._isActive = _isActive
		e._isSticky = _isSticky
		e._life = _life
		e._spawnDirection = _spawnDirection
		e._spawnRotation = _spawnRotation

		e._friction = _friction
		
		e._rotation = _rotation.Clone()
		e._sizeX = _sizeX.Clone()
		e._sizeY = _sizeY.Clone()
		e._offsetX = _offsetX.Clone()
		e._offsetY = _offsetY.Clone()
		e._spawnSize = _spawnSize.Clone()
		
'		_angle.SettingsToEngineFloat(e._angle)
'		_sizeX.SettingsToEngineFloat(e._sizeX)
'		_sizeY.SettingsToEngineFloat(e._sizeY)
'		_offsetX.SettingsToEngineFloat(e._offsetX)
'		_offsetY.SettingsToEngineFloat(e._offsetY)
'		_spawnSize.SettingsToEngineFloat(e._spawnSize)
		Return e
	End Method

	Method GetSpawnObject:TParticleActor()
		Return _toSpawn
	End Method

	Method SetSpawnObject(o:TParticleActor)
		_toSpawn = o
	End Method
	

	Method SetActive(bool:Int)
		_isActive = bool
	End Method

	Method IsActive:Int()
		Return _isActive
	End Method

	Method Render(tweening:Double, fixed:Int)
	
		Local x:Int = _currentPosition.x
		Local y:Int = _currentPosition.y
	
		SetColor 255, 255, 0
		Plot x, y
		DrawText "active: " + _isActive, x + 10, y
		DrawText "spawn amount: " + _spawnAmount, x + 10, y + 20
		DrawText "spawn delay: " + _currentSpawnDelay, x + 10, y + 40
		DrawText "children: " + _childList.Count(), x + 10, y + 60
		
	End Method

	'***** PRIVATE *****
	
	'
	'todo : both spawn methods can be merged. do casting in here.
	
	Method _SpawnParticles()
	
		Local rotation:Float = _rotation.GetValue()
		Local p:TParticle
		Local source:TParticle = TParticle(_toSpawn)
		For Local amount:Int = 1 To _spawnAmount
			p = source.Clone()
			p.SetParent(Self)
			Self.AddChild(p)
			TLayerManager.GetInstance().AddRenderableToLayerById(p, _layer)

			Local val:Float = _spawnSize.GetValue()
			p._sizeX.Scale(val)
			p._sizeY.Scale(val)
			
			If _spawnDirection = SPAWN_ROTATION_RND Then rotation = Rnd(360)
'			Select _spawnDirection
'				Case ANGLE_EMITTER
'					p._rotation.Lock(rotation)
'				Case ANGLE_RANDOM
'					p._rotation.Lock(Rnd(359))
'					If Rand(1, 10) < 6 Then p._rotation._changeValue = -p._rotation._changeValue	'chance to rotate the other way
'			End Select

			_ForceShapeSettings(p, rotation)
		Next
	End Method

	Method _SpawnEmitters()
		Local rotation:Float = _rotation.GetValue()
		Local s:TParticleEmitter
		Local source:TParticleEmitter = TParticleEmitter(_toSpawn)
		For Local amount:Int = 1 To _spawnAmount
			s = source.Clone()
			s.SetParent(Self)
			Self.AddChild(s)

			
			Local val:Float = _spawnSize.GetValue()
			s._sizeX.Scale(val)
			s._sizeY.Scale(val)

			If _spawnDirection = SPAWN_ROTATION_RND Then rotation = Rnd(360)
			_ForceShapeSettings(s, rotation)
		Next
	End Method

	Method _ForceShapeSettings(o:TParticleActor, rotation:Float)
		'
		'placement according to each Emitter type
		
		o = TParticleActor(o)
		
		Select _shape
			Case STYLE_RADIAL, STYLE_FOUNTAIN
				o.ResetPosition(_currentPosition.x + Sin(rotation) * _sizeX.GetValue() / 2, _currentPosition.y + -Cos(rotation) * _sizeY.GetValue() / 2)
			Case STYLE_LINE
				Local posOnLine:Float = Rnd(1, _sizeY.getValue())
				o.ResetPosition(_currentPosition.x + Sin(rotation) * posOnLine, _currentPosition.y + -Cos(rotation) * posOnLine)
		End Select

		Local accRND:Float = Rnd(_accelerationRND)
		Local acc:TVector2D = TVector2D.Create(Sin(rotation) * (_acceleration + accRND), -Cos(rotation) * (_acceleration + accRND))
		o.AddAcceleration(acc)
		
'		o.AddAcceleration(Sin(rotation) * (_acceleration + accRND), -Cos(rotation) * (_acceleration + accRND))
	End Method

End Type
