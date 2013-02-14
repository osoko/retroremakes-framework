rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

rem
bbdoc: The registry allows you to store any object for later retrieval
about: <pre>
Local myObject:TMyType = new TMyType
TRegistry.GetInstance().Add("My Index", myObject)

Local getMyObject:TMyType = TMyType(TRegistry.GetInstance().Get("My Index"))
</pre>
endrem
Type TRegistry

	' This holds the singleton instance of this Type
	Global g_instance:TRegistry
	
	Field _registry:TMap
		

	
	rem
	bbdoc: Add an Object to the registry indexed by the provided index String
	about: An exception will be thrown if an Object with the provided index already
	exists in the registry
	endrem
	Method Add(index:String, value:Object)
		If Not IsRegistered(index)
			_registry.Insert(index, value)
		Else
			Throw "An Object with index '" + index + "' already exists in the registry."
		End If
	End Method
	
	
		
	rem
	bbdoc: Retrieves the Object associated with the provided index String
	returns: Object
	endrem
	Method Get:Object(index:String)
		Local value:Object = Null
		If IsRegistered(index)
			value = _registry.ValueForKey(index)
		EndIf
		Return value
	End Method
	
	
	
	rem
	bbdoc: Returns the Singleton instance of this Type
	returns: TRegistry
	endrem	
	Function GetInstance:TRegistry()
		If Not g_instance
			g_instance = New TRegistry
		EndIf
		Return g_instance
	End Function
	
	
	
	rem
	bbdoc: Returns whether the registry contains an Object indexed by the provided String
	returns: True if the index exists, otherwise False
	endrem
	Method IsRegistered:Int(index:String)
		Return _registry.Contains(index)
	End Method
	
	
	
	' This should only be called via the GetInstance() Function	
	Method New()
		If g_instance Throw "Cannot create multiple instances of Singleton Type"
		_registry = New TMap
	End Method
	


	rem
	bbdoc: Removes the Object associated with the provided index String
	endrem
	Method Remove(index:String)
		If IsRegistered(index)
			Local value:Object = Get(index)
			_registry.Remove(value)
		End If
	End Method

EndType
