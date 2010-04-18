Rem
'
' Copyright (c) 2007-2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

rem
bbdoc: particle library configuration handler
endrem
Type TLibraryConfiguration

	'last loaded configuration filename
	Field configurationName:String
	
	'tmap containing the loaded configuration
	Field library:TMap
	
	'type containing the 'world' settings (gravity, updatefreq, etc)
	'Field world:TParticleWorldSettings
	
	
	
	rem
	bbdoc: Returns the TMap containing the library configuration
	endrem
	Method GetLibrary:TMap()
		If Not library Then Throw("No configuration loaded!")
		Return library
	End Method

	
	rem
	bbdoc: Loads library configuration file and adds objects to the library
	endrem
	Method ReadConfiguration:Int(filename:String)
	
		Local fileHandle:TStream = ReadFile(filename)
		If Not fileHandle Then Return False
		
		If Not library
			library = New TMap
		Else
			library.Clear()
		EndIf
		
		While Not Eof(fileHandle)
			Local line:String = Trim(ReadLine(fileHandle))
			
			'ignore blank lines
			If line = "" Then Continue
			
			Local settings:String[] = line.Split(",")
			Select settings[0]
				Case "image"
					ImportImage(settings)
				Case "particle"
				
			End Select
			
		Wend
				
		CloseFile(fileHandle)
		configurationName = filename
		
		'do post process
		
		Return True
	End Method
	
	
	
	rem
	bbdoc: Adds particle world settings to the library map
	about: These settings are stored with the id "world"
	endrem
	Method AddWorld(settings:String)
	
	End Method


	
	rem
	bbdoc: Adds an image to the library map
	about: a blank TParticleImage is added if no settings are specified
	endrem
	Method AddImage(settings:String[] = Null)
		Local i:TParticleImage = New TParticleImage
		If settings Then i.ImportSettings(settings)
		StoreObject(i, i.GetID())
	End Method
	
	
	
	rem
	bbdoc: Adds a particle to the library map
	about: a blank TParticle is added if no settings are specified
	endrem
	Method AddParticle(settings:String[] = Null)
'		Local p:TParticle = New TParticle
'		If settings Then p.ImportSettings(settings)
'		StoreObject(p, p.GetID())
	End Method
	
	
	
	rem
	bbdoc: Stores an object in the library map
	endrem
	Method StoreObject(o:Object, id:String)
		library.Insert(id, o)
	End Method
	
	
	
	rem
	bbdoc: Returns an object from the library, using the passed ID
	endrem
	Method GetObject:Object(id:String)
		Local o:Object = library.ValueForKey(id)
		If o = Null Then Throw "Cannot find object with id : " + id
		Return o
	End Method
	
	
	
	rem
	bbdoc: Saves the library configuration to a file
	about: The current configuration name is used if no filename is given
	endrem	
	Method SaveConfiguration:Int(filename:String = "")
	
		If filename = "" Then filename = configurationName
		
		'TMap.
		
	
		
		Return True
	End Method
	
	

End Type