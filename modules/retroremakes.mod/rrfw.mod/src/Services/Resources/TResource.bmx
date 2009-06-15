Type TResource
	Field filename:String
	Field name:String
	Field path:String
	Field refCount:Int
	
	Method New()
		refCount = 0
	End Method
	
	Method DecRefCount:Int()
		If refCount = 0 Then Throw "Resource reference count cannot be negative"
		refCount:-1
		Return GetRefCount()
	End Method
	
	Method GetResourceFilename:String()
		Return filename
	End Method
	
	Method GetResourceName:String()
		Return name
	End Method
	
	Method GetResourcePath:String()
		Return path
	End Method
	
	Method GetRefCount:Int()
		Return refCount
	End Method
	
	Method IncRefCount:Int()
		refCount:+1
		Return GetRefCount()
	End Method
	
	Method Free() Abstract
	
	Method Reload()
		'overload if necessary
	End Method
	
End Type