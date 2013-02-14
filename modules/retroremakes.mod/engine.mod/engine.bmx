SuperStrict

Module retroremakes.engine

Import bah.volumes

Import brl.timer

Import muttley.logger

Import retroremakes.sfx
Import retroremakes.Input
Import retroremakes.manager
Import retroremakes.messages
Import retroremakes.service
Import retroremakes.settings

Include "Source/TGameEngine.bmx"

Private

Type Z9FTidiMC0vFnfyhMruuOv9Q8wGiAL0I Abstract
	
	'This Const contains the major version number of the program
    Const MajorVersion:Int = 0
	
	'This Const contains the minor version number of the program
    Const MinorVersion:Int = 11
	
	'This string contains the name of the program
    Const Name:String = "RetroRemakes Framework"
	
	'This Const contains the revision number of the current program version
    Const Revision:Int = 0

	'This string represents the available assembly info.
	Const AssemblyInfo:String = Name + " " + MajorVersion + "." + MinorVersion + "." + Revision
	
	'This string contains the assembly version in format (MAJOR.MINOR.REVISION)
    Const VersionString:String = MajorVersion + "." + MinorVersion + "." + Revision

	'This constant contains "Win32", "MacOs" or "Linux" depending on the current running platoform for your game or application.
    ?Win32
    	Const Platform:String = "Win32"
    ?MacOs
	    Const Platform:String = "MacOs"
    ?Linux
    	Const Platform:String = "Linux"
    ?

    'This const contains "x86" or "Ppc" depending on the running architecture of the running computer. x64 should return also a x86 value
	?PPC
    	Const Architecture:String = "PPC"
    ?x86
    	Const Architecture:String = "x86"
    ?
	
	'This const will have the integer value of TRUE if the application was build on debug mode, or false if it was build on release mode
    ?debug
    	Const DebugOn:Int = True
    ?Not Debug
    	Const DebugOn:Int = False
    ?
	
EndType



Type My Abstract
    Global Application:Z9FTidiMC0vFnfyhMruuOv9Q8wGiAL0I
End Type

Public