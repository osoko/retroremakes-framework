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

Type LibraryConfigurationTest Extends TTest
	
	Field c:TLibraryConfiguration

	Method setup() {before}
		c = New TLibraryConfiguration
	End Method
	
	Method cleanup() {after}
		c = Null
	End Method
	
	'can we create a config handler?
	Method testConstructor() {test}
		assertNotNull(c)
	End Method
	
	'do we get an exception when there is no configuration loaded?
	Method testErrorOnNoConfiguration() {test}
		Try
			Local m:TMap = c.GetLibrary()
		Catch result:String
			assertEquals(result, "No configuration loaded!")
		EndTry
	End Method
	
	'can we load a configuration file?
	Method testReadConfiguration() {test}
		c.ReadConfiguration("media/test_library.csv")
		
		Local m:Tmap = c.GetLibrary()
		assertNotNull(m)
	End Method
	
	'do we get an exception when we try to get an non existing object?
	Method testErrorOnNoID() {test}
		c.ReadConfiguration("media/test_library.csv")
		
		Try
			Local o:Object = c.getobject("blah")
		Catch result:String
			assertEquals(result, "Cannot find object with id : blah")
		EndTry
	End Method

	'can we retrieve the sample image?
	Method testGetTestImage() {test}
		c.ReadConfiguration("media/test_library.csv")
		
		Local i:TParticleImage = TParticleImage(c.GetObject("1"))
		assertNotNull(i)
		assertEquals("Handy Image", i.GetDescription())
	End Method
	

End Type