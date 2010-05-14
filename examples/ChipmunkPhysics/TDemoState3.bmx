Type TDemoState3 Extends TGameState

	Field staticBody:CPBody
	Field space:CPSpace
	
	Field finished_:Int = False

	Method Initialise()
		
		staticBody = New CPBody.Create(INFINITY, INFINITY)
		
		ResetShapeIdCounter()
		
		space = New CPSpace.Create()
		space.SetIterations(5)
		space.ResizeStaticHash(40.0, 999)
		space.ResizeActiveHash(30.0, 2999)
		space.SetGravity(Vec2(0, 100))
	
	
		Local body:CPBody
		Local shape:CPShape
	
		Local num:Int = 5
		Local verts:CPVect[] = New CPVect[num]
		For Local i:Int = 0 Until num
			Local angle:Float = 360/num * (4 - i)
			verts[i] = Vec2(10 * Cos(angle), 10 * Sin(angle))
		Next
		
		Local tris:CPVect[] = [ ..
			Vec2( 15, 15), ..
			Vec2(  0, -10), ..
			Vec2(-15, 15)]
	
	
		For Local i:Int = 0 Until 9
			For Local j:Int = 0 Until 6
				Local stagger:Float = (j Mod 2)*40
				Local offset:CPVect = Vec2(i * 80 - 320 + stagger, 240 - j * 70)
	
				shape = New CPPolyShape.Create(staticBody, tris, offset)
				shape.SetElasticity(1.0)
				shape.SetFriction(1.0)
				space.AddStaticShape(shape)
			Next
		Next
	
		For Local i:Int = 0 Until 300
			body = New CPBody.Create(1.0, MomentForPoly(1.0, verts, Vec2(0,0)))
			Local x:Float = Rand(-320, 320)
			body.SetPosition(Vec2(x, Rand(-350, -290)))
			space.AddBody(body)
			shape = New CPPolyShape.Create(body, verts, Vec2(0,0))
			shape.SetElasticity(0)
			shape.SetFriction(0.4)
			space.AddShape(shape)
		Next
		
	End Method
	
	Method Stop()
	End Method
	
	Method Start()
		Initialise()
	End Method

	
	Method Update()
		Local steps:Int = 1
		Local dt:Float = 1.0/60.0/steps
		
		For Local i:Int = 0 Until steps
			space.DoStep(dt)
			space.EachBody(eachBody)
		Next
	End Method
	
	Method Render(tweening:Double, fixed:Int = False)
		SetOrigin(rrGetGraphicsWidth() / 2, rrGetGraphicsHeight() / 2)
		SetColor 255, 255, 255
		space.GetActiveShapes().ForEach(drawObject)
		space.GetStaticShapes().ForEach(drawObject)
		SetColor 255, 255, 0
		SetOrigin 0, 0
		Local fps:String = "FPS: " + rrGetFPS()
		DrawText(fps, 5, 5)
	End Method


	Function eachBody(body:Object, data:Object)
		Local pos:CPVect = CPBody(body).GetPosition()
		
		If pos.y > 260 Or Abs(pos.x) > 340 Then
			Local x:Float = Rand(-320, 320)
			CPBody(body).SetPosition(Vec2(x, -260))
		End If
	
	End Function
	
	Function drawPolyShape(shape:CPPolyShape)
	
		Local body:CPBody = shape.GetBody()
		
		Local pos:CPVect = body.GetPosition()

		Local verts:CPVect[] = shape.GetVerts()
		Local First:CPVect = Null
		Local Last:CPVect = Null
		
		For Local i:Int = 0 Until verts.length
			Local v:CPVect = pos.Add(verts[i].Rotate(body.GetRot()))
			
			If Not First Then
				First = v
			End If
			
			If last Then
				DrawLine last.x, last.y, v.x, v.y
			End If
			
			last = v
		Next
		
		DrawLine last.x, last.y, First.x, First.y
	
	End Function
	
	Function drawCircleShape(shape:CPCircleShape)
	
		Local center:CPVect = shape.GetTransformedCenter()
	
		Local radius:Float = shape.GetRadius()
		DrawOval center.x - radius, center.y - radius, radius * 2, radius * 2
	End Function
	
	Function drawSegmentShape(shape:CPSegmentShape)
	
		SetRotation 0
	
		Local body:CPBody = shape.GetBody()
		
		Local pos:CPVect = body.GetPosition()
	
		Local a:CPVect = pos.Add(shape.GetEndPointA().Rotate(body.GetRot()))
		Local b:CPVect = pos.Add(shape.GetEndPointB().Rotate(body.GetRot()))
		
		DrawLine a.x, a.y, b.x, b.y
	
	End Function
	
	Function drawObject(shape:Object, data:Object)
	
		If CPPolyShape(shape) Then
			drawPolyShape(CPPolyShape(shape))
		ElseIf CPSegmentShape(shape) Then
			drawSegmentShape(CPSegmentShape(shape))
		ElseIf CPCircleShape(shape) Then
			drawCircleShape(CPCircleShape(shape))
		End If
		
	End Function		
End Type

