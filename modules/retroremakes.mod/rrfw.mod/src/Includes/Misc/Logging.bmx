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

Rem
bbdoc:Logs an Alert level message
EndRem
Function rrLogAlert(message:String)
	TLogger.getInstance().LogAlert(message)
End Function



Rem
bbdoc:Logs a Critical level message
EndRem
Function rrLogCritical(message:String)
	TLogger.getInstance().LogCritical(message)
End Function



Rem
bbdoc:Logs a Debug level message
EndRem
Function rrLogDebug(message:String)
	TLogger.getInstance().LogDebug(message)
End Function



Rem
bbdoc:Logs an Emergency level message
EndRem
Function rrLogEmergency(message:String)
	TLogger.getInstance().LogEmergency(message)
End Function



Rem
bbdoc:Logs an Error level message
EndRem
Function rrLogError(message:String)
	TLogger.getInstance().LogError(message)
End Function



Rem
bbdoc:Logs an Info level message
EndRem
Function rrLogInfo(message:String)
	TLogger.getInstance().LogInfo(message)
End Function



Rem
bbdoc:Logs a Notice level message
EndRem
Function rrLogNotice(message:String)
	TLogger.getInstance().LogNotice(message)
End Function



Rem
bbdoc:Logs a Warning level message
EndRem
Function rrLogWarning(message:String)
	TLogger.getInstance().LogWarning(message)
End Function