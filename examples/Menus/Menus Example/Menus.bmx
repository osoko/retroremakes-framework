SuperStrict

Framework retroremakes.rrfw

Include "src/GameManager.bmx"

rrUseExeDirectoryForData()

rrSetProjectionMatrixResolution(800, 600)
rrEnableProjectionMatrix()

TGameEngine.GetInstance()
TGameEngine.GetInstance().SetGameManager(New MyGameManager)
rrEngineRun()
