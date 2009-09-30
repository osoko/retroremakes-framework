SuperStrict

Import retroremakes.rrfw

rrUseExeDirectoryForData()

rrEngineInitialise()

Include "TIntroState.bmx"
Include "TDemoState1.bmx"
Include "TDemoState2.bmx"
Include "TDemoState3.bmx"
Include "TDemoState4.bmx"
Include "TDemoState5.bmx"
Include "TDemoState6.bmx"
Include "TDemoState7.bmx"
Include "TDemoState8.bmx"

Incbin "media\ball.png"
Incbin "media\crate.png"
Incbin "media\VeraMono.ttf"

Global intro:TIntroState = New TIntroState
Global demo1:TDemoState1 = New TDemoState1
Global demo2:TDemoState2 = New TDemoState2
Global demo3:TDemoState3 = New TDemoState3
Global demo4:TDemoState4 = New TDemoState4
Global demo5:TDemoState5 = New TDemoState5
Global demo6:TDemoState6 = New TDemoState6
Global demo7:TDemoState7 = New TDemoState7
Global demo8:TDemoState8 = New TDemoState8

rrSetGraphicsWidth(640)
rrSetGraphicsHeight(480)
rrDisableProjectionMatrix()
rrEnableKeyboardInput()

rrAddGameState(intro)
rrAddGameState(demo1)
rrAddGameState(demo2)
rrAddGameState(demo3)
rrAddGameState(demo4)
rrAddGameState(demo5)
rrAddGameState(demo6)
rrAddGameState(demo7)
rrAddGameState(demo8)

rrEngineRun()
