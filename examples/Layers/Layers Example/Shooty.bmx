SuperStrict

Framework retroremakes.rrfw

Include "src/GameManager.bmx"
Include "src/TGameplayScreen.bmx"
Include "src/THighScoreTableScreen.bmx"
Include "src/TModeMessageData.bmx"
Include "src/TPlayer.bmx"
Include "src/TPlayerBullet.bmx"
Include "src/TScreenBase.bmx"
Include "src/TScroller.bmx"
Include "src/TStar.bmx"
Include "src/TStarfield.bmx"
Include "src/TTitleScreen.bmx"

rrUseExeDirectoryForData()

rrEngineInitialise()

theEngine().SetGameManager(New GameManager)

rrSetProjectionMatrixResolution(800.0, 600.0)
rrEnableProjectionMatrix()
rrSetUpdateFrequency(60.0)

theEngine().Run()



