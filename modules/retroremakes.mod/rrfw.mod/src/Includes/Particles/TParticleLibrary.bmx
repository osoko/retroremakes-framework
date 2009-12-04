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


rem
	bbdoc: library for particle engine
	about: particle objects (particles, emitter, effects) are stored in this library, ready
	to be called by the game engine
endrem
Type TParticleLibrary

	'objects are stored in this tmap, using the _libraryID or _gameName fields as labels.
	Field _objectMap:TMap

	rem
		bbdoc:default constructor
	endrem
	Method New()
		_objectMap = New TMap
	End Method
	
	rem
		bbdoc:loads the configuration file for the library
	endrem
	Method LoadConfiguration:Int(name:String)
		Local in:TStream = ReadStream(name)
		If Not in Then Return 0
		While Not Eof(in)
			Local line:String = in.ReadLine()
			line.Trim()
			Select line.ToLower()
				Case "#image"
					Local i:TParticleImage = New TParticleImage
					i.LoadConfiguration(in)
					_StoreObject(i, i._libraryID)
					
				Case "#particle"
					Local p:TParticle = New TParticle
					p.LoadConfiguration(in)
					_StoreObject(p, p._libraryID)
					
				Case "#effect"
					Local ef:TParticleEffect = New TParticleEffect
					ef.LoadConfiguration(in)
					
					'store effect using gamename, not id
					_StoreObject(ef, ef._gameName)
					
				Case "#emitter"
					Local e:TParticleEmitter = New TParticleEmitter
					e.LoadConfiguration(in)
					
					'store emitter using gamename, not id
					_StoreObject(e, e._gameName)

				Default rrThrow line
			End Select
		Wend

		in.Close()
		
		'do some post processing (put in references to actual objects instead of id's)

		'add images to particles
		Local i:TParticleImage
		For Local p:TParticle = EachIn MapValues(_objectMap)
			i = TParticleImage(GetObject(p._imageID))
			p._image = i.GetImage()
		Next
		
		'add spawn objects to emitters.
		'as these can be emitters or particles, cast to TParticleActor
		For Local e:TParticleEmitter = EachIn MapValues(_objectMap)
			e._toSpawn = TParticleActor(GetObject(e._spawnID))
		Next

		Return 1
	End Method
	
	rem
		bbdoc: clears the library configuration
	endrem	
	Method Clear()
		_objectMap.Clear()
	End Method

	Method CloneEmitter:TParticleEmitter(name:String)', x:Float, y:Float, parent:Object = Null)
		Local source:TParticleEmitter = TParticleEmitter(Self.GetObject(name))
		If source = Null Then rrThrow "Cannot find emitter: " + name
		Return source.Clone()
	End Method
	
rem
	Method CreateEffect(name:String, x:Float, y:Float, parent:Object)				' an effect creates multiple emitters
		Local source:TParticleEffect = TParticleEffect(GetObject(name))
		If Not source Then rrThrow "Cannot find effect: " + name
		Local toCreate:TList = source.GetList()
		For Local ename:String = EachIn toCreate
			CreateEmitter(ename, x, y, parent)
		Next

	End Method
endrem
	
	'**** RETRIEVAL METHODS *****

	Method GetObject:Object(id:String)
		Local o:Object = MapValueForKey( _objectMap, id)
		If o = Null Then rrThrow "Library does not contain object with id : " + id
		Return o
	End Method

	'***** PRIVATE *****

	Method _StoreObject(o:Object, id:String)
		MapInsert( _objectMap, id, o )
	End Method
	
End Type