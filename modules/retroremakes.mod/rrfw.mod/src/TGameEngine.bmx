rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.

' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Rem
	bbdoc: The core of the RetroRemakes Framework.
EndRem
Type TGameEngine

	rem
		bbdoc: The #TGameEngine instance
		about: #TGameEngine is a @{Singleton Type} and when it is instantiated this @Global holds
		a reference to the instance
	endrem	
	Global instance:TGameEngine

	rem
		bbdoc: Whether to use the current executable directory for writing to or not.
		about: If false, we will use an OS specific recommended directory (default).
	endrem
	Global exeDirectoryForData:Int = False

	rem
		bbdoc: The TGameManager that the engine has been told to call as part of the main loop
	endrem
	Field gameManager:TGameManager
	
	Method SetGameManager(value:TGameManager)
		gameManager = value
	End Method
	
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
'#Region updateFrameCount Get/Set Methods
	Rem
		bbdoc: Get the updateFrameCount value in this TGameEngine object.
	End Rem
	Method GetUpdateFrameCount:Int()
		Return Self.updateFrameCount
	End Method
	Rem
		bbdoc: Set the updateFrameCount value for this TGameEngine object.
	End Rem
	Method SetUpdateFrameCount(value:Int)
		Self.updateFrameCount = Value
	End Method
'#End Region 
	
	rem
		bbdoc: Counter showing how many time the #TGameEngine #Render method has been called
	endrem
	Field renderFrameCount:Int
'#Region renderFrameCount Get/Set Methods
	Rem
		bbdoc: Get the renderFrameCount value in this TGameEngine object.
	End Rem
	Method GetRenderFrameCount:Int()
		Return Self.renderFrameCount
	End Method
	Rem
		bbdoc: Set the renderFrameCount value for this TGameEngine object.
	End Rem
	Method SetRenderFrameCount(value:Int)
		Self.renderFrameCount = value
	End Method
'#End Region 
	
	rem
		bbdoc: @True if the TGameEngine instance is running
	endrem	
	Field engineRunning:Int
'#Region engineRunning Get/Set Methods
	Rem
		bbdoc: Get the engineRunning value in this TGameEngine object.
	End Rem
	Method GetEngineRunning:Int()
		Return Self.engineRunning
	End Method
	Rem
		bbdoc: Set the engineRunning value for this TGameEngine object.
	End Rem
	Method SetEngineRunning(value:Int)
		Self.engineRunning = value
	End Method
'#End Region 

	rem
		bbdoc: @True if the TGameEngine instance is paused by using #SetPaused
	endrem	
	Field enginePaused:Int

	rem
		bbdoc: This is the logger used by the Engine
	endrem	
	Field logger:TLogger
	
	rem
		bbdoc: This is the log file writer used by the engin
	endrem
	Field logFile:TFileLogWriter
	
	rem
		bbdoc: @true if debug is enabled
	endrem	
	Field debugEnabled:Int
	
	rem
		bbdoc: The debug level to use for the engines log file
	endrem
	Field debugLevel:Int

	' Some profilers for core engine routines, only really required in debug mode
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
	Field gameDirectory:String
'#Region gameDirectory Get/Set Methods
	Rem
		bbdoc: Get the gameDirectory value in this TGameEngine object.
	End Rem
	Method GetGameDirectory:String()
		Return Self.gameDirectory
	End Method
	Rem
		bbdoc: Set the gameDirectory value for this TGameEngine object.
	End Rem
	Method SetGameDirectory(value:String)
		Self.gameDirectory = value
	End Method
'#End Region 
	
	rem
		bbdoc: The name of the game executable
	endrem
	Field gameExecutable:String
'#Region gameExecutable Get/Set Methods
	Rem
		bbdoc: Get the gameExecutable value in this TGameEngine object.
	End Rem
	Method GetGameExecutable:String()
		Return Self.gameExecutable
	End Method
	Rem
		bbdoc: Set the gameExecutable value for this TGameEngine object.
	End Rem
	Method SetGameExecutable(value:String)
		Self.gameExecutable = value
	End Method
'#End Region 
	
	rem
		bbdoc: The name of the game.
		about: This is the executable name with the extension and directory stripped.
	endrem
	Field gameName:String
'#Region gameName Get/Set Methods
	Rem
		bbdoc: Get the gameName value in this TGameEngine object.
	End Rem
	Method GetGameName:String()
		Return Self.gameName
	End Method
	Rem
		bbdoc: Set the gameName value for this TGameEngine object.
	End Rem
	Method SetGameName(value:String)
		Self.gameName = value
	End Method
'#End Region 

	rem
		bbdoc: The data directory to be used for storing game generated files
	endrem	
	Field gameDataDirectory:String
'#Region gameDataDirectory Get/Set Methods
	rem
		bbdoc: Gets the directory that this game's data should be stored in
		returns: String
		about: The directory returned will have the same name as the game executable and,
		depending on the platform, will be situated in on of these paths
		<br />
		<table align="center">
		<tr><th>Platform</th><th>Example</th><th>Equivalent</th></tr>
		<tr><td>Linux</td><td>/home/username</td><td>~</td></tr>
		<tr><td>Mac OS</td><td>/Users/username/Library/Application Support</td><td>~/Library/Application Support</td></tr>
		<tr><td>Win32</td><td>C:\Documents and Settings\username\Application Data</td><td>&nbsp;</td></tr>
		</table>
	endrem
	Method GetGameDataDirectory:String()
		Return Self.gameDataDirectory
	End Method
	Rem
		bbdoc: Set the gameDataDirectory value for this TGameEngine object.
	End Rem
	Method SetGameDataDirectory(value:String)
		Self.gameDataDirectory = value
	End Method
