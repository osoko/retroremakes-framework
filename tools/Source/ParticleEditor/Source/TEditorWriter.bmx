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
Type TEditorWriter Extends TLibraryWriter

	Method Write(stream:TStream)

		'debug	
		Print "starting write, objects: " + library.GetObjectList().Count()
	
		Local obj:Object		
		
		For Local o:TLibraryObject = EachIn library.GetObjectList()
			
			'retrieve the object from the library objectholder
			obj = o.GetObject()
			
			'cast to find the type
			If TEditorImage(obj)
				TEditorImage(obj).WritePropertiesToStream(stream)
'			ElseIf TEditorParticle(obj)
			
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