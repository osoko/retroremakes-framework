Type TDemoState2 Extends TGameState

	Field staticBody:CPBody
	Field space:CPSpace
	
	Field finished_:Int = False
	
	Global crate:TImage
	Global ball:TImage
	
	Method Initialise()
	
		AutoMidHandle(True)
		rrLoadResourceImage("incbin::media\ball.png")
		rrLoadResourceImage("incbin::media\crate.png")
		ball = rrGetResourceImage("incbin::media\ball.png")
		crate = rrGetResourceImage("incbin::media\crate.png")	
		staticBody = New CPBody.Create(INFINITY, INFINITY)
		
		ResetShapeIdCounter()
		
		space = New CPSpace.Create()
		space.SetIterations(20)
		space.ResizeStaticHash(40.0, 1000)
		space.ResizeActiveHash(40.0, 1000)
		space.SetGravity(Vec2(0, 100))
	
		Local verts:CPVect[] = [ ..
			Vec2(-15,-15), ..
			Vec2(-15, 15), ..
			Vec2( 15, 15), ..
			Vec2( 15,-15)]
	
		Local body:CPBody
		Local shape:CPShape
	
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

		For Local i:Int = 0 Until 14
			For Local j:Int = 0 To i
				body = New CPBody.Create(1.0, MomentForPoly(1.0, verts, Vec2(0,0)))

				body.SetPosition(Vec2(j*32 - i*16, 194 - i*30))
				space.AddBody(body)
				shape = New CPPolyShape.Create(body, verts, Vec2(0,0))

				shape.SetElasticity(0.0)
				shape.SetFriction(0.8)
				space.AddShape(shape)
			Next
		Next
	
		Local radius:Float = 15.0
		body = New CPBody.Create(10.0, MomentForCircle(10.0, 0.0, radius, Vec2(0,0)))
		body.SetPosition(Vec2(0, 240 - radius))
	
		space.AddBody(body)
		shape = New CPCircleShape.Create(body, radius, Vec2(0,0))
		shape.SetElasticity(0)
		shape.SetFriction(0.9)
		space.AddShape(shape)	
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
		Local steps:Int = 1
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

		SetRotation body.GetAngle()
		DrawImage TDemoState2.crate, pos.x, pos.y
	
	End Function
	
	Function drawCircleShape(shape:CPCircleShape)
	
		Local body:CPBody = shape.GetBody()
		
		Local pos:CPVect = body.GetPosition()
	
		SetRotation body.GetAngle()
		DrawImage TDemoState2.ball, pos.x, pos.y
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

