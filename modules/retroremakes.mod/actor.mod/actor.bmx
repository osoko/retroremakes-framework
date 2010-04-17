rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

SuperStrict

Module retroremakes.actor

Import retroremakes.colour
Import retroremakes.colour_oscillator
Import retroremakes.maths
Import retroremakes.renderable
Import retroremakes.scale_oscillator

Include "Source/TActor.bmx"
Include "Source/TFontActor.bmx"
Include "Source/TImageActor.bmx"
Include "Source/TPolygonActor.bmx"

Include "Source/TAnimation.bmx"
Include "Source/TAnimationManager.bmx"

Include "Source/AnimationStyles/TAlphaFadeAnimation.bmx"
Include "Source/AnimationStyles/TBlinkAnimation.bmx"
Include "Source/AnimationStyles/TColourOscillatorAnimation.bmx"
Include "Source/AnimationStyles/TCompositeAnimation.bmx"
Include "Source/AnimationStyles/TDelayedAnimation.bmx"
Include "Source/AnimationStyles/TLoopedAnimation.bmx"
Include "Source/AnimationStyles/TLoopedFrameAnimation.bmx"
Include "Source/AnimationStyles/TMakeInvisibleAnimation.bmx"
Include "Source/AnimationStyles/TMakeVisibleAnimation.bmx"
Include "Source/AnimationStyles/TPointToPointPathAnimation.bmx"
Include "Source/AnimationStyles/TResetPositionAnimation.bmx"
Include "Source/AnimationStyles/TScaleOscillatorAnimation.bmx"
Include "Source/AnimationStyles/TSequentialAnimation.bmx"
Include "Source/AnimationStyles/TSetAlphaAnimation.bmx"
Include "Source/AnimationStyles/TSetColourAnimation.bmx"
Include "Source/AnimationStyles/TSetPositionAnimation.bmx"
Include "Source/AnimationStyles/TTimedAnimation.bmx"
