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
bbdoc: RetroRemakes Framework: Profiler
EndRem
Module retroremakes.profiler

'Import brl.max2d

Import muttley.logger

Import retroremakes.precision_counter
Import retroremakes.settings

Include "Source/TProfiler.bmx"
Include "Source/TProfilerResult.bmx"
Include "Source/TProfilerSample.bmx"
