rem
bbdoc: Take a screenshot of current front buffer
returns: The filename that the screenshot was saved as
about: The filename used is timestamped with the current value from @{Millisecs()}
endrem
Function rrTakeScreenshot:String(myName:String = "screenshot")

	Local filename:String = myName + "-" + MilliSecs() + ".png"
		
	Local img:TPixmap = GrabPixmap(0,0,GraphicsWidth(),GraphicsHeight())
	
	SavePixmapPNG(img, filename)
		
	Return filename
EndFunction