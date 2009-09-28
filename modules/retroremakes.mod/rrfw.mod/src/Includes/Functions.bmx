
Function rrGetMessageCount:Int()
	Return TMessageService.GetInstance().GetMessageCount()
End Function

Function rrSubscribeToChannel(channel:Int, listener:Object)
	TMessageService.GetInstance().SubscribeToChannel(channel, listener)
End Function

Function rrUnsubscribeFromChannel(channel:Int, listener:Object)
	TMessageService.GetInstance().UnsubscribeFromChannel(channel, listener)
End Function

Function rrUnsubscribeAllChannels(listener:Object)
	TMessageService.GetInstance().UnsubscribeAllChannels(listener)
End Function

Function rrCreateMessageChannel(channel:Int, name:String)
	TMessageService.GetInstance().CreateMessageChannel(channel, name)
End Function

Function rrDeleteMessageChannel(channel:Int, name:String)
	TMessageService.GetInstance().DeleteMessageChannel(channel, name)
End Function



'console command stuff
Function cmdQuit(parms:String[])
	TGameEngine.GetInstance().SetEngineRunning(False)
End Function



Function cmdServices(parms:String[])
	Local services:String[] = TGameEngine.GetInstance().GetAllServices()
	For Local i:String = EachIn services
		TConsole.GetInstance().AddConsoleText(i)
	Next
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
Function rrGetGameDataDirectory:String()
	Return TGameEngine.GetInstance().GetGameDataDirectory()
End Function



rem
bbdoc: Determine how many frames have been rendered
returns: The amount of frames rendered since the #TGameEngine was started
endrem
Function rrGetRenderFrameCount:Int()
	Return TGameEngine.GetInstance().GetRenderFrameCount()
End Function



rem
bbdoc: Determine how many update loops have been run
returns: The amount of times the update loop has been run since the #TGameEngine was started
endrem
Function rrGetUpdateFrameCount:Int()
	Return TGameEngine.GetInstance().GetUpdateFrameCount()
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
	TGameEngine.exeDirectoryForData = bool
End Function



Function rrResetFPS()
	TFramesPerSecond.GetInstance().Reset()
End Function

Function rrGetFPS:String()
	Return TFramesPerSecond.fps
End Function

Function rrGetFPSTotals:String()
	Return TFramesPerSecond.GetInstance().GetFPSTotals()
End Function


Function rrCalculateFixedTimestep()
	TFixedTimestep.GetInstance().Calculate()
End Function



Function rrCalculateRenderTweening()
	TFixedTimestep.GetInstance().CalculateTweening()
End Function



Function rrGetDeltaTime:Double()
	Return TFixedTimestep.GetInstance().GetDeltaTime()
End Function



Function rrGetUpdateFrequency:Double()
	Return TFixedTimestep.GetInstance().GetUpdateFrequency()
End Function



Function rrResetFixedTimestep()
	TFixedTimestep.GetInstance().Reset()
End Function



Function rrSetUpdateFrequency(freq:Double)
	rrSetDoubleVariable("LOGIC_UPDATE_FREQUENCY", freq, "Engine")
	TFixedTimestep.GetInstance().SetUpdateFrequency(freq)
End Function



Function rrStartFixedTimestep()
	TFixedTimestep.GetInstance().Start()
End Function



Function rrTimeStepNeeded:Int()
	Return TFixedTimestep.GetInstance().TimeStepNeeded()
End Function

