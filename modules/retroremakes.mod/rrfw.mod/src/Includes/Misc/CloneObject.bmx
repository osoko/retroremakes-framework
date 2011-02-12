rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.

' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

' Clones an object and returns the clone.
' Any fields that references an object only gets the reference copied unless MetaData contains {Clone}
' which then a copy is also made of the object referenced.
' {NoClone} prevents the field being copied.
Function rrCloneObject:Object(obj:Object)
	Local cobj:Object
	
	If obj=Null Then Return Null
	
	Local objId:TTypeId=TTypeId.ForObject(obj)
	
	If objId.ExtendsType(StringTypeId)
		Return String(obj)
	EndIf
	
	If objId.ExtendsType(ArrayTypeId)
		If objId.ArrayLength(obj)>0
			cobj=objId.NewArray(objId.ArrayLength(obj))
			
			If cobj
				For Local i:Int=0 Until objId.ArrayLength(obj)
					If objId.ElementType().ExtendsType(ArrayTypeId) Or objId.ElementType().ExtendsType(StringTypeId) ..
						Or objId.ElementType().ExtendsType(ObjectTypeId)
						objId.SetArrayElement(cobj, i, rrCloneObject(objId.GetArrayElement(obj, i)))
					Else
						objId.SetArrayElement(cobj,i,objId.GetArrayElement(obj,i))
					EndIf
				Next
			EndIf
		EndIf
		
		Return cobj
	EndIf
	
	cobj=New obj
	
	For Local fld:TField=EachIn objId.EnumFields()
		'Local fldId:TTypeId=fld.TypeId()
		
		If fld.Get(obj)<>Null And fld.MetaData("NoClone")=Null
			If Not fld.MetaData("Clone")=Null
				fld.Set(cobj,rrCloneObject(fld.Get(obj)))
			Else
				fld.Set(cobj,fld.Get(obj))
			EndIf
		EndIf
	Next
	
	Return cobj
	
EndFunction
