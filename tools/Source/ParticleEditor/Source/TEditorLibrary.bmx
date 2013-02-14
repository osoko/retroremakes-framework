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
	bbdoc: Editor extension for the particle library
	about: Adds editor related methods.
endrem
Type TEditorLibrary Extends TParticleLibrary
	
	Method RemoveImage:Int(i:TEditorImage)
	
		Local result:Int
	
		'check if there are particles referencing this image.
		
		'ask permission to delete image if true
		
		'remove references to this image from particles
		
		Return True'result
	
	End Method


End Type