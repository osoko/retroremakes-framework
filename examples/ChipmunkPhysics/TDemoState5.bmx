Type TDemoState5 Extends TGameState

	Field staticBody:CPBody
	Field space:CPSpace
	
	Field finished_:Int = False
	
	Method Initialise()
		staticBody = New CPBody.Create(INFINITY, INFINITY)
		
		ResetShapeIdCounter()
		
		space = New CPSpace.Create()
		space.SetIterations(20)
		space.ResizeStaticHash(40.0, 2999)
		space.ResizeActiveHash(40.0, 999)
		space.SetGravity(Vec2(0, 300))
	
		Local body:CPBody
		Local shape:CPShape
		
		Local verts:CPVect[] = [ ..
			Vec2( 3, 20), ..
			Vec2( 3,-20), ..
			Vec2(-3,-20), ..
			Vec2(-3, 20)]
	
		shape = New CPSegmentShape.Create(staticBody, Vec2(-600, 240), Vec2(600, 240), 0)
		shape.SetElasticity(1.0)
		shape.SetFriction(1.0)
		space.AddStaticShape(shape)
	
		Local friction:Float = 0.6
		
		Local n:Int = 9
		For Local i:Int = 1 To n
			Local offset:CPVect = Vec2(i*60/2.0, (n - i)*52)
			
			For Local j:Int = 0 Until i
				body = New CPBody.Create(1.0, MomentForPoly(1.0, verts, Vec2(0,0)))
				body.SetPosition(Vec2(j*60, 220).Sub(offset))
				space.AddBody(body)
				shape = New CPPolyShape.Create(body, verts, Vec2(0,0))
				shape.SetElasticity(0.0)
				shape.SetFriction(friction)
				space.AddShape(shape)
	
				body = New CPBody.Create(1.0, MomentForPoly(1.0, verts, Vec2(0,0)))
				body.SetPosition(Vec2(j*60, 197).Sub(offset))
				body.SetAngle(90)
				space.AddBody(body)
				shape = New CPPolyShape.Create(body, verts, Vec2(0,0))
				shape.SetElasticity(0.0)
				shape.SetFriction(friction)
				space.AddShape(shape)
				
				If j = (i - 1) Then
					Continue
				End If
				body = New CPBody.Create(1.0, MomentForPoly(1.0, verts, Vec2(0,0)))
				body.SetPosition(Vec2(j*60 + 30, 191).Sub(offset))
				body.SetAngle(90)
				space.AddBody(body)
				shape = New CPPolyShape.Create(body, verts, Vec2(0,0))
				shape.SetElasticity(0.0)
				shape.SetFriction(friction)
				space.AddShape(shape)
			Next
	
			body = New CPBody.Create(1.0, MomentForPoly(1.0, verts, Vec2(0,0)))
			body.SetPosition(Vec2(-17, 174).Sub(offset))
			space.AddBody(body)
			shape = New CPPolyShape.Create(body, verts, Vec2(0,0))
			shape.SetElasticity(0.0)
			shape.SetFriction(friction)
			space.AddShape(shape)
	
			body = New CPBody.Create(1.0, MomentForPoly(1.0, verts, Vec2(0,0)))
			body.SetPosition(Vec2((i - 1)*60 + 17, 174).Sub(offset))
			space.AddBody(body)
			shape = New CPPolyShape.Create(body, verts, Vec2(0,0))
			shape.SetElasticity(0.0)
			shape.SetFriction(friction)
			space.AddShape(shape)
		Next
		
		body.SetAngularVelocity(1)
		
	body.SetVelocity(Vec2(body.GetAngularVelocity() * 20, 0))
	End Method
	
	Method Leave()
		rrUnsubscribeFromChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Enter()
		rrSubscribeToChannel(CHANNEL_INPUT, Self)
		finished_ = False
	End Method

	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardInput(message)
		End Select
	End Method
	
	Method HandleKeyboardInput(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		
		If data.key = KEY_SPACE And data.keyHits
			finished_ = True
		End If
	End Method
	
	Method Update()
		Local steps:Int = 2
		Local dt:Float = 1.0/60.0/steps
		
		For Local i:Int = 0 Until steps
			space.DoStep(dt)
		Next
		If finished_ Then rrNextGameState()
	End Method
	
	Method Render()
		SetOrigin(rrGetGraphicsWidth() / 2, rrGetGraphicsHeight() / 2)
		SetColor 255, 255, 255
		space.GetActiveShapes().ForEach(drawObject)
		space.GetStaticShapes().ForEach(drawObject)
		SetColor 255, 255, 0
		SetOrigin 0, 0
		Local fps:String = "FPS: " + rrGetFPS()
		DrawText(fps, 5, 5)
	End Method
	
	Method Shutdown()
	End Method

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

