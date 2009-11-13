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
	bbdoc: Base class used for mapping a virtual control to a physical input device
End Rem
Type TVirtualControlMapping Abstract
	
	Field name_:String	' human readable version of the control mapping
	
	Field lastControlDownDigital_:Int
	Field lastControlDownAnalogue_:Float

	Field controlDownDigital_:Int
	Field controlDownAnalogue_:Float
	Field controlHits_:Int

	
	
	Method GetAnalogueStatus:Float()
		Return controlDownAnalogue_
	End Method

	

	Method GetDigitalStatus:Int()
		Return controlDownDigital_
	End Method

	
	
	Method GetHits:Int()
		Local hits:Int = controlHits_
		controlHits_ = 0
		Return hits
	End Method
			
	
	
	Method GetName:String()
		Return name_
	End Method		

	
	
	Method SetName(name:String)
		name_ = name
	End Method
		
	
	
	Method Save(control:TVirtualControl) Abstract
			
	
	
	Method Update(message:TMessage) Abstract

	

End Type
