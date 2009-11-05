SuperStrict

Framework retroremakes.rrfw

Include "src/GameManager.bmx"

rrUseExeDirectoryForData()

TGameEngine.GetInstance()
TGameEngine.GetInstance().SetGameManager(New MyGameManager)
rrEngineRun()
