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
bbdoc: base type for an application
end rem
Type TAppBase Abstract

	Field main_window:TGadget

	
	Method Run() Abstract
	
	
	
	rem
	bbdoc: Sets main window size
	endrem	
	Method SetSize(w:Int, h:Int)
		SetGadgetShape(main_window, GadgetX(main_window), GadgetY(main_window), w, h)
	End Method
	
	
	
	rem
	bbdoc: Sets main window position
	endrem
	Method SetPosition(x:Int, y:Int)
		SetGadgetShape(main_window, x, y, GadgetWidth(main_window), GadgetHeight(main_window))
	End Method	
		
End Type
