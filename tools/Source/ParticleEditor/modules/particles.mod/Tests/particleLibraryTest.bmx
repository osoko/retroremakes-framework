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

Type particleLibraryTest Extends TTest

	Field l:TParticleLibrary
	
	Method setup() {before}
		l = New TParticleLibrary
	End Method
	
	Method cleanup() {after}
		l = Null
	End Method
	
	' Can we create a library
	Method testCreateLibrary() {test}
		assertNotNull(l)
	End Method
	
	'can we load a configuration file?
'	Method testLoadConfiguration() {test}
'		Local result:Int = l.LoadConfiguration("media\library.csv")
'		assertTrue(result)
'	End Method
	
	
	'can we retrieve the configuration file name?
'	Method testGetConfigurationName() {test}
'		
'	End Method
	

End Type
