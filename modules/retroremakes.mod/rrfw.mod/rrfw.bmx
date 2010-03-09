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

SuperStrict

Rem
bbdoc: RetroRemakes Framework
EndRem
Module retroremakes.rrfw

ModuleInfo "Version: 0.11.0"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Author: Paul Maskelyne (Muttley) and others"
ModuleInfo "Copyright: (C) 2007-2009 Paul Maskelyne"
ModuleInfo "E-Mail: muttley@muttleyville.org"
ModuleInfo "Website: http://code.google.com/p/retroremakes-framework/"
ModuleInfo "Forum: http://www.muttleyville.org/forum/"

Import bah.chipmunk
Import bah.volumes

Import brl.audio
Import brl.freetypefont
Import brl.jpgloader
Import pub.libjpeg
Import pub.libpng
Import brl.openalaudio
Import brl.pngloader
Import brl.tgaloader
Import brl.timer

Import gman.zipengine

Import koriolis.bufferedstream
Import koriolis.zipstream

Import muttley.inifilehandler
Import muttley.logger
Import muttley.stack

Import pub.freejoy

Import retroremakes.colour
Import retroremakes.gfx
Import retroremakes.maths
Import retroremakes.messages
Import retroremakes.service
Import retroremakes.settings
Import retroremakes.timing
Import retroremakes.precision_counter
Import retroremakes.profiler



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



'#Region Include Files

''
'' General Includes
''
' Core engine
Include "src\TGameEngine.bmx"

' Some helper functions for people who prefer them.
Include "src\Includes\Functions.bmx"

Include "src\Includes\TGameManager.bmx"

 ' Miscellaneous Graphics
Include "src\Includes\Graphics\GraphicsUtils.bmx"
Include "src\Includes\Graphics\Screenshot.bmx"
Include "src\Includes\Graphics\TRenderable.bmx"

' Actors
Include "src\Includes\Graphics\Actors\TActor.bmx"
Include "src\Includes\Graphics\Actors\TFontActor.bmx"
Include "src\Includes\Graphics\Actors\TImageActor.bmx"
Include "src\Includes\Graphics\Actors\TPolygonActor.bmx"

' Animations
Include "src\Includes\Graphics\Animation\TAnimation.bmx"
Include "src\Includes\Graphics\Animation\TAnimationManager.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TAlphaFadeAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TBlinkAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TColourOscillatorAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TCompositeAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TDelayedAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TLoopedAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TLoopedFrameAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TMakeInvisibleAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TMakeVisibleAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TPointToPointPathAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TResetPositionAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TScaleOscillatorAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TSequentialAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TSetAlphaAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TSetColourAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TSetPositionAnimation.bmx"
Include "src\Includes\Graphics\Animation\AnimationStyles\TTimedAnimation.bmx"

'Menus
Include "src\Includes\Menus\TMenuManager.bmx"
Include "src\Includes\Menus\TMenu.bmx"
Include "src\Includes\Menus\TMenuItem.bmx"
Include "src\Includes\Menus\TSubMenuItem.bmx"
Include "src\Includes\Menus\TActionMenuItem.bmx"
Include "src\Includes\Menus\TOptionMenuItem.bmx"
Include "src\Includes\Menus\TMenuOption.bmx"
Include "src\Includes\Menus\TMenuStyle.bmx"
Include "src\Includes\Menus\TMenuMessageData.bmx"

'Particles
Include "src\Includes\Particles\TValues.bmx"
Include "src\Includes\Particles\TParticleActor.bmx"
Include "src\Includes\Particles\TParticle.bmx"
Include "src\Includes\Particles\TParticleEmitter.bmx"
Include "src\Includes\Particles\TParticleImage.bmx"
Include "src\Includes\Particles\TParticleEffect.bmx"
Include "src\Includes\Particles\TParticleLibrary.bmx"
Include "src\Includes\Particles\TParticleManager.bmx"

' Miscellaneous Maths and Algorithms
Include "src\Includes\Maths\PolygonCollisions.bmx"
Include "src\Includes\Maths\TPolygon.bmx"
Include "src\Includes\Maths\Utility.bmx"

Include "src\Includes\Misc\CloneObject.bmx"
Include "src\Includes\Misc\DataValidation.bmx"
Include "src\Includes\Misc\Logging.bmx"
Include "src\Includes\Misc\StringManipulation.bmx"
Include "src\Includes\Misc\TCommand.bmx"
Include "src\Includes\Misc\TCommandStack.bmx"
Include "src\Includes\Misc\TEngineException.bmx"
Include "src\Includes\Misc\TMacroCommand.bmx"
Include "src\Includes\Misc\TRegistry.bmx"

''
'' Engine Services
''
Include "src\Services\Audio\TGameSoundChannel.bmx"
Include "src\Services\Audio\TGameSound.bmx"
Include "src\Services\Audio\TGameSoundHandler.bmx"

Include "src\Services\Debug\TConsole.bmx"

Include "src\Services\Graphics\TColourOscillator\TColourGen.bmx"
Include "src\Services\Graphics\TColourOscillator\TColourOscillator.bmx"
Include "src\Services\Graphics\TScaleOscillator\TScaleGen.bmx"
Include "src\Services\Graphics\TScaleOscillator\TScaleOscillator.bmx"

Include "src\Services\Resources\TResource.bmx"
Include "src\Services\Resources\TResourceManager.bmx"
Include "src\Services\Resources\ResourceTypes\TResourceAnimImage.bmx"
Include "src\Services\Resources\ResourceTypes\TResourceImage.bmx"

Include "src\Services\Score\TScore.bmx"
Include "src\Services\Score\TScoreService.bmx"
Include "src\Services\Score\HighScoreTable\THighScoreEntry.bmx"
Include "src\Services\Score\HighScoreTable\THighScoreTable.bmx"

Include "src\Services\Resources\ResourceTypes\TResourceImageFont.bmx"
Include "src\Services\Resources\ResourceTypes\TResourceColourGen.bmx"

Include "src\Services\Physics\TPhysicsManager.bmx"

Include "src\Services\Input\TInputManager.bmx"
Include "src\Services\Input\Devices\Keyboard\TKeyboard.bmx"
Include "src\Services\Input\TInputDevice.bmx"
Include "src\Services\Input\Devices\Keyboard\TKeyboardMessageData.bmx"
Include "src\Services\Input\Devices\Joystick\TJoystickManager.bmx"
Include "src\Services\Input\Devices\Joystick\TJoystick.bmx"
Include "src\Services\Input\Devices\Joystick\TJoystickMessageData.bmx"
Include "src\Services\Input\Devices\VirtualGamepad\TVirtualGamepadManager.bmx"
Include "src\Services\Input\Devices\VirtualGamepad\TVirtualGamepad.bmx"
Include "src\Services\Input\Devices\VirtualGamepad\TVirtualControls\TVirtualControl.bmx"
Include "src\Services\Input\Devices\VirtualGamepad\TVirtualControls\TVirtualControlMapping.bmx"
Include "src\Services\Input\Devices\VirtualGamepad\TVirtualControls\JoystickMapping\TJoystickButtonMapping.bmx"
Include "src\Services\Input\Devices\VirtualGamepad\TVirtualControls\KeyboardMapping\TKeyboardMapping.bmx"
Include "src\Services\Input\Devices\VirtualGamepad\TVirtualControls\JoystickMapping\TJoystickAxisMapping.bmx"
Include "src\Services\Input\Devices\VirtualGamepad\TVirtualControls\JoystickMapping\TJoystickHatMapping.bmx"
Include "src\Services\Input\Devices\VirtualGamepad\TVirtualControls\MouseMapping\TMouseButtonMapping.bmx"
Include "src\Services\Input\Devices\VirtualGamepad\TVirtualControls\MouseMapping\TMouseAxisMapping.bmx"
Include "src\Services\Input\Devices\Mouse\TMouse.bmx"
Include "src\Services\Input\Devices\VirtualGamepad\TVirtualControls\TVirtualControlMessageData.bmx"
Include "src\Services\Input\Devices\Mouse\TMouseMessageData.bmx"

Include "src\Services\Layers\TLayerManager.bmx"
Include "src\Services\Layers\TRenderLayer.bmx"

'
'#End Region 
