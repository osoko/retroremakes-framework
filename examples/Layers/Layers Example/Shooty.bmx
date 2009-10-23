SuperStrict

Framework retroremakes.rrfw

Include "src/GameManager.bmx"
Include "src/THighScoreTableScreen.bmx"
Include "src/TModeMessageData.bmx"
Include "src/TPlayer.bmx"
Include "src/TScreenBase.bmx"
Include "src/TScroller.bmx"
Include "src/TStar.bmx"
Include "src/TStarfield.bmx"
Include "src/TTitleScreen.bmx"

rrUseExeDirectoryForData()

TGameEngine.GetInstance()

TGameEngine.GetInstance().SetGameManager(New GameManager)

rrSetProjectionMatrixResolution(800.0, 600.0)
rrEnableProjectionMatrix()
rrSetUpdateFrequency(60.0)

TGameEngine.GetInstance().Run()
