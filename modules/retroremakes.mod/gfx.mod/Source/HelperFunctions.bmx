rem
	bbdoc: Take a screenshot of current front buffer
	returns: The filename that the screenshot was saved as
	about: The filename used is timestamped with the current value from @{Millisecs()}
endrem
Function TakeScreenshot:String(myName:String = "screenshot")

	Local filename:String = myName + "-" + MilliSecs() + ".png"
		
	Local screenshot:TPixmap = GrabPixmap(0, 0, GraphicsWidth(), GraphicsHeight())
	
	SavePixmapPNG(screenshot, filename)
		
	Return filename
EndFunction