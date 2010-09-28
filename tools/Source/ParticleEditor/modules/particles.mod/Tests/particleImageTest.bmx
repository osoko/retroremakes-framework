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

Type particleImageTest Extends TTest
	Field i:TParticleImage

	Method setup() {before}
		i = New TParticleImage
	End Method
	
	Method cleanup() {after}
		i = Null
	End Method
	
	'can we create a particleimage?
	Method testConstructor() {test}
		assertNotNull(i)
	End Method
	
	'do we get an error when we retrieve an empty image?
	Method testGetImageError() {test}
		Try
			Local img:TImage = i.GetImage()
		Catch result:String
			assertEquals("No Image present!", result)
		EndTry
		
	End Method
	
	'do we get an exception when image cannot be loaded?
	Method testImageLoadError() {test}
		i.SetImageFileName("bad.png")
		
		Try
			i.LoadImageFile()
		Catch result:String
			assertEquals("Cannot load: bad.png", result)
		EndTry
	End Method
	
	'can we load an image?
	Method testLoadImage() {test}
		SetSingleImageConfig()

		i.LoadImageFile()
		assertNotNull(i._image)
	End Method
	
	'can we load multi frame image?
	Method testLoadMultiFrameImage() {test}
		SetMultiImageConfig()

		i.LoadImageFile()
		assertNotNull(i._image)
	End Method

	
	'can we export settings to stream?
	Method testWriteSettings() {test}
	
		SetMultiImageConfig()
		
		Local s:TStream = WriteFile("media/imagewritetest.txt")
		Local result:Int = i.WritePropertiesToStream(s)
		assertEqualsI(True, result)
		
	End Method
	
	'can we import settings from stream?
	Method testReadSettings() {test}
	
		Local s:TStream = ReadFile("media/imagewritetest.txt")
		i.ReadPropertiesFromStream(s)
		
		assertEqualsI(10, i.GetID())
		assertEquals("My Image", i.getEditorName())
		assertEquals("Handy Image", i.GetDescription())
		assertEquals("media/stars.png", i.GetImageFileName())
	
		'the following asserts adress fields directly as they have no interface
		assertEqualsI(4, i._frameCount)
		assertEqualsI(8, i._frameDimensionX)
		assertEqualsI(8, i._frameDimensionY)
		assertEqualsI(HANDLE_CENTER, i._handlePoint)
	End Method	
	
 '---------------------------------------------------------	
	'configuration methods for tests
	Method SetSingleImageConfig()
		i.SetID(10)
		i.SetEditorName("My Image")
		i.SetDescription("Handy Image")
		i.SetImageFileName("media/stars.png")
		i._frameCount = 0
		i._frameDimensionX = 0
		i._frameDimensionY = 0
		i._handlePoint = HANDLE_CENTER
	End Method

	Method SetMultiImageConfig()
		i.SetID(10)
		i.SetEditorName("My Image")
		i.SetDescription("Handy Image")
		i.SetImageFileName("media/stars.png")
		i._frameCount = 4
		i._frameDimensionX = 8
		i._frameDimensionY = 8
		i._handlePoint = HANDLE_CENTER
	End Method
	
	
End Type