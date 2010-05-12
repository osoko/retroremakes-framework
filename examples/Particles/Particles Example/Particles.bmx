Rem
'
' Copyright (c) 2007-2009 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem


SuperStrict

Framework retroremakes.rrfw

Include "src/GameManager.bmx"

rrUseExeDirectoryForData()

rrEngineInitialise()

rrSetProjectionMatrixResolution(800, 600)
rrEnableProjectionMatrix()

TGameEngine.GetInstance().SetGameManager(New MyGameManager)
rrEngineRun()