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


'
'an effect holds a list of emitters it has to spawn when called from the library.


Type TEffect

	Field _id:String
	Field _name:String
	Field _description:String
	Field _childList:TList	

	Method New()
		_childList = New TList
	End Method

	Method SettingsFromStream( s:TStream, library:Object )
		Local l:String, a:String[]
		l = s.ReadLine()
		l.Trim()
		While l <> "#endeffect"
			a = l.split("=")
			Select a[0]
				Case "gamename"		_id = a[1]						' store gamename of this effect so we can ask engine
				Case "emitter"		_childList.AddLast( a[1] )		' gamename of emitters belonging to this effect, so engine can spawn them
'				Default 			DebugLog "effect: " + l
			End Select
			l = s.ReadLine()
			l.Trim()
		Wend
	End Method

	Method GetChildren:TList()
		Return _childList
	End Method

End Type