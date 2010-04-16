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

'spawned object rotation options
Const SPAWN_ROTATION_EMITTER:Int = 25
Const SPAWN_ROTATION_RND:Int = 26
Const SPAWN_ROTATION_OBJECT:Int = 27

'spawned object direction options
Const SPAWN_DIRECTION_EMITTER:Int = 30
Const SPAWN_DIRECTION_RND:Int = 31

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
		If _parent Then _currentPosition.SetV(_parent._currentPosition)

		_offsetX.Update()
		_offsetY.Update()
		_rotation.Update()
		_spawnSize.Update()
		
		If _isActive = False Then Return

		If _isSticky
			RotateChildren(_rotation.GetChangedAmount())

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

		'spawn something?
		If _spawnAmount = 0 Then Return
		
		_currentSpawnDelay:-1
		If _currentSpawnDelay < 0
			_currentSpawnDelay = _spawnDelay

			If _shape = STYLE_LINE
				_spawnAmount = _sizeY.GetCurrentValue() / _lineDensity
				If _spawnAmount <= 0 Then _spawnAmount = 1
			End If
			
			DoSpawn()
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
				Case "spawndirection" _spawnDirection = Int(a[1])
				Case "spawnrotation" _spawnRotation = Int(a[1])
				Case "life" _life = Int(a[1])
				Case "shape" _shape = Int(a[1])
				Case "friction" _friction = Float(a[1])
				Case "spawn" _spawnID = a[1]					' store id. post processing is done in TParticleLibrary.bmx
				Case "#rotation" _rotation.LoadConfiguration(s)
				Case "#sizex" _sizeX.LoadConfiguration(s)
				Case "#sizey" _sizeY.LoadConfiguration(s)
				Case "#spawnscale" _spawnSize.LoadConfiguration(s)
				Case "#offsetx" _offsetX.LoadConfiguration(s)
				Case "#offsety" _offsetY.LoadConfiguration(s)
				Default Throw "emitter parameter not found: " + l
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


	rem
		bbdoc: spawns the object located in _toSpawn
		about: does a cast to determine which object type is needed
	endrem			
	Method DoSpawn()
		If TParticle(_toSpawn)
			Local p:TParticle
			Local source:TParticle = TParticle(_toSpawn)
			For Local amount:Int = 1 To _spawnAmount
				
				'create it
				p = source.Clone()
				
				'send it off
				ForceEmitterSettings(p)', rotation)
			Next
			Return
		EndIf
			
		If TParticleEmitter(_toSpawn)
			Local s:TParticleEmitter
			Local source:TParticleEmitter = TParticleEmitter(_toSpawn)
			For Local amount:Int = 1 To _spawnAmount
				s = source.Clone()
				ForceEmitterSettings(s)', rotation)
			Next
			Return
		EndIf
	
	End Method
	
	rem
		bbdoc: forces the emitter settings on the spawned object
		this includes direction, angle, scale, etc.
		about: private method, not called from outside the emitter
	endrem
	Method ForceEmitterSettings(o:TParticleActor)

		'add to the same layer as emitter
		TLayerManager.GetInstance().AddRenderableToLayerById(o, _layer)
		
		'set relations
		o.SetParent(Self)
		Self.AddChild(o)

		'scale spawned object to current emitter spawn size
		Local val:Float = _spawnSize.GetCurrentValue()
		o._sizeX.Scale(val)
		o._sizeY.Scale(val)
		
		'determine where the object has to travel to
		Local directionAngle:Float
		
		Select _spawnDirection
			Case SPAWN_DIRECTION_EMITTER
				directionAngle = _rotation.GetCurrentValue()
				
			Case SPAWN_DIRECTION_RND
			
				'set direction to random value. this means that the spawned object will move in a random direction
				'this does not change the emitter rotation.
				directionAngle = Rnd(360)
		End Select
		
		'determine at which rotation angle the object is spawned
		Select _spawnRotation
			Case SPAWN_ROTATION_EMITTER
			
				'make sure the spawned object rotation is idential to its direction
				o._rotation.Freeze(directionAngle)
			Case SPAWN_ROTATION_RND
			
				'the rotation of the spawned object is random, and turns in a random direction (if value is active of course)
				o._rotation.Randomize()
			Case SPAWN_ROTATION_OBJECT
				'do nothing. object keeps its own rotation value
		End Select
		
		'determine emitter shape and force begin location on spawned object
		Select _shape
			Case STYLE_RADIAL, STYLE_FOUNTAIN
				o.ResetPosition(_currentPosition.x + Sin(directionAngle) * _sizeX.GetCurrentValue() / 2, _currentPosition.y + -Cos(directionAngle) * _sizeY.GetCurrentValue() / 2)
			Case STYLE_LINE
				Local posOnLine:Float = Rnd(1, _sizeY.GetCurrentValue())
				o.ResetPosition(_currentPosition.x + Sin(directionAngle) * posOnLine, _currentPosition.y + -Cos(directionAngle) * posOnLine)
		End Select
		
		'fire off object
		Local accRND:Float = Rnd(_accelerationRND)
		Local acc:TVector2D = TVector2D.Create(Sin(directionAngle) * (_acceleration + accRND), -Cos(directionAngle) * (_acceleration + accRND))
		o.AddAcceleration(acc)
		
'		o.AddAcceleration(Sin(rotation) * (_acceleration + accRND), -Cos(rotation) * (_acceleration + accRND))
	End Method

End Type
