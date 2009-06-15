Rem
	bbdoc: #TGameEngine
	about: The core of the RetroRemakes Framework.
EndRem
Type TGameEngine

	' Default value used if ini file setting is not defined.
	'Const DEFAULT_DEBUG_ENABLED:String = False

	rem
	bbdoc: The #TGameEngine instance
	about: #TGameEngine is a @{Singleton Type} and when it is instantiated this @Global holds
	a pointer to the instance
	endrem	
	Global instance:TGameEngine

	' Whether to use the current executable directory for writing to or not.
	' If false, we will use an OS specific recommended directory.
	Global exeDirectoryForData_:Int = False

	rem
	bbdoc: @TList containing all #TGameService instances that have registered with the #TGameEngine instance
	about: Every instance of #TGameService that registers with the #TGameEngine instance is added to this @TList
	endrem
	Field LAllServices:TList

	rem
	bbdoc: @TList containing all registered #TGameService instances that have a @Render Method
	about: If a #TGameService instance that registers includes a @Render method, it is added to this @TList
	<br>
	This TList is used in the main #Render loop
	endrem	
	Field LRenderServices:TList

	rem
	bbdoc: @TList containing all registered #TGameService instances that have an @Update Method
	about: If a #TGameService instance that registers includes an @Update method, it is added to this @TList
	<br>
	This TList is used in the main #Update loop		
	endrem
	Field LUpdateServices:TList

	rem
	bbdoc: @TList containing all registered #TGameService instances that have a DebugRender Method
	about: If a #TGameService instance that registers includes a @DebugRender method, it is added to this @TList
	<br>
	This TList is used in the main #DebugRender loop
	endrem	
	Field LDebugRenderServices:TList
	
	rem
	bbdoc: @TList containing all registered #TGameService instances that have a @DebugUpdate Method
	about: If a #TGameService instance that registers includes an @Update method, it is added to this @TList
	<br>
	This TList is used in the main #DebugUpdate loop			
	endrem	
	Field LDebugUpdateServices:TList

	rem
	bbdoc: @TList containing all registered #TGameService instances that have a @Start Method
	about: If a #TGameService instance that registers includes an @Start method, it is added to this @TList
	<br>
	This TList is used when the TGameEngine instance starts to run
	endrem	
	Field LStartServices:TList
	
	rem
	bbdoc: Counter showing how many time the #TGameEngine #Update method has been called
	endrem
	Field updateFrameCount:Int

	rem
	bbdoc: Counter showing how many time the #TGameEngine #Render method has been called
	endrem
	Field renderFrameCount:Int
	
	rem
	bbdoc: @True if the TGameEngine instance is running
	endrem	
	Field engineRunning:Int

	rem
	bbdoc: @True if the TGameEngine instance is paused by using #SetPaused
	endrem	
	Field enginePaused:Int
	'Global gameRunning:Int

	rem
	bbdoc: This is the log file used by the Engine
	endrem	
	Field logfile:TLogFile
	
	rem
	bbdoc: @true if debug is enabled
	endrem	
	Field debugEnabled:Int	

	' Some profilers for core engine routines, only required in debug mode
	rem
	bbdoc: Debug #TProfilerSample for the main loop
	endrem	
	Field mainLoopProfile:TProfilerSample

	rem
	bbdoc: Debug #TProfilerSample for the #Update loop
	endrem	
	Field updateProfile:TProfilerSample

	rem
	bbdoc: Debug #TProfilerSample for the #Render loop
	endrem	
	Field renderProfile:TProfilerSample

	rem
	bbdoc: Debug #TProfilerSample for the #DebugUpdate loop
	endrem	
	Field debugUpdateProfile:TProfilerSample

	rem
	bbdoc: Debug #TProfilerSample for the #DebugRender loop
	endrem	
	Field debugRenderProfile:TProfilerSample
	
	rem
	bbdoc: The directory that the game was launched from
	endrem
	Field gameDirectory_:String
	
	rem
	bbdoc: The name of the game executable
	endrem
	Field gameExecutable_:String
	
	rem
	bbdoc: The name of the game.  This is the executable name with the
	extension and directory stripped.
	endrem
	Field gameName_:String

	rem
	bbdoc: The data directory to be used for storing game generated files
	endrem	
	Field gameDataDirectory_:String

	
	
	rem
	bbdoc: Create a new instance of #TGameEngine
	returns: #TGameEngine
	about: Returns a new instance of #TGameEngine, or if one already
	exists returns that instance instead
	endrem	
	Function GetInstance:TGameEngine()
		If Not instance
			Return New TGameEngine
		Else
			Return instance
		EndIf
	End Function	
	
	
	
	rem
	bbdoc: Adds a #TGameService instance to the TGameEngine
	returns:
	about: When a child of #TGameService is instantiated, it registers itself with the
	#TGameEngine instance using this method.
	<br>
	This method uses Reflection to find out if they have the following methods:
	<table
	<tr><th>Method</th><th>Description</th></tr>
	<tr><td>DebugRender</td><td>Called during the main #TGameEngine #DebugRender loop</td></tr>
	<tr><td>DebugUpdate</td><td>Called during the main #TGameEngine #DebugUpdate loop</td></tr>
	<tr><td>Render</td><td>Called during the main #TGameEngine #Render loop</td></tr>
	<tr><td>Start</td><td>Called when the #TGameEngine instance is started</td></tr>
	<tr><td>Update</td><td>Called during the main #TGameEngine #Update loop</td></tr>
	</table>
	endrem
	Method AddService(myService:TGameService)
		LogInfo("Adding Service ~q" + myService.ToString() + "~q")
		ListAddLast(LAllServices, myService)

		' use reflection to find out if this service has render, update or flip methods
		Local myTTypeId:TTypeId = TTypeId.ForObject(Object(myService))
		If myTTypeId.FindMethod("Update")
		
			LogInfo("Registered Service ~q" + myService.ToString() + "~q with the Update Manager, priority: " + myService.GetUpdatePriority())
			ListAddLast(LUpdateServices, myService)
			
			' Create an update method profiler which will be used if debugging is enabled
			TGameService(myService).updateProfiler = rrCreateProfilerSample(myService.ToString() + ": Update")
		EndIf
		
		If myTTypeId.FindMethod("Render")
			LogInfo("Registered Service ~q" + myService.ToString() + "~q with the Render Manager, priority: " + myService.GetRenderPriority())
			ListAddLast(LRenderServices, myService)
			TGameService(myService).renderProfiler = rrCreateProfilerSample(myService.ToString() + ": Render")
		EndIf
		
		If myTTypeId.FindMethod("DebugUpdate")
			LogInfo("Registered Service ~q" + myService.ToString() + "~q with the DebugUpdate Manager, priority: " + myService.GetDebugUpdatePriority())
			ListAddLast(LDebugUpdateServices, myService)
			
			' Create an update method profiler which will be used if debugging is enabled
			TGameService(myService).debugUpdateProfiler = rrCreateProfilerSample(myService.ToString() + ": DebugUpdate")
		EndIf
		
		If myTTypeId.FindMethod("DebugRender")
			LogInfo("Registered Service ~q" + myService.ToString() + "~q with the DebugRender Manager, priority: " + myService.GetDebugRenderPriority())
			ListAddLast(LDebugRenderServices, myService)
			TGameService(myService).debugRenderProfiler = rrCreateProfilerSample(myService.ToString() + ": DebugRender")
		EndIf
		
		If myTTypeId.FindMethod("Start")
			LogInfo("Registered Service ~q" + myService.ToString() + "~q with the Start Manager, priority: " + myService.GetStartPriority())
			ListAddLast(LStartServices, myService)
		EndIf
		
		' Sort the lists by relevant priority
		SortList(LUpdateServices, True, rrServiceUpdatePrioritySort)
		SortList(LRenderServices, True, rrServiceRenderPrioritySort)
		SortList(LDebugUpdateServices, True, rrServiceDebugUpdatePrioritySort)
		SortList(LDebugRenderServices, True, rrServiceDebugRenderPrioritySort)
		SortList(LStartServices, True, rrServiceStartPrioritySort)
	
	End Method	

	
	
	rem
	bbdoc: Close the logfile used by the #TGameEngine instance
	returns:
	endrem	
	Method CloseLog()
		logfile.Close()
	End Method
		
	
	
	rem
	bbdoc: Create a TLogFile to be used by the #TGameEngine instance
	returns:
	endrem		
	Method CreateLog()
		Local logName:String = gameDataDirectory_ + "/" + gameName_ + ".log"
		Local logDescription:String = gameName_ + " Log File"
		logfile = TLogFile.Create(logName, logDescription, LOG_ERROR)	' Logfile only shows errors by default
 		logfile.LogGlobal("Powered by the " + My.Application.Name + " v" + My.Application.VersionString + " (" + My.Application.Platform + "/" + My.Application.Architecture + ")")
		logfile.LogGlobal("Project Home Page: http://code.google.com/p/retroremakes-framework/")
		If debugEnabled
			logfile.WriteEntry("Debug enabled", LOG_GLOBAL)
			logfile.SetLevel(LOG_INFO)
		EndIf
	End Method
		
	
	
	rem
	bbdoc: Calls the @DebugRender method for all necessary #TGameService instances
	returns:
	about: This method is called by the #TGameService #Render method only if
	debug is enabled by the #SetDebug method, or	if this is a Debug build. 
	endrem		
	Method DebugRender()
		rrStartProfilerSample(debugRenderProfile)
		For Local service:TGameService = EachIn LDebugRenderServices
			rrPushRenderState
			rrStartProfilerSample(service.debugRenderProfiler)
			service.debugRenderMethod.Invoke(service, Null)
			rrPopRenderState
			rrStopProfilerSample(service.debugRenderProfiler)
		Next
		rrStopProfilerSample(debugRenderProfile)
	End Method
		
	
	
	rem
	bbdoc: Calls the @DebugUpdate method for all necessary #TGameService instances
	returns:
	about: This method is called by the #TGameService #Update method only if
	debug is enabled by the #SetDebug method, or	if this is a Debug build. 
	endrem
	Method DebugUpdate()
		rrStartProfilerSample(debugUpdateProfile)
		For Local service:TGameService = EachIn LDebugUpdateServices
			rrPushRenderState
			rrStartProfilerSample(service.debugUpdateProfiler)
			service.debugUpdateMethod.Invoke(service, Null)
			rrPopRenderState
			rrStopProfilerSample(service.debugUpdateProfiler)
		Next
		rrStopProfilerSample(debugUpdateProfile)
	End Method
		
	
	
	'Finds and/or creates the directory to store game data in
	Method FindDataDirectory:String()
		Local dir:String = gameDirectory_ + "/"
		If Not exeDirectoryForData_
			Local AppDir:String = GetUserAppDir()
			
			Select FileType(AppDir + "/" + gameName_)
				Case 0
					'directory doesn't exist
					If Not CreateDir(AppDir + "/" + gameName_)
						Throw "Unable to create game data directory: " + AppDir + "/" + gameName_
					End If
					dir = AppDir + "/" + gameName_ + "/"
				Case 1
					'file of that name exists
					Throw "Unable to create game data directory: " + AppDir + "/" + gameName_
				Case 2
					'directory already exists, no problem
					dir = AppDir + "/" + gameName_ + "/"
			End Select
		EndIf
		Return dir
	End Method
		
	
	
	rem
	bbdoc: Returns the names of all TGameServices registered with the #TGameEngine #LAllServices @Tlist
	returns: String[]
	endrem		
	Method GetAllServices:String[] ()
		Return GetRegisteredServices(LAllServices)
	End Method

	
	
	rem
	bbdoc: Gets the directory that this game's data should be stored in
	returns: String
	about: The directory returned will have the same name as the game executable and,
	depending on the platform, will be situated in on of these paths
	<br>
	<table align="center">
	<tr><th>Platform</th><th>Example</th><th>Equivalent</th></tr>
	<tr><td>Linux</td><td>/home/username</td><td>~</td></tr>
	<tr><td>Mac OS</td><td>/Users/username/Library/Application Support</td><td>~/Library/Application Support</td></tr>
	<tr><td>Win32</td><td>C:\Documents and Settings\username\Application Data</td><td>&nbsp;</td></tr>
	</table>
	endrem
	Method GetDataDirectory:String()
		Return gameDataDirectory_
	End Method
					
	
	
	rem
	bbdoc: Determine whether the #TGameEngine instance has debug enabled
	returns: @True if debug is enabled
	about: #GetDebug will return @True if debug is enabled, or @False if it is not
	endrem
	Method GetDebug:Int()
		Return debugEnabled
	End Method

	
	
	rem
	bbdoc: Returns the names of all TGameServices registered with the #TGameEngine #LRenderServices @TList
	returns: String[]
	endrem	
	Method GetDebugRenderServices:String[] ()
		Return GetRegisteredServices(LDebugRenderServices)
	End Method
		
	
	
	rem
	bbdoc: Returns the names of all TGameServices registered with the #TGameEngine #LDebugUpdateServices @TList
	returns: String[]
	endrem	
	Method GetDebugUpdateServices:String[] ()
		Return GetRegisteredServices(LDebugUpdateServices)
	End Method

	
	
	rem
	bbdoc: Returns the names of all TGameServices registered with the #TGameEngine in a specified @Tlist
	returns: String[]
	endrem			
	Method GetRegisteredServices:String[] (list:TList)
		Local _services:String[] = New String[list.Count()]
		Local i:Int = 0
		For Local service:TGameService = EachIn list
			_services[i] = service.ToString() + " - Render: " + service.renderPriority + ", Update: " + service.updatePriority
			i:+1
		Next
		Return _services
	End Method
			
	
	
	rem
	bbdoc: Returns the names of all TGameServices registered with the #TGameEngine #LStartServices @TList
	returns: String[]
	endrem	
	Method GetStartServices:String[] ()
		Return GetRegisteredServices(LStartServices)
	End Method
			
	
	
	rem
	bbdoc: Returns the names of all TGameServices registered with the #TGameEngine #LUpdateServices @TList
	returns: String[]
	endrem	
	Method GetUpdateServices:String[] ()
		Return GetRegisteredServices(LUpdateServices)
	End Method
		
	
	
	rem
	bbdoc: Determine whether the #TGameEngine instance is paused?
	returns: @True if paused
	about: #GetPaused will return @True if the TGameEngine instance is paused,
	or @False if it is not
	endrem
	Method GetPaused:Int()
		Return enginePaused
	End Method

	
	
	rem
	bbdoc: Returns the names of all TGameServices registered with the #TGameEngine #LRenderServices @TList
	returns: String[]
	endrem	
	Method GetRenderServices:String[] ()
		Return GetRegisteredServices(LRenderServices)
	End Method

	
	
	Method HandleKeyboardInput(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		Select data.key
			Case KEY_ESCAPE
				'engineRunning = False
			Case KEY_F11
				rrTakeScreenshot()
		End Select
	End Method
		
	
	
	rem
	bbdoc: Initialise the TGameEngine instance
	returns:
	about: This method is called when the TGameEngine is instantiated
	<br> 
	It instantiates the core #TGameService Types, starts logging and sets some default values
	endrem		
	Method Initialise()
		LAllServices = New TList					' All Services that have registered
		LRenderServices:TList = New TList		' Services that need to be rendered each frame
		LUpdateServices:TList = New TList		' Services that need to be updated each logic step
		LDebugRenderServices:TList = New TList	' Services that need to be rendered each frame if Debug enabled
		LDebugUpdateServices:TList = New TList	' Services that need to be updated each logic step	if Debug enabled
		LStartServices:TList = New TList			' Services that need to be started when the engine is first run
		
		updateFrameCount = 0
		renderFrameCount = 0
			
		' Do we want to turn on debug mode?
		' From the command line
		For Local i:String = EachIn AppArgs
			If i.ToLower() = "-debug" Then rrEnableDebug()
		Next
						
		gameDirectory_:String = ExtractDir(AppArgs[0])
		
		gameExecutable_:String = StripDir(AppArgs[0])
		
		gameName_ = StripAll(AppArgs[0])
		
		'Set the AppTitle.  This can be overridden but is a good default
		AppTitle = gameName_ + " :: Powered by the RetroRemakes Framework"
		
		gameDataDirectory_ = FindDataDirectory()		
		
		CreateLog()	' start logfile
		
		TGameSettings.GetInstance().SetIniFilePath(gameDataDirectory_ + gameName_ + ".ini")
		TGameSettings.GetInstance().Load()

		' See if debug mode has been enabled in the INI file.
		If rrGetBoolVariable("DEBUG_ENABLED", "false", "Engine")
			debugEnabled = True
			rrEnableDebug()
		EndIf
		
		LogInfo("Game directory: " + gameDirectory_)
		LogInfo("Executable: " + gameExecutable_)
		LogInfo("Game Name: " + gameName_)		

		TResourceManager.GetInstance()
		TFramesPerSecond.GetInstance()
		TProjectionMatrix.GetInstance()
		TColourOscillator.GetInstance()
		TScaleOscillator.GetInstance()
		TGraphicsService.GetInstance()
		TFixedTimestep.GetInstance()
		TGameSoundHandler.GetInstance()
		TProfiler.GetInstance()
		TConsole.GetInstance()
		TScoreService.GetInstance()
		TGameStateManager.GetInstance()
		TPhysicsManager.GetInstance()
		TMessageService.GetInstance()
		TInputManager.GetInstance()
		
		'Add some commands to the console
		rrAddConsoleCommand("services", "services - show all registered services", cmdServices)
		rrAddConsoleCommand("quit", "quit - quit the game", cmdQuit)
		
		' Main engine profilers for debugging purposes
		mainLoopProfile = rrCreateProfilerSample("Engine: Main Loop")
		updateProfile = rrCreateProfilerSample("Engine: Update")
		renderProfile = rrCreateProfilerSample("Engine: Render")
		debugUpdateProfile = rrCreateProfilerSample("Engine: DebugUpdate")
		debugRenderProfile = rrCreateProfilerSample("Engine: DebugRender")
		LogGlobal("Engine Initialised")
	End Method

	
	
	rem
	bbdoc: Write a LOG_ERROR message to the #TGameEngine log file
	returns:
	endrem			
	Method LogError(myEntry:String)
		logfile.LogError(myEntry)
	End Method

	
	
	rem
	bbdoc: Write a LOG_GLOBAL message to the #TGameEngine log file
	returns:
	endrem			
	Method LogGlobal(myEntry:String)
		logfile.LogGlobal(myEntry)
	End Method
			
	
	
	rem
	bbdoc: Write a LOG_INFO message to the #TGameEngine log file
	returns:
	endrem			
	Method LogInfo(myEntry:String)
		logfile.LogInfo(myEntry)
	End Method

	

	rem
	bbdoc: Write a LOG_WARN message to the #TGameEngine log file
	returns:
	endrem			
	Method LogWarn(myEntry:String)
		logfile.LogWarn(myEntry)
	End Method	
	
	
	
	' 
	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardInput(message)
		EndSelect
	End Method					

	
	
	rem
	bbdoc: Create a new instance of #TGameEngine
	about: Will Throw an exception if you try to create more than one instance
	endrem
	Method New()
		If instance Throw "Cannot create multiple instances of Singleton Type"
		instance = Self
		
		' Automatically enable debug mode if we're running a debug version
		' this will give access to the console and turn on profiling, etc.
		' It is also be possible to enable this via an INI file setting
		' or command line switch	
		?debug
			debugEnabled = True
		?Not debug
			debugEnabled = False
		?
		Self.Initialise()
	EndMethod
			
	
	
	rem
	bbdoc: Removes a #TGameService instance from the #TGameEngine
	returns:
	about: This method is usually called when the #TGameService is shutting down
	and removes a #TGameService
	endrem		
	Method RemoveService(myService:TGameService)
		LogInfo("Removing Service ~q" + myService.ToString() + "~q")
		ListRemove(LAllServices, myService)
		ListRemove(LUpdateServices, myService)
		ListRemove(LRenderServices, myService)
		ListRemove(LDebugUpdateServices, myService)
		ListRemove(LDebugRenderServices, myService)
		ListRemove(LStartServices, myService)
	End Method

	
	
	rem
	bbdoc: Calls the @Render method for all necessary #TGameService instances
	returns:
	about: This method is called by the main loop and updates all
	#TGameService instances that are registered
	with the #TGameService and have a @Render or @DebugRender method.
	<br><br>
	The @DebugRender method is only called if debug is enabled by the #SetDebug or
	if this is a Debug build. 	
	endrem		
	Method Render()
		rrStartProfilerSample(renderProfile)
		For Local service:TGameService = EachIn LRenderServices
			rrPushRenderState
			If debugEnabled
				rrStartProfilerSample(service.renderProfiler)
				service.renderMethod.Invoke(service, Null)
				rrStopProfilerSample(service.renderProfiler)
			Else
				service.renderMethod.Invoke(service, Null)
			EndIf
			rrPopRenderState
		Next
		If debugEnabled
			DebugRender()
		End If
		renderFrameCount:+1
		rrStopProfilerSample(renderProfile)
	End Method
		
	
	
	rem
	bbdoc: Runs the TGameEngine instance
	returns:
	about: This method starts the main loop of the TGameEngine instance.
	endrem		
	Method Run()
	
	?Not Debug
		Try
	?
			engineRunning = True
			StartServices()
			
			LogInfo("Engine Running")
	
			' Main loop
			While (engineRunning And Not AppTerminate())
				rrStartProfilerSample(mainLoopProfile)
				TGraphicsService.GetInstance().CheckIfActive()
			
				Update()
	
				Cls
	
				Render()
				
				Flip(TGraphicsService.GetInstance().vblank)
				rrStopProfilerSample(mainLoopProfile)
			Wend
			Shutdown()
		
		?Not Debug
			Catch obj:Object
				Local errorText:String = TTypeId.ForObject(obj).Name() + ":" + obj.ToString()
				LogError(errorText)
				Notify errorText
				Shutdown()
			End Try
		?
	End Method
			
	
	
	rem
	bbdoc: Enable or Disable debug mode for the #TGameEngine instance
	returns:
	about: @True to enable debug mode,
	or @False to disable it
	endrem		
	Method SetDebug(value:Int = True)
		debugEnabled = value
		logfile.WriteEntry("Debug enabled", LOG_GLOBAL)
		logfile.SetLevel(LOG_INFO)
	End Method

	
	
	rem
	bbdoc: Pause or Unpause the #TGameEngine instance
	returns:
	about: @True to %Pause the #TGameEngine instance,
	or @False to %Unpase it
	endrem		
	Method SetPaused(value:Int)
		enginePaused = value
		If value
			LogInfo("Game Suspended")
			rrPauseSound(True)
		Else
			LogInfo("Game Resumed")
			rrPauseSound(False)
		EndIf	
	End Method

	
	
	rem
	bbdoc: Shutdown the TGameEngine instance
	returns:
	about: This method is called when the #TGameEngine has been flagged to @Stop.
	It calls the @Shutdown method for all registered TGameService instances, closes
	the log file and then @Ends the program
	endrem				
	Method Shutdown()
		LogGlobal("Engine Cleaning Up")
		' TODO: Cleanup here
		For Local myService:TGameService = EachIn LAllServices
			LogInfo("Shutting down service ~q" + myService.ToString() + "~q")
			myService.Shutdown()
			myService = Null
		Next
		LogGlobal("Engine Shutdown")
		CloseLog()
		End
	End Method
		
	
	
	rem
	bbdoc: Calls the @Start method for all necessary #TGameService instances.
	returns:
	about: This method starts all #TGameService instances that are registered
	with the #TGameService and have a @Start method.
	endrem		
	Method StartServices()
		For Local service:TGameService = EachIn LStartServices
			LogInfo("Starting Service ~q" + service.ToString() + "~q")
			service.startMethod.Invoke(service, Null)
		Next
	End Method
		
	
	
	rem
	bbdoc: Flags the running TGameEngine instance to @Stop
	returns:
	about: This method stops the main loop of the TGameEngine instance.
	endrem	
	Method Stop()
		engineRunning = False
	End Method

	
	
	rem
	bbdoc: Calls the @Update method for all necessary #TGameService instances
	returns:
	about: This method is called by the main loop and updates all
	#TGameService instances that are registered
	with the #TGameService and have a @Update or @DebugUpdate method.
	<br><br>
	The @DebugUpdate method is only called if debug is enabled by the #SetDebug or
	if this is a Debug build. 
	<br><br>
	The #Update loop uses the #TFixedTimestep #TGameService to ensure that the
	#Update loop is run at the same rate regardless of the speed of the machine
	the engine is running on.
	endrem		
	Method Update()
		
		Global fixedTimestep:TFixedTimestep = TFixedTimestep.GetInstance()
		
		fixedTimestep.Calculate()
		
		While(fixedTimestep.TimeStepNeeded())
		
			rrStartProfilerSample(updateProfile)
			For Local service:TGameService = EachIn LUpdateServices
				If debugEnabled
					rrStartProfilerSample(service.updateProfiler)
					service.updateMethod.Invoke(service, Null)
					rrStopProfilerSample(service.updateProfiler)
				Else
					service.updateMethod.Invoke(service, Null)
				EndIf
			Next
			If debugEnabled
				DebugUpdate()
			End If
			updateFrameCount:+1
			rrStopProfilerSample(updateProfile)
			
		Wend
		
		fixedTimestep.CalculateTweening()
		
	End Method
	
End Type


'console command stuff
Function cmdQuit(parms:String[])
	TGameEngine.GetInstance().engineRunning = False
End Function



Function cmdServices(parms:String[])
	Local services:String[] = TGameEngine.GetInstance().GetAllServices()
	For Local i:String = EachIn services
		TConsole.GetInstance().AddConsoleText(i)
	Next
End Function



rem
bbdoc: Determine whether the #TGameEngine instance has debug enabled
returns: @True if debug is enabled
about: #rrDebugEnabled will return @True if debug is enabled, or @False if it is not
endrem
Function rrDebugEnabled:Int()
	Return TGameEngine.GetInstance().GetDebug()
End Function



rem
bbdoc: Disable debug mode for the #TGameEngine instance
returns:
endrem
Function rrDisableDebug()
	TGameEngine.GetInstance().SetDebug(False)
End Function



rem
bbdoc: Enable debug mode for the #TGameEngine instance
returns:
endrem
Function rrEnableDebug()
	TGameEngine.GetInstance().SetDebug(True)
End Function



Rem
bbdoc: Inititalise the #TGameEngine instance.
returns:
endrem
Function rrEngineInitialise()
	TGameEngine.GetInstance()
End Function



rem
bbdoc: Determine whether the #TGameEngine instance is paused
returns: @True if the #TGameEngine instance is paused
about: #rrEnginePased will return @True if debug is enabled, or @False if it is not
endrem
Function rrEnginePaused:Int()
	Return TGameEngine.GetInstance().GetPaused()
End Function



rem
bbdoc: Run the #TGameEngine instance
returns:
endrem
Function rrEngineRun()
	TGameEngine.GetInstance().Run()
End Function



rem
bbdoc: Stop the #TGameEngine instance
returns:
endrem
Function rrEngineStop()
	TGameEngine.GetInstance().Stop()
End Function



Rem
bbdoc: Find the directory being used to store data written by the game
returns: directory path
endrem
Function rrGetDataDirectory:String()
	Return TGameEngine.GetInstance().GetDataDirectory()
End Function



rem
bbdoc: Determine how many frames have been rendered
returns: The amount of frames rendered since the #TGameEngine was started
endrem
Function rrGetRenderFrameCount:Int()
	Return TGameEngine.GetInstance().renderFrameCount
End Function



rem
bbdoc: Determine how many update loops have been run
returns: The amount of times the update loop has been run since the #TGameEngine was started
endrem
Function rrGetUpdateFrameCount:Int()
	Return TGameEngine.GetInstance().updateFrameCount
End Function



rem
bbdoc: Pause the #TGameEngine instance
returns:
endrem
Function rrPauseEngine()
	TGameEngine.GetInstance().SetPaused(True)
End Function



rem
bbdoc: Unpause the #TGameEngine instance
returns:
endrem
Function rrUnpauseEngine()
	TGameEngine.GetInstance().SetPaused(False)
End Function



Rem
bbdoc: Specify whether data should be written to the executables directory.
The default is false, in which case the data will be written to an OS
specific application data directory.
returns:
endrem
Function rrUseExeDirectoryForData(bool:Int = True)
	TGameEngine.exeDirectoryForData_ = bool
End Function

