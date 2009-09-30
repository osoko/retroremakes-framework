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
'#Region loopStates Get/Set methods

	Rem
		bbdoc: Get the loopStates value in this TGameStateManager object
	endrem
	Method getLoopStates:Int()
		Return loopStates
	End Method
		
	rem
		bbdoc: Set the loopStates value for this TGameStateManager object
	endrem
	Method setLoopStates(Loop:Int = True)
		loopStates = Loop
	End Method
	
'#End Region 
	


	rem
		bbdoc: The number of game states registered with the manager
		about:
	endrem
	Field nGameStates:Int = 0
	
	
	
	Rem
		bbdoc: Register a game state with the manager
		about: If the game state doesn't have a name specified then the manager will
		allocate a name in the format 'NamelessState#', where # is the registration
		number
	EndRem
	Method AddGameState(state:TGameState)
		If Not state.name
			state.name = "NamelessState" + nGameStates
		EndIf
		If state.link Then Throw "You cannot add a game state more than once"
		If gameStatesMap.Contains(state.name) Then Throw "You cannot add a game state with the same name more than once"
		state.link = gameStates.AddLast(state)
		gameStatesMap.Insert(state.name, state)
		nGameStates:+1
		TLogger.GetInstance().LogInfo("[" + toString() + "] Added stae: " + state.name)
	End Method



	rem
		bbdoc: Get the #TGameStateManager instance
		about: If there is not an instance it will create one
	endrem
	Function GetInstance:TGameStateManager()
		If Not instance
			Return New TGameStateManager
		Else
			Return instance
		EndIf
	EndFunction
	
	
	
	rem
		bbdoc: Initialises the #TGameStateManager service
		about: This is overriden from #TGameService, see the documentation for
		that class for more details		
	endrem	
	Method Initialise()
		SetName("State Manager")
		gameStates = New TList
		gameStatesMap = New TMap
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
		bbdoc: Switch to the next registered game state
		about: If there are no more game states then it will either shutdown
		the engine, thus ending the game, or loop back to the first state
		dependent on whether loopStates has been set to True or False
	endrem
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
	
	
	
	rem
		bbdoc: Switch to the previous registered game state
		about: If there are no more game states then it will either shutdown
		the engine, thus ending the game, or loop to the last state
		dependent on whether loopStates has been set to True or False
	endrem	
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
	
	
		
	Rem
		bbdoc: Remove a registered game state from the manager
		about: The state's Shutdown() method will be called before it is removed
	EndRem
	Method RemoveGameState(state:TGameState)
		If Not state.link Then Throw "You cannot remove a game state that hasn't been added"
		If currentState = state Then Throw "You cannot remove the currently active game state"
		State.Shutdown()
		gameStates.Remove(state)
	End Method
	
	
	
	rem
		bbdoc: Calls the Render() method of the currently active game state
		about:
	endrem		
	Method Render()
		If Not currentState Then Return
		currentState.Render()
	End Method
	
	
	
	rem
		bbdoc: Set the specifed game state to be active
		about: If a state is already running then its Leave() method
		will be called before making the specified state current and
		calling its Enter() method
	endrem	
	Method SetGameState(state:TGameState)
		If currentState Then currentState.Leave()
		currentState = state
		currentState.Enter()
	End Method
	
	
	
	rem
		bbdoc: Set the specifed game state to be active, looked up by name
		about: See SetGameState() for more details
	endrem	
	Method SetGameStateByName(stateName:String)
		Local state:TGameState = TGameState(Self.gameStatesMap.ValueForKey(stateName))
		If state
			SetGameState(state)
		Else
			Throw "Game State ~q" + stateName + "~q does not exist"
		End If
	End Method
		

	
	rem
		bbdoc: Shutdown the #TGameStateManager service
		about: This shuts down all registered game states and removes them
		before shutting itself down
	endrem				
	Method Shutdown()
		For Local state:TGameState = EachIn gameStates
			state.Shutdown()
			gameStates.Remove(state)
		Next
		Super.Shutdown()
	End Method

	
		
	rem
		bbdoc: Starts the #TGameStateManager service
		about: This initialises all registered game states
	endrem	
	Method Start()
		For Local state:TGameState = EachIn gameStates
			state.Initialise()
		Next
	End Method

	
	
	rem
		bbdoc: Calles the Update method of the currently active game state
		about: This is called once every logic iteration. If there is no currently active
		state it will start the first registered state. In the case there are no registered
		states it will do nothing.
	endrem		
	Method Update()
		If Not currentState
			If gameStates.Count() > 0
				currentState = TGameState(gameStates.First())
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

Function rrRemoveGameState(State:TGameState)
	TGameStateManager.GetInstance().RemoveGameState(State)
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