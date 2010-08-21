
rem
bbdoc: library configuration loader
about: Extended by each game to allow loading of custom types
endrem
Type TLibraryReader Abstract
	
	'handle to library
	Field library:TLibrary

	Method Read:int(stream:TStream) Abstract

		
	
	rem
	bbdoc: Sets handle to library
	about: Called by Tlibrary.setreader()
	endrem
	Method SetLibrary(lib:TLibrary)
		library = lib
	End Method
	
	
	
	Rem
	bbdoc: Reads library configuration file from disk
	about: Uses Read() method in extended reader
	endrem	
	Method ReadConfiguration:Int(filename:String) Final
	
		If filename = "" Then filename = library.GetConfigurationName()
		If filename = "" Then Return False'Throw "ERROR: No library filename specified"
	
		Local fileHandle:TStream = ReadFile(filename)
		If Not fileHandle Then Return False
		
		'clear library before load
		library.Clear()
		
		'read and add objects to library
		Local result:Int = Read(fileHandle)
		
		CloseFile(fileHandle)
		library.SetConfigurationName(filename)
		Return result
	End Method
	
End Type