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
	bbdoc: Service for accessing saved engine and game settings.
endrem
Type TGameSettings Extends TGameService

	Global instance:TGameSettings		' This holds the singleton instance of this Type

	Field iniFile:TINIFile
	
	Field iniFilePath:String
		
'#Region Constructors
	rem
		bbdoc: Constructor
	endrem
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod

	rem
		bbdoc: Get an instance of TGameSettings
		about: Either returns the existing instance if there is one
		or returns a new instance
	endrem	
	Function GetInstance:TGameSettings()
		If Not instance
			Return New TGameSettings	
		Else
			Return instance
		EndIf
	EndFunction
'#End Region 

	Method Initialise()
		SetName("Game Settings")
		Super.Initialise()  'Call TGameService initialisation routines
	End Method

	Method SetIniFilePath(path:String)
		iniFilePath = path
	End Method
	
	Method Load()
		TLogger.GetInstance().LogInfo("[" + toString() + "] Attempting to load configuration file: " + iniFilePath)
		iniFile = TINIFile.Create(iniFilePath)
		
		iniFile.CreateMissingEntries()

		If Not iniFile.Load()
			TLogger.GetInstance().LogWarning("["+ toString() + "] Unable to load INI file.  Default values will be used")
		Else
			TLogger.GetInstance().LogInfo("["+ toString() + "] Configuration file loaded")
		End If		
	End Method
	
'#Region Wrappers for INIFileHandler methods
	Method GetBoolVariable:Int(name:String, defaultValue:String, section:String = "Game")
		Return iniFile.GetBoolValue(section, name, defaultValue)
	End Method
	
	Method GetBoolVariables:Int[] (name:String, defaultValues:String[], section:String = "Game")
		Return iniFile.GetBoolValues(section, name, defaultValues)
	End Method
	
	Method GetByteVariable:Byte(name:String, defaultValue:Byte, section:String = "Game")
		Return iniFile.GetByteValue(section, name, defaultValue)
	End Method
	
	Method GetByteVariables:Byte[] (name:String, defaultValues:Byte[], section:String = "Game")
		Return iniFile.GetByteValues(section, name, defaultValues)
	End Method
	
	Method GetDoubleVariable:Double(name:String, defaultValue:Double, section:String = "Game")
		Return iniFile.GetDoubleValue(section, name, defaultValue)
	End Method
	
	Method GetDoubleVariables:Double[] (name:String, defaultValues:Double[], section:String = "Game")
		Return iniFile.GetDoubleValues(section, name, defaultValues)
	End Method
	
	Method GetFloatVariable:Float(name:String, defaultValue:Float, section:String = "Game")
		Return iniFile.GetFloatValue(section, name, defaultValue)
	End Method
	
	Method GetFloatVariables:Float[] (name:String, defaultValues:Float[], section:String = "Game")
		Return iniFile.GetFloatValues(section, name, defaultValues)
	End Method
	
	Method GetIntVariable:Int(name:String, defaultValue:Int, section:String = "Game")
		Return iniFile.GetIntValue(section, name, defaultValue)
	End Method
	
	Method GetIntVariables:Int[] (name:String, defaultValues:Int[], section:String = "Game")
		Return iniFile.GetIntValues(section, name, defaultValues)
	End Method
	
	Method GetLongVariable:Long(name:String, defaultValue:Long, section:String = "Game")
		Return iniFile.GetLongValue(section, name, defaultValue)
	End Method
	
	Method GetLongVariables:Long[] (name:String, defaultValues:Long[], section:String = "Game")
		Return iniFile.GetLongValues(section, name, defaultValues)
	End Method
	
	Method GetShortVariable:Short(name:String, defaultValue:Short, section:String = "Game")
		Return iniFile.GetShortValue(section, name, defaultValue)
	End Method
	
	Method GetShortVariables:Short[] (name:String, defaultValues:Short[], section:String = "Game")
		Return iniFile.GetShortValues(section, name, defaultValues)
	End Method

	Method GetStringVariable:String(name:String, defaultValue:String, section:String = "Game")
		Return iniFile.GetStringValue(section, name, defaultValue)
	End Method
	
	Method GetStringVariables:String[] (name:String, defaultValues:String[], section:String = "Game")
		Return iniFile.GetStringValues(section, name, defaultValues)
	End Method

	Method SetBoolVariable(name:String, value:String, section:String = "Game")
		iniFile.SetBoolValue(section, name, value)
	End Method
	
	Method SetBoolVariables(name:String, values:String[], section:String = "Game")
		iniFile.SetBoolValues(section, name, values)
	End Method
	
	Method SetByteVariable(name:String, value:Byte, section:String = "Game")
		iniFile.SetByteValue(section, name, value)
	End Method
	
	Method SetByteVariables(name:String, values:Byte[], section:String = "Game")
		iniFile.SetByteValues(section, name, values)
	End Method
	
	Method SetDoubleVariable(name:String, value:Double, section:String = "Game")
		iniFile.SetDoubleValue(section, name, value)
	End Method
	
	Method SetDoubleVariables(name:String, values:Double[], section:String = "Game")
		iniFile.SetDoubleValues(section, name, values)
	End Method
	
	Method SetFloatVariable(name:String, value:Float, section:String = "Game")
		iniFile.SetFloatValue(section, name, value)
	End Method
	
	Method SetFloatVariables(name:String, values:Float[], section:String = "Game")
		iniFile.SetFloatValues(section, name, values)
	End Method
	
	Method SetIntVariable(name:String, value:Int, section:String = "Game")
		iniFile.SetIntValue(section, name, value)
	End Method
	
	Method SetIntVariables(name:String, values:Int[], section:String = "Game")
		iniFile.SetIntValues(section, name, values)
	End Method
	
	Method SetLongVariable(name:String, value:Long, section:String = "Game")
		iniFile.SetLongValue(section, name, value)
	End Method
	
	Method SetLongVariables(name:String, values:Long[], section:String = "Game")
		iniFile.SetLongValues(section, name, values)
	End Method
	
	Method SetShortVariable(name:String, value:Short, section:String = "Game")
		iniFile.SetShortValue(section, name, value)
	End Method
	
	Method SetShortVariables(name:String, values:Short[], section:String = "Game")
		iniFile.SetShortValues(section, name, values)
	End Method			
			
	Method SetStringVariable(name:String, value:String, section:String = "Game")
		iniFile.SetStringValue(section, name, value)
	End Method
	
	Method SetStringVariables(name:String, values:String[], section:String = "Game")
		iniFile.SetStringValues(section, name, values)
	End Method	
'#End Region 
		
	Method Shutdown()
		iniFile.Save()
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method
	
EndType

Function rrGetBoolVariable:Int(name:String, defaultValue:String, section:String = "Game")
	Return TGameSettings.GetInstance().GetBoolVariable(name, defaultValue, section)
End Function

Function rrGetBoolVariables:Int[] (name:String, defaultValues:String[], section:String = "Game")
	Return TGameSettings.GetInstance().GetBoolVariables(name, defaultValues, section)
End Function

Function rrSetBoolVariable(name:String, value:String, section:String = "Game")
	TGameSettings.GetInstance().SetBoolVariable(name, value, section)
End Function

Function rrSetBoolVariables(name:String, values:String[], section:String = "Game")
	TGameSettings.GetInstance().SetBoolVariables(name, values, section)
End Function

Function rrGetByteVariable:Byte(name:String, defaultValue:Byte, section:String = "Game")
	Return TGameSettings.GetInstance().GetByteVariable(name, defaultValue, section)
End Function

Function rrGetByteVariables:Byte[] (name:String, defaultValues:Byte[], section:String = "Game")
	Return TGameSettings.GetInstance().GetByteVariables(name, defaultValues, section)
End Function

Function rrSetByteVariable(name:String, value:Byte, section:String = "Game")
	TGameSettings.GetInstance().SetByteVariable(name, value, section)
End Function

Function rrSetByteVariables(name:String, values:Byte[], section:String = "Game")
	TGameSettings.GetInstance().SetByteVariables(name, values, section)
End Function

Function rrGetDoubleVariable:Double(name:String, defaultValue:Double, section:String = "Game")
	Return TGameSettings.GetInstance().GetDoubleVariable(name, defaultValue, section)
