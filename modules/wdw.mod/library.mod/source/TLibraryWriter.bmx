
rem
    bbdoc: library configuration writer
    about: Extended by each game to allow writing of custom types
endrem
Type TLibraryWriter Abstract
	
	'handle to library
	Field library:TLibrary

	Method Write:int(stream:TStream) Abstract

	
	
	rem
        bbdoc: Sets handle to library
        about: Called by Tlibrary.SetWriter()
	endrem
	Method SetLibrary(lib:TLibrary)
		library = lib
	End Method

		
	
	rem
        bbdoc: Writes library configuration file to disk
        about: Uses Write() in extended writer
	endrem	
	Method WriteConfiguration:Int(fileName:String) Final
	
		If filename = "" Then filename = library.GetConfigurationName()
		If fileName = "" Then Return False'Throw "ERROR: No library filename specified"
	
		Local fileHandle:TStream = WriteFile(filename)
		If Not fileHandle Then Return False
		
		Write(fileHandle)
		Return True
	End Method
	
End Type