Rem
'
' Copyright (c) 2007-2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

rem
	bbdoc: an effect holds a list of emitters it has to spawn when called from the library.
endrem
Type TParticleEffect

	'id of this effect in the library
	Field _libraryID:String
	
	'name used in the game
	Field _gameName:String
	
	'friendly name
	Field _name:String
	
	'handy description
	Field _description:String
	
	'list containing the gamenames of the emitters to spawn
	Field _childList:TList	

	Method New()
		_childList = New TList
	End Method
	
	rem
		bbdoc: loads the effect settings from a file stream
	endrem
	Method LoadConfiguration(s:TStream)', library:Object )
		Local l:String, a:String[]
		l = s.ReadLine()
		l.Trim()
		While l <> "#endeffect"
			a = l.split("=")
			Select a[0].ToLower()
				Case "id" _libraryID = a[1]
				Case "gamename" _gameName = a[1]				' store gamename of this effect so we can ask engine
				Case "description" _description = a[1]
				Case "emitter" _childList.AddLast(a[1])			' gamenames of emitters belonging to this effect, so engine can spawn them
			End Select
			l = s.ReadLine()
			l.Trim()
		Wend
	End Method

	rem
		bbdoc: returns list of emitter gamenames
	endrem
	Method GetList:TList()
		Return _childList
	End Method

End Type