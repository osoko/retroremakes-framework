SuperStrict

Framework retroremakes.rrfw

Include "src/GameManager.bmx"
Include "src/TScreenBase.bmx"
Include "src/TScroller.bmx"
Include "src/TStar.bmx"
Include "src/TStarfield.bmx"
Include "src/TTitleScreen.bmx"

rrUseExeDirectoryForData()

TGameEngine.GetInstance()

TGameEngine.GetInstance().SetGameManager(New GameManager)

TGameEngine.GetInstance().Run()
