Rem
'
' Copyright (c) 2007-2009 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem


Type TParticleManager

	' The Singleton instance of this class
	Global _instance:TParticleManager
	
	
	' particle library
	Field _library:TParticleLibrary
	
	Method New()
		If _instance rrThrow "Cannot create multiple instances of this Singleton Type"
		_instance = Self
		_library = New TParticleLibrary
	End Method

	
	rem
		bbdoc: Gets the Singleton instance of this class
	endrem	
	Function GetInstance:TParticleManager()
		If Not _instance
			Return New TParticleManager
		Else
			Return _instance
		EndIf
	End Function

		
	rem
		bbdoc: Returns the particle library in the particle manager
	endrem
	Method GetParticleLibrary:TParticleLibrary()
		Return _library
	End Method

		
	rem
		bbdoc: Load the passed configuration file into the library
	endrem
	Method LoadConfiguration(filename:String)
'		_library.LoadConfiguration(filename)
	End Method
	
	rem
		bbdoc: Clears the configuration in the library
	endrem
	
	Method ClearConfiguration()
'		_library.Clear()
	End Method
	
		
	rem
		bbdoc: Returns a human readable representation of the class
	endrem
	Method ToString:String()
		Return "Particle Manager"
	End Method
	
	rem
		bbdoc: Create an emitter using its game name
		about: game name is defined in the particle library editor
	endrem
'	Method CreateEmitter:TEmitter(name:String, xpos:Float = 0, ypos:Float = 0, parent:Object = Null)
'		Return _library.CreateEmitter(name, xpos, ypos, parent)
'	End Method

	rem
		bbdoc: Create an effect using its game name
		about: game name is defined in the particle library editor
	endrem
'	Method CreateEffect(name:String, xpos:Float = 0.0, ypos:Float = 0.0, parent:Object = Null)
'		_library.CreateEffect(name, xpos, ypos, parent)
'	End Method
	
	
End Type