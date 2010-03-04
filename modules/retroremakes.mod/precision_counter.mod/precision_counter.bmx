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
bbdoc: RetroRemakes Framework: Precision Counter
about: The Precision Counter allows you to use a higher definition time soure
than the internal BlitzMax Millisecs() command.
<p />
Note: This currently only works on Win32 platforms. All other platforms will
return Millisecs() cast to a double to ensure compatability.
EndRem
Module retroremakes.precision_counter

Include "Source/TNormalPrecisionCounter.bmx"
Include "Source/TPrecisionCounter.bmx"

?Win32
	Include "Source/TPrecisionCounterWin32.bmx"
?
