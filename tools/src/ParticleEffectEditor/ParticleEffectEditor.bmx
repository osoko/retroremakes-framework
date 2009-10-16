'Source Code created on 23 Jul 2008 23:12:30 with Logic Gui Version 3.1 Build 333
'Paul Maskelyne (Muttley)
'Start of external Header File
SuperStrict

Import maxgui.maxgui
Import maxgui.win32maxgui
'End Of external Header File

Global	lblBlendMode:TGadget
Global	comBlendModes:TGadget

Local	GadgetList:TList = New TList
Const	Disable:Int=1
Const	Enable:Int=2
Const	Hide:Int=3
Const	Show:Int=4
Const	Check:Int=5
Const	Uncheck:Int=6
Const	Free:Int=7
Const	SetText:Int=8
Const	Activate:Int=9
Const	Redraw:Int=10
Const	RemoveFromList:Int=11
Const	GetGadgetHandle:Int=12

Local Timer3:TTimer

Local Editor:TGadget = CreateWindow:TGadget("RetroRemakes Framework :: Particle Effect Editor - [Untitled1.par]",ClientWidth(Desktop())/2-(402),ClientHeight(Desktop())/2-(331),804,662,Null,WINDOW_TITLEBAR|WINDOW_MENU |WINDOW_STATUS )
	GadgetList.AddLast( Editor:TGadget ) ; Editor.Context="Editor"
	Local Editor_File:TGadget = CreateMenu( "File" , 100 , WindowMenu( Editor:TGadget ) )
		GadgetList.AddLast( Editor_File:TGadget ) ; Editor_File.Context="Editor#File"
		Local Editor_New:TGadget = CreateMenu( "New" , 101 , Editor_File:TGadget , KEY_N, MODIFIER_CONTROL )
			GadgetList.AddLast( Editor_New:TGadget ) ; Editor_New.Context="Editor#New"
		Local Editor_Open:TGadget = CreateMenu( "Open..." , 102 , Editor_File:TGadget , KEY_O, MODIFIER_CONTROL )
			GadgetList.AddLast( Editor_Open:TGadget ) ; Editor_Open.Context="Editor#Open"
		Local Editor_Close:TGadget = CreateMenu( "Close" , 103 , Editor_File:TGadget  )
			GadgetList.AddLast( Editor_Close:TGadget ) ; Editor_Close.Context="Editor#Close"
		Local Editor_spc1:TGadget = CreateMenu( "" , 104 , Editor_File:TGadget  )
			GadgetList.AddLast( Editor_spc1:TGadget ) ; Editor_spc1.Context="Editor#spc1"
		Local Editor_Save:TGadget = CreateMenu( "Save" , 105 , Editor_File:TGadget , KEY_S, MODIFIER_CONTROL )
			GadgetList.AddLast( Editor_Save:TGadget ) ; Editor_Save.Context="Editor#Save"
		Local Editor_SaveAs:TGadget = CreateMenu( "Save As..." , 106 , Editor_File:TGadget  )
			GadgetList.AddLast( Editor_SaveAs:TGadget ) ; Editor_SaveAs.Context="Editor#SaveAs"
		Local Editor_spc2:TGadget = CreateMenu( "" , 107 , Editor_File:TGadget  )
			GadgetList.AddLast( Editor_spc2:TGadget ) ; Editor_spc2.Context="Editor#spc2"
		Local Editor_Exit:TGadget = CreateMenu( "Exit" , 108 , Editor_File:TGadget  )
			GadgetList.AddLast( Editor_Exit:TGadget ) ; Editor_Exit.Context="Editor#Exit"
	Local Editor_Settings:TGadget = CreateMenu( "Settings" , 200 , WindowMenu( Editor:TGadget ) )
		GadgetList.AddLast( Editor_Settings:TGadget ) ; Editor_Settings.Context="Editor#Settings"
		Local Editor_LoopEffect:TGadget = CreateMenu( "Loop Effect" , 201 , Editor_Settings:TGadget  )
			GadgetList.AddLast( Editor_LoopEffect:TGadget ) ; Editor_LoopEffect.Context="Editor#LoopEffect"
		    CheckMenu( Editor_LoopEffect:TGadget )
		Local Editor_FollowMouse:TGadget = CreateMenu( "Follow Mouse" , 202 , Editor_Settings:TGadget  )
			GadgetList.AddLast( Editor_FollowMouse:TGadget ) ; Editor_FollowMouse.Context="Editor#FollowMouse"
		    CheckMenu( Editor_FollowMouse:TGadget )
	Local Editor_Help:TGadget = CreateMenu( "Help" , 300 , WindowMenu( Editor:TGadget ) )
		GadgetList.AddLast( Editor_Help:TGadget ) ; Editor_Help.Context="Editor#Help"
		Local Editor_About:TGadget = CreateMenu( "About" , 301 , Editor_Help:TGadget  )
			GadgetList.AddLast( Editor_About:TGadget ) ; Editor_About.Context="Editor#About"
	UpdateWindowMenu( Editor:TGadget )
	Local grpEmitters:TGadget = CreatePanel:TGadget(450,4,340,242,Editor:TGadget,PANEL_GROUP|PANEL_ACTIVE,"Emitters")
		GadgetList.AddLast( grpEmitters:TGadget ) ; grpEmitters.Context="grpEmitters"
		Local panColourStyleGroup:TGadget = CreatePanel:TGadget(208,4,118,211,grpEmitters:TGadget,PANEL_GROUP,"Colour/Blend Style")
			GadgetList.AddLast( panColourStyleGroup:TGadget ) ; panColourStyleGroup.Context="panColourStyleGroup"
			Local grpColourPreview:TGadget = CreatePanel:TGadget(24,58,64,64,panColourStyleGroup:TGadget,PANEL_GROUP,"Preview")
				GadgetList.AddLast( grpColourPreview:TGadget ) ; grpColourPreview.Context="grpColourPreview"
				Local cvsColourPreview:TGadget = CreateCanvas:TGadget(0,0,56,43,grpColourPreview:TGadget,Null)
					GadgetList.AddLast( cvsColourPreview:TGadget ) ; cvsColourPreview.Context="cvsColourPreview"
					SetGadgetLayout( cvsColourPreview:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
			lblBlendMode:TGadget = CreateLabel:TGadget("Blend Mode",24,133,58,14,panColourStyleGroup:TGadget,Null)
				GadgetList.AddLast( lblBlendMode:TGadget ) ; lblBlendMode.Context="lblBlendMode"
			Local radUseColourOscillator:TGadget = CreateButton:TGadget("Colour Oscillator",6,34,98,19,panColourStyleGroup:TGadget,BUTTON_RADIO)
				GadgetList.AddLast( radUseColourOscillator:TGadget ) ; radUseColourOscillator.Context="radUseColourOscillator"
				SetButtonState( radUseColourOscillator:TGadget,0 )
			Local radUseColourChanger:TGadget = CreateButton:TGadget("Colour Changer",7,9,96,19,panColourStyleGroup:TGadget,BUTTON_RADIO)
				GadgetList.AddLast( radUseColourChanger:TGadget ) ; radUseColourChanger.Context="radUseColourChanger"
				SetButtonState( radUseColourChanger:TGadget,1 )
			comBlendModes:TGadget = CreateComboBox:TGadget(7,152,93,23,panColourStyleGroup:TGadget,Null)
				GadgetList.AddLast( comBlendModes:TGadget ) ; comBlendModes.Context="comBlendModes"
				AddGadgetItem( comBlendModes:TGadget,"AlphaBlend",GADGETITEM_DEFAULT )
				AddGadgetItem( comBlendModes:TGadget,"LightBlend",GADGETITEM_NORMAL )
				AddGadgetItem( comBlendModes:TGadget,"MaskBlend",GADGETITEM_NORMAL )
				AddGadgetItem( comBlendModes:TGadget,"ShadeBlend",GADGETITEM_NORMAL )
				AddGadgetItem( comBlendModes:TGadget,"SolidBlend",GADGETITEM_NORMAL )
		Local tckEmitterSolo:TGadget = CreateButton:TGadget("Solo Emitter",107,33,75,18,grpEmitters:TGadget,BUTTON_CHECKBOX)
			GadgetList.AddLast( tckEmitterSolo:TGadget ) ; tckEmitterSolo.Context="tckEmitterSolo"
			SetButtonState( tckEmitterSolo:TGadget,0 )
		Local tckEmitterEnabled:TGadget = CreateButton:TGadget("Enable Emitter",107,2,89,18,grpEmitters:TGadget,BUTTON_CHECKBOX)
			GadgetList.AddLast( tckEmitterEnabled:TGadget ) ; tckEmitterEnabled.Context="tckEmitterEnabled"
			SetButtonState( tckEmitterEnabled:TGadget,1 )
		Local lstEmitters:TGadget = CreateListBox:TGadget(9,4,84,179,grpEmitters:TGadget,Null)
			GadgetList.AddLast( lstEmitters:TGadget ) ; lstEmitters.Context="lstEmitters"
			AddGadgetItem( lstEmitters:TGadget,"Emitter 1",GADGETITEM_DEFAULT )
			SetGadgetLayout( lstEmitters:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
		Local btnMoveEmitterUp:TGadget = CreateButton:TGadget("Up",8,192,38,23,grpEmitters:TGadget,BUTTON_PUSH)
			GadgetList.AddLast( btnMoveEmitterUp:TGadget ) ; btnMoveEmitterUp.Context="btnMoveEmitterUp"
		Local btnDeleteEmitter:TGadget = CreateButton:TGadget("Delete Emitter",100,184,101,31,grpEmitters:TGadget,BUTTON_PUSH)
			GadgetList.AddLast( btnDeleteEmitter:TGadget ) ; btnDeleteEmitter.Context="btnDeleteEmitter"
		Local btnMoveEmitterDown:TGadget = CreateButton:TGadget("Down",54,192,38,23,grpEmitters:TGadget,BUTTON_PUSH)
			GadgetList.AddLast( btnMoveEmitterDown:TGadget ) ; btnMoveEmitterDown.Context="btnMoveEmitterDown"
		Local btnCloneEmitter:TGadget = CreateButton:TGadget("Clone Emitter",100,143,101,31,grpEmitters:TGadget,BUTTON_PUSH)
			GadgetList.AddLast( btnCloneEmitter:TGadget ) ; btnCloneEmitter.Context="btnCloneEmitter"
		Local btnRenameEmitter:TGadget = CreateButton:TGadget("Rename Emitter",100,102,101,31,grpEmitters:TGadget,BUTTON_PUSH)
			GadgetList.AddLast( btnRenameEmitter:TGadget ) ; btnRenameEmitter.Context="btnRenameEmitter"
		Local btnNewEmitter:TGadget = CreateButton:TGadget("New Emitter",101,60,101,31,grpEmitters:TGadget,BUTTON_PUSH)
			GadgetList.AddLast( btnNewEmitter:TGadget ) ; btnNewEmitter.Context="btnNewEmitter"
	Local tabEmitterSettings:TGadget = CreateTabber:TGadget(452,251,339,335,Editor:TGadget,Null)
		GadgetList.AddLast( tabEmitterSettings:TGadget ) ; tabEmitterSettings.Context="tabEmitterSettings"
		AddGadgetItem( tabEmitterSettings:TGadget,"Spawn",GADGETITEM_DEFAULT )
		Local tabEmitterSettings_Tab1:TGadget = CreatePanel( 0,0,ClientWidth(tabEmitterSettings:TGadget),ClientHeight(tabEmitterSettings:TGadget),tabEmitterSettings:TGadget )
			tabEmitterSettings.items[0].extra = tabEmitterSettings_Tab1:TGadget
			SetGadgetLayout( tabEmitterSettings_Tab1,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
			Local grpEmitterPosition:TGadget = CreatePanel:TGadget(32,12,272,86,tabEmitterSettings_Tab1:TGadget,PANEL_GROUP,"Position")
				GadgetList.AddLast( grpEmitterPosition:TGadget ) ; grpEmitterPosition.Context="grpEmitterPosition"
				Local lblEmitterY:TGadget = CreateLabel:TGadget("Y:",6,42,12,14,grpEmitterPosition:TGadget,Null)
					GadgetList.AddLast( lblEmitterY:TGadget ) ; lblEmitterY.Context="lblEmitterY"
				Local lblEmitterX:TGadget = CreateLabel:TGadget("X:",6,8,12,14,grpEmitterPosition:TGadget,Null)
					GadgetList.AddLast( lblEmitterX:TGadget ) ; lblEmitterX.Context="lblEmitterX"
				Local lblEmitterXVariation:TGadget = CreateLabel:TGadget("X Variation:",117,8,57,14,grpEmitterPosition:TGadget,Null)
					GadgetList.AddLast( lblEmitterXVariation:TGadget ) ; lblEmitterXVariation.Context="lblEmitterXVariation"
				Local lblEmitterYVariation:TGadget = CreateLabel:TGadget("Y Variation:",117,42,57,14,grpEmitterPosition:TGadget,Null)
					GadgetList.AddLast( lblEmitterYVariation:TGadget ) ; lblEmitterYVariation.Context="lblEmitterYVariation"
				Local txtEmitterY:TGadget = CreateTextArea:TGadget(23,40,80,18,grpEmitterPosition:TGadget,Null)
					GadgetList.AddLast( txtEmitterY:TGadget ) ; txtEmitterY.Context="txtEmitterY"
					SetTextAreaText( txtEmitterY:TGadget , "" )
				Local txtEmitterX:TGadget = CreateTextArea:TGadget(23,6,80,18,grpEmitterPosition:TGadget,Null)
					GadgetList.AddLast( txtEmitterX:TGadget ) ; txtEmitterX.Context="txtEmitterX"
					SetTextAreaText( txtEmitterX:TGadget , "" )
				Local txtEmitterXVariation:TGadget = CreateTextArea:TGadget(176,6,80,18,grpEmitterPosition:TGadget,Null)
					GadgetList.AddLast( txtEmitterXVariation:TGadget ) ; txtEmitterXVariation.Context="txtEmitterXVariation"
					SetTextAreaText( txtEmitterXVariation:TGadget , "" )
				Local txtEmitterYVariation:TGadget = CreateTextArea:TGadget(176,40,80,18,grpEmitterPosition:TGadget,Null)
					GadgetList.AddLast( txtEmitterYVariation:TGadget ) ; txtEmitterYVariation.Context="txtEmitterYVariation"
					SetTextAreaText( txtEmitterYVariation:TGadget , "" )
			Local txtEmissionRateValue:TGadget = CreateTextArea:TGadget(281,196,49,19,tabEmitterSettings_Tab1:TGadget,Null)
				GadgetList.AddLast( txtEmissionRateValue:TGadget ) ; txtEmissionRateValue.Context="txtEmissionRateValue"
				SetTextAreaText( txtEmissionRateValue:TGadget , "" )
			Local txtParticlesValue:TGadget = CreateTextArea:TGadget(281,235,49,19,tabEmitterSettings_Tab1:TGadget,Null)
				GadgetList.AddLast( txtParticlesValue:TGadget ) ; txtParticlesValue.Context="txtParticlesValue"
				SetTextAreaText( txtParticlesValue:TGadget , "" )
			Local txtParticleEnergyValue:TGadget = CreateTextArea:TGadget(281,277,49,19,tabEmitterSettings_Tab1:TGadget,Null)
				GadgetList.AddLast( txtParticleEnergyValue:TGadget ) ; txtParticleEnergyValue.Context="txtParticleEnergyValue"
				SetTextAreaText( txtParticleEnergyValue:TGadget , "" )
			Local lblEmitterDelay:TGadget = CreateLabel:TGadget("Emitter Delay",7,113,60,25,tabEmitterSettings_Tab1:TGadget,Null)
				GadgetList.AddLast( lblEmitterDelay:TGadget ) ; lblEmitterDelay.Context="lblEmitterDelay"
			Local lblEmitterDuration:TGadget = CreateLabel:TGadget("Emitter Duration",7,153,60,26,tabEmitterSettings_Tab1:TGadget,Null)
				GadgetList.AddLast( lblEmitterDuration:TGadget ) ; lblEmitterDuration.Context="lblEmitterDuration"
			Local lblEmissionRate:TGadget = CreateLabel:TGadget("Emmision Rate",7,192,60,27,tabEmitterSettings_Tab1:TGadget,Null)
				GadgetList.AddLast( lblEmissionRate:TGadget ) ; lblEmissionRate.Context="lblEmissionRate"
			Local lblParticles:TGadget = CreateLabel:TGadget("Particles",7,237,60,15,tabEmitterSettings_Tab1:TGadget,Null)
				GadgetList.AddLast( lblParticles:TGadget ) ; lblParticles.Context="lblParticles"
			Local lblParticleEnergy:TGadget = CreateLabel:TGadget("Particle Energy",7,273,60,27,tabEmitterSettings_Tab1:TGadget,Null)
				GadgetList.AddLast( lblParticleEnergy:TGadget ) ; lblParticleEnergy.Context="lblParticleEnergy"
			Local scrEmitterDelay:TGadget = CreateSlider:TGadget(66,118,200,19,tabEmitterSettings_Tab1:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrEmitterDelay:TGadget,0 ,1001 )
				SetSliderValue( scrEmitterDelay:TGadget,0 )
				GadgetList.AddLast( scrEmitterDelay:TGadget ) ; scrEmitterDelay.Context="scrEmitterDelay"
			Local scrEmitterDuration:TGadget = CreateSlider:TGadget(66,157,200,19,tabEmitterSettings_Tab1:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrEmitterDuration:TGadget,0 ,1001 )
				SetSliderValue( scrEmitterDuration:TGadget,0 )
				GadgetList.AddLast( scrEmitterDuration:TGadget ) ; scrEmitterDuration.Context="scrEmitterDuration"
			Local scrEmissionRate:TGadget = CreateSlider:TGadget(66,196,200,19,tabEmitterSettings_Tab1:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrEmissionRate:TGadget,0 ,1001 )
				SetSliderValue( scrEmissionRate:TGadget,0 )
				GadgetList.AddLast( scrEmissionRate:TGadget ) ; scrEmissionRate.Context="scrEmissionRate"
			Local scrParticles:TGadget = CreateSlider:TGadget(66,235,200,19,tabEmitterSettings_Tab1:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrParticles:TGadget,0 ,1001 )
				SetSliderValue( scrParticles:TGadget,0 )
				GadgetList.AddLast( scrParticles:TGadget ) ; scrParticles.Context="scrParticles"
			Local scrParticleEnergy:TGadget = CreateSlider:TGadget(66,277,200,19,tabEmitterSettings_Tab1:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrParticleEnergy:TGadget,0 ,1001 )
				SetSliderValue( scrParticleEnergy:TGadget,0 )
				GadgetList.AddLast( scrParticleEnergy:TGadget ) ; scrParticleEnergy.Context="scrParticleEnergy"
			Local txtEmitterDurationValue:TGadget = CreateTextArea:TGadget(281,157,49,19,tabEmitterSettings_Tab1:TGadget,Null)
				GadgetList.AddLast( txtEmitterDurationValue:TGadget ) ; txtEmitterDurationValue.Context="txtEmitterDurationValue"
				SetTextAreaText( txtEmitterDurationValue:TGadget , "" )
			Local txtEmitterDelayValue:TGadget = CreateTextArea:TGadget(281,118,49,19,tabEmitterSettings_Tab1:TGadget,Null)
				GadgetList.AddLast( txtEmitterDelayValue:TGadget ) ; txtEmitterDelayValue.Context="txtEmitterDelayValue"
				SetTextAreaText( txtEmitterDelayValue:TGadget , "" )
		AddGadgetItem( tabEmitterSettings:TGadget,"Movement",GADGETITEM_NORMAL )
		Local tabEmitterSettings_Tab2:TGadget = CreatePanel( 0,0,ClientWidth(tabEmitterSettings:TGadget),ClientHeight(tabEmitterSettings:TGadget),tabEmitterSettings:TGadget )
			tabEmitterSettings.items[1].extra = tabEmitterSettings_Tab2:TGadget
			SetGadgetLayout( tabEmitterSettings_Tab2,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
			Local txtYGravity:TGadget = CreateTextArea:TGadget(281,257,49,19,tabEmitterSettings_Tab2:TGadget,Null)
				GadgetList.AddLast( txtYGravity:TGadget ) ; txtYGravity.Context="txtYGravity"
				SetTextAreaText( txtYGravity:TGadget , "" )
			Local lblYGravity:TGadget = CreateLabel:TGadget("Y Gravity",7,259,60,15,tabEmitterSettings_Tab2:TGadget,Null)
				GadgetList.AddLast( lblYGravity:TGadget ) ; lblYGravity.Context="lblYGravity"
			Local lblYSpeed:TGadget = CreateLabel:TGadget("Y Speed",7,79,60,15,tabEmitterSettings_Tab2:TGadget,Null)
				GadgetList.AddLast( lblYSpeed:TGadget ) ; lblYSpeed.Context="lblYSpeed"
			Local txtXSpeedVariationValue:TGadget = CreateTextArea:TGadget(281,122,49,19,tabEmitterSettings_Tab2:TGadget,Null)
				GadgetList.AddLast( txtXSpeedVariationValue:TGadget ) ; txtXSpeedVariationValue.Context="txtXSpeedVariationValue"
				SetTextAreaText( txtXSpeedVariationValue:TGadget , "" )
			Local lblXSpeedVariation:TGadget = CreateLabel:TGadget("X Speed Variation",7,119,60,25,tabEmitterSettings_Tab2:TGadget,Null)
				GadgetList.AddLast( lblXSpeedVariation:TGadget ) ; lblXSpeedVariation.Context="lblXSpeedVariation"
			Local lblYSpeedVariation:TGadget = CreateLabel:TGadget("Y Speed Variation",7,164,60,25,tabEmitterSettings_Tab2:TGadget,Null)
				GadgetList.AddLast( lblYSpeedVariation:TGadget ) ; lblYSpeedVariation.Context="lblYSpeedVariation"
			Local txtYSpeedVariationValue:TGadget = CreateTextArea:TGadget(281,167,49,19,tabEmitterSettings_Tab2:TGadget,Null)
				GadgetList.AddLast( txtYSpeedVariationValue:TGadget ) ; txtYSpeedVariationValue.Context="txtYSpeedVariationValue"
				SetTextAreaText( txtYSpeedVariationValue:TGadget , "" )
			Local lblXGravity:TGadget = CreateLabel:TGadget("X Gravity",7,214,60,15,tabEmitterSettings_Tab2:TGadget,Null)
				GadgetList.AddLast( lblXGravity:TGadget ) ; lblXGravity.Context="lblXGravity"
			Local txtXGravity:TGadget = CreateTextArea:TGadget(281,212,49,19,tabEmitterSettings_Tab2:TGadget,Null)
				GadgetList.AddLast( txtXGravity:TGadget ) ; txtXGravity.Context="txtXGravity"
				SetTextAreaText( txtXGravity:TGadget , "" )
			Local lblXSpeed:TGadget = CreateLabel:TGadget("X Speed",7,34,60,15,tabEmitterSettings_Tab2:TGadget,Null)
				GadgetList.AddLast( lblXSpeed:TGadget ) ; lblXSpeed.Context="lblXSpeed"
			Local txtXSpeedValue:TGadget = CreateTextArea:TGadget(281,32,49,19,tabEmitterSettings_Tab2:TGadget,Null)
				GadgetList.AddLast( txtXSpeedValue:TGadget ) ; txtXSpeedValue.Context="txtXSpeedValue"
				SetTextAreaText( txtXSpeedValue:TGadget , "" )
			Local scrXSpeed:TGadget = CreateSlider:TGadget(67,32,200,19,tabEmitterSettings_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrXSpeed:TGadget,0 ,2001 )
				SetSliderValue( scrXSpeed:TGadget,1000 )
				GadgetList.AddLast( scrXSpeed:TGadget ) ; scrXSpeed.Context="scrXSpeed"
			Local scrYSpeed:TGadget = CreateSlider:TGadget(67,77,200,19,tabEmitterSettings_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrYSpeed:TGadget,0 ,2001 )
				SetSliderValue( scrYSpeed:TGadget,1000 )
				GadgetList.AddLast( scrYSpeed:TGadget ) ; scrYSpeed.Context="scrYSpeed"
			Local scrXSpeedVariation:TGadget = CreateSlider:TGadget(67,122,200,19,tabEmitterSettings_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrXSpeedVariation:TGadget,0 ,1001 )
				SetSliderValue( scrXSpeedVariation:TGadget,0 )
				GadgetList.AddLast( scrXSpeedVariation:TGadget ) ; scrXSpeedVariation.Context="scrXSpeedVariation"
			Local scrYSpeedVariation:TGadget = CreateSlider:TGadget(67,167,200,19,tabEmitterSettings_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrYSpeedVariation:TGadget,0 ,1001 )
				SetSliderValue( scrYSpeedVariation:TGadget,0 )
				GadgetList.AddLast( scrYSpeedVariation:TGadget ) ; scrYSpeedVariation.Context="scrYSpeedVariation"
			Local scrXGravity:TGadget = CreateSlider:TGadget(67,212,200,19,tabEmitterSettings_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrXGravity:TGadget,0 ,2001 )
				SetSliderValue( scrXGravity:TGadget,1000 )
				GadgetList.AddLast( scrXGravity:TGadget ) ; scrXGravity.Context="scrXGravity"
			Local scrYGravity:TGadget = CreateSlider:TGadget(67,257,200,19,tabEmitterSettings_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrYGravity:TGadget,0 ,2001 )
				SetSliderValue( scrYGravity:TGadget,1000 )
				GadgetList.AddLast( scrYGravity:TGadget ) ; scrYGravity.Context="scrYGravity"
			Local txtYSpeed:TGadget = CreateTextArea:TGadget(281,77,49,19,tabEmitterSettings_Tab2:TGadget,Null)
				GadgetList.AddLast( txtYSpeed:TGadget ) ; txtYSpeed.Context="txtYSpeed"
				SetTextAreaText( txtYSpeed:TGadget , "" )
		AddGadgetItem( tabEmitterSettings:TGadget,"Transform",GADGETITEM_NORMAL )
		Local tabEmitterSettings_Tab3:TGadget = CreatePanel( 0,0,ClientWidth(tabEmitterSettings:TGadget),ClientHeight(tabEmitterSettings:TGadget),tabEmitterSettings:TGadget )
			tabEmitterSettings.items[2].extra = tabEmitterSettings_Tab3:TGadget
			SetGadgetLayout( tabEmitterSettings_Tab3,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
			Local txtMinSize:TGadget = CreateTextArea:TGadget(279,120,49,19,tabEmitterSettings_Tab3:TGadget,Null)
				GadgetList.AddLast( txtMinSize:TGadget ) ; txtMinSize.Context="txtMinSize"
				SetTextAreaText( txtMinSize:TGadget , "" )
			Local txtMaxScale:TGadget = CreateTextArea:TGadget(279,150,49,19,tabEmitterSettings_Tab3:TGadget,Null)
				GadgetList.AddLast( txtMaxScale:TGadget ) ; txtMaxScale.Context="txtMaxScale"
				SetTextAreaText( txtMaxScale:TGadget , "" )
			Local txtRotateSpeedVariation:TGadget = CreateTextArea:TGadget(279,245,49,19,tabEmitterSettings_Tab3:TGadget,Null)
				GadgetList.AddLast( txtRotateSpeedVariation:TGadget ) ; txtRotateSpeedVariation.Context="txtRotateSpeedVariation"
				SetTextAreaText( txtRotateSpeedVariation:TGadget , "" )
			Local lblRotateSpeedVariation:TGadget = CreateLabel:TGadget("Rotate Speed Variation",5,235,56,39,tabEmitterSettings_Tab3:TGadget,Null)
				GadgetList.AddLast( lblRotateSpeedVariation:TGadget ) ; lblRotateSpeedVariation.Context="lblRotateSpeedVariation"
			Local txtRotateSpeed:TGadget = CreateTextArea:TGadget(279,207,49,19,tabEmitterSettings_Tab3:TGadget,Null)
				GadgetList.AddLast( txtRotateSpeed:TGadget ) ; txtRotateSpeed.Context="txtRotateSpeed"
				SetTextAreaText( txtRotateSpeed:TGadget , "" )
			Local txtStartScaleValue:TGadget = CreateTextArea:TGadget(279,30,49,19,tabEmitterSettings_Tab3:TGadget,Null)
				GadgetList.AddLast( txtStartScaleValue:TGadget ) ; txtStartScaleValue.Context="txtStartScaleValue"
				SetTextAreaText( txtStartScaleValue:TGadget , "" )
			Local txtScaleVariation:TGadget = CreateTextArea:TGadget(279,60,49,19,tabEmitterSettings_Tab3:TGadget,Null)
				GadgetList.AddLast( txtScaleVariation:TGadget ) ; txtScaleVariation.Context="txtScaleVariation"
				SetTextAreaText( txtScaleVariation:TGadget , "" )
			Local txtScaleSpeed:TGadget = CreateTextArea:TGadget(279,90,49,19,tabEmitterSettings_Tab3:TGadget,Null)
				GadgetList.AddLast( txtScaleSpeed:TGadget ) ; txtScaleSpeed.Context="txtScaleSpeed"
				SetTextAreaText( txtScaleSpeed:TGadget , "" )
			Local lblRotateSpeed:TGadget = CreateLabel:TGadget("Rotate Speed",5,203,56,27,tabEmitterSettings_Tab3:TGadget,Null)
				GadgetList.AddLast( lblRotateSpeed:TGadget ) ; lblRotateSpeed.Context="lblRotateSpeed"
			Local lblMaxScale:TGadget = CreateLabel:TGadget("Max. Scale",5,152,56,15,tabEmitterSettings_Tab3:TGadget,Null)
				GadgetList.AddLast( lblMaxScale:TGadget ) ; lblMaxScale.Context="lblMaxScale"
			Local lblMinScale:TGadget = CreateLabel:TGadget("Min. Scale",5,122,56,15,tabEmitterSettings_Tab3:TGadget,Null)
				GadgetList.AddLast( lblMinScale:TGadget ) ; lblMinScale.Context="lblMinScale"
			Local lblScaleSpeed:TGadget = CreateLabel:TGadget("Scale Speed",6,85,50,28,tabEmitterSettings_Tab3:TGadget,Null)
				GadgetList.AddLast( lblScaleSpeed:TGadget ) ; lblScaleSpeed.Context="lblScaleSpeed"
			Local lblScaleVariation:TGadget = CreateLabel:TGadget("Scale Variation",5,56,56,26,tabEmitterSettings_Tab3:TGadget,Null)
				GadgetList.AddLast( lblScaleVariation:TGadget ) ; lblScaleVariation.Context="lblScaleVariation"
			Local lblStartScale:TGadget = CreateLabel:TGadget("Start Scale",5,32,56,15,tabEmitterSettings_Tab3:TGadget,Null)
				GadgetList.AddLast( lblStartScale:TGadget ) ; lblStartScale.Context="lblStartScale"
			Local scrStartScale:TGadget = CreateSlider:TGadget(65,30,200,19,tabEmitterSettings_Tab3:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrStartScale:TGadget,0 ,2001 )
				SetSliderValue( scrStartScale:TGadget,1000 )
				GadgetList.AddLast( scrStartScale:TGadget ) ; scrStartScale.Context="scrStartScale"
			Local scrScaleVariation:TGadget = CreateSlider:TGadget(65,60,200,19,tabEmitterSettings_Tab3:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrScaleVariation:TGadget,0 ,2001 )
				SetSliderValue( scrScaleVariation:TGadget,0 )
				GadgetList.AddLast( scrScaleVariation:TGadget ) ; scrScaleVariation.Context="scrScaleVariation"
			Local scrScaleSpeed:TGadget = CreateSlider:TGadget(65,90,200,19,tabEmitterSettings_Tab3:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrScaleSpeed:TGadget,0 ,2001 )
				SetSliderValue( scrScaleSpeed:TGadget,1000 )
				GadgetList.AddLast( scrScaleSpeed:TGadget ) ; scrScaleSpeed.Context="scrScaleSpeed"
			Local scrMinScale:TGadget = CreateSlider:TGadget(65,120,200,19,tabEmitterSettings_Tab3:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrMinScale:TGadget,0 ,10001 )
				SetSliderValue( scrMinScale:TGadget,0 )
				GadgetList.AddLast( scrMinScale:TGadget ) ; scrMinScale.Context="scrMinScale"
			Local scrMaxScale:TGadget = CreateSlider:TGadget(65,150,200,19,tabEmitterSettings_Tab3:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrMaxScale:TGadget,0 ,10001 )
				SetSliderValue( scrMaxScale:TGadget,0 )
				GadgetList.AddLast( scrMaxScale:TGadget ) ; scrMaxScale.Context="scrMaxScale"
			Local scrRotateSpeed:TGadget = CreateSlider:TGadget(65,207,200,19,tabEmitterSettings_Tab3:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrRotateSpeed:TGadget,0 ,2001 )
				SetSliderValue( scrRotateSpeed:TGadget,1000 )
				GadgetList.AddLast( scrRotateSpeed:TGadget ) ; scrRotateSpeed.Context="scrRotateSpeed"
			Local scrRotateSpeedVariation:TGadget = CreateSlider:TGadget(65,245,200,19,tabEmitterSettings_Tab3:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
				SetSliderRange( scrRotateSpeedVariation:TGadget,0 ,2001 )
				SetSliderValue( scrRotateSpeedVariation:TGadget,1000 )
				GadgetList.AddLast( scrRotateSpeedVariation:TGadget ) ; scrRotateSpeedVariation.Context="scrRotateSpeedVariation"
		AddGadgetItem( tabEmitterSettings:TGadget,"Colour",GADGETITEM_NORMAL )
		Local tabEmitterSettings_Tab4:TGadget = CreatePanel( 0,0,ClientWidth(tabEmitterSettings:TGadget),ClientHeight(tabEmitterSettings:TGadget),tabEmitterSettings:TGadget )
			tabEmitterSettings.items[3].extra = tabEmitterSettings_Tab4:TGadget
			SetGadgetLayout( tabEmitterSettings_Tab4,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
			Local tabColours:TGadget = CreateTabber:TGadget(2,2,330,305,tabEmitterSettings_Tab4:TGadget,Null)
				GadgetList.AddLast( tabColours:TGadget ) ; tabColours.Context="tabColours"
				AddGadgetItem( tabColours:TGadget,"Changer",GADGETITEM_DEFAULT )
				Local tabColours_Tab1:TGadget = CreatePanel( 0,0,ClientWidth(tabColours:TGadget),ClientHeight(tabColours:TGadget),tabColours:TGadget )
					tabColours.items[0].extra = tabColours_Tab1:TGadget
					SetGadgetLayout( tabColours_Tab1,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
					Local bdrColourPanel:TGadget = CreatePanel:TGadget(201,8,24,24,tabColours_Tab1:TGadget,PANEL_BORDER,"")
						GadgetList.AddLast( bdrColourPanel:TGadget ) ; bdrColourPanel.Context="bdrColourPanel"
					Local cvsColourPanel:TGadget = CreateCanvas:TGadget(203,10,22,22,tabColours_Tab1:TGadget,Null)
						GadgetList.AddLast( cvsColourPanel:TGadget ) ; cvsColourPanel.Context="cvsColourPanel"
						SetGadgetLayout( cvsColourPanel:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
					Local scrRedSpeed:TGadget = CreateSlider:TGadget(56,45,200,19,tabColours_Tab1:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrRedSpeed:TGadget,0 ,2001 )
						SetSliderValue( scrRedSpeed:TGadget,1000 )
						GadgetList.AddLast( scrRedSpeed:TGadget ) ; scrRedSpeed.Context="scrRedSpeed"
					Local lblRedSpeed:TGadget = CreateLabel:TGadget("Red Speed",7,41,44,26,tabColours_Tab1:TGadget,Null)
						GadgetList.AddLast( lblRedSpeed:TGadget ) ; lblRedSpeed.Context="lblRedSpeed"
					Local lblGreenSpeed:TGadget = CreateLabel:TGadget("Green Speed",7,70,44,26,tabColours_Tab1:TGadget,Null)
						GadgetList.AddLast( lblGreenSpeed:TGadget ) ; lblGreenSpeed.Context="lblGreenSpeed"
					Local scrGreenSpeed:TGadget = CreateSlider:TGadget(57,74,200,19,tabColours_Tab1:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrGreenSpeed:TGadget,0 ,2001 )
						SetSliderValue( scrGreenSpeed:TGadget,1000 )
						GadgetList.AddLast( scrGreenSpeed:TGadget ) ; scrGreenSpeed.Context="scrGreenSpeed"
					Local txtRedSpeed:TGadget = CreateTextArea:TGadget(270,45,49,19,tabColours_Tab1:TGadget,Null)
						GadgetList.AddLast( txtRedSpeed:TGadget ) ; txtRedSpeed.Context="txtRedSpeed"
						SetTextAreaText( txtRedSpeed:TGadget , "" )
					Local txtGreenSpeed:TGadget = CreateTextArea:TGadget(271,74,49,19,tabColours_Tab1:TGadget,Null)
						GadgetList.AddLast( txtGreenSpeed:TGadget ) ; txtGreenSpeed.Context="txtGreenSpeed"
						SetTextAreaText( txtGreenSpeed:TGadget , "" )
					Local txtBlueSpeed:TGadget = CreateTextArea:TGadget(271,103,49,19,tabColours_Tab1:TGadget,Null)
						GadgetList.AddLast( txtBlueSpeed:TGadget ) ; txtBlueSpeed.Context="txtBlueSpeed"
						SetTextAreaText( txtBlueSpeed:TGadget , "" )
					Local scrBlueSpeed:TGadget = CreateSlider:TGadget(57,103,200,19,tabColours_Tab1:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrBlueSpeed:TGadget,0 ,2001 )
						SetSliderValue( scrBlueSpeed:TGadget,1000 )
						GadgetList.AddLast( scrBlueSpeed:TGadget ) ; scrBlueSpeed.Context="scrBlueSpeed"
					Local lblBlueSpeed:TGadget = CreateLabel:TGadget("Blue Speed",7,99,44,26,tabColours_Tab1:TGadget,Null)
						GadgetList.AddLast( lblBlueSpeed:TGadget ) ; lblBlueSpeed.Context="lblBlueSpeed"
					Local lblStartAlpha:TGadget = CreateLabel:TGadget("Start Alpha",7,151,44,26,tabColours_Tab1:TGadget,Null)
						GadgetList.AddLast( lblStartAlpha:TGadget ) ; lblStartAlpha.Context="lblStartAlpha"
					Local lblAlphaVariation:TGadget = CreateLabel:TGadget("Alpha Variation",7,181,44,26,tabColours_Tab1:TGadget,Null)
						GadgetList.AddLast( lblAlphaVariation:TGadget ) ; lblAlphaVariation.Context="lblAlphaVariation"
					Local lblAlphaSpeed:TGadget = CreateLabel:TGadget("Alpha Speed",7,211,44,26,tabColours_Tab1:TGadget,Null)
						GadgetList.AddLast( lblAlphaSpeed:TGadget ) ; lblAlphaSpeed.Context="lblAlphaSpeed"
					Local scrAlphaSpeed:TGadget = CreateSlider:TGadget(56,215,200,19,tabColours_Tab1:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrAlphaSpeed:TGadget,0 ,2001 )
						SetSliderValue( scrAlphaSpeed:TGadget,1000 )
						GadgetList.AddLast( scrAlphaSpeed:TGadget ) ; scrAlphaSpeed.Context="scrAlphaSpeed"
					Local txtStartAlphaValue:TGadget = CreateTextArea:TGadget(270,155,49,19,tabColours_Tab1:TGadget,Null)
						GadgetList.AddLast( txtStartAlphaValue:TGadget ) ; txtStartAlphaValue.Context="txtStartAlphaValue"
						SetTextAreaText( txtStartAlphaValue:TGadget , "" )
					Local txtAlphaVariation:TGadget = CreateTextArea:TGadget(270,185,49,19,tabColours_Tab1:TGadget,Null)
						GadgetList.AddLast( txtAlphaVariation:TGadget ) ; txtAlphaVariation.Context="txtAlphaVariation"
						SetTextAreaText( txtAlphaVariation:TGadget , "" )
					Local txtAlphaSpeed:TGadget = CreateTextArea:TGadget(270,215,49,19,tabColours_Tab1:TGadget,Null)
						GadgetList.AddLast( txtAlphaSpeed:TGadget ) ; txtAlphaSpeed.Context="txtAlphaSpeed"
						SetTextAreaText( txtAlphaSpeed:TGadget , "" )
					Local btnBaseColour:TGadget = CreateButton:TGadget("Base Colour...",102,8,90,24,tabColours_Tab1:TGadget,BUTTON_PUSH)
						GadgetList.AddLast( btnBaseColour:TGadget ) ; btnBaseColour.Context="btnBaseColour"
					Local scrStartAlpha:TGadget = CreateSlider:TGadget(56,155,200,19,tabColours_Tab1:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrStartAlpha:TGadget,0 ,1001 )
						SetSliderValue( scrStartAlpha:TGadget,1000 )
						GadgetList.AddLast( scrStartAlpha:TGadget ) ; scrStartAlpha.Context="scrStartAlpha"
					Local scrAlphaVariation:TGadget = CreateSlider:TGadget(56,185,200,19,tabColours_Tab1:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrAlphaVariation:TGadget,0 ,1001 )
						SetSliderValue( scrAlphaVariation:TGadget,0 )
						GadgetList.AddLast( scrAlphaVariation:TGadget ) ; scrAlphaVariation.Context="scrAlphaVariation"
				AddGadgetItem( tabColours:TGadget,"Oscillator",GADGETITEM_NORMAL )
				Local tabColours_Tab2:TGadget = CreatePanel( 0,0,ClientWidth(tabColours:TGadget),ClientHeight(tabColours:TGadget),tabColours:TGadget )
					tabColours.items[1].extra = tabColours_Tab2:TGadget
					SetGadgetLayout( tabColours_Tab2,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
					Local lblMaxRed:TGadget = CreateLabel:TGadget("Max. Red",178,161,29,25,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( lblMaxRed:TGadget ) ; lblMaxRed.Context="lblMaxRed"
					Local scrMaxGreen:TGadget = CreateSlider:TGadget(212,195,75,18,tabColours_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrMaxGreen:TGadget,0 ,256 )
						SetSliderValue( scrMaxGreen:TGadget,0 )
						GadgetList.AddLast( scrMaxGreen:TGadget ) ; scrMaxGreen.Context="scrMaxGreen"
					Local lblMaxGreen:TGadget = CreateLabel:TGadget("Max. Green",178,191,29,25,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( lblMaxGreen:TGadget ) ; lblMaxGreen.Context="lblMaxGreen"
					Local lblMinRed:TGadget = CreateLabel:TGadget("Min. Red",6,161,29,25,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( lblMinRed:TGadget ) ; lblMinRed.Context="lblMinRed"
					Local lblMinGreen:TGadget = CreateLabel:TGadget("Min. Green",6,191,29,25,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( lblMinGreen:TGadget ) ; lblMinGreen.Context="lblMinGreen"
					Local scrMaxBlue:TGadget = CreateSlider:TGadget(212,225,75,18,tabColours_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrMaxBlue:TGadget,0 ,256 )
						SetSliderValue( scrMaxBlue:TGadget,0 )
						GadgetList.AddLast( scrMaxBlue:TGadget ) ; scrMaxBlue.Context="scrMaxBlue"
					Local lblMaxBlue:TGadget = CreateLabel:TGadget("Max. Blue",178,221,29,25,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( lblMaxBlue:TGadget ) ; lblMaxBlue.Context="lblMaxBlue"
					Local lblMinBlue:TGadget = CreateLabel:TGadget("Min. Blue",6,221,29,25,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( lblMinBlue:TGadget ) ; lblMinBlue.Context="lblMinBlue"
					Local scrMaxAlpha:TGadget = CreateSlider:TGadget(212,255,75,18,tabColours_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrMaxAlpha:TGadget,0 ,256 )
						SetSliderValue( scrMaxAlpha:TGadget,0 )
						GadgetList.AddLast( scrMaxAlpha:TGadget ) ; scrMaxAlpha.Context="scrMaxAlpha"
					Local lblMaxAlpha:TGadget = CreateLabel:TGadget("Max. Alpha",178,251,29,25,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( lblMaxAlpha:TGadget ) ; lblMaxAlpha.Context="lblMaxAlpha"
					Local scrMinGreen:TGadget = CreateSlider:TGadget(40,195,75,18,tabColours_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrMinGreen:TGadget,0 ,256 )
						SetSliderValue( scrMinGreen:TGadget,0 )
						GadgetList.AddLast( scrMinGreen:TGadget ) ; scrMinGreen.Context="scrMinGreen"
					Local scrMinBlue:TGadget = CreateSlider:TGadget(40,225,75,18,tabColours_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrMinBlue:TGadget,0 ,256 )
						SetSliderValue( scrMinBlue:TGadget,0 )
						GadgetList.AddLast( scrMinBlue:TGadget ) ; scrMinBlue.Context="scrMinBlue"
					Local scrMinAlpha:TGadget = CreateSlider:TGadget(40,255,75,18,tabColours_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrMinAlpha:TGadget,0 ,256 )
						SetSliderValue( scrMinAlpha:TGadget,0 )
						GadgetList.AddLast( scrMinAlpha:TGadget ) ; scrMinAlpha.Context="scrMinAlpha"
					Local lblMinAlpha:TGadget = CreateLabel:TGadget("Min. Alpha",6,251,29,25,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( lblMinAlpha:TGadget ) ; lblMinAlpha.Context="lblMinAlpha"
					Local lblRedOscSpeed:TGadget = CreateLabel:TGadget("Red Speed",7,36,44,25,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( lblRedOscSpeed:TGadget ) ; lblRedOscSpeed.Context="lblRedOscSpeed"
					Local txtRedOscSpeed:TGadget = CreateTextArea:TGadget(271,40,49,19,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( txtRedOscSpeed:TGadget ) ; txtRedOscSpeed.Context="txtRedOscSpeed"
						SetTextAreaText( txtRedOscSpeed:TGadget , "" )
					Local lblGreenOscSpeed:TGadget = CreateLabel:TGadget("Green Speed",7,67,44,25,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( lblGreenOscSpeed:TGadget ) ; lblGreenOscSpeed.Context="lblGreenOscSpeed"
					Local txtGreenOscSpeed:TGadget = CreateTextArea:TGadget(271,71,49,19,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( txtGreenOscSpeed:TGadget ) ; txtGreenOscSpeed.Context="txtGreenOscSpeed"
						SetTextAreaText( txtGreenOscSpeed:TGadget , "" )
					Local lblBlueOscSpeed:TGadget = CreateLabel:TGadget("Blue Speed",7,96,44,25,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( lblBlueOscSpeed:TGadget ) ; lblBlueOscSpeed.Context="lblBlueOscSpeed"
					Local txtBlueOscSpeed:TGadget = CreateTextArea:TGadget(271,100,49,19,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( txtBlueOscSpeed:TGadget ) ; txtBlueOscSpeed.Context="txtBlueOscSpeed"
						SetTextAreaText( txtBlueOscSpeed:TGadget , "" )
					Local lblParticleColourOffset:TGadget = CreateLabel:TGadget("Particle Offset",7,7,44,25,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( lblParticleColourOffset:TGadget ) ; lblParticleColourOffset.Context="lblParticleColourOffset"
					Local txtParticleColourOffset:TGadget = CreateTextArea:TGadget(271,10,49,19,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( txtParticleColourOffset:TGadget ) ; txtParticleColourOffset.Context="txtParticleColourOffset"
						SetTextAreaText( txtParticleColourOffset:TGadget , "" )
					Local txtAlphaOscSpeed:TGadget = CreateTextArea:TGadget(271,130,49,19,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( txtAlphaOscSpeed:TGadget ) ; txtAlphaOscSpeed.Context="txtAlphaOscSpeed"
						SetTextAreaText( txtAlphaOscSpeed:TGadget , "" )
					Local lblAlphaOscSpeed:TGadget = CreateLabel:TGadget("Alpha Speed",7,126,44,25,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( lblAlphaOscSpeed:TGadget ) ; lblAlphaOscSpeed.Context="lblAlphaOscSpeed"
					Local txtMaxGreen:TGadget = CreateTextArea:TGadget(292,195,27,18,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( txtMaxGreen:TGadget ) ; txtMaxGreen.Context="txtMaxGreen"
						SetTextAreaText( txtMaxGreen:TGadget , "" )
					Local txtMaxBlue:TGadget = CreateTextArea:TGadget(292,225,27,18,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( txtMaxBlue:TGadget ) ; txtMaxBlue.Context="txtMaxBlue"
						SetTextAreaText( txtMaxBlue:TGadget , "" )
					Local txtMaxAlpha:TGadget = CreateTextArea:TGadget(292,255,27,18,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( txtMaxAlpha:TGadget ) ; txtMaxAlpha.Context="txtMaxAlpha"
						SetTextAreaText( txtMaxAlpha:TGadget , "" )
					Local txtMinRed:TGadget = CreateTextArea:TGadget(120,165,27,18,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( txtMinRed:TGadget ) ; txtMinRed.Context="txtMinRed"
						SetTextAreaText( txtMinRed:TGadget , "" )
					Local txtMinGreen:TGadget = CreateTextArea:TGadget(120,195,27,18,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( txtMinGreen:TGadget ) ; txtMinGreen.Context="txtMinGreen"
						SetTextAreaText( txtMinGreen:TGadget , "" )
					Local txtMinBlue:TGadget = CreateTextArea:TGadget(120,225,27,18,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( txtMinBlue:TGadget ) ; txtMinBlue.Context="txtMinBlue"
						SetTextAreaText( txtMinBlue:TGadget , "" )
					Local txtMinAlpha:TGadget = CreateTextArea:TGadget(120,255,27,18,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( txtMinAlpha:TGadget ) ; txtMinAlpha.Context="txtMinAlpha"
						SetTextAreaText( txtMinAlpha:TGadget , "" )
					Local scrMinRed:TGadget = CreateSlider:TGadget(40,165,75,18,tabColours_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrMinRed:TGadget,0 ,256 )
						SetSliderValue( scrMinRed:TGadget,0 )
						GadgetList.AddLast( scrMinRed:TGadget ) ; scrMinRed.Context="scrMinRed"
					Local txtMaxRed:TGadget = CreateTextArea:TGadget(292,165,27,18,tabColours_Tab2:TGadget,Null)
						GadgetList.AddLast( txtMaxRed:TGadget ) ; txtMaxRed.Context="txtMaxRed"
						SetTextAreaText( txtMaxRed:TGadget , "" )
					Local scrMaxRed:TGadget = CreateSlider:TGadget(212,165,75,18,tabColours_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrMaxRed:TGadget,0 ,256 )
						SetSliderValue( scrMaxRed:TGadget,0 )
						GadgetList.AddLast( scrMaxRed:TGadget ) ; scrMaxRed.Context="scrMaxRed"
					Local scrParticleColourOffset:TGadget = CreateSlider:TGadget(57,10,199,18,tabColours_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrParticleColourOffset:TGadget,0 ,1001 )
						SetSliderValue( scrParticleColourOffset:TGadget,0 )
						GadgetList.AddLast( scrParticleColourOffset:TGadget ) ; scrParticleColourOffset.Context="scrParticleColourOffset"
					Local scrRedOscSpeed:TGadget = CreateSlider:TGadget(57,40,200,18,tabColours_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrRedOscSpeed:TGadget,0 ,2001 )
						SetSliderValue( scrRedOscSpeed:TGadget,1000 )
						GadgetList.AddLast( scrRedOscSpeed:TGadget ) ; scrRedOscSpeed.Context="scrRedOscSpeed"
					Local scrGreenOscSpeed:TGadget = CreateSlider:TGadget(57,70,200,18,tabColours_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrGreenOscSpeed:TGadget,0 ,2001 )
						SetSliderValue( scrGreenOscSpeed:TGadget,1000 )
						GadgetList.AddLast( scrGreenOscSpeed:TGadget ) ; scrGreenOscSpeed.Context="scrGreenOscSpeed"
					Local scrBlueOscSpeed:TGadget = CreateSlider:TGadget(57,100,200,18,tabColours_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrBlueOscSpeed:TGadget,0 ,2001 )
						SetSliderValue( scrBlueOscSpeed:TGadget,1000 )
						GadgetList.AddLast( scrBlueOscSpeed:TGadget ) ; scrBlueOscSpeed.Context="scrBlueOscSpeed"
					Local scrAlphaOscSpeed:TGadget = CreateSlider:TGadget(57,130,200,18,tabColours_Tab2:TGadget,SLIDER_HORIZONTAL | SLIDER_SCROLLBAR )
						SetSliderRange( scrAlphaOscSpeed:TGadget,0 ,2001 )
						SetSliderValue( scrAlphaOscSpeed:TGadget,1000 )
						GadgetList.AddLast( scrAlphaOscSpeed:TGadget ) ; scrAlphaOscSpeed.Context="scrAlphaOscSpeed"
				tabColours_GA( tabColours:TGadget , 0 )
		AddGadgetItem( tabEmitterSettings:TGadget,"Image",GADGETITEM_NORMAL )
		Local tabEmitterSettings_Tab5:TGadget = CreatePanel( 0,0,ClientWidth(tabEmitterSettings:TGadget),ClientHeight(tabEmitterSettings:TGadget),tabEmitterSettings:TGadget )
			tabEmitterSettings.items[4].extra = tabEmitterSettings_Tab5:TGadget
			SetGadgetLayout( tabEmitterSettings_Tab5,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
			Local grpImagePreview:TGadget = CreatePanel:TGadget(35,2,264,277,tabEmitterSettings_Tab5:TGadget,PANEL_GROUP,"Image Preview")
				GadgetList.AddLast( grpImagePreview:TGadget ) ; grpImagePreview.Context="grpImagePreview"
				Local cvsImagePreview:TGadget = CreateCanvas:TGadget(0,-1,256,256,grpImagePreview:TGadget,Null)
					GadgetList.AddLast( cvsImagePreview:TGadget ) ; cvsImagePreview.Context="cvsImagePreview"
					SetGadgetLayout( cvsImagePreview:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
			Local btnLoadImage:TGadget = CreateButton:TGadget("Load Image...",103,284,128,23,tabEmitterSettings_Tab5:TGadget,BUTTON_PUSH)
				GadgetList.AddLast( btnLoadImage:TGadget ) ; btnLoadImage.Context="btnLoadImage"
		tabEmitterSettings_GA( tabEmitterSettings:TGadget , 0 )
	Local grpEffectPreview:TGadget = CreatePanel:TGadget(7,4,439,583,Editor:TGadget,PANEL_GROUP,"Effect Preview")
		GadgetList.AddLast( grpEffectPreview:TGadget ) ; grpEffectPreview.Context="grpEffectPreview"
		Local cvsEffectPreview:TGadget = CreateCanvas:TGadget(0,0,431,562,grpEffectPreview:TGadget,Null)
			GadgetList.AddLast( cvsEffectPreview:TGadget ) ; cvsEffectPreview.Context="cvsEffectPreview"
			ActivateGadget( cvsEffectPreview:TGadget )
			SetGadgetLayout( cvsEffectPreview:TGadget,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED )
			Local cvsEffectPreview_PopUpMenu:TGadget = CreateMenu( "" , 0 , Null ) 
				Local cvsEffectPreview_PopUpMenu_puLoopEffect:TGadget = CreateMenu( "Loop Effect" , 10100 , cvsEffectPreview_PopUpMenu:TGadget  )
					GadgetList.AddLast( cvsEffectPreview_PopUpMenu_puLoopEffect:TGadget ) ; cvsEffectPreview_PopUpMenu_puLoopEffect.Context="cvsEffectPreview_PopUpMenu#puLoopEffect"
				    CheckMenu( cvsEffectPreview_PopUpMenu_puLoopEffect:TGadget )
				Local cvsEffectPreview_PopUpMenu_puFollowMouse:TGadget = CreateMenu( "Follow Mouse" , 10200 , cvsEffectPreview_PopUpMenu:TGadget  )
					GadgetList.AddLast( cvsEffectPreview_PopUpMenu_puFollowMouse:TGadget ) ; cvsEffectPreview_PopUpMenu_puFollowMouse.Context="cvsEffectPreview_PopUpMenu#puFollowMouse"
				    CheckMenu( cvsEffectPreview_PopUpMenu_puFollowMouse:TGadget )

Repeat
	WaitEvent()
	Select EventID()
		Case EVENT_WINDOWCLOSE
			Select EventSource()
				Case Editor	Editor_WC( Editor:TGadget , GadgetList:TList )
			End Select

		Case EVENT_GADGETACTION
			Select EventSource()
				Case tabEmitterSettings	tabEmitterSettings_GA( tabEmitterSettings:TGadget , EventData() , GadgetList:TList )
				Case tckEmitterSolo	tckEmitterSolo_GA( tckEmitterSolo:TGadget, EventData() , GadgetList:TList )
				Case tckEmitterEnabled	tckEmitterEnabled_GA( tckEmitterEnabled:TGadget, EventData() , GadgetList:TList )
				Case lstEmitters	lstEmitters_GA( lstEmitters:TGadget , EventData() , EventExtra:Object() , GadgetList:TList )
				Case btnMoveEmitterUp	btnMoveEmitterUp_GA( btnMoveEmitterUp:TGadget , GadgetList:TList )
				Case btnDeleteEmitter	btnDeleteEmitter_GA( btnDeleteEmitter:TGadget , GadgetList:TList )
				Case btnMoveEmitterDown	btnMoveEmitterDown_GA( btnMoveEmitterDown:TGadget , GadgetList:TList )
				Case btnCloneEmitter	btnCloneEmitter_GA( btnCloneEmitter:TGadget , GadgetList:TList )
				Case btnRenameEmitter	btnRenameEmitter_GA( btnRenameEmitter:TGadget , GadgetList:TList )
				Case radUseColourOscillator	radUseColourOscillator_GA( radUseColourOscillator:TGadget , GadgetList:TList )
				Case radUseColourChanger	radUseColourChanger_GA( radUseColourChanger:TGadget , GadgetList:TList )
				Case comBlendModes	comBlendModes_GA( comBlendModes:TGadget , EventData() , GadgetList:TList )
				Case tabColours	tabColours_GA( tabColours:TGadget , EventData() , GadgetList:TList )
				Case scrRedSpeed	scrRedSpeed_GA( scrRedSpeed:TGadget , EventData() , GadgetList:TList )
				Case scrGreenSpeed	scrGreenSpeed_GA( scrGreenSpeed:TGadget , EventData() , GadgetList:TList )
				Case txtRedSpeed	txtRedSpeed_GA( txtRedSpeed:TGadget , GadgetList:TList )
				Case txtGreenSpeed	txtGreenSpeed_GA( txtGreenSpeed:TGadget , GadgetList:TList )
				Case txtBlueSpeed	txtBlueSpeed_GA( txtBlueSpeed:TGadget , GadgetList:TList )
				Case scrBlueSpeed	scrBlueSpeed_GA( scrBlueSpeed:TGadget , EventData() , GadgetList:TList )
				Case scrAlphaSpeed	scrAlphaSpeed_GA( scrAlphaSpeed:TGadget , EventData() , GadgetList:TList )
				Case txtStartAlphaValue	txtStartAlphaValue_GA( txtStartAlphaValue:TGadget , GadgetList:TList )
				Case txtAlphaVariation	txtAlphaVariation_GA( txtAlphaVariation:TGadget , GadgetList:TList )
				Case txtAlphaSpeed	txtAlphaSpeed_GA( txtAlphaSpeed:TGadget , GadgetList:TList )
				Case btnBaseColour	btnBaseColour_GA( btnBaseColour:TGadget , GadgetList:TList )
				Case scrStartAlpha	scrStartAlpha_GA( scrStartAlpha:TGadget , EventData() , GadgetList:TList )
				Case scrAlphaVariation	scrAlphaVariation_GA( scrAlphaVariation:TGadget , EventData() , GadgetList:TList )
				Case btnNewEmitter	btnNewEmitter_GA( btnNewEmitter:TGadget , GadgetList:TList )
				Case txtEmissionRateValue	txtEmissionRateValue_GA( txtEmissionRateValue:TGadget , GadgetList:TList )
				Case txtParticlesValue	txtParticlesValue_GA( txtParticlesValue:TGadget , GadgetList:TList )
				Case txtParticleEnergyValue	txtParticleEnergyValue_GA( txtParticleEnergyValue:TGadget , GadgetList:TList )
				Case scrEmitterDelay	scrEmitterDelay_GA( scrEmitterDelay:TGadget , EventData() , GadgetList:TList )
				Case scrEmitterDuration	scrEmitterDuration_GA( scrEmitterDuration:TGadget , EventData() , GadgetList:TList )
				Case scrEmissionRate	scrEmissionRate_GA( scrEmissionRate:TGadget , EventData() , GadgetList:TList )
				Case scrParticles	scrParticles_GA( scrParticles:TGadget , EventData() , GadgetList:TList )
				Case scrParticleEnergy	scrParticleEnergy_GA( scrParticleEnergy:TGadget , EventData() , GadgetList:TList )
				Case txtEmitterY	txtEmitterY_GA( txtEmitterY:TGadget , GadgetList:TList )
				Case txtEmitterX	txtEmitterX_GA( txtEmitterX:TGadget , GadgetList:TList )
				Case txtEmitterDurationValue	txtEmitterDurationValue_GA( txtEmitterDurationValue:TGadget , GadgetList:TList )
				Case txtEmitterDelayValue	txtEmitterDelayValue_GA( txtEmitterDelayValue:TGadget , GadgetList:TList )
				Case txtEmitterXVariation	txtEmitterXVariation_GA( txtEmitterXVariation:TGadget , GadgetList:TList )
				Case txtEmitterYVariation	txtEmitterYVariation_GA( txtEmitterYVariation:TGadget , GadgetList:TList )
				Case txtYGravity	txtYGravity_GA( txtYGravity:TGadget , GadgetList:TList )
				Case txtXSpeedVariationValue	txtXSpeedVariationValue_GA( txtXSpeedVariationValue:TGadget , GadgetList:TList )
				Case txtYSpeedVariationValue	txtYSpeedVariationValue_GA( txtYSpeedVariationValue:TGadget , GadgetList:TList )
				Case txtXGravity	txtXGravity_GA( txtXGravity:TGadget , GadgetList:TList )
				Case txtXSpeedValue	txtXSpeedValue_GA( txtXSpeedValue:TGadget , GadgetList:TList )
				Case scrXSpeed	scrXSpeed_GA( scrXSpeed:TGadget , EventData() , GadgetList:TList )
				Case scrYSpeed	scrYSpeed_GA( scrYSpeed:TGadget , EventData() , GadgetList:TList )
				Case scrXSpeedVariation	scrXSpeedVariation_GA( scrXSpeedVariation:TGadget , EventData() , GadgetList:TList )
				Case scrYSpeedVariation	scrYSpeedVariation_GA( scrYSpeedVariation:TGadget , EventData() , GadgetList:TList )
				Case scrXGravity	scrXGravity_GA( scrXGravity:TGadget , EventData() , GadgetList:TList )
				Case scrYGravity	scrYGravity_GA( scrYGravity:TGadget , EventData() , GadgetList:TList )
				Case txtYSpeed	txtYSpeed_GA( txtYSpeed:TGadget , GadgetList:TList )
				Case btnLoadImage	btnLoadImage_GA( btnLoadImage:TGadget , GadgetList:TList )
				Case txtMinSize	txtMinSize_GA( txtMinSize:TGadget , GadgetList:TList )
				Case txtMaxScale	txtMaxScale_GA( txtMaxScale:TGadget , GadgetList:TList )
				Case txtRotateSpeedVariation	txtRotateSpeedVariation_GA( txtRotateSpeedVariation:TGadget , GadgetList:TList )
				Case txtRotateSpeed	txtRotateSpeed_GA( txtRotateSpeed:TGadget , GadgetList:TList )
				Case txtStartScaleValue	txtStartScaleValue_GA( txtStartScaleValue:TGadget , GadgetList:TList )
				Case txtScaleVariation	txtScaleVariation_GA( txtScaleVariation:TGadget , GadgetList:TList )
				Case txtScaleSpeed	txtScaleSpeed_GA( txtScaleSpeed:TGadget , GadgetList:TList )
				Case scrStartScale	scrStartScale_GA( scrStartScale:TGadget , EventData() , GadgetList:TList )
				Case scrScaleVariation	scrScaleVariation_GA( scrScaleVariation:TGadget , EventData() , GadgetList:TList )
				Case scrScaleSpeed	scrScaleSpeed_GA( scrScaleSpeed:TGadget , EventData() , GadgetList:TList )
				Case scrMinScale	scrMinScale_GA( scrMinScale:TGadget , EventData() , GadgetList:TList )
				Case scrMaxScale	scrMaxScale_GA( scrMaxScale:TGadget , EventData() , GadgetList:TList )
				Case scrRotateSpeed	scrRotateSpeed_GA( scrRotateSpeed:TGadget , EventData() , GadgetList:TList )
				Case scrRotateSpeedVariation	scrRotateSpeedVariation_GA( scrRotateSpeedVariation:TGadget , EventData() , GadgetList:TList )
				Case scrMaxGreen	scrMaxGreen_GA( scrMaxGreen:TGadget , EventData() , GadgetList:TList )
				Case scrMaxBlue	scrMaxBlue_GA( scrMaxBlue:TGadget , EventData() , GadgetList:TList )
				Case scrMaxAlpha	scrMaxAlpha_GA( scrMaxAlpha:TGadget , EventData() , GadgetList:TList )
				Case scrMinGreen	scrMinGreen_GA( scrMinGreen:TGadget , EventData() , GadgetList:TList )
				Case scrMinBlue	scrMinBlue_GA( scrMinBlue:TGadget , EventData() , GadgetList:TList )
				Case scrMinAlpha	scrMinAlpha_GA( scrMinAlpha:TGadget , EventData() , GadgetList:TList )
				Case txtRedOscSpeed	txtRedOscSpeed_GA( txtRedOscSpeed:TGadget , GadgetList:TList )
				Case txtGreenOscSpeed	txtGreenOscSpeed_GA( txtGreenOscSpeed:TGadget , GadgetList:TList )
				Case txtBlueOscSpeed	txtBlueOscSpeed_GA( txtBlueOscSpeed:TGadget , GadgetList:TList )
				Case txtParticleColourOffset	txtParticleColourOffset_GA( txtParticleColourOffset:TGadget , GadgetList:TList )
				Case txtAlphaOscSpeed	txtAlphaOscSpeed_GA( txtAlphaOscSpeed:TGadget , GadgetList:TList )
				Case txtMaxGreen	txtMaxGreen_GA( txtMaxGreen:TGadget , GadgetList:TList )
				Case txtMaxBlue	txtMaxBlue_GA( txtMaxBlue:TGadget , GadgetList:TList )
				Case txtMaxAlpha	txtMaxAlpha_GA( txtMaxAlpha:TGadget , GadgetList:TList )
				Case txtMinRed	txtMinRed_GA( txtMinRed:TGadget , GadgetList:TList )
				Case txtMinGreen	txtMinGreen_GA( txtMinGreen:TGadget , GadgetList:TList )
				Case txtMinBlue	txtMinBlue_GA( txtMinBlue:TGadget , GadgetList:TList )
				Case txtMinAlpha	txtMinAlpha_GA( txtMinAlpha:TGadget , GadgetList:TList )
				Case scrMinRed	scrMinRed_GA( scrMinRed:TGadget , EventData() , GadgetList:TList )
				Case txtMaxRed	txtMaxRed_GA( txtMaxRed:TGadget , GadgetList:TList )
				Case scrMaxRed	scrMaxRed_GA( scrMaxRed:TGadget , EventData() , GadgetList:TList )
				Case scrParticleColourOffset	scrParticleColourOffset_GA( scrParticleColourOffset:TGadget , EventData() , GadgetList:TList )
				Case scrRedOscSpeed	scrRedOscSpeed_GA( scrRedOscSpeed:TGadget , EventData() , GadgetList:TList )
				Case scrGreenOscSpeed	scrGreenOscSpeed_GA( scrGreenOscSpeed:TGadget , EventData() , GadgetList:TList )
				Case scrBlueOscSpeed	scrBlueOscSpeed_GA( scrBlueOscSpeed:TGadget , EventData() , GadgetList:TList )
				Case scrAlphaOscSpeed	scrAlphaOscSpeed_GA( scrAlphaOscSpeed:TGadget , EventData() , GadgetList:TList )
			End Select

		Case EVENT_GADGETSELECT
			Select EventSource()
				Case lstEmitters	lstEmitters_GS( lstEmitters:TGadget , EventData() , EventExtra:Object() , GadgetList:TList )
			End Select

		Case EVENT_GADGETMENU
			Select EventSource()
				Case lstEmitters	lstEmitters_GM( lstEmitters:TGadget , EventData() , EventExtra:Object() , Editor:TGadget , GadgetList:TList )
				Case txtEmitterX	txtEmitterX_GM( txtEmitterX:TGadget , Editor:TGadget , GadgetList:TList )
			End Select

		Case EVENT_MOUSEDOWN
			Select EventSource()
				Case grpEmitters	grpEmitters_MD( grpEmitters:TGadget , EventData() , Editor:TGadget , GadgetList:TList )
				Case cvsEffectPreview	cvsEffectPreview_MD( cvsEffectPreview:TGadget , EventData() , Editor:TGadget , cvsEffectPreview_PopUpMenu:TGadget , GadgetList:TList )
				Case cvsColourPanel	cvsColourPanel_MD( cvsColourPanel:TGadget , EventData() , Editor:TGadget , GadgetList:TList )
			End Select

		Case EVENT_GADGETPAINT
			Select EventSource()
				Case cvsEffectPreview	cvsEffectPreview_GP( cvsEffectPreview:TGadget , GadgetList:TList )
			End Select

		Case EVENT_MENUACTION
			Select EventData()
				'Menu_Events for Gadget = Editor
				Case 101	Editor_New_MA( Editor:TGadget , Editor_File:TGadget , Editor_New:TGadget , GadgetList:TList )
				Case 102	Editor_Open_MA( Editor:TGadget , Editor_File:TGadget , Editor_Open:TGadget , GadgetList:TList )
				Case 103	Editor_Close_MA( Editor:TGadget , Editor_File:TGadget , Editor_Close:TGadget , GadgetList:TList )
				Case 105	Editor_Save_MA( Editor:TGadget , Editor_File:TGadget , Editor_Save:TGadget , GadgetList:TList )
				Case 106	Editor_SaveAs_MA( Editor:TGadget , Editor_File:TGadget , Editor_SaveAs:TGadget , GadgetList:TList )
				Case 108	Editor_Exit_MA( Editor:TGadget , Editor_File:TGadget , Editor_Exit:TGadget , GadgetList:TList )
				Case 201	Editor_LoopEffect_MA( Editor:TGadget , Editor_Settings:TGadget , Editor_LoopEffect:TGadget , GadgetList:TList )
				Case 202	Editor_FollowMouse_MA( Editor:TGadget , Editor_Settings:TGadget , Editor_FollowMouse:TGadget , GadgetList:TList )
				Case 301	Editor_About_MA( Editor:TGadget , Editor_Help:TGadget , Editor_About:TGadget , GadgetList:TList )
				'Menu_Events for Gadget = cvsEffectPreview_PopUpMenu
			End Select

		Case EVENT_TIMERTICK
			Select EventSource()
				Case Timer3	Timer3_Timer( Timer3:TTimer , GadgetList:TList )
			End Select

	End Select
Forever

Function Editor_WC( Window:TGadget , GadgetList:TList=Null )
	DebugLog "Window Editor wants to be closed"
'	HideGadget( Window:TGadget )

	END
End Function

Function tabEmitterSettings_GA( Tabber:TGadget , Number:Int , GadgetList:TList=Null )
	DebugLog "Tabber tabEmitterSettings selected Tab " + Number
	For Local i:int = 0 to Tabber.items.length -1
		HideGadget( TGadget( Tabber.items[i].extra ) )
	Next
	ShowGadget( TGadget( Tabber.items[Number].extra ) )
	
End Function

Function tckEmitterSolo_GA( Button:TGadget, State:Int , GadgetList:TList=Null )
	DebugLog "Checkbox Button tckEmitterSolo changed to "+ State
	
End Function

Function tckEmitterEnabled_GA( Button:TGadget, State:Int , GadgetList:TList=Null )
	DebugLog "Checkbox Button tckEmitterEnabled changed to "+ State
	
End Function

Function lstEmitters_GA( ListBox:TGadget , Number:Int , Extra:Object , GadgetList:TList=Null )
	DebugLog "ListBox lstEmitters double clicked an Item " + Number
    If Number => 0 DebugLog "Selected Text = "+ GadgetItemText( ListBox:TGadget , Number:Int )
	
End Function

Function btnMoveEmitterUp_GA( Button:TGadget , GadgetList:TList=Null )
	DebugLog "Button btnMoveEmitterUp was pressed"
	
End Function

Function btnDeleteEmitter_GA( Button:TGadget , GadgetList:TList=Null )
	DebugLog "Button btnDeleteEmitter was pressed"
	
End Function

Function btnMoveEmitterDown_GA( Button:TGadget , GadgetList:TList=Null )
	DebugLog "Button btnMoveEmitterDown was pressed"
	
End Function

Function btnCloneEmitter_GA( Button:TGadget , GadgetList:TList=Null )
	DebugLog "Button btnCloneEmitter was pressed"
	
End Function

Function btnRenameEmitter_GA( Button:TGadget , GadgetList:TList=Null )
	DebugLog "Button btnRenameEmitter was pressed"
	
End Function

Function radUseColourOscillator_GA( Button:TGadget , GadgetList:TList=Null )
	DebugLog "Button radUseColourOscillator was pressed"
	
End Function

Function radUseColourChanger_GA( Button:TGadget , GadgetList:TList=Null )
	DebugLog "Button radUseColourChanger was pressed"
	
End Function

Function comBlendModes_GA( Combo:TGadget , Number:Int , GadgetList:TList=Null )
	DebugLog "ComboBox comBlendModes selected Nr. " + Number
	DebugLog "Selected Text = "+ GadgetItemText( Combo:TGadget , Number:Int )
	
End Function

Function tabColours_GA( Tabber:TGadget , Number:Int , GadgetList:TList=Null )
	DebugLog "Tabber tabColours selected Tab " + Number
	For Local i:int = 0 to Tabber.items.length -1
		HideGadget( TGadget( Tabber.items[i].extra ) )
	Next
	ShowGadget( TGadget( Tabber.items[Number].extra ) )
	
End Function

Function scrRedSpeed_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrRedSpeed changed to " + Number
	
End Function

Function scrGreenSpeed_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrGreenSpeed changed to " + Number
	
End Function

Function txtRedSpeed_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtRedSpeed was modified"
	
End Function

Function txtGreenSpeed_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtGreenSpeed was modified"
	
End Function

Function txtBlueSpeed_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtBlueSpeed was modified"
	
End Function

Function scrBlueSpeed_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrBlueSpeed changed to " + Number
	
End Function

Function scrAlphaSpeed_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrAlphaSpeed changed to " + Number
	
End Function

Function txtStartAlphaValue_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtStartAlphaValue was modified"
	
End Function

Function txtAlphaVariation_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtAlphaVariation was modified"
	
End Function

Function txtAlphaSpeed_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtAlphaSpeed was modified"
	
End Function

Function btnBaseColour_GA( Button:TGadget , GadgetList:TList=Null )
	DebugLog "Button btnBaseColour was pressed"
	
End Function

Function scrStartAlpha_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 1001 as End Value
	DebugLog "Slider scrStartAlpha changed to " + Number
	
End Function

Function scrAlphaVariation_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 1001 as End Value
	DebugLog "Slider scrAlphaVariation changed to " + Number
	
End Function

Function btnNewEmitter_GA( Button:TGadget , GadgetList:TList=Null )
	DebugLog "Button btnNewEmitter was pressed"
	
End Function

Function txtEmissionRateValue_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtEmissionRateValue was modified"
	
End Function

Function txtParticlesValue_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtParticlesValue was modified"
	
End Function

Function txtParticleEnergyValue_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtParticleEnergyValue was modified"
	
End Function

Function scrEmitterDelay_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 1001 as End Value
	DebugLog "Slider scrEmitterDelay changed to " + Number
	
End Function

Function scrEmitterDuration_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 1001 as End Value
	DebugLog "Slider scrEmitterDuration changed to " + Number
	
End Function

Function scrEmissionRate_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 1001 as End Value
	DebugLog "Slider scrEmissionRate changed to " + Number
	
End Function

Function scrParticles_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 1001 as End Value
	DebugLog "Slider scrParticles changed to " + Number
	
End Function

Function scrParticleEnergy_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 1001 as End Value
	DebugLog "Slider scrParticleEnergy changed to " + Number
	
End Function

Function txtEmitterY_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtEmitterY was modified"
	
End Function

Function txtEmitterX_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtEmitterX was modified"
	
End Function

Function txtEmitterDurationValue_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtEmitterDurationValue was modified"
	
End Function

Function txtEmitterDelayValue_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtEmitterDelayValue was modified"
	
End Function

Function txtEmitterXVariation_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtEmitterXVariation was modified"
	
End Function

Function txtEmitterYVariation_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtEmitterYVariation was modified"
	
End Function

Function txtYGravity_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtYGravity was modified"
	
End Function

Function txtXSpeedVariationValue_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtXSpeedVariationValue was modified"
	
End Function

Function txtYSpeedVariationValue_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtYSpeedVariationValue was modified"
	
End Function

Function txtXGravity_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtXGravity was modified"
	
End Function

Function txtXSpeedValue_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtXSpeedValue was modified"
	
End Function

Function scrXSpeed_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrXSpeed changed to " + Number
	Local Gadget1:TGadget, GadgetArray1$[] =["txtXSpeedValue"] 
If GadgetList Gadget1:TGadget =GadgetCommander(SetText,GadgetArray1,GadgetList:TList,"Your Text Here" )


End Function

Function scrYSpeed_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrYSpeed changed to " + Number
	
End Function

Function scrXSpeedVariation_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 1001 as End Value
	DebugLog "Slider scrXSpeedVariation changed to " + Number
	
End Function

Function scrYSpeedVariation_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 1001 as End Value
	DebugLog "Slider scrYSpeedVariation changed to " + Number
	
End Function

Function scrXGravity_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrXGravity changed to " + Number
	
End Function

Function scrYGravity_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrYGravity changed to " + Number
	
End Function

Function txtYSpeed_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtYSpeed was modified"
	
End Function

Function btnLoadImage_GA( Button:TGadget , GadgetList:TList=Null )
	DebugLog "Button btnLoadImage was pressed"
	
End Function

Function txtMinSize_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtMinSize was modified"
	
End Function

Function txtMaxScale_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtMaxScale was modified"
	
End Function

Function txtRotateSpeedVariation_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtRotateSpeedVariation was modified"
	
End Function

Function txtRotateSpeed_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtRotateSpeed was modified"
	
End Function

Function txtStartScaleValue_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtStartScaleValue was modified"
	
End Function

Function txtScaleVariation_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtScaleVariation was modified"
	
End Function

Function txtScaleSpeed_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtScaleSpeed was modified"
	
End Function

Function scrStartScale_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrStartScale changed to " + Number
	
End Function

Function scrScaleVariation_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrScaleVariation changed to " + Number
	
End Function

Function scrScaleSpeed_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrScaleSpeed changed to " + Number
	
End Function

Function scrMinScale_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 10001 as End Value
	DebugLog "Slider scrMinScale changed to " + Number
	
End Function

Function scrMaxScale_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 10001 as End Value
	DebugLog "Slider scrMaxScale changed to " + Number
	
End Function

Function scrRotateSpeed_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrRotateSpeed changed to " + Number
	
End Function

Function scrRotateSpeedVariation_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrRotateSpeedVariation changed to " + Number
	
End Function

Function scrMaxGreen_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 256 as End Value
	DebugLog "Slider scrMaxGreen changed to " + Number
	
End Function

Function scrMaxBlue_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 256 as End Value
	DebugLog "Slider scrMaxBlue changed to " + Number
	
End Function

Function scrMaxAlpha_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 256 as End Value
	DebugLog "Slider scrMaxAlpha changed to " + Number
	
End Function

Function scrMinGreen_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 256 as End Value
	DebugLog "Slider scrMinGreen changed to " + Number
	
End Function

Function scrMinBlue_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 256 as End Value
	DebugLog "Slider scrMinBlue changed to " + Number
	
End Function

Function scrMinAlpha_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 256 as End Value
	DebugLog "Slider scrMinAlpha changed to " + Number
	
End Function

Function txtRedOscSpeed_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtRedOscSpeed was modified"
	
End Function

Function txtGreenOscSpeed_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtGreenOscSpeed was modified"
	
End Function

Function txtBlueOscSpeed_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtBlueOscSpeed was modified"
	
End Function

Function txtParticleColourOffset_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtParticleColourOffset was modified"
	
End Function

Function txtAlphaOscSpeed_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtAlphaOscSpeed was modified"
	
End Function

Function txtMaxGreen_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtMaxGreen was modified"
	
End Function

Function txtMaxBlue_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtMaxBlue was modified"
	
End Function

Function txtMaxAlpha_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtMaxAlpha was modified"
	
End Function

Function txtMinRed_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtMinRed was modified"
	
End Function

Function txtMinGreen_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtMinGreen was modified"
	
End Function

Function txtMinBlue_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtMinBlue was modified"
	
End Function

Function txtMinAlpha_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtMinAlpha was modified"
	
End Function

Function scrMinRed_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 256 as End Value
	DebugLog "Slider scrMinRed changed to " + Number
	
End Function

Function txtMaxRed_GA( TextArea:TGadget , GadgetList:TList=Null )
	DebugLog "TextArea txtMaxRed was modified"
	
End Function

Function scrMaxRed_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 256 as End Value
	DebugLog "Slider scrMaxRed changed to " + Number
	
End Function

Function scrParticleColourOffset_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 1001 as End Value
	DebugLog "Slider scrParticleColourOffset changed to " + Number
	
End Function

Function scrRedOscSpeed_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrRedOscSpeed changed to " + Number
	
End Function

Function scrGreenOscSpeed_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrGreenOscSpeed changed to " + Number
	
End Function

Function scrBlueOscSpeed_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrBlueOscSpeed changed to " + Number
	
End Function

Function scrAlphaOscSpeed_GA( Slider:TGadget , Number:Int , GadgetList:TList=Null )
'Slider Range was initially set to: 0 as Start and: 2001 as End Value
	DebugLog "Slider scrAlphaOscSpeed changed to " + Number
	
End Function

Function lstEmitters_GS( ListBox:TGadget , Number:Int , Extra:Object , GadgetList:TList=Null )
	DebugLog "ListBox lstEmitters single clicked an Item"
	
End Function

Function lstEmitters_GM( ListBox:TGadget , Number:Int , Extra:Object , Window:TGadget=Null , GadgetList:TList=Null )
	DebugLog "ListBox lstEmitters right clicked an Item"
	
End Function

Function txtEmitterX_GM( TextArea:TGadget , Window:TGadget=Null , GadgetList:TList=Null )
	DebugLog "TextArea txtEmitterX was right clicked"
	
End Function

Function grpEmitters_MD( Panel:TGadget , MouseButton:Int , Window:TGadget=Null , GadgetList:TList=Null )
	DebugLog "Panel grpEmitters detected Mouse Button "+ MouseButton +" pressed down"
	
End Function

Function cvsEffectPreview_MD( Canvas:TGadget , MouseButton:Int , Window:TGadget=Null , PopUpMenu:TGadget=Null , GadgetList:TList=Null )
	DebugLog "Canvas cvsEffectPreview detected Mouse Button "+ MouseButton +" pressed down"
    If MouseButton = MOUSE_RIGHT Then PopupWindowMenu( Window:TGadget , PopUpMenu:TGadget )
	
End Function

Function cvsColourPanel_MD( Canvas:TGadget , MouseButton:Int , Window:TGadget=Null , GadgetList:TList=Null )
	DebugLog "Canvas cvsColourPanel detected Mouse Button "+ MouseButton +" pressed down"
	
End Function

Function cvsEffectPreview_GP( Canvas:TGadget , GadgetList:TList=Null )
	DebugLog "Canvas cvsEffectPreview needs to be redrawn"
	SetGraphics CanvasGraphics ( Canvas )
	SetViewport 0,0,GadgetWidth( Canvas ),GadgetHeight( Canvas )
	SetClsColor( 0,0,0 )
	Cls
	SetColor( 255,255,255 )
	
	'This temporary code will diasappear when you enter your own!
	DrawText( "LogicZone" ,1,1 )
	Flip
	'End of temporary code!

End Function

Function Editor_New_MA( Window:TGadget , Parent:TGadget , Menu:TGadget , GadgetList:TList=Null )
	DebugLog "Menu New was selected from Window Editor"
	
End Function

Function Editor_Open_MA( Window:TGadget , Parent:TGadget , Menu:TGadget , GadgetList:TList=Null )
	DebugLog "Menu Open... was selected from Window Editor"
	
End Function

Function Editor_Close_MA( Window:TGadget , Parent:TGadget , Menu:TGadget , GadgetList:TList=Null )
	DebugLog "Menu Close was selected from Window Editor"
	
End Function

Function Editor_Save_MA( Window:TGadget , Parent:TGadget , Menu:TGadget , GadgetList:TList=Null )
	DebugLog "Menu Save was selected from Window Editor"
	
End Function

Function Editor_SaveAs_MA( Window:TGadget , Parent:TGadget , Menu:TGadget , GadgetList:TList=Null )
	DebugLog "Menu Save As... was selected from Window Editor"
	
End Function

Function Editor_Exit_MA( Window:TGadget , Parent:TGadget , Menu:TGadget , GadgetList:TList=Null )
	DebugLog "Menu Exit was selected from Window Editor"
	
End Function

Function Editor_LoopEffect_MA( Window:TGadget , Parent:TGadget , Menu:TGadget , GadgetList:TList=Null )
	DebugLog "Menu Loop Effect was selected from Window Editor"
	
End Function

Function Editor_FollowMouse_MA( Window:TGadget , Parent:TGadget , Menu:TGadget , GadgetList:TList=Null )
	DebugLog "Menu Follow Mouse was selected from Window Editor"
	
End Function

Function Editor_About_MA( Window:TGadget , Parent:TGadget , Menu:TGadget , GadgetList:TList=Null )
	DebugLog "Menu About was selected from Window Editor"
	
End Function

Function Timer3_Timer( Timer:TTimer , GadgetList:TList=Null )
	DebugLog "Timer Timer3 ticked"
	
End Function

Function GadgetCommander:TGadget( Action:Int , GadgetArray$[] , GadgetList:TList Var, Params:String=Null )
	For Local i$ = EachIn GadgetArray
		For Local ii:TGadget = EachIn GadgetList
			If String(ii.Context) = i$
				Select Action
					Case Disable			DisableGadget( ii:TGadget )
					Case Enable				EnableGadget( ii:TGadget )
					Case Hide				HideGadget( ii:TGadget )
					Case Show				ShowGadget( ii:TGadget )
					Case Check				SetButtonState( ii:TGadget , True )
					Case Uncheck			SetButtonState( ii:TGadget , False )
					Case Free				FreeGadget( ii:TGadget )
					Case SetText			SetGadgetText( ii:TGadget,Params$ )
					Case Activate			ActivateGadget( ii:TGadget )
					Case Redraw				RedrawGadget( ii:TGadget )
					Case RemoveFromList		GadgetList.Remove( ii:TGadget )
					Case GetGadgetHandle	Return ( ii:TGadget )
				End Select
				Exit
			End If
		Next
	Next
	Return Null
End Function

