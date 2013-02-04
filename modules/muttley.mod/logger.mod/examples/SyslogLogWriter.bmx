SuperStrict

Framework muttley.logger

' The default TSysLogWriter configuration will send its messages
' to a syslog server on localhost.
'
Local syslogWriter:TSyslogLogWriter = New TSyslogLogWriter
syslogWriter.setLevel (LOGGER_DEBUG)

Local logger:TLogger = Tlogger.getInstance()
logger.addWriter (syslogWriter)

logger.LogInfo  ("[SyslogLogWriter] An example Info log message")
logger.LogError ("[SyslogLogWriter] An example Error log message")

logger.close()
