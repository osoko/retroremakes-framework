SuperStrict

Import retroremakes.rrfw

rrUseExeDirectoryForData()

rrEngineInitialise()

Global myState:TPolygonCollisionExample = New TPolygonCollisionExample

rrAddGameState(myState)

rrSetGameState(myState)

rrEngineRun()


Type TPolygonCollisionExample Extends TGameState

	Field verts:Float[] = [- 25.0, 0.0, - 75.0, 75.0, 0.0, 50.0, 100.0, 100.0,  ..
			50.0, 25.0, 100.0, 0.0, 50.0, - 25.0, 100.0, - 100.0, 0.0, - 50.0, - 75.0, - 75.0]
			
	Field cursor:Float[] = [0.0, - 50.0, 100.0, - 100.0, 50.0, 0.0, 100.0, 100.0,  ..
			0.0, 50.0, - 100.0, 100.0, - 50.0, 0.0, - 100.0, - 100.0]
			
	Field ang:Float = 0
	Field colType:Int = 0
	Field rad:Float = 20
	
	Field x:Float
	Field y:Float
	Field rot:Float
	Field sx:Float
	Field sy:Float
	Field hx:Float
	Field hy:Float
	Field ox:Float
	Field oy:Float
	Field lx:Float
	Field ly:Float
	Field mx:Int
	Field My:Int
	
	Method Update()
		If KeyHit(KEY_1) Then colType = 0
		If KeyHit(KEY_2) Then colType = 1
		If KeyHit(KEY_3) Then colType = 3
		If KeyHit(KEY_4) Then colType = 2
		
		ang:+1
					
		x = 400
		y = 300
		rot = ang / 2
		sx = Cos(ang) / 2 + 1.5
		sy = Sin(ang) / 2 + 1.5
		hx = Cos(ang) * 50
		hy = Sin(ang) * 50
		ox = Cos(ang / 2) * 50
		oy = Sin(ang / 2) * 50
		lx = 400 + Cos(- ang) * 300
		ly = 300 + Sin(- ang) * 300
			
		mx = MouseX()
		My = MouseY()
	EndMethod
	
	Method Render()
	
		SetRotation rot
		SetScale sx, sy
		SetHandle hx, hy
		SetOrigin ox, oy
		
		Select colType
			Case 0
				If rrPointInTFormPoly(mx, my, verts, x, y, rot, sx, sy, hx, hy, ox, oy)
					SetColor 0, 255, 255
				Else
					SetColor 0, 128, 128
				EndIf
			Case 1
				If rrCircleToTFormPoly(mx, my, rad, verts, x, y, rot, sx, sy, hx, hy, ox, oy)
					SetColor 0, 255, 255
				Else
					SetColor 0, 128, 128
				EndIf
			Case 2
				If rrTFormPolyToTFormPoly(verts, x, y, rot, sx, sy, hx, hy, ox, oy, cursor, mx, my, - rot, 0.5, 0.5)
					SetColor 0, 255, 255
				Else
					SetColor 0, 128, 128
				EndIf
			Case 3
				If rrLineToTFormPoly(mx, my, mx - 20, my + 20, verts, x, y, rot, sx, sy, hx, hy, ox, oy, True)
					SetColor 0, 255, 255
				Else
					SetColor 0, 128, 128
				EndIf
		End Select

		rrDrawPoly verts, x, y, True
			
		SetRotation 0
		SetScale 1, 1
		SetHandle 0, 0
		SetOrigin 0, 0
		SetColor 255, 255, 255
		DrawText "Select 1, 2, 3 Or 4", 5, 0
		DrawText "1: PointToTFormPoly", 5, 20
		DrawText "2: CircleToTFormPoly", 5, 35
		DrawText "3: LineToTFormPoly", 5, 50
		DrawText "4: TFormPolyToTFormPoly", 5, 65
		SetColor 255, 0, 0
			
		Select coltype
			Case 0
				DrawLine mx, my - 10, mx, my + 10, True
				DrawLine mx - 10, my, mx + 10, my, True
			Case 1
				DrawOval mx - rad, my - rad, rad * 2, rad * 2
			Case 2
				SetRotation - rot
				SetScale 0.5, 0.5
				rrDrawPoly cursor, mx, my, True
			Case 3
				DrawLine mx, My, mx - 10, my + 20, True'lx, ly, True
		End Select
	EndMethod
	
	Method Shutdown()
	EndMethod

EndType
