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
	bbdoc: Type description
end rem
Type TGameManager Extends TRenderable Abstract

	Method MessageListener(message:TMessage) Abstract
	
	Method Render(tweening:Double, fixed:Int = False) Abstract
	
	Method Start() Abstract
	
	Method Stop() Abstract

	Method Update() Abstract
		
End Type
