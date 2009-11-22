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

Rem
	bbdoc: Base class for input devices that can be used by the engine.
End Rem
Type TInputDevice Abstract

	' Human readable name for the input device
	Field _name:String

	
	
	rem
		bbdoc: Get the name of this input device
	endrem
	Method GetName:String()
		Return _name
	End Method
	
	
	
	rem
		bbdoc: Default Constructor
	endrem
	Method New()
		' Default name
		_name = "Unidentified Input Device"
	End Method
	
	
	rem
		bbdoc: Sets the human readable name of the input device
	endrem
	Method SetName(name:String)
		_name = name
	End Method
	
	
	
	rem
		bbdoc: Returns a string representation of the object
	endrem
	Method ToString:String()
		Return GetName() + ":" + Super.ToString()
	End Method
	
	
	
	rem
		bbdoc: Updates the input device
		about: This method can be overloaded to perform any required steps that an
		input device needs to do each update loop
	endrem
	Method Update()
	End Method
	
End Type
