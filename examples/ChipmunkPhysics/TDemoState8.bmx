Type TDemoState8 Extends TGameState

	Const WIDTH:Int = 200
	Const HEIGHT:Int = 40

	Field staticBody:CPBody
	Field space:CPSpace
		
	Field boxCount:Int

	Method Initialise()
		staticBody = New CPBody.Create(INFINITY, INFINITY)
		
		ResetShapeIdCounter()
		
		space = New CPSpace.Create()
		space.SetIterations(5)
		space.ResizeActiveHash(30.0, 2999)
		space.ResizeStaticHash(40.0, 999)
		space.SetGravity(Vec2(0, 100))
	
		Local shape:CPShape
		
		' Screen border
		shape = New CPSegmentShape.Create(staticBody, Vec2(-320, 240), Vec2(-320, -240), 0.0)
		shape.SetElasticity(1.0)
		shape.SetFriction(1.0)
		space.AddStaticShape(shape)
	
		shape = New CPSegmentShape.Create(staticBody, Vec2(320, 240), Vec2(320, -240), 0.0)
		shape.SetElasticity(1.0)
		shape.SetFriction(1.0)
		space.AddStaticShape(shape)
	
		shape = New CPSegmentShape.Create(staticBody, Vec2(-320, 240), Vec2(320, 240), 0.0)
		shape.SetElasticity(1.0)
		shape.SetFriction(1.0)
		space.AddStaticShape(shape)
		
		' Reference line
		shape = New CPSegmentShape.Create(staticBody, Vec2(-320,0), Vec2(320,0), 0.0)
		shape.SetCollisionType(1)
		space.AddStaticShape(shape)
		
		space.AddCollisionPairFunc(0, 1, Null, Null)
		
		' Create boxes
		makeBox(Vec2(-150, -150), Vec2(200, 100), 0, 0.0)
		makeBox(Vec2(150, -150), Vec2(0, 300), 5, 0.0)
		makeBox(Vec2(0, -150), Vec2(0, -200), 0.0, 0.0)
		makeBox(Vec2(0, -250), Vec2(50, -100), 0.0, 2.0)
	
	End Method
	
	Method Stop()
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
	End Method
	
	Method Start()
		Initialise()
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
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
			Case KEY_B
				If data.keyHits Then makeBox(Vec2(0, -250), Vec2(0, 0), 0.0, 10.0)
		End Select
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
		Local fps:String = "FPS: " + rrGetFPS()
		Local boxes:String = "Boxes ('b' to add): " + boxCount
		DrawText(fps, 5, rrGetGraphicsHeight() - TextHeight(fps))
		DrawText boxes, rrGetGraphicsWidth() - TextWidth(boxes), rrGetGraphicsHeight() - TextHeight(fps)
	End Method

	
	Function applyBuoyancy(body:CPBody, gravity:CPVect, damping:Float, dt:Float)
	
		Const numx:Int = 20
		Const numy:Int = 4
		
		Const stepx:Float = TDemoState8.WIDTH / Float(numx)
		Const stepy:Float = TDemoState8.HEIGHT / Float(numy)
		
		body.ResetForces()
	
		For Local x:Int = 0 Until numx
			For Local y:Int = 0 Until numy
				Local pSample:CPVect = Vec2((x + 0.5)*stepx - WIDTH/2, (y + 0.5)*stepy - HEIGHT/2)
				Local p:CPVect = body.Local2World(pSample)
				Local r:CPVect = p.Sub(body.GetPosition())
			
				If p.y > 0 Then
					Local v:CPVect = body.GetVelocity().Add(r.Perp().Mult(body.GetAngularVelocity()))
					Local fDamp:CPVect = v.Mult(-0.0003 * v.Length())
					Local f:CPVect = Vec2(0, -2.0).Add(fDamp)
					body.ApplyForce(f, r)
				End If
			Next
		Next
		
		body.UpdateVelocity(gravity, damping, dt)
	
	End Function
	
	Method makeBox(p:CPVect, v:CPVect, a:Float, w:Float)
	
		Global verts:CPVect[] = [ ..
			Vec2(-WIDTH/3.5,-HEIGHT/2.0), ..
			Vec2(-WIDTH/3.5, HEIGHT/2.0), ..
			Vec2( WIDTH/3.5, HEIGHT/2.0), ..
			Vec2( WIDTH/3.5,-HEIGHT/2.0) ]
		
	
		Local body:CPBody = New CPBody.Create(1.0, MomentForPoly(1.0, verts, CPVZero))
		body.SetPosition(p)
		body.SetVelocity(v)
		body.SetAngle(a)
		body.SetAngularVelocity(w)
		body.SetVelocityFunction(applyBuoyancy)
		space.AddBody(body)
		
		Local shape:CPShape = New CPPolyShape.Create(body, verts, CPVZero)
		shape.SetElasticity(0.0)
		shape.SetFriction(0.7)
		space.AddShape(shape)
		
		boxCount:+1
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

