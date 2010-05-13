rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Rem
	bbdoc: Base class used for mapping a virtual control to a physical input device
End Rem
Type TVirtualControlMapping Abstract

	' The analogue status of the control
	Field _analogueStatus:Float

	' The digital status of the control
	Field _digitalStatus:Int

	' The number of times this control has been pressed since the hits were last queried
	Field _hits:Int
	
	' The last analogue status of the control		
	Field _lastAnalogueStatus:Float
	
	' The last digital status of the control	
	Field _lastDigitalStatus:Int
			
	' human readable name of the control mapping
	Field _name:String



	rem
		bbdoc: Returns the current analogue status of the control
		about: Values are in the range 0.0 to 1.0
	endrem
	Method GetAnalogueStatus:Float()
		Return _analogueStatus
	End Method

	

	rem
		bbdoc: Returns the current digital status of the control
		about: Values are in either 1 for pressed, or 0 for unpressed
	endrem
	Method GetDigitalStatus:Int()
		Return _digitalStatus
	End Method

	
	
	rem
		bbdoc: Returns the number of times this control was pressed since the last
		query
	endrem
	Method GetHits:Int()
		Local hits:Int = _hits
		_hits = 0
		Return hits
	End Method
			
	
	
	rem
		bbdoc: Returns the last analogue status of the control
		about: Values are in the range 0.0 to 1.0
	endrem	
	Method GetLastAnalogueStatus:Float()
		Return _lastAnalogueStatus
	End Method
	
	
	
	rem
		bbdoc: Returns the last digital status of the control
		about: Values are in either 1 for pressed, or 0 for unpressed
	endrem	
	Method GetLastDigitalStatus:Int()
		Return _lastDigitalStatus
	End Method
	
	
	
	rem
		bbdoc: Returns the name of this control
	endrem	
	Method GetName:String()
		Return _name
	End Method		
		
	

	rem
		bbdoc: Increments the control's hit counter
	endrem
	Method IncrementHits()
		_hits:+1
	End Method
	
	
	
	rem
		bbdoc: Saves the control mapping to the application INI file
		about: Abstract method which needs to be implemented by every control
		mapping class
	endrem	
	Method Save(control:TVirtualControl) Abstract
			
	

	rem
		bbdoc: Sets the hit counter for this control
	endrem
	Method SetHits(hits:Int)
		_hits = hits
	End Method
	
	
	
	rem
		bbdoc: Sets the name of this control
	endrem
	Method SetName(name:String)
		_name = name
	End Method

	
		
	rem
		bbdoc: Sets the current analogue status of the control
	endrem			
	Method SetAnalogueStatus(status:Float)
		_analogueStatus = status
	End Method
	
	
	
	rem
		bbdoc: Sets the current digital status of the control
	endrem	
	Method SetDigitalStatus(status:Int)
		_digitalStatus = status
	End Method
	
	
	
	rem
		bbdoc: Sets the last analogue status of the control
	endrem		
	Method SetLastAnalogueStatus(status:Float)
		_lastAnalogueStatus = status
	End Method	
	
	
	rem
		bbdoc: Sets the last digital status of the control
	endrem	
	Method SetLastDigitalStatus(status:Int)
		_lastDigitalStatus = status
	End Method
	
	

	rem
		bbdoc: Updates the control
		about: Abstract method which needs to be implemented by every control
		mapping class
	endrem			
	Method Update(message:TMessage) Abstract

End Type
