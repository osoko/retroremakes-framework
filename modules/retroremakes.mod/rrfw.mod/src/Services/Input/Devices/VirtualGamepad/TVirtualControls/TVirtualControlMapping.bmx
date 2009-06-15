'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TVirtualControlMapping
	
	Field name_:String	' human readable version of the control mapping
	
	Field lastControlDownDigital_:Int
	Field lastControlDownAnalogue_:Float

	Field controlDownDigital_:Int
	Field controlDownAnalogue_:Float
	Field controlHits_:Int

	
	
	Method GetAnalogueStatus:Float()
		Return controlDownAnalogue_
	End Method

	

	Method GetDigitalStatus:Int()
		Return controlDownDigital_
	End Method

	
	
	Method GetHits:Int()
		Local hits:Int = controlHits_
		controlHits_ = 0
		Return hits
	End Method
			
	
	
	Method GetName:String()
		Return name_
	End Method		

	
	
	Method SetName(name:String)
		name_ = name
	End Method
		
	
	
	Method Save(control:TVirtualControl) Abstract
			
	
	
	Method Update(message:TMessage) Abstract

	

End Type
