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
	bbdoc: A keyboard key that can be mapped to a #TVirtualControl
End Rem
Type TKeyboardMapping Extends TVirtualControlMapping

	Field keyboardButtonId_:Int

	Method Update(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
				If data.key = keyboardButtonId_
					SetDigitalStatus(data.keyState)
					SetAnalogueStatus(Float(GetDigitalStatus()))
					SetHits(data.keyHits)
				EndIf
		End Select		
	End Method
	
	Method SetButton(id:Int)
		If id >= 0 And id < 256
			keyboardButtonId_ = id
			SetName(Null)
		EndIf
	End Method
	
	Method GetButton(id:Int)
		keyboardButtonId_ = id
	End Method
	
	Method GetName:String()
		If Not Super.GetName()
			SetName(TKeyboard.GetInstance().GetKeyName(keyboardButtonId_))
		EndIf
		Return Super.GetName()
	End Method

	
	
	Method Save(control:TVirtualControl)
		Local section:String = "VirtualGamepad" + control.GetGamepad().GetPaddedId()
		rrSetStringVariables(control.GetPaddedControlId(), [control.GetName(),  ..
									"keyboard", String(keyboardButtonId_)], section)
	End Method
			
End Type
