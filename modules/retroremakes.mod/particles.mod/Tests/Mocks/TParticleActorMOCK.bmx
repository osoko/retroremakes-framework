
Type TParticleActorMOCK Extends TParticleActor
	
	Method Render(tweening:Double, fixed:Int)
	End Method
	
	
	rem
	bbdoc: Applies physics to this object
	about: force frequency to avoid needing a TFixedTimeStep
	endrem	
	Method ApplyPhysics()

		_previousPosition.SetV(_currentPosition)

		_velocity.MulF(1.0 - _friction)
		
		Local freq:Double = 120  'TFixedTimestep.GetInstance().GetUpdateFrequency()
		_velocity.AddF(_acceleration.x / freq, _acceleration.y / freq)

		_currentPosition.AddV(_velocity)
		_acceleration.Set(0, 0)
		
	End Method	
	
	
	
End Type
