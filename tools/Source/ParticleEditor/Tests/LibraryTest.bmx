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

Type EditorLibraryTests Extends TTest

	Field l:TEditorLibraryConfiguration

	Method Setup() {before}
		l = New TEditorLibraryConfiguration
	End Method
	
	Method CleanUp() {after}
		l = Null
	End Method
	
	'can we create a new library?
	Method testConstructor() {test}
		assertNotNull(l)
	End Method
	
	'can we load a config file?
	

	
	
	
	'can we add an image
	Method testAddImage() {test}
	
		'Local i:TEditorImage = New TEditorImage
	'	l.AddImage()
	
	End Method
	
	
	'can we delete an image
	
	'can we add a particle
	'can we delete a particle
	
	'casn we add an emitter
	'can we delete an emitter
	
	'can we add an effect
	'can we delete an effect
	
	'can we add a project?
	'can we delete a project
	'can we export a project
		

	'can we load a configuration file?
	'can we save a configuration file?
	

End Type