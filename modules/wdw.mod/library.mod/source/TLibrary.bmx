

rem
bbdoc: object library
about: A library is a text file containing objects saved in a simple format
       the reader is responsable for reading the library configuration file and passing the line
	   with settings to the custom object. This can then be created and added to the library.
	   Objects can be retreived by id. An ID is a integer number.
endrem
Type TLibrary

	'objects go here
	Field objectList:TList
	
	'extended types by applications
	Field reader:TLibraryReader
	Field writer:TLibraryWriter
	
	'object ids
	Field nextID:Int
	
	'last loaded configuration file
	Field filename:String

	
	
	rem
	bbdoc: Default constructor
	endrem
	Method New()
		objectList = New TList
	End Method
	
	
	
	Rem
	bbdoc: Clears all objects from the library, and resets id counter
	endrem	
	Method Clear()
		objectList.Clear()
		nextID = 0
	End Method
	
	

	rem
	bbdoc: Returns a new ID
	endrem	
	Method GetNewID:Int()
		nextID:+1
		Return nextID
	End Method
	
	
	
	Method SetConfigurationName(name:String)
		filename = name
	End Method
	
	
	Method GetConfigurationName:String()
		Return filename
	End Method
	
	
	
	Method SetReader(r:TLibraryReader)
		reader = r
		r.SetLibrary(Self)
	End Method
	
	
	
	Method SetWriter(w:TLibraryWriter)
		writer = w
		w.SetLibrary(Self)
	End Method
	
	
	Rem
        bbdoc: Sets id counter to passed id if this is higher
        about: Used when a new object is added to the library by loading it.
	endrem
	Method DetermineNextID(id:Int)
		If testID >= nextID Then nextID = id + 1
	End Method
	
	
	
	rem
        bbdoc: Removes object from library by id
	endrem
	Method RemoveObjectById(id:Int)
		For Local a:TLibraryObject = EachIn objectList
			If a.GetID() = id
				objectList.Remove(a)
				Return
			End If
		Next
	End Method
	


	rem
	bbdoc: Removes object from library
	endrem
	Method RemoveObject(o:Object)
		For Local a:TLibraryObject = EachIn objectList
			If a.GetObject() = o
				objectList.Remove(a)
				Return
			End If
		Next
	End Method


	
	rem
	bbdoc: Adds object to library. uses id if passed
	returns: id of added object
	endrem
	Method AddObject:Int(o:Object, id:Int = -1)
	
		If id = -1 Then id = Self.GetNewID()
		Local l:TLibraryObject = New TLibraryObject
		l.SetObject(o)
		l.SetID(id)
		objectList.AddLast(l)
		Return id
	End Method
	

		
	rem
	bbdoc: Returns object from library by id
	endrem	
	Method GetObject:Object(id:Int)
		For Local a:TLibraryObject = EachIn objectList
			If a.GetID() = id
				Return a.GetObject()
			End If
		Next
		Return Null
		'Throw "ERROR: Cannot find object with id: " + id
	End Method
	
	
	
	Rem
	bbdoc: Returns true if object is already in library
	endrem	
	Method ContainsObject:Int(o:Object)
		For Local a:TLibraryObject = EachIn objectList
			If a.GetObject() = o
				Return True
			End If
		Next
		Return False
	End Method
	
	
	
	rem
	bbdoc: Returns list containing library objects
	endrem	
	Method GetObjectList:TList()
		Return objectList
	End Method
	
	
	
	Method WriteConfiguration:int(name:String = "")
		return writer.WriteConfiguration(name)
	End Method
	
	
	Method ReadConfiguration:Int(name:String = "")
		Return reader.ReadConfiguration(name)
	End Method
	
	
End Type