rem
	bbdoc: Type description
end rem
Type TMenuOption
	
	Field _label:String
	Field _obj:Object

	Method SetLabel(s:String)
		_label = s
	End Method	
	
	Method ToString:String()
		Return _label
	End Method
	
	Method SetOptionObject(o:Object)
		_obj = o
	End Method
	
	Method GetOptionObject:Object()
		Return _obj
	End Method

End Type

