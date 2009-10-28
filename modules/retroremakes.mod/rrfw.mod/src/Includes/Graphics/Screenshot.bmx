rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

rem
	bbdoc: Take a screenshot of current front buffer
	returns: The filename that the screenshot was saved as
	about: The filename used is timestamped with the current value from @{Millisecs()}
endrem
Function rrTakeScreenshot:String(myName:String = "screenshot")

	Local filename:String = myName + "-" + MilliSecs() + ".png"
		
	Local screenshot:TPixmap = GrabPixmap(0, 0, GraphicsWidth(), GraphicsHeight())
	
	SavePixmapPNG(screenshot, filename)
		
	Return filename
EndFunction
