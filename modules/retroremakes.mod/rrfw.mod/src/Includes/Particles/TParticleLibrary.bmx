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


Type TParticleLibrary

	'library objects are stored in this tmap
	Field _objectMap:TMap

	Method New()
		_objectMap = New TMap
	End Method

	rem
	
	Method LoadConfiguration:Int(name:String)
		Local in:TStream = ReadStream(name)
		If Not in Then Return 0
		While Not Eof(in)
			Local line:String = in.ReadLine()
			line.Trim()
			Select line
				Case "#image"
'					Local i:TLibraryImage = New TLibraryImage
'					i.SettingsFromStream( in )
'					_StoreObject( i, i._id)
				Case "#particle"
'					Local p:TLibraryParticle = New TLibraryParticle
'					p.SettingsFromStream( in, Self )
'					_StoreObject( p, p._id)
				Case "#effect"
'					Local ef:TLibraryEffect = New TLibraryEffect
'					ef.SettingsFromStream( in, Self )
'					_StoreObject( ef, ef._id)
				Case "#emitter"
'					Local e:TLibraryEmitter = New TLibraryEmitter
'					e.SettingsFromStream( in, Self )
'					_StoreObject( e, e._id)

				Default 		RuntimeError line
			End Select
		Wend

		'set the 'spawn object' after all objects have loaded.
		'reason: if a emitter contains a emitter with an ID that is not yet in the library, it would not get set.
		Local id:String
		For Local s:TLibraryEmitter = EachIn MapValues(_objectMap)
			id = String(s.GetSpawnObject())
			If id <> "none" Then s.SetSpawnObject( GetObject(id) )
		Next
		in.Close()
		Return 1
	End Method

	'***** ENGINE CLONE METHOD *****

	Method CreateEmitter:TEmitter(name:String, x:Float, y:Float, parent:Object = Null)
		Local source:TLibraryEmitter = TLibraryEmitter(Self.GetObject(name) )
		If source = Null Then RuntimeError name
		Local e:TEmitter = source.CloneToEngine( parent )
		e.SetPosition(x,y)
		If e.IsActive() Then e.Enable()
		Return e
	End Method

	Method CreateEffect( name:String, x:Float, y:Float, parent:Object )				' an effect creates multiple emitters
		Local source:TLibraryEffect = TLibraryEffect( GetObject(name) )
		If source = Null Then RuntimeError name
		For Local ename:String = EachIn source._childList
			CreateEmitter( ename, x, y, parent )
		Next

	End Method

	endrem	
	
	'**** RETRIEVAL METHODS *****

	Method GetObject:Object(id:String)
		Local o:Object = MapValueForKey( _objectMap, id)
		If o = Null Then rrThrow "not found id: " + id
		Return o
	End Method


	'***** PRIVATE *****

	Method _StoreObject(o:Object, id:String)
		MapInsert( _objectMap, id, o )
	End Method

	
	
End Type