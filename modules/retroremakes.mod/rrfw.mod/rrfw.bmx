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

Import brl.freetypefont
Import brl.pngloader
Import brl.timer

Import gman.zipengine

Import koriolis.bufferedstream
Import koriolis.zipstream

Import muttley.inifilehandler
Import muttley.logger
Import muttley.stack

Import pub.freejoy

Import retroremakes.colour
Import retroremakes.engine
Import retroremakes.manager
Import retroremakes.gfx
Import retroremakes.Input
Import retroremakes.layer
Import retroremakes.manager
Import retroremakes.maths
Import retroremakes.messages
Import retroremakes.registry
Import retroremakes.renderable
Import retroremakes.resource
Import retroremakes.service
Import retroremakes.settings
Import retroremakes.sfx
Import retroremakes.timing
Import retroremakes.precision_counter
Import retroremakes.profiler


'#Region Include Files

' Some helper functions for people who prefer them.
Include "src\Includes\Functions.bmx"

 ' Miscellaneous Graphics
Include "src\Includes\Graphics\GraphicsUtils.bmx"

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

Include "src\Includes\Misc\CloneObject.bmx"
Include "src\Includes\Misc\Logging.bmx"
Include "src\Includes\Misc\StringManipulation.bmx"
Include "src\Includes\Misc\TCommand.bmx"
Include "src\Includes\Misc\TCommandStack.bmx"
Include "src\Includes\Misc\TEngineException.bmx"
Include "src\Includes\Misc\TMacroCommand.bmx"
'Include "src\Includes\Misc\TRegistry.bmx"

''
'' Engine Services
''
Include "src\Services\Debug\TConsole.bmx"

Include "src\Services\Graphics\TScaleOscillator\TScaleGen.bmx"
Include "src\Services\Graphics\TScaleOscillator\TScaleOscillator.bmx"

Include "src\Services\Score\TScore.bmx"
Include "src\Services\Score\TScoreService.bmx"
Include "src\Services\Score\HighScoreTable\THighScoreEntry.bmx"
Include "src\Services\Score\HighScoreTable\THighScoreTable.bmx"

Include "src\Services\Physics\TPhysicsManager.bmx"

'#End Region 