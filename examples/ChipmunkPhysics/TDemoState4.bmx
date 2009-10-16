Type TDemoState4 Extends TGameState

	Field staticBody:CPBody
	Field space:CPSpace

	Global toggleMode:Int = 0

	Method Initialise()
	
		staticBody = New CPBody.Create(INFINITY, INFINITY)
		
		ResetShapeIdCounter()
		
		space = New CPSpace.Create()
		space.SetIterations(10)
		space.ResizeStaticHash(30.0, 999)
		space.ResizeActiveHash(200.0, 99)
		space.SetGravity(Vec2(0, 600))
	
		Local body:CPBody
		Local shape:CPShape
		
		Local verts:CPVect[] = [ ..
			Vec2(-30,-15), ..
			Vec2(-30, 15), ..
			Vec2( 30, 15), ..
			Vec2( 30,-15)]
	
		Local a:CPVect = Vec2(-200,  200)
		Local b:CPVect = Vec2(-200, -200)
		Local c:CPVect = Vec2( 200, -200)
		Local d:CPVect = Vec2( 200,  200)
		
		shape = New CPSegmentShape.Create(staticBody, a, b, 0)
		shape.SetElasticity(1.0)
		shape.SetFriction(1.0)
		space.AddStaticShape(shape)
	
		shape = New CPSegmentShape.Create(staticBody, b, c, 0)
		shape.SetElasticity(1.0)
		shape.SetFriction(1.0)
		space.AddStaticShape(shape)
	
		shape = New CPSegmentShape.Create(staticBody, c, d, 0)
		shape.SetElasticity(1.0)
		shape.SetFriction(1.0)
		space.AddStaticShape(shape)
	
		shape = New CPSegmentShape.Create(staticBody, d, a, 0)
		shape.SetElasticity(1.0)
		shape.SetFriction(1.0)
		space.AddStaticShape(shape)
		
		staticBody.SetAngularVelocity(0.4)
	
		Local count:Int = 1
		For Local i:Int = 0 Until 3
			For Local j:Int = 0 Until 7
				body = New CPBody.Create(1.0, MomentForPoly(1.0, verts, Vec2(0,0)))
				body.SetPosition(Vec2(i*60 - 150, j*30 - 150))
				space.AddBody(body)
				shape = New ExtraShape.Create(body, verts, Vec2(0,0))
				ExtraShape(shape).letter = count
				shape.SetElasticity(0.0)
				shape.SetFriction(0.7)
				space.AddShape(shape)
				
				count:+ 1
			Next
		Next
		
	End Method

	Method Stop()
		rrUnsubscribeFromChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Start()
		Initialise()
		rrSubscribeToChannel(CHANNEL_INPUT, Self)
	End Method

	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardInput(message)
		End Select
	End Method
	
	Method HandleKeyboardInput(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		
		Select data.key
			Case KEY_T
				If data.keyHits Then toggleMode = Not toggleMode
		End Select

	End Method
	
	Method Update()
		Local steps:Int = 10
		Local dt:Float = 1.0/60.0/steps
		
		For Local i:Int = 0 Until steps
			space.DoStep(dt)
			staticBody.UpdatePosition(dt)
			space.RehashStatic()
		Next
	End Method
	
	Method Render(tweening:Double, fixed:Int = False)
		SetOrigin 320, 240
		SetColor 255, 255, 255

		space.GetActiveShapes().ForEach(drawObject)
		space.GetStaticShapes().ForEach(drawObject)
	
		SetOrigin 0, 0
		SetColor 255, 255, 0
		Local text:String = "'T' to toggle text"
			
		DrawText text, rrGetGraphicsWidth() - TextWidth(text) - 5, 5

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
	
		If toggleMode Then
			SetRotation body.GetAngle()
			DrawText Chr(ExtraShape(shape).letter + 64), pos.x, pos.y
			SetRotation 0
		End If
	
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

Type ExtraShape Extends CPPolyShape

	Field letter:Int
	
End Type	