rem
	bbdoc: Type description
end rem
Type TMenuOption
	
	Field _label:String
	Field _option:Object

	Method ToString:String()
		Return _label
	End Method
	
	Method SetOptionObject(o:Object)
		_option = o
	End Method
	
End Type
