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

Import retroremakes.actor
Import retroremakes.colour
Import retroremakes.engine
Import retroremakes.manager
Import retroremakes.gfx
Import retroremakes.Input
Import retroremakes.layer
Import retroremakes.manager
Import retroremakes.maths
Import retroremakes.menu
Import retroremakes.messages
Import retroremakes.particles
Import retroremakes.registry
Import retroremakes.renderable
Import retroremakes.resource
Import retroremakes.score
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

' Miscellaneous Maths and Algorithms
Include "src\Includes\Maths\PolygonCollisions.bmx"
Include "src\Includes\Maths\TPolygon.bmx"

Include "src\Includes\Misc\CloneObject.bmx"
Include "src\Includes\Misc\StringManipulation.bmx"
'Include "src\Includes\Misc\TEngineException.bmx"

''
'' Engine Services
''
Include "src\Services\Debug\TConsole.bmx"

Include "src\Services\Physics\TPhysicsManager.bmx"

'#End Region
