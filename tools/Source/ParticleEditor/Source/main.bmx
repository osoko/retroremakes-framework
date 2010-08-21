Rem
'
' Copyright (c) 2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

SuperStrict

Framework maxgui.drivers
Import maxgui.proxygadgets

Import wdw.propertygrid
Import wdw.LIBRARY

Import muttley.inifilehandler
Import retroremakes.particles

Include "TAppBase.bmx"
Include "TEditorGui.bmx"
Include "TEditorMain.bmx"
Include "TEditorLibrary.bmx"
Include "TParticleLibraryWriter.bmx"
Include "TEditorImage.bmx"

Local editor:TEditorMain = New TEditorMain
editor.Run()
