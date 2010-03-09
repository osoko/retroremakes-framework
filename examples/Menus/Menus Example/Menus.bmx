SuperStrict

Framework retroremakes.rrfw

Include "src/GameManager.bmx"

rrUseExeDirectoryForData()

TGameEngine.GetInstance()

rrSetProjectionMatrixResolution(800, 600)
rrEnableProjectionMatrix()

TGameEngine.GetInstance().SetGameManager(New MyGameManager)
rrEngineRun()
