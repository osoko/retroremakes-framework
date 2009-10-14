Type TDemoState1 Extends TGameState

	Field staticBody:CPBody
	Field space:CPSpace
	
	Field body:CPBody
	Field shape:CPShape
	
	Global collisionText:String = ""
	
	'Called when adding the state to the TGameStateManager
	Method Initialise()
		staticBody = New CPBody.Create(INFINITY, INFINITY)
		
		ResetShapeIdCounter()
		
		space = New CPSpace.Create()
	
		space.ResizeStaticHash(20.0, 999)
		space.SetGravity(Vec2(0, 100))
	
		shape = New CPSegmentShape.Create(staticBody, Vec2(-320,-240), Vec2(-320,239), 0)
		shape.SetElasticity(1.0)
		shape.SetFriction(1.0)
		space.AddStaticShape(shape)
	
		shape = New CPSegmentShape.Create(staticBody, Vec2(319,-240), Vec2(319,239), 0)
		shape.SetElasticity(1.0)
		shape.SetFriction(1.0)
		space.AddStaticShape(shape)
	
		shape = New CPSegmentShape.Create(staticBody, Vec2(-320, 239), Vec2(319, 239), 0)
		shape.SetElasticity(1.0)
		shape.SetFriction(1.0)
		space.AddStaticShape(shape)
	
		For Local i:Int = 0 Until 50
			Local j:Int = i + 1
			Local a:CPVect = Vec2(i*10 - 320, i*10 - 240)
			Local b:CPVect = Vec2(j*10 - 320, i*10 - 240)
			Local c:CPVect = Vec2(j*10 - 320, j*10 - 240)
			
			shape = New CPSegmentShape.Create(staticBody, a, b, 0)
			shape.SetElasticity(1.0)
			shape.SetFriction(1.0)
			space.AddStaticShape(shape)
			
			shape = New CPSegmentShape.Create(staticBody, b, c, 0)
			shape.SetElasticity(1.0)
			shape.SetFriction(1.0)
			space.AddStaticShape(shape)
		Next
		
		Local verts:CPVect[] = [ ..
			Vec2(-15,-15), ..
			Vec2(-15, 15), ..
			Vec2( 15, 15), ..
			Vec2( 15,-15)]
	
	
		body = New CPBody.Create(1.0, MomentForPoly(1.0, verts, Vec2(0,0)))
		body.SetPosition(Vec2(-280, -240))
		space.AddBody(body)
		
		shape = New CPPolyShape.Create(body, verts, Vec2(0,0))
		shape.SetElasticity(0)
		shape.SetFriction(1.5)
		shape.SetCollisionType(1)
		space.AddShape(shape)
		
		space.AddCollisionPairFunc(1, 0, collFunc)	
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
		Next
	End Method
	
	Method Render(tweening:Double, fixed:Int = False)
		SetOrigin(rrGetGraphicsWidth() / 2, rrGetGraphicsHeight() / 2)
		SetColor 255, 255, 255
		space.GetActiveShapes().ForEach(drawObject)
		space.GetStaticShapes().ForEach(drawObject)
		
		SetOrigin 0, 0
		SetColor 255, 255, 0
		DrawText(collisionText, rrGetGraphicsWidth() - TextWidth(collisionText) - 5, 0)
		Local fps:String = "FPS: " + rrGetFPS()
		DrawText(fps, 5, rrGetGraphicsHeight() - TextHeight(fps))
		
	End Method

	Function collFunc:Int(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoeficient:Float, data:Object)
	
		Local pos:CPVect
			
		For Local i:Int = 0 Until contacts.length
			pos = contacts[i].GetPosition()
			Local text:String = "Collision at " + pos.x + ", " + pos.y
			TDemoState1.collisionText = text
		Next
		
		Return True
			
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


