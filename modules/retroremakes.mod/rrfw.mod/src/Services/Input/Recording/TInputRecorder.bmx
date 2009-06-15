'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TInputRecorder Extends TGameService

	Global instance:TInputRecorder		' This holds the singleton instance of this Type
	
	rem
	bbdoc: The seed used for the random number generator
	about: When we start recording we need to be given the seed used for random number generation
	otherwise playback may be incosistent.  If this is not provided then we will seed the random
	number generator ourselves and record that.
	endrem
	Global randomSeed:Int
	
	rem
	bbdoc: The time we started the recording.  All saved input is offset from this time when played back.
	endrem
	Global startTime:Int
	
	Global recordingLength:Int = 0
	
	Global LInputSnapshots:TList = New TList

'#Region Constructors
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod

	Function Create:TInputRecorder()
		Return TInputRecorder.GetInstance()
	End Function
	
	Function GetInstance:TInputRecorder()
		If Not instance
			Return New TInputRecorder
		Else
			Return instance
		EndIf
	EndFunction
'#End Region 

	Method Initialise()
		Self.name = "Input Recorder"
		Super.Initialise()  'Call TGameService initialisation routines
	End Method

	Method Shutdown()
		'TODO
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method
	
	Method MessageListener(message:TMessage)
		Local ts:Int = MilliSecs()
		Local snapshot:TInputSnapshot = New TInputSnapshot
		snapshot.message = message
		snapshot.timestamp = (ts - startTime)
		LInputSnapshots.AddLast(snapshot)
		recordingLength:+1
	End Method
	
	Method StartRecording(seed:Int = Null)
		startTime = MilliSecs()
		If seed
			randomSeed = seed
		Else
			randomSeed = startTime
			SeedRnd(randomSeed)
		End If

		'Subscribe to the input channel as this is what we're recording
		rrSubscribeToChannel(CHANNEL_INPUT, Self)
		rrLogInfo("Started recording input...")
	End Method
	
	Method StopRecording()
		rrUnsubscribeFromChannel(CHANNEL_INPUT, Self)
		rrLogInfo("Finsihed recording input.  Recording Length: " + recordingLength)
	End Method
EndType
