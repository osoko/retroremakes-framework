rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.

' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Type TCommand

	Method Execute:Int() Abstract
	
	Method Unexecute() Abstract
	
	Method CanBeUndone:Int() Abstract
	
	Method Merge:Int(command:TCommand) Abstract
	
	Method ToString:String()
		Return "Command Pattern function object."
	End Method

End Type

