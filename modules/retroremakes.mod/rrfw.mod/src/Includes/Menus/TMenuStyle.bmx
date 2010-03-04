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
