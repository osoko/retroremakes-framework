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
    bbdoc: Loads particle engine objects into the library
endrem
Type TParticleLibraryReader Extends TLibraryReader
	
	Method Read:Int(stream:TStream)
	
		While Not Eof(stream)
			Local line:String = stream.ReadLine()
			line.Trim()
			line.ToLower()
			
			If line = "" Then Continue
			Select line
				Case "[image]"
					Local o:TParticleImage = New TParticleImage
					o.ReadPropertiesFromStream(stream)
					library.AddObject(o, o.GetId())
					
				Case "[particle]"
					Local o:TParticle = New TParticle
					o.ReadPropertiesFromStream(stream)
					library.AddObject(o, o.GetID())
'				Case "[effect]"
'					Local ef:TParticleEffect = New TParticleEffect
'					ef.LoadConfiguration(in)
'					
'					'store effect using gamename, not id
'					_StoreObject(ef, ef._gameName)
'					
'				Case "[emitter]"
'					Local e:TParticleEmitter = New TParticleEmitter
'					e.LoadConfiguration(in)
'					
'					'store emitter using gamename, not id
'					_StoreObject(e, e._gameName)
'
				Default
					'Return False
					'Throw "" + line + " is not a recognized object!"
			End Select
		Wend

		stream.Close()
        
		Return True
	End Method
	
End Type