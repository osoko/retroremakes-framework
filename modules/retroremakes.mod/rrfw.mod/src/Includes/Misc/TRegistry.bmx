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

Type TRegistry

	Global instance_:TRegistry		' This holds the singleton instance of this Type
	
	Field registry_:TMap
		
'#Region Constructors
	Method New()
		If instance_ Throw "Cannot create multiple instances of Singleton Type"
		registry_ = New TMap
	End Method
	
	Function GetInstance:TRegistry()
		If Not instance_
			instance_ = New TRegistry
		EndIf
		Return instance_
	End Function
'#End Region 

	Method Add(index:String, value:Object)
		If Not IsRegistered(index)
			registry_.Insert(index, value)
		End If
	End Method

	Method Remove(index:String)
		If IsRegistered(index)
			Local value:Object = Get(index)
			registry_.Remove(value)
		End If
	End Method
		
	Method Get:Object(index:String)
		Local value:Object = Null
		If IsRegistered(index)
			value = registry_.ValueForKey(index)
		EndIf
		Return value
	End Method
	
	Method IsRegistered:Int(index:String)
		Return registry_.Contains(index)
	End Method
EndType
