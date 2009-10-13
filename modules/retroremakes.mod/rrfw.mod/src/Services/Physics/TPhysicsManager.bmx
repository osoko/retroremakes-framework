rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

' Engine wrapper for Brucey's bah.chipmunk mod
' which is itself a wrapper for Chipmunk
Type TPhysicsManager Extends TGameService

	Global instance:TPhysicsManager		' This holds the singleton instance of this Type

	'Field enabled:Int = True
	Field updateSteps:Int = 10
	Field stepDeltaTime:Float = 1.0 / 60.0 / updateSteps
		
'#Region Constructors
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod

	Function Create:TPhysicsManager()
		Return TPhysicsManager.GetInstance()
	End Function
	
	Function GetInstance:TPhysicsManager()
		If Not instance
			Return New TPhysicsManager
		Else
			Return instance
		EndIf
	EndFunction
'#End Region 

	Method Initialise()
		SetName("Chipmunk Physics")
		InitChipmunk()
		Super.Initialise()  'Call TGameService initialisation routines
	End Method

	Method Shutdown()
		'TODO
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method
	
	Method Start()
		CalcUpdateDeltaTime()
	End Method
	
	Method SetUpdateSteps(steps:Int)
		updateSteps = steps
	End Method
	
	Method GetUpdateSteps:Int()
		Return updateSteps
	End Method
	
	Method GetStepDeltaTime:Float()
		Return stepDeltaTime
	End Method
	
	Method CalcUpdateDeltaTime()
		Local logicFrequency:Double = TFixedTimestep.GetInstance().GetDeltaTime()
		stepDeltaTime = 1.0 / logicFrequency / updateSteps
	End Method
	
EndType