

rem
bbdoc: library object which can contain any type
endrem
Type TLibraryObject

	'library id
	Field id:Int
	
	'the actual object
	Field obj:Object
	
	'name used to load the object
	Field filename:String
	
	
	
	Rem
	bbdoc: Sets object ID
	endrem
	Method SetID(value:Int)
		id = value
	End Method
	
	

	rem
	bbdoc: Returns object ID
	endrem		
	Method GetID:Int()
		Return id
	End Method
	
	
	
	rem
	bbdoc: Sets object
	endrem
	Method SetObject(o:Object)
		obj = o
	End Method
	
	

	rem
	bbdoc: Returns object
	endrem
	Method GetObject:Object()
		Return obj
	End Method
	
	
	
	Method SetFileName(name:String)
		filename = name
	End Method


	Method GetFileName:String()
		Return filename
	End Method

End Type