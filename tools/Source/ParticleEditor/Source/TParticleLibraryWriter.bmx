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

rem
	bbdoc: Writes particle library to stream
endrem
Type TParticleLibraryWriter Extends TLibraryWriter

	Method Write(stream:TStream)
	
		Local obj:Object
	
		'first, some library information
		WriteLine(stream, "[library]")
		WriteLine(stream, "lastID=" + library.nextID)
		WriteLine(stream, "[end library]")
		
		For Local o:TLibraryObject = EachIn library.GetObjectList()
			
			obj = o.GetObject()
			
			If TEditorImage(obj)
				TEditorImage(obj).WritePropertiesToStream(stream)
'			ElseIf
			
'			ElseIf
			
'			ElseIf
			
			End If
			
		
		Next
		
		'particles
		
		
		'emitters
		
		
		'effects
		
		
		'projects
		
	End Method

End Type