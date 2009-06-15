
rem
bbdoc: Help function to log Info messages to the engine logfile
endrem
Function rrLogInfo(message:String)
	TGameEngine.GetInstance().LogInfo(message)
EndFunction

rem
bbdoc: Help function to log Warn messages to the engine logfile
endrem
Function rrLogWarn(message:String)
	TGameEngine.GetInstance().LogWarn(message)
EndFunction

rem
bbdoc: Help function to log Error messages to the engine logfile
endrem
Function rrLogError(message:String)
	TGameEngine.GetInstance().LogError(message)
EndFunction

rem
bbdoc: Help function to log Global messages to the engine logfile
endrem
Function rrLogGlobal(message:String)
	TGameEngine.GetInstance().LogGlobal(message)
EndFunction
