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

Type particleImageTest Extends TTest
	Field i:TParticleImage
	Field arrayForSingleImage:String[9]
	Field arrayForMultiframeImage:String[9]
	

	Method setup() {before}
		i = New TParticleImage

		' create config arrays
		arrayForSingleImage[0] = "image"
		arrayForSingleImage[1] = "1"
		arrayForSingleImage[2] = "My Image"
		arrayForSingleImage[3] = "Handy image"
		arrayForSingleImage[4] = "media\stars.png"
		arrayForSingleImage[5] = "0"
		arrayForSingleImage[6] = "0"
		arrayForSingleImage[7] = "0"
		arrayForSingleImage[8] = "100"
		
		arrayForMultiframeImage[0] = "image"
		arrayForMultiframeImage[1] = "1"
		arrayForMultiframeImage[2] = "My Image"
		arrayForMultiframeImage[3] = "Handy Image"
		arrayForMultiframeImage[4] = "media\stars.png"
		arrayForMultiframeImage[5] = "4"
		arrayForMultiframeImage[6] = "8"
		arrayForMultiframeImage[7] = "8"
		arrayForMultiframeImage[8] = "100"
		
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
	
	'do we get an error if the settings array is not complete?
	Method testSettingsArrayLength() {test}
		Local badArray:String[4]
		Try
			i.ImportSettings(badArray)
		Catch result:String
			assertEquals("Image array not complete!", result)
		EndTry
	End Method
	
	'can we import the settings from an array?
	Method testImportSettingsFromArray()
		
		i.ImportSettings(arrayForMultiframeImage)
		
		assertEquals("1", i.GetID())
		assertEquals("My Image", i.getEditorName())
		assertEquals("Handy image", i.GetDescription())
		
		'the following asserts adress fields directly as they have no interface
		assertEquals("media\stars.png", i._imageFileName)
		assertEqualsI(4, i._frameCount)
		assertEqualsI(8, i._frameDimensionX)
		assertEqualsI(8, i._frameDimensionY)
		assertEqualsI(100, i._handlePoint)
	
	End Method
	
	'can we export the settings to an array?
	Method testExportSettingsToArray()
		
		i.ImportSettings(arrayForMultiframeImage)
		Local export:String[] = i.ExportSettings()
			
		assertEquals(export[0], "image")
		assertEquals(export[1], i.GetID())
		assertEquals(export[2], i.getEditorName())
		assertEquals(export[3], i.GetDescription())
		assertEquals(export[4], i._imageFileName)
		assertEqualsI(Int(export[5]), i._frameCount)
		assertEqualsI(Int(export[6]), i._frameDimensionX)
		assertEqualsI(Int(export[7]), i._frameDimensionY)
		assertEqualsI(Int(export[8]), i._handlePoint)
	End Method
	
	'do we get an exception when image cannot be loaded?
	Method testImageLoadError() {test}
		arrayForSingleImage[4] = "bad.png"
		i.ImportSettings(arrayForSingleImage)
		Try
			i.LoadImageFile()
		Catch result:String
			assertEquals("Cannot load: bad.png", result)
		EndTry
	End Method
	
	'can we load an image?
	Method testLoadImage() {test}
		i.ImportSettings(arrayForSingleImage)
		i.LoadImageFile()
		
		assertNotNull(i._image)
	End Method
	
	'can we load multi frame image?
	Method testLoadMultiFrameImage() {test}
		i.ImportSettings(arrayForMultiframeImage)
		i.LoadImageFile()
		
		assertNotNull(i._image)
	End Method

End Type