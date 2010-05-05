Rem
'
' Copyright (c) 2007-2010 Paul Maskelyne (Muttley) <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
EndRem

rem
	bbdoc: Class describing a style for a menu item
	about: Used by menu manager to set styles for elements added to menus.
	Combines colour, font and animation styles.
end rem
Type TMenuStyle
	
	Field animation:TAnimation
	
	Field colour:TColourRGB
	
	Field font:TImageFont

	Method New()
		colour = New TColourRGB
	End Method
	
End Type
