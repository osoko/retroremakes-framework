rem
	bbdoc: TGameStateManager
	about: TGameStateManager is a TGameService which handles registering and
	switching between TGameStates.
endrem
Type TGameStateManager Extends TGameService

	rem
		bbdoc: The TGameStateManager instance
		about: TGameStateManager is a Singleton Type
	endrem
	Global instance:TGameStateManager

	
	rem
		bbdoc: The currently active TGameState.
		about:
	endrem
	Field currentState:TGameState
	
	
	rem
		bbdoc: TList containing all registered TGameStates.
		about:
	endrem	
	Field gameStates:TList
	
	
	rem
		bbdoc: TMap containg all registered TGameStates indexed by name
		about:
	endrem
	Field gameStatesMap:TMap
	

	
	rem
		bbdoc: Whether to loop TGameStates or not
		about: This allows you to loop forwards or backwards through all TGameStates
		using the NextGameState() and PreviousGameState() methods.  Default setting
		is to not loop, in which case the Engine will be shutdown once all
		TGameStates have been used (good for demos, etc.)
	endrem	
	Field loopStates:Int = False

	

	Field nGameStates:Int = 0
	
	
		
	Method AddGameState(state:TGameState)
		If Not state.name
			state.name = "NamelessState" + nGameStates
		EndIf
		
		If state.link Then Throw "You cannot add a game state more than once"
		
		If gameStatesMap.Contains(state.name) Then Throw "You cannot add a game state with the same name more than once"
		
		state.link = gameStates.AddLast(state)
		gameStatesMap.Insert(state.name, state)
		
		nGameStates:+1
		
		TLogger.GetInstance().LogInfo("[" + toString() + "] Added state: " + state.toString())
	End Method



	Method DeleteGameState(State:TGameState)
		If Not State.link Then Throw "You cannot delete a game state that hasn't been added"
		State.Shutdown()
		gameStates.Remove(State)
	End Method



	Function GetInstance:TGameStateManager()
		If Not instance
			Return New TGameStateManager
		Else
			Return instance
		EndIf
	EndFunction
	
	
	
	Method GetLoopStates:Int()
		Return loopStates
	End Method
	
	
			
	Method Initialise()
		SetName("State Manager")
		gameStates = New TList
		gameStatesMap = New TMap
		Super.Initialise()  'Call TGameService initialisation routines
	End Method
	
	
				
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod

	

	Method NextGameState()
		If currentState.link.NextLink()
			SetGameState(TGameState(currentState.link.NextLink().Value()))
		Else
			If loopStates
				SetGameState(TGameState(gameStates.First()))
			Else
				rrEngineStop()
			End If
		End If
	End Method
	
	
	
	Method PreviousGameState()
		If currentState.link.PrevLink()
			SetGameState(TGameState(currentState.link.PrevLink().Value()))
		Else
			If loopStates
				SetGameState(TGameState(gameStates.Last()))
			Else
				rrEngineStop()
			End If
		End If
	End Method
	
	
			
	Method Render()
		If Not currentState Then Return
		currentState.Render()
	End Method
	
	
	
	Method SetGameState(state:TGameState)
		If currentState
			TLogger.getInstance().LogInfo("[" + toString() + "] Leaving state: " + currentState.toString())
			currentState.Leave()
		EndIf
		currentState = state
		TLogger.getInstance().LogInfo("[" + toString() + "] Entering state: " + currentState.toString())
		currentState.Enter()
	End Method
	
	
	
	Method SetGameStateByName(stateName:String)
		Local state:TGameState = TGameState(Self.gameStatesMap.ValueForKey(stateName))
		If state
			SetGameState(state)
		Else
			Throw "Game State ~q" + stateName + "~q does not exist"
		End If
	End Method
	
	
		
	Method SetLoopStates(Loop:Int = True)
		loopStates = Loop
	End Method
	
	
				
	Method Shutdown()
		For Local state:TGameState = EachIn gameStates
			state.Shutdown()
			gameStates.Remove(state)
		Next
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method

	
		
	Method Start()
		'Run Start Method of all registered TStates
		For Local state:TGameState = EachIn gameStates
			TLogger.getInstance().LogInfo("[" + toString() + "] Initialising state: " + state.toString())
			state.Initialise()
		Next
	End Method

	
		
	Method Update()
		If Not currentState
			If gameStates.Count() > 0
				currentState = TGameState(gameStates.First())
				TLogger.getInstance().LogInfo("[" + toString() + "] Entering state: " + currentState.toString())
				currentState.Enter()
			Else
				Return
			End If
		EndIf
		currentState.Update()
	End Method

EndType

Function rrAddGameState(state:TGameState)
	TGameStateManager.GetInstance().AddGameState(state)
End Function

Function rrDeleteGameState(State:TGameState)
	TGameStateManager.GetInstance().DeleteGameState(State)
End Function

Function rrSetGameState(state:TGameState)
	TGameStateManager.GetInstance().SetGameState(state)
End Function

Function rrNextGameState()
	TGameStateManager.GetInstance().NextGameState()
End Function

Function rrPreviousGameState()
	TGameStateManager.GetInstance().PreviousGameState()
End Function

Function rrSetLoopStates(Loop:Int = True)
	TGameStateManager.GetInstance().SetLoopStates(Loop)
End Function

Function rrGetLoopStates:Int()
	Return TGameStateManager.GetInstance().GetLoopStates()
End Function