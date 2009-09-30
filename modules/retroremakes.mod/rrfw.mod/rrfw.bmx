SuperStrict

Rem
bbdoc: RetroRemakes Framework
EndRem
Module retroremakes.rrfw

ModuleInfo "Version: 0.9.0"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Author: Paul Maskelyne (Muttley) and others"
ModuleInfo "Copyright: (C) 2007-2009 Paul Maskelyne"
ModuleInfo "E-Mail: muttley@muttleyville.org"
ModuleInfo "Website: http://code.google.com/p/retroremakes-framework/"
ModuleInfo "Forum: http://www.muttleyville.org/forum/"

Import bah.chipmunk
Import bah.libxml
Import bah.maxunit
Import bah.volumes

Import brl.audio
Import brl.audiosample
Import brl.bmploader
Import brl.d3d7max2d
Import brl.directsoundaudio
Import brl.dxgraphics
Import brl.event
Import brl.freeaudioaudio
Import brl.freetypefont
Import brl.GLGraphics
Import brl.glmax2d
Import brl.Graphics
Import brl.hook
Import brl.jpgloader
Import brl.keycodes
Import pub.libjpeg
Import pub.libpng
Import brl.linkedlist
Import brl.map
Import brl.max2d
Import brl.oggloader
Import pub.oggvorbis
Import pub.openal
Import pub.opengl
Import brl.openalaudio
Import brl.pngloader
Import brl.polledinput
Import brl.reflection
Import brl.tgaloader
Import brl.timer

Import dbs.d3d9max2d
Import dbs.dx9graphics

Import gman.zipengine

Import koriolis.bufferedstream
Import koriolis.zipstream

Import muttley.inifilehandler
Import muttley.logger

Import pub.freejoy



Private



Type Z9FTidiMC0vFnfyhMruuOv9Q8wGiAL0I Abstract
	
	'This Const contains the major version number of the program
    Const MajorVersion:Int = 0
	
	'This Const contains the minor version number of the program
    Const MinorVersion:Int = 9
	
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

 ' Miscellaneous Graphics
Include "src\Includes\Graphics\GraphicsUtils.bmx"
Include "src\Includes\Graphics\Screenshot.bmx"
Include "src\Includes\Graphics\TColour.bmx"
Include "src\Includes\Graphics\TColourHSV.bmx"
Include "src\Includes\Graphics\TColourRGB.bmx"
Include "src\Includes\Graphics\TRenderState.bmx"

' Sprites
Include "src\Includes\Graphics\Sprites\TImageFontSprite.bmx"
Include "src\Includes\Graphics\Sprites\TImageSprite.bmx"
Include "src\Includes\Graphics\Sprites\TPolygonSprite.bmx"
Include "src\Includes\Graphics\Sprites\TSprite.bmx"
Include "src\Includes\Graphics\Sprites\TSpriteManager.bmx"

' Sprite Animation
Include "src\Includes\Graphics\Sprites\Animation\TSpriteAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\TSpriteAnimationManager.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TAlphaFadeAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TBlinkAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TColourOscillatorAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TCompositeAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TDelayedAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TLoopedAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TLoopedFrameAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TMakeInvisibleAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TMakeVisibleAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TPointToPointPathAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TScaleOscillatorAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TSequentialAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TSetAlphaAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TSetColourAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TSetPositionAnimation.bmx"
Include "src\Includes\Graphics\Sprites\Animation\AnimationStyles\TTimedAnimation.bmx"

' Miscellaneous Maths and Algorithms
Include "src\Includes\Maths\PolygonCollisions.bmx"
Include "src\Includes\Maths\RC4Encrypt.bmx"
Include "src\Includes\Maths\TPolygon.bmx"
Include "src\Includes\Maths\TVector2D.bmx"


Include "src\Includes\Misc\CloneObject.bmx"
Include "src\Includes\Misc\DataValidation.bmx"
Include "src\Includes\Misc\Logging.bmx"
Include "src\Includes\Misc\StringManipulation.bmx"
Include "src\Includes\Misc\TCommand.bmx"
Include "src\Includes\Misc\TCommandStack.bmx"
Include "src\Includes\Misc\TEngineException.bmx"
Include "src\Includes\Misc\TMacroCommand.bmx"
Include "src\Includes\Misc\TRegistry.bmx"
Include "src\Includes\Misc\TStack.bmx"

' Timing
Include "src\Includes\Timing\TPrecisionCounter.bmx"



''
'' Engine Services
''
Include "src\Services\TGameService.bmx"

Include "src\Services\Audio\TGameSoundChannel.bmx"
Include "src\Services\Audio\TGameSound.bmx"
Include "src\Services\Audio\TGameSoundHandler.bmx"

Include "src\Services\Debug\TConsole.bmx"
Include "src\Services\Debug\TProfiler.bmx"

Include "src\Services\Graphics\TGraphicsService.bmx"
Include "src\Services\Graphics\TProjectionMatrix.bmx"
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

Include "src\Services\Settings\TGameSettings.bmx"

Include "src\Services\States\TGameState.bmx"
Include "src\Services\States\TGameStateManager.bmx"

Include "src\Services\Timing\TFixedTimestep.bmx"
Include "src\Services\Timing\TFramesPerSecond.bmx"

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

Include "src\Services\Messages\TMessageService.bmx"
Include "src\Services\Messages\TMessage.bmx"
Include "src\Services\Messages\TMessageData.bmx"
Include "src\Services\Messages\TMessageChannel.bmx"
Include "src\Services\Messages\TMessageListener.bmx"


'#End Region 