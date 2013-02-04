SuperStrict

Framework muttley.logger

Local consoleWriter:TConsoleLogWriter = New TConsoleLogWriter

consoleWriter.setLevel (LOGGER_DEBUG)
consoleWriter.showTimestamp (True)
consoleWriter.showSeverity  (True)

Local logger:TLogger = Tlogger.getInstance()
logger.addWriter (consoleWriter)

logger.LogInfo  ("[ConsoleLogWriter] An example Info log message")
logger.LogError ("[ConsoleLogWriter] An example Error log message")

logger.close()