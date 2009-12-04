Rem
'
' Copyright (c) 2007-2009 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem


Type MyGameManager Extends TGameManager
	
	Field particleManager:TParticleManager
	Field layerManager:TLayerManager

	Method Quit()
		TGameEngine.GetInstance().Stop()
	End Method

	Method New()
	End Method
		
	Method Render(tweening:Double, fixed:Int)
	End Method

	' The Start() method is called after all engine services have been started, therefore
	' the graphics context has been create and all engine facilities should be available.
	' This is basically were we do our game initialisation, and kick things off.		
	Method Start()

		layerManager = New TLayerManager
		layerManager.CreateLayer(0, "back")
		layerManager.CreateLayer(1, "front")

		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)			' get keyboard input
		
		particleManager = TParticleManager.GetInstance()
		particleManager.LoadConfiguration("media\particles.txt")
		
	End Method
		
	Method Stop()
		TMessageService.GetInstance().UnsubscribeAllChannels(Self)
	End Method

	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardMessages(message)
		End Select
	End Method
	
	Method HandleKeyboardMessages(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		Select data.key
			Case KEY_ESCAPE
				If data.keyHits Then rrEngineStop()
				
			Case KEY_A
				If data.keyHits Then particleManager.CreateEmitter("PLAYER_ENGINE2", 1, 400, 300)

				
			Case KEY_B
				If data.keyHits
				
					Local p:TParticle = TParticle(particleManager._library.GetObject("16"))
					Local p2:TParticle = p.Clone()
					p2.ResetPosition(400, 300)
					layerManager.AddRenderableToLayerById(p2, 1)
				EndIf
				
								
		End Select
	End Method
	
	Method Update()
	
	End Method
	
End Type