'#End Region 

	
	
	rem
		bbdoc: Adds a #TGameService instance to the TGameEngine
		about: When a child of #TGameService is instantiated, it registers itself with the
		#TGameEngine instance using this method.<br>
		This method uses Reflection to find out if they have the following methods:
		<table>
		<tr><th>Method</th><th>Description</th></tr>
		<tr><td>DebugRender</td><td>Called during the main #TGameEngine #DebugRender loop</td></tr>
		<tr><td>DebugUpdate</td><td>Called during the main #TGameEngine #DebugUpdate loop</td></tr>
		<tr><td>Render</td><td>Called during the main #TGameEngine #Render loop</td></tr>
		<tr><td>Start</td><td>Called when the #TGameEngine instance is started</td></tr>
		<tr><td>Update</td><td>Called during the main #TGameEngine #Update loop</td></tr>
		</table>
	endrem
	Method AddService(myService:TGameService)
		logger.LogInfo("[" + toString() + "] Adding service: " + myService.ToString())
		ListAddLast(LAllServices, myService)

		' use reflection to find out if this service has render, update or flip methods
		Local myTTypeId:TTypeId = TTypeId.ForObject(Object(myService))
		If myTTypeId.FindMethod("Update")
		
			logger.LogInfo("[" + toString() + "] Registered service ~q" + myService.ToString() + "~q with the Update manager, priority: " + myService.GetUpdatePriority())
			ListAddLast(LUpdateServices, myService)
			
			' Create an update method profiler which will be used if debugging is enabled
			TGameService(myService).updateProfiler = rrCreateProfilerSample(myService.ToString() + ": Update")
		EndIf
		
		If myTTypeId.FindMethod("Render")
			logger.LogInfo("[" + toString() + "] Registered service ~q" + myService.ToString() + "~q with the Render manager, priority: " + myService.GetRenderPriority())
			ListAddLast(LRenderServices, myService)
			TGameService(myService).renderProfiler = rrCreateProfilerSample(myService.ToString() + ": Render")
		EndIf
		
		If myTTypeId.FindMethod("DebugUpdate")
			logger.LogInfo("[" + toString() + "] Registered service ~q" + myService.ToString() + "~q with the DebugUpdate Manager, priority: " + myService.GetDebugUpdatePriority())
			ListAddLast(LDebugUpdateServices, myService)
			
			' Create an update method profiler which will be used if debugging is enabled
			TGameService(myService).debugUpdateProfiler = rrCreateProfilerSample(myService.ToString() + ": DebugUpdate")
		EndIf
		
		If myTTypeId.FindMethod("DebugRender")
			logger.LogInfo("[" + toString() + "] Registered service ~q" + myService.ToString() + "~q with the DebugRender manager, priority: " + myService.GetDebugRenderPriority())
			ListAddLast(LDebugRenderServices, myService)
			TGameService(myService).debugRenderProfiler = rrCreateProfilerSample(myService.ToString() + ": DebugRender")
		EndIf
		
		If myTTypeId.FindMethod("Start")
			logger.LogInfo("[" + toString() + "] Registered service ~q" + myService.ToString() + "~q with the Start manager, priority: " + myService.GetStartPriority())
			ListAddLast(LStartServices, myService)
		EndIf
		
		' Sort the lists by relevant priority
		SortList(LUpdateServices, True, TGameService.UpdatePrioritySort)
		SortList(LRenderServices, True, TGameService.RenderPrioritySort)
		SortList(LDebugUpdateServices, True, TGameService.DebugUpdatePrioritySort)
		SortList(LDebugRenderServices, True, TGameService.DebugRenderPrioritySort)
		SortList(LStartServices, True, TGameService.StartPrioritySort)
	
	End Method	

	
	
	rem
		bbdoc: Close the logfile used by the #TGameEngine instance
	endrem	
	Method CloseLog()
		logger.Close()
	End Method
		
	
	
	rem
		bbdoc: Create a TLogFile to be used by the #TGameEngine instance
	endrem		
	Method CreateLog()
		logger = TLogger.getInstance()
		
		logFile = New TFileLogWriter
		logFile.setFilename(GetGameDataDirectory() + "/" + GetGameName() + ".log")
		logFile.setLevel(LOGGER_INFO)
		logger.addWriter(logFile)
				
 		logger.LogInfo("Powered by the " + My.Application.Name + " v" + My.Application.VersionString + " (" + My.Application.Platform + "/" + My.Application.Architecture + ")")
		logger.LogInfo("Project Home Page: http://code.google.com/p/retroremakes-framework/")

		logfile.SetLevel(debugLevel)
	End Method
		
	
	
	rem
		bbdoc: Calls the @DebugRender method for all necessary #TGameService instances
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
		
	
	
	rem
		bbdoc: Finds and creates if necessary the directory to write data to
		about: Directory is used for log files, configuration files, saved high-score tables, etc.
	endrem
	Method FindDataDirectory:String()
		Local dir:String = GetGameDirectory() + "/"
		If Not exeDirectoryForData
			Local AppDir:String = GetUserAppDir()
			
			Select FileType(AppDir + "/" + GetGameName())
				Case 0
					'directory doesn't exist
					If Not CreateDir(AppDir + "/" + GetGameName())
						rrThrow ("Unable to create game data directory: " + AppDir + "/" + GetGameName())
					End If
					dir = AppDir + "/" + GetGameName() + "/"
				Case 1
					'file of that name exists
					rrThrow ("Unable to create game data directory: " + AppDir + "/" + GetGameName())
				Case 2
					'directory already exists, no problem
					dir = AppDir + "/" + GetGameName() + "/"
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
		bbdoc: Return an instance of #TGameEngine
		returns: #TGameEngine
		about: Returns a new instance of #TGameEngine, or if one already exists returns that instance instead
	endrem	
	Function GetInstance:TGameEngine()
		If Not instance
			Return New TGameEngine
		Else
			Return instance
		EndIf
	End Function
	
	
		
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

	
	
	rem
		bbdoc: Handler for keyboard input messages
		about: Currently only used for catching F11 to take a screenshot
	endrem
	Method HandleKeyboardInput(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		Select data.key
			Case KEY_F11
				rrTakeScreenshot()
		End Select
	End Method
		
	
	
	rem
		bbdoc: Increments the Render Frame Counter
	endrem
	Method IncrementRenderFrameCount()
		SetRenderFrameCount(GetRenderFrameCount() + 1)
	End Method
	
	
		
	rem
		bbdoc: Increments the Update Frame Counter
	endrem
	Method IncrementUpdateFrameCount()
		SetUpdateFrameCount(GetUpdateFrameCount() + 1)
	End Method
	
	
		
	rem
		bbdoc: Initialise the TGameEngine instance
		returns:
		about: This method is called when the TGameEngine is instantiated
		<br /> 
		It creates the core #TGameService Types, starts logging and sets some default values
	endrem		
	Method Initialise()
		LAllServices = New TList					' All Services that have registered
		LRenderServices:TList = New TList		' Services that need to be rendered each frame
		LUpdateServices:TList = New TList		' Services that need to be updated each logic step
		LDebugRenderServices:TList = New TList	' Services that need to be rendered each frame if Debug enabled
		LDebugUpdateServices:TList = New TList	' Services that need to be updated each logic step	if Debug enabled
		LStartServices:TList = New TList			' Services that need to be started when the engine is first run
		
		SetUpdateFrameCount(0)
		SetRenderFrameCount(0)
			
		' Do we want to turn on debug mode?
		' From the command line
		For Local i:String = EachIn AppArgs
			Select i.ToLower()
				Case "-debug"
					debugEnabled = True
				Case "-exedirectoryfordata"
					exeDirectoryForData = True
			End Select
		Next
		
		?Debug
			debugEnabled = True
		?
		
		If debugEnabled
			debugLevel = LOGGER_DEBUG
		Else
			debugLevel = LOGGER_ERROR
		End If
		
		SetGameDirectory(ExtractDir(AppArgs[0]))
		
		SetGameExecutable(StripDir(AppArgs[0]))
		
		SetGameName(StripAll(AppArgs[0]))
		
		'Set the AppTitle.  This can be overridden but is a good default
		AppTitle = GetGameName() + " :: Powered by the RetroRemakes Framework"
		
		SetGameDataDirectory(FindDataDirectory())
		
		CreateLog()	' start logfile
		
		TGameSettings.GetInstance().SetIniFilePath(GetGameDataDirectory() + GetGameName() + ".ini")
		TGameSettings.GetInstance().Load()

		' See if debug mode has been enabled in the INI file.
		If rrGetBoolVariable("DEBUG_ENABLED", "false", "Engine")
			SetDebugLevel(LOGGER_DEBUG)
		EndIf
		?
		
		logger.LogInfo("[" + toString() + "] Game directory: " + GetGameDirectory())
		logger.LogInfo("[" + toString() + "] Executable: " + GetGameExecutable())
		logger.LogInfo("[" + toString() + "] Game Name: " + GetGameName())

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
		'TGameStateManager.GetInstance()
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
		logger.LogInfo("[" + toString() + "] Initialised")
	End Method

	
	
	rem
		bbdoc: The listener method that any messages are delivered to
	endrem
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
		If instance rrThrow ("Cannot create multiple instances of Singleton Type")
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
		about: This method is usually called when the #TGameService is shutting down
		and removes a #TGameService
	endrem		
	Method RemoveService(myService:TGameService)
		logger.LogInfo("[" + toString() + "] Removing service: " + myService.ToString())
		ListRemove(LAllServices, myService)
		ListRemove(LUpdateServices, myService)
		ListRemove(LRenderServices, myService)
		ListRemove(LDebugUpdateServices, myService)
		ListRemove(LDebugRenderServices, myService)
		ListRemove(LStartServices, myService)
	End Method

	
	
	rem
		bbdoc: Calls the @Render method for all necessary #TGameService instances
		about: This method is called by the main loop and updates all
		#TGameService instances that are registered
		with the #TGameService and have a @Render or @DebugRender method.
		<br /><br />
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
		
		Local tweening:Double = TFixedTimestep.GetInstance().GetTweening()
		
		If gameManager Then gameManager.Render(tweening, True)
		
		If debugEnabled
			DebugRender()
		End If
		
		IncrementRenderFrameCount()
		rrStopProfilerSample(renderProfile)
	End Method
		
	
	
	rem
		bbdoc: Runs the TGameEngine instance
		about: This method starts the main loop of the TGameEngine instance.
	endrem		
	Method Run()
	
		Try
			SetEngineRunning(True)
			StartServices()
			
			logger.LogInfo("[" + toString() + "] Engine running")
	
			If gameManager
				gameManager.Start()
			End If
			
			' Main loop
			While (GetEngineRunning() And Not AppTerminate())
				rrStartProfilerSample(mainLoopProfile)
				TGraphicsService.GetInstance().CheckIfActive()
			
				Update()
	
				Cls
	
				Render()
				
				Flip(TGraphicsService.GetInstance().vblank)
				rrStopProfilerSample(mainLoopProfile)
			Wend
			
			If gameManager
				gameManager.Stop()
			End If
						
			Shutdown()

		Catch obj:Object
			Local errorText:String = "[" + TTypeId.ForObject(obj).Name() + "] " + obj.ToString()
			logger.LogError(errorText)
			logger.LogError("[" + toString() + "] A fatal error has occured.")
			Notify("A fatal error has occured: " + errorText, True)
			Shutdown()
		End Try
	End Method
			
	
	
	rem
		bbdoc: Enable or Disable debug mode for the #TGameEngine instance
		about: @True to enable debug mode,
		or @False to disable it
	endrem		
	Method SetDebugLevel(value:Int)
		debugLevel = value
		logger.LogInfo("[" + toString() + "] Setting debug level " + debugLevel)
		logfile.SetLevel(debugLevel)
	End Method

	
	
	rem
		bbdoc: Pause or Unpause the #TGameEngine instance
		about: @True to %Pause the #TGameEngine instance,
		or @False to %Unpase it
	endrem		
	Method SetPaused(value:Int)
		enginePaused = value
		If value
			logger.LogInfo("[" + toString() + "] Game suspended")
			rrPauseSound(True)
		Else
			logger.LogInfo("[" + toString() + "] Game resumed")
			rrPauseSound(False)
		EndIf	
	End Method

	
	
	rem
		bbdoc: Shutdown the TGameEngine instance
		about: This method is called when the #TGameEngine has been flagged to @Stop.
		It calls the @Shutdown method for all registered TGameService instances, closes
		the log file and then @Ends the program
	endrem				
	Method Shutdown()
		logger.LogInfo("[" + toString() + "] Cleaning up")
		' TODO: Cleanup here
		For Local myService:TGameService = EachIn LAllServices
			logger.LogInfo("[" + toString() + "] Shutting down service: " + myService.ToString())
			myService.Shutdown()
			myService = Null
		Next
		logger.LogInfo("[" + toString() + "] Shutdown")
		CloseLog()
	End Method
		
	
	
	rem
		bbdoc: Calls the @Start method for all necessary #TGameService instances.
		about: This method starts all #TGameService instances that are registered
		with the #TGameService and have a @Start method.
	endrem		
	Method StartServices()
		For Local service:TGameService = EachIn LStartServices
			logger.LogInfo("[" + ToString() + "] Starting service: " + service.ToString())
			service.startMethod.Invoke(service, Null)
		Next
	End Method
		
	
	
	rem
		bbdoc: Flags the running TGameEngine instance to @Stop
		about: This method stops the main loop of the TGameEngine instance.
	endrem	
	Method Stop()
		SetEngineRunning(False)
	End Method

	
	
	Method ToString:String()
		Return "Engine"
	End Method
	
	
	
	rem
		bbdoc: Calls the @Update method for all necessary #TGameService instances
		about: This method is called by the main loop and updates all
		#TGameService instances that are registered
		with the #TGameService and have a @Update or @DebugUpdate method.
		<br /><br />
		The @DebugUpdate method is only called if debug is enabled by the #SetDebug or
		if this is a Debug build. 
		<br /><br />
		The #Update loop uses the #TFixedTimestep #TGameService to ensure that the
		#Update loop is run at the same rate regardless of the speed of the machine
		the engine is running on.
	endrem		
	Method Update()
		
		Global fixedTimestep:TFixedTimestep = TFixedTimestep.GetInstance()
		
		fixedTimestep.Calculate()
		
		Local dt:Double = fixedTimestep.GetDeltaTime()
		
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
			IncrementUpdateFrameCount()
			rrStopProfilerSample(updateProfile)
			
		Wend
		
		fixedTimestep.CalculateTweening()
		
	End Method
	
End Type