End Function

Function rrGetDoubleVariables:Double[] (name:String, defaultValues:Double[], section:String = "Game")
	Return TGameSettings.GetInstance().GetDoubleVariables(name, defaultValues, section)
End Function

Function rrSetDoubleVariable(name:String, value:Double, section:String = "Game")
	TGameSettings.GetInstance().SetDoubleVariable(name, value, section)
End Function

Function rrSetDoubleVariables(name:String, values:Double[], section:String = "Game")
	TGameSettings.GetInstance().SetDoubleVariables(name, values, section)
End Function

Function rrGetFloatVariable:Float(name:String, defaultValue:Float, section:String = "Game")
	Return TGameSettings.GetInstance().GetFloatVariable(name, defaultValue, section)
End Function

Function rrGetFloatVariables:Float[] (name:String, defaultValues:Float[], section:String = "Game")
	Return TGameSettings.GetInstance().GetFloatVariables(name, defaultValues, section)
End Function

Function rrSetFloatVariable(name:String, value:Float, section:String = "Game")
	TGameSettings.GetInstance().SetFloatVariable(name, value, section)
End Function

Function rrSetFloatVariables(name:String, values:Float[], section:String = "Game")
	TGameSettings.GetInstance().SetFloatVariables(name, values, section)
End Function

Function rrGetIntVariable:Int(name:String, defaultValue:Int, section:String = "Game")
	Return TGameSettings.GetInstance().GetIntVariable(name, defaultValue, section)
End Function

Function rrGetIntVariables:Int[] (name:String, defaultValues:Int[], section:String = "Game")
	Return TGameSettings.GetInstance().GetIntVariables(name, defaultValues, section)
End Function

Function rrSetIntVariable(name:String, value:Int, section:String = "Game")
	TGameSettings.GetInstance().SetIntVariable(name, value, section)
End Function

Function rrSetIntVariables(name:String, values:Int[], section:String = "Game")
	TGameSettings.GetInstance().SetIntVariables(name, values, section)
End Function

Function rrGetLongVariable:Long(name:String, defaultValue:Long, section:String = "Game")
	Return TGameSettings.GetInstance().GetLongVariable(name, defaultValue, section)
End Function

Function rrGetLongVariables:Long[] (name:String, defaultValues:Long[], section:String = "Game")
	Return TGameSettings.GetInstance().GetLongVariables(name, defaultValues, section)
End Function

Function rrSetLongVariable(name:String, value:Long, section:String = "Game")
	TGameSettings.GetInstance().SetLongVariable(name, value, section)
End Function

Function rrSetLongVariables(name:String, values:Long[], section:String = "Game")
	TGameSettings.GetInstance().SetLongVariables(name, values, section)
End Function

Function rrGetShortVariable:Short(name:String, defaultValue:Short, section:String = "Game")
	Return TGameSettings.GetInstance().GetShortVariable(name, defaultValue, section)
End Function

Function rrGetShortVariables:Short[] (name:String, defaultValues:Short[], section:String = "Game")
	Return TGameSettings.GetInstance().GetShortVariables(name, defaultValues, section)
End Function

Function rrSetShortVariable(name:String, value:Short, section:String = "Game")
	TGameSettings.GetInstance().SetShortVariable(name, value, section)
End Function

Function rrSetShortVariables(name:String, values:Short[], section:String = "Game")
	TGameSettings.GetInstance().SetShortVariables(name, values, section)
End Function

Function rrGetStringVariable:String(name:String, defaultValue:String, section:String = "Game")
	Return TGameSettings.GetInstance().GetStringVariable(name, defaultValue, section)
End Function

Function rrGetStringVariables:String[] (name:String, defaultValues:String[], section:String = "Game")
	Return TGameSettings.GetInstance().GetStringVariables(name, defaultValues, section)
End Function

Function rrSetStringVariable(name:String, value:String, section:String = "Game")
	TGameSettings.GetInstance().SetStringVariable(name, value, section)
End Function

Function rrSetStringVariables(name:String, values:String[], section:String = "Game")
	TGameSettings.GetInstance().SetStringVariables(name, values, section)
End Function