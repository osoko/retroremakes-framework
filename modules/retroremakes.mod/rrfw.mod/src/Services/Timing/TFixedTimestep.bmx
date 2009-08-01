rem
	bbdoc: #TFixedTimestep
	about: #TFixedTimestep a #TGameService that manages the speed of the update
	loop, and calculates a tweening value to smooth out any spikes in moving graphics.
	<br />
	This code was based on the Fix Your Timestep! article by Glenn Fiedler:
	<a href="http://gafferongames.com/game-physics/fix-your-timestep/">http://gafferongames.com/game-physics/fix-your-timestep/</a>
endrem
Type TFixedTimestep Extends TGameService
	
	Const DEFAULT_LOGIC_UPDATE_FREQUENCY:Double = 60.0	'60 frames per second


	rem
		bbdoc: The #TFixedTimestep service instance
		about: #TFixedTimestep is a @{Singleton Type} and when it is instantiated this @Global holds
		a reference to the instance
	endrem		
	Global instance:TFixedTimestep
	
	
	rem
		bbdoc: 
	endrem
	Field accumulator:Double = 0.0
'#Region accumulator Get/Set Methods

	Rem
		bbdoc: Get the accumulator value in this TFixedTimestep object.
	End Rem
	Method GetAccumulator:Double()
		Return Self.accumulator
	End Method
	
	Rem
		bbdoc: Set the accumulator value for this TFixedTimestep object.
	End Rem
	Method SetAccumulator(value:Double)
		Self.accumulator = value
	End Method
	
'#End Region 
	
	rem
		bbdoc: The number of ticks per logic update
		about: This is calculated from the requested update frequency
	endrem
	Field deltaTime:Double
'#Region deltaTime Get/Set Methods

	Rem
		bbdoc: Get the deltaTime value in this TFixedTimestep object.
	End Rem	
	Method GetDeltaTime:Double()
		Return Self.deltaTime
	End Method
	
	Rem
		bbdoc: Get the deltaTime value in this TFixedTimestep object.
	End Rem	
	Method SetDeltaTime(value:Double)
		Self.deltaTime = value
	End Method
	
'#End Region 
	
	rem
		bbdoc: The time that the last calculation was made
	endrem
	Field nowTime:Double
'#Region nowTime Get/Set Methods

	Rem
		bbdoc: Get the nowTime value in this TFixedTimestep object.
	End Rem
	Method GetNowTime:Double()
		Return nowTime
	End Method
	
	Rem
		bbdoc: Set the nowTime value for this TFixedTimestep object.
	End Rem
	Method SetNowTime(value:Double)
		nowTime = value
	End Method
	
'#End Region 

	rem
		bbdoc: tweening value that can be used to smooth out object movement and
		animation, etc.
	endrem 
	Field tweening:Double
'#Region tweening Get/Set Methods

	Rem
		bbdoc: Get the tweening value in this TFixedTimestep object.
	End Rem
	Method GetTweening:Double()
		Return Self.tweening
	End Method
	
	Rem
		bbdoc: Set the tweening value for this TFixedTimestep object.
	End Rem	
	Method SetTweening(value:Double)
		Self.tweening = value
	End Method
	
'#End Region 	
	
	rem
		bbdoc: The frequency in Hz that the logic should run at
	endrem
	Field updateFrequency:Double
'#Region updateFrequency Get/Set Methods

	Rem
		bbdoc: Get the updateFrequency value in this TFixedTimestep object.
	End Rem
	Method GetUpdateFrequency:Double()
		Return Self.updateFrequency
	End Method
	
	Rem
		bbdoc: Set the updateFrequency value for this TFixedTimestep object.
	End Rem	
	Method SetUpdateFrequency(value:Double)
		Self.updateFrequency = value
		SetDeltaTime(1000.0:Double / value)
	End Method
	
'#End Region 



	rem
		bbdoc: Calculate the delta time between the last calculation time and now
		and add this to the accumulator
	endrem
	Method Calculate()
		Local newTime:Double = rrMillisecs()

		Local dt:Double = newTime - GetNowTime()
		SetNowTime(newTime)
		
		SetAccumulator(GetAccumulator() + dt)
	End Method
	
	
	
	rem
		bbdoc: Calculation the render tweening value that can be used to smooth out
		object movement and animation, etc.
	endrem
	Method CalculateTweening()
		SetTweening(GetAccumulator() / GetDeltaTime())
	End Method
	
	
		
	rem
		bbdoc: Return an instance of #TFramesPerSecond
		returns: #TFramesPerSecond
		about: Returns a new instance of #TFramesPerSecond, or if one already exists returns that instance instead
	endrem		
	Function GetInstance:TFixedTimestep()
		If Not instance
			Return New TFixedTimestep
		Else
			Return instance
		EndIf
	EndFunction



	rem
		bbdoc: Initialises the #TFixedTimestep service
		about: This is overriden from #TGameService, see the documentation for
		that class for more details		
	endrem		
	Method Initialise()
		SetName("Fixed Timestep Logic")
		Super.Initialise()
	End Method

	
	
	rem
		bbdoc: Constructor
	endrem	
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod
		
	
	
	rem
		bbdoc: Resets the #TFixedTimestep service to starting values
	endrem		
	Method Reset()
		SetUpdateFrequency(rrGetDoubleVariable("LOGIC_UPDATE_FREQUENCY", DEFAULT_LOGIC_UPDATE_FREQUENCY, "Engine"))
		SetNowTime(rrMillisecs())
	End Method



	rem
		bbdoc: Starts the #TFixedTimestep service
	endrem		
	Method Start()
		Reset()
	End Method



	rem
		bbdoc: Calculate whether a logic timestep is needed
		returns: True if a timestep is needed, otherwise False
	endrem
	Method TimeStepNeeded:Int()
		Local dt:Double = GetDeltaTime()
		Local accumulator:Double = GetAccumulator()
		If accumulator >= dt
			SetAccumulator(accumulator - dt)
			Return True
		Else
			Return False
		End If
	End Method
	
End Type
