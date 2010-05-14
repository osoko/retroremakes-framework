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
	bbdoc: A mouse button that can be mapped to a #TVirtualControl
End Rem
Type TMouseButtonMapping Extends TVirtualControlMapping

	Field buttonNames:String[]

	Field buttonId_:Int
	
	
	
	Method New()
		buttonNames = New String[4]
		buttonNames[0] = ""
		buttonNames[1] = "Left"
		buttonNames[2] = "Right"
		buttonNames[3] = "Middle"
	End Method
	
	
	
	Method Update(message:TMessage)
		Select message.messageID
			Case MSG_MOUSE
				Local data:TMouseMessageData = TMouseMessageData(message.data)
				SetDigitalStatus(data.mouseStates[buttonId_])
				SetAnalogueStatus(Float(GetDigitalStatus()))
				SetHits(data.mouseHits[buttonId_])
		End Select
	End Method
	
	
	
	Method SetButtonId(id:Int)
		buttonId_ = id
	End Method
	
	
	
	Method GetName:String()
		Return buttonNames[buttonId_] + " Mouse Button"
	End Method
	
	
	
	Method Save(control:TVirtualControl)
		Local section:String = "VirtualGamepad" + control.GetGamepad().GetPaddedId()
		rrSetStringVariables(control.GetPaddedControlId(), [control.GetName(),  ..
									"mouse", "button", buttonNames[buttonId_].ToLower()], section)
	End Method
	
End Type
