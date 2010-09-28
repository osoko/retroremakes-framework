Rem
'
' Copyright (c) 2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem


rem
bbdoc: object library for particle engine
endrem
Type TParticleLibrary Extends TLibrary

	Method New()
		SetReader(New TParticleLibraryReader)
	End Method



	rem
	bbdoc: Performed after loading the library
	endrem
	Method PostProcess:Int(name:String)
		
		'do some post processing (put in references to actual objects instead of id's)

		'add images to particles
'		Local i:TParticleImage
'		For Local p:TParticle = EachIn MapValues(_objectMap)
'			i = TParticleImage(GetObject(p._imageID))
'			p._image = i.GetImage()
'		Next
		
		'add spawn objects to emitters.
		'as these can be emitters or particles, cast to TParticleActor
'		For Local e:TParticleEmitter = EachIn MapValues(_objectMap)
'			e._toSpawn = TParticleActor(GetObject(e._spawnID))
'		Next

		Return 1
	End Method

		
	
'	Method CloneEmitter:TParticleEmitter(name:String)', x:Float, y:Float, parent:Object = Null)
'		Local source:TParticleEmitter = TParticleEmitter(Self.GetObject(name))
'		If source = Null Then Throw "Cannot find emitter: " + name
'		Return source.Clone()
'	End Method
	
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

End Type