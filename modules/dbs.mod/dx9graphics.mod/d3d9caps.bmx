SuperStrict
Rem
/*==========================================================================;
 *
 *  Copyright (C) Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       d3d9caps.h
 *  Content:    Direct3D capabilities Include file
 *
 ***************************************************************************/
End Rem
Rem
typedef struct _D3DVSHADERCAPS2_0
{
        DWORD Caps;
        Int DynamicFlowControlDepth;
        Int NumTemps;
        Int StaticFlowControlDepth;
} D3DVSHADERCAPS2_0;
End Rem


Const D3DVS20CAPS_PREDICATION            	: Int = 1 '  (1<<0)

Const D3DVS20_MAX_DYNAMICFLOWCONTROLDEPTH	: Int = 24
Const D3DVS20_MIN_DYNAMICFLOWCONTROLDEPTH	: Int =  0
Const D3DVS20_MAX_NUMTEMPS    				: Int = 32
Const D3DVS20_MIN_NUMTEMPS    				: Int = 12
Const D3DVS20_MAX_STATICFLOWCONTROLDEPTH	: Int =  4
Const D3DVS20_MIN_STATICFLOWCONTROLDEPTH	: Int =  1

Rem
typedef struct _D3DPSHADERCAPS2_0
{
    DWORD Caps;
    Int DynamicFlowControlDepth;
    Int NumTemps;
    Int StaticFlowControlDepth;
    Int NumInstructionSlots;
} D3DPSHADERCAPS2_0;
End Rem

Const D3DPS20CAPS_ARBITRARYSWIZZLE        	: Int = 1 '(1<<0)
Const D3DPS20CAPS_GRADIENTINSTRUCTIONS    	: Int = 2 '(1<<1)
Const D3DPS20CAPS_PREDICATION             	: Int = 4 '(1<<2)
Const D3DPS20CAPS_NODEPENDENTREADLIMIT    	: Int = 8 '(1<<3)
Const D3DPS20CAPS_NOTEXINSTRUCTIONLIMIT   	: Int = 16 '(1<<4)

Const D3DPS20_MAX_DYNAMICFLOWCONTROLDEPTH	: Int = 24
Const D3DPS20_MIN_DYNAMICFLOWCONTROLDEPTH   : Int = 0
Const D3DPS20_MAX_NUMTEMPS    				: Int =32
Const D3DPS20_MIN_NUMTEMPS    				: Int =12
Const D3DPS20_MAX_STATICFLOWCONTROLDEPTH    : Int =	4
Const D3DPS20_MIN_STATICFLOWCONTROLDEPTH    : Int = 0
Const D3DPS20_MAX_NUMINSTRUCTIONSLOTS    	: Int =512
Const D3DPS20_MIN_NUMINSTRUCTIONSLOTS    	: Int =96

Const D3DMIN30SHADERINSTRUCTIONS 			: Int =512
Const D3DMAX30SHADERINSTRUCTIONS 			: Int =32768


Type  D3DCAPS9
	Field DeviceType :Int ' D3DDEVTYPE  
    Field AdapterOrdinal : Int

'    '/* Caps from DX7 Draw */
    Field Caps : Int
    Field Caps2 : Int
    Field Caps3 : Int
    Field PresentationIntervals: Int

    '/* Cursor Caps */
    Field CursorCaps: Int

    '/* 3D Device Caps */
    Field  DevCaps: Int

    Field PrimitiveMiscCaps: Int
    Field RasterCaps: Int
    Field ZCmpCaps: Int
    Field SrcBlendCaps: Int
    Field DestBlendCaps: Int
    Field AlphaCmpCaps: Int
    Field ShadeCaps: Int
    Field TextureCaps: Int
    Field TextureFilterCaps: Int'          // D3DPTFILTERCAPS For IDirect3DTexture9's
    Field CubeTextureFilterCaps: Int'      // D3DPTFILTERCAPS For IDirect3DCubeTexture9's
    Field VolumeTextureFilterCaps: Int'    // D3DPTFILTERCAPS For IDirect3DVolumeTexture9's
    Field TextureAddressCaps: Int'         // D3DPTADDRESSCAPS For IDirect3DTexture9's
    Field VolumeTextureAddressCaps: Int   '// D3DPTADDRESSCAPS For IDirect3DVolumeTexture9's

    Field LineCaps: Int                   '// D3DLINECAPS

    Field MaxTextureWidth: Int
	Field MaxTextureHeight: Int
    Field MaxVolumeExtent: Int

    Field MaxTextureRepeat: Int
    Field MaxTextureAspectRatio: Int
    Field MaxAnisotropy: Int
    Field MaxVertexW : Float

    Field GuardBandLeft:Float
    Field GuardBandTop: Float
    Field GuardBandRight:Float
    Field GuardBandBottom:Float

    Field ExtentsAdjust:Float
    Field StencilCaps: Int

    Field FVFCaps: Int
    Field TextureOpCaps: Int
    Field MaxTextureBlendStages: Int
    Field MaxSimultaneousTextures: Int

    Field VertexProcessingCaps: Int
    Field MaxActiveLights: Int
    Field MaxUserClipPlanes: Int
    Field MaxVertexBlendMatrices: Int
    Field MaxVertexBlendMatrixIndex: Int

    Field MaxPointSize:Float

    Field MaxPrimitiveCount: Int'          // Max number of primitives per DrawPrimitive call
    Field MaxVertexIndex: Int
    Field MaxStreams: Int
    Field MaxStreamStride: Int       '     // Max stride For SetStreamSource

    Field VertexShaderVersion: Int
    Field MaxVertexShaderConst: Int   '    // number of vertex shader constant registers

    Field PixelShaderVersion: Int
    Field PixelShader1xMaxValue:Float  '    // Max value storable in registers of ps.1.x shaders

    '// Here are the DX9 specific ones
    Field DevCaps2: Int

    Field MaxNpatchTessellationLevel:Float
    Field Reserved5: Int

    Field MasterAdapterOrdinal: Int  '     // ordinal of master adaptor For adapter group
    Field AdapterOrdinalInGroup: Int  '    // ordinal inside the adapter group
    Field NumberOfAdaptersInGroup: Int '   // number of adapters in this adapter group (only If master)
    Field DeclTypes: Int                '  // Data types, supported in vertex declarations
    Field NumSimultaneousRTs: Int'         // Will be at least 1
    Field StretchRectFilterCaps: Int'      // Filter caps supported by StretchRect

'   D3DVSHADERCAPS2_0 VS20Caps;
    Field VS20Caps_Caps :Int
    Field VS20Caps_DynamicFlowControlDepth :Int
    Field VS20Caps_NumTemps :Int
    Field VS20Caps_StaticFlowControlDepth : Int
'   D3DPSHADERCAPS2_0 PS20Caps;
    Field PS20Caps_Caps :Int
    Field PS20Caps_DynamicFlowControlDepth :Int
    Field PS20Caps_NumTemps :Int
    Field PS20Caps_StaticFlowControlDepth : Int
    Field PS20Caps_NumInstructionSlots : Int

    Field VertexTextureFilterCaps: Int'    // D3DPTFILTERCAPS For IDirect3DTexture9's for texture, used in vertex shaders
    Field MaxVShaderInstructionsExecuted: Int '// maximum number of vertex shader instructions that can be executed
    Field MaxPShaderInstructionsExecuted: Int '// maximum number of pixel shader instructions that can be executed
    Field MaxVertexShader30InstructionSlots: Int 
    Field MaxPixelShader30InstructionSlots: Int
End Type

Rem
//
// BIT DEFINES For D3DCAPS9 DWORD MEMBERS
//

//
// Caps
//
End Rem
Const D3DCAPS_READ_SCANLINE  			: Int = $00020000

Rem
//
// Caps2
//
End Rem
Const D3DCAPS2_FULLSCREENGAMMA        : Int =$00020000
Const D3DCAPS2_CANCALIBRATEGAMMA      : Int =$00100000
Const D3DCAPS2_RESERVED               : Int =$02000000
Const D3DCAPS2_CANMANAGERESOURCE      : Int =$10000000
Const D3DCAPS2_DYNAMICTEXTURES        : Int =$20000000
Const D3DCAPS2_CANAUTOGENMIPMAP       : Int =$40000000

Rem
//
// Caps3
//
End Rem
Const D3DCAPS3_RESERVED               : Int =$8000001f

Rem
// Indicates that the device can respect the ALPHABLENDENABLE render state
// when fullscreen While using the Flip Or DISCARD swap effect.
// COPY And COPYVSYNC swap effects work whether Or Not this flag is set.
End Rem

Const D3DCAPS3_ALPHA_FULLSCREEN_FLIP_OR_DISCARD   : Int =$00000020

Rem
// Indicates that the device can perform a gamma correction from 
// a windowed back buffer containing linear content To the sRGB desktop.
End Rem

Const D3DCAPS3_LINEAR_TO_SRGB_PRESENTATION : Int =$00000080

Const D3DCAPS3_COPY_TO_VIDMEM         : Int =$00000100' /* Device can acclerate copies from sysmem To Local vidmem */
Const D3DCAPS3_COPY_TO_SYSTEMMEM      : Int =$00000200' /* Device can acclerate copies from Local vidmem To sysmem */

Rem
//
// PresentationIntervals
//
End Rem
Const D3DPRESENT_INTERVAL_DEFAULT     : Int =$00000000
Const D3DPRESENT_INTERVAL_ONE         : Int =$00000001
Const D3DPRESENT_INTERVAL_TWO         : Int =$00000002
Const D3DPRESENT_INTERVAL_THREE       : Int =$00000004
Const D3DPRESENT_INTERVAL_FOUR        : Int =$00000008
Const D3DPRESENT_INTERVAL_IMMEDIATE   : Int =$80000000

Rem
//
// CursorCaps
//
// Driver supports HW color cursor in at least hi-res modes(height >=400)
End Rem

Const D3DCURSORCAPS_COLOR             : Int =$00000001
'// Driver supports HW cursor also in low-res modes(height < 400)
Const D3DCURSORCAPS_LOWRES            : Int =$00000002
Rem
//
// DevCaps
//
End Rem

Const D3DDEVCAPS_EXECUTESYSTEMMEMORY  : Int =$00000010 '/* Device can use execute buffers from system memory */
Const D3DDEVCAPS_EXECUTEVIDEOMEMORY   : Int =$00000020 ' /* Device can use execute buffers from video memory */
Const D3DDEVCAPS_TLVERTEXSYSTEMMEMORY : Int =$00000040 ' /* Device can use TL buffers from system memory */
Const D3DDEVCAPS_TLVERTEXVIDEOMEMORY  : Int =$00000080 ' /* Device can use TL buffers from video memory */
Const D3DDEVCAPS_TEXTURESYSTEMMEMORY  : Int =$00000100 ' /* Device can texture from system memory */
Const D3DDEVCAPS_TEXTUREVIDEOMEMORY   : Int =$00000200 ' /* Device can texture from device memory */
Const D3DDEVCAPS_DRAWPRIMTLVERTEX     : Int =$00000400 ' /* Device can draw TLVERTEX primitives */
Const D3DDEVCAPS_CANRENDERAFTERFLIP   : Int =$00000800 ' /* Device can render without waiting For Flip To complete */
Const D3DDEVCAPS_TEXTURENONLOCALVIDMEM: Int =$00001000 ' /* Device can texture from nonlocal video memory */
Const D3DDEVCAPS_DRAWPRIMITIVES2      : Int =$00002000 ' /* Device can support DrawPrimitives2 */
Const D3DDEVCAPS_SEPARATETEXTUREMEMORIES : Int =$00004000' /* Device is texturing from separate memory pools */
Const D3DDEVCAPS_DRAWPRIMITIVES2EX    : Int =$00008000 ' /* Device can support Extended DrawPrimitives2 i.e. DX7 compliant driver*/
Const D3DDEVCAPS_HWTRANSFORMANDLIGHT  : Int =$00010000 ' /* Device can support transformation And lighting in hardware And DRAWPRIMITIVES2EX must be also */
Const D3DDEVCAPS_CANBLTSYSTONONLOCAL  : Int =$00020000 ' /* Device supports a Tex Blt from system memory To non-Local vidmem */
'Const D3DDEVCAPS_HWRASTERIZATION      : Int =$00080000 ' /* Device has HW acceleration For rasterization */
Const D3DDEVCAPS_PUREDEVICE           : Int =$00100000 ' /* Device supports D3DCREATE_PUREDEVICE */
Const D3DDEVCAPS_QUINTICRTPATCHES     : Int =$00200000 ' /* Device supports quintic Beziers And BSplines */
Const D3DDEVCAPS_RTPATCHES            : Int =$00400000 ' /* Device supports Rect And Tri patches */
Const D3DDEVCAPS_RTPATCHHANDLEZERO    : Int =$00800000 ' /* Indicates that RT Patches may be drawn efficiently using handle 0 */
Const D3DDEVCAPS_NPATCHES             : Int =$01000000 ' /* Device supports N-Patches */

Rem
//
// PrimitiveMiscCaps
//
End Rem

Const D3DPMISCCAPS_MASKZ              : Int =$00000002
Const D3DPMISCCAPS_CULLNONE           : Int =$00000010
Const D3DPMISCCAPS_CULLCW             : Int =$00000020
Const D3DPMISCCAPS_CULLCCW            : Int =$00000040
Const D3DPMISCCAPS_COLORWRITEENABLE   : Int =$00000080
Const D3DPMISCCAPS_CLIPPLANESCALEDPOINTS : Int =$00000100' /* Device correctly clips scaled points To clip planes */
Const D3DPMISCCAPS_CLIPTLVERTS        : Int =$00000200' /* device will clip post-transformed vertex primitives */
Const D3DPMISCCAPS_TSSARGTEMP         : Int =$00000400' /* device supports D3DTA_TEMP For temporary register */
Const D3DPMISCCAPS_BLENDOP            : Int =$00000800' /* device supports D3DRS_BLENDOP */
Const D3DPMISCCAPS_NULLREFERENCE      : Int =$00001000' /* Reference Device that doesnt render */
Const D3DPMISCCAPS_INDEPENDENTWRITEMASKS    : Int =$00004000' /* Device supports independent write masks For MET Or MRT */
Const D3DPMISCCAPS_PERSTAGECONSTANT   : Int =$00008000' /* Device supports per-stage constants */
Const D3DPMISCCAPS_FOGANDSPECULARALPHA : Int =$00010000' /* Device supports separate fog And specular alpha (many devices
                                                        '  use the specular alpha channel To store fog factor) */
Const D3DPMISCCAPS_SEPARATEALPHABLEND         : Int =$00020000 ' /* Device supports separate blend settings For the alpha channel */
Const D3DPMISCCAPS_MRTINDEPENDENTBITDEPTHS    : Int =$00040000 ' /* Device supports different bit depths For MRT */
Const D3DPMISCCAPS_MRTPOSTPIXELSHADERBLENDING : Int =$00080000 ' /* Device supports post-pixel shader operations For MRT */
Const D3DPMISCCAPS_FOGVERTEXCLAMPED           : Int =$00100000 ' /* Device clamps fog blend factor per vertex */

Rem
//
// LineCaps
//
End Rem
Const D3DLINECAPS_TEXTURE             : Int =$00000001
Const D3DLINECAPS_ZTEST               : Int =$00000002
Const D3DLINECAPS_BLEND               : Int =$00000004
Const D3DLINECAPS_ALPHACMP            : Int =$00000008
Const D3DLINECAPS_FOG                 : Int =$00000010
Const D3DLINECAPS_ANTIALIAS           : Int =$00000020

Rem
//
// RasterCaps
//
End Rem

Const D3DPRASTERCAPS_DITHER                 : Int =$00000001
Const D3DPRASTERCAPS_ZTEST                  : Int =$00000010
Const D3DPRASTERCAPS_FOGVERTEX              : Int =$00000080
Const D3DPRASTERCAPS_FOGTABLE               : Int =$00000100
Const D3DPRASTERCAPS_MIPMAPLODBIAS          : Int =$00002000
Const D3DPRASTERCAPS_ZBUFFERLESSHSR         : Int =$00008000
Const D3DPRASTERCAPS_FOGRANGE               : Int =$00010000
Const D3DPRASTERCAPS_ANISOTROPY             : Int =$00020000
Const D3DPRASTERCAPS_WBUFFER                : Int =$00040000
Const D3DPRASTERCAPS_WFOG                   : Int =$00100000
Const D3DPRASTERCAPS_ZFOG                   : Int =$00200000
Const D3DPRASTERCAPS_COLORPERSPECTIVE       : Int =$00400000' /* Device iterates colors perspective correct */
Const D3DPRASTERCAPS_SCISSORTEST            : Int =$01000000
Const D3DPRASTERCAPS_SLOPESCALEDEPTHBIAS    : Int =$02000000
Const D3DPRASTERCAPS_DEPTHBIAS              : Int =$04000000
Const D3DPRASTERCAPS_MULTISAMPLE_TOGGLE     : Int =$08000000
Rem
//
// ZCmpCaps, AlphaCmpCaps
//
End Rem
Const D3DPCMPCAPS_NEVER               : Int =$00000001
Const D3DPCMPCAPS_LESS                : Int =$00000002
Const D3DPCMPCAPS_EQUAL               : Int =$00000004
Const D3DPCMPCAPS_LESSEQUAL           : Int =$00000008
Const D3DPCMPCAPS_GREATER             : Int =$00000010
Const D3DPCMPCAPS_NOTEQUAL            : Int =$00000020
Const D3DPCMPCAPS_GREATEREQUAL        : Int =$00000040
Const D3DPCMPCAPS_ALWAYS              : Int =$00000080

Rem
//
// SourceBlendCaps, DestBlendCaps
//
End Rem


Const D3DPBLENDCAPS_ZERO              : Int =$00000001
Const D3DPBLENDCAPS_ONE               : Int =$00000002
Const D3DPBLENDCAPS_SRCCOLOR          : Int =$00000004
Const D3DPBLENDCAPS_INVSRCCOLOR       : Int =$00000008
Const D3DPBLENDCAPS_SRCALPHA          : Int =$00000010
Const D3DPBLENDCAPS_INVSRCALPHA       : Int =$00000020
Const D3DPBLENDCAPS_DESTALPHA         : Int =$00000040
Const D3DPBLENDCAPS_INVDESTALPHA      : Int =$00000080
Const D3DPBLENDCAPS_DESTCOLOR         : Int =$00000100
Const D3DPBLENDCAPS_INVDESTCOLOR      : Int =$00000200
Const D3DPBLENDCAPS_SRCALPHASAT       : Int =$00000400
Const D3DPBLENDCAPS_BOTHSRCALPHA      : Int =$00000800
Const D3DPBLENDCAPS_BOTHINVSRCALPHA   : Int =$00001000
Const D3DPBLENDCAPS_BLENDFACTOR       : Int =$00002000' /* Supports both D3DBLEND_BLENDFACTOR And D3DBLEND_INVBLENDFACTOR */

Rem
//
// ShadeCaps
//
End Rem

Const D3DPSHADECAPS_COLORGOURAUDRGB       : Int =$00000008
Const D3DPSHADECAPS_SPECULARGOURAUDRGB    : Int =$00000200
Const D3DPSHADECAPS_ALPHAGOURAUDBLEND     : Int =$00004000
Const D3DPSHADECAPS_FOGGOURAUD            : Int =$00080000

Rem
//
// TextureCaps
//
End Rem

Const D3DPTEXTURECAPS_PERSPECTIVE         : Int =$00000001' /* Perspective-correct texturing is supported */
Const D3DPTEXTURECAPS_POW2                : Int =$00000002' /* Power-of-2 texture dimensions are required - applies To non-Cube/Volume textures only. */
Const D3DPTEXTURECAPS_ALPHA               : Int =$00000004' /* Alpha in texture pixels is supported */
Const D3DPTEXTURECAPS_SQUAREONLY          : Int =$00000020' /* Only square textures are supported */
Const D3DPTEXTURECAPS_TEXREPEATNOTSCALEDBYSIZE : Int =$00000040' /* Texture indices are Not scaled by the texture size prior To interpolation */
Const D3DPTEXTURECAPS_ALPHAPALETTE        : Int =$00000080' /* Device can draw alpha from texture palettes */
Rem
// Device can use non-POW2 textures If:
//  1) D3DTEXTURE_ADDRESS is set To CLAMP For this texture's stage
//  2) D3DRS_WRAP(N) is zero For this texture's coordinates
//  3) mip mapping is Not enabled (use magnification filter only)
End Rem

Const D3DPTEXTURECAPS_NONPOW2CONDITIONAL  : Int =$00000100
Const D3DPTEXTURECAPS_PROJECTED           : Int =$00000400' /* Device can do D3DTTFF_PROJECTED */
Const D3DPTEXTURECAPS_CUBEMAP             : Int =$00000800' /* Device can do cubemap textures */
Const D3DPTEXTURECAPS_VOLUMEMAP           : Int =$00002000' /* Device can do volume textures */
Const D3DPTEXTURECAPS_MIPMAP              : Int =$00004000' /* Device can do mipmapped textures */
Const D3DPTEXTURECAPS_MIPVOLUMEMAP        : Int =$00008000' /* Device can do mipmapped volume textures */
Const D3DPTEXTURECAPS_MIPCUBEMAP          : Int =$00010000' /* Device can do mipmapped cube maps */
Const D3DPTEXTURECAPS_CUBEMAP_POW2        : Int =$00020000' /* Device requires that cubemaps be power-of-2 dimension */
Const D3DPTEXTURECAPS_VOLUMEMAP_POW2      : Int =$00040000' /* Device requires that volume maps be power-of-2 dimension */
Const D3DPTEXTURECAPS_NOPROJECTEDBUMPENV  : Int =$00200000' /* Device does Not support projected bump env lookup operation 
                                                          ' in programmable And fixed Function pixel shaders */
Rem
//
// TextureFilterCaps, StretchRectFilterCaps
//
End Rem

Const D3DPTFILTERCAPS_MINFPOINT           : Int =$00000100' /* Min Filter */
Const D3DPTFILTERCAPS_MINFLINEAR          : Int =$00000200
Const D3DPTFILTERCAPS_MINFANISOTROPIC     : Int =$00000400
Const D3DPTFILTERCAPS_MINFPYRAMIDALQUAD   : Int =$00000800
Const D3DPTFILTERCAPS_MINFGAUSSIANQUAD    : Int =$00001000
Const D3DPTFILTERCAPS_MIPFPOINT           : Int =$00010000' /* Mip Filter */
Const D3DPTFILTERCAPS_MIPFLINEAR          : Int =$00020000
Const D3DPTFILTERCAPS_MAGFPOINT           : Int =$01000000' /* Mag Filter */
Const D3DPTFILTERCAPS_MAGFLINEAR          : Int =$02000000
Const D3DPTFILTERCAPS_MAGFANISOTROPIC     : Int =$04000000
Const D3DPTFILTERCAPS_MAGFPYRAMIDALQUAD   : Int =$08000000
Const D3DPTFILTERCAPS_MAGFGAUSSIANQUAD    : Int =$10000000

Rem
//
// TextureAddressCaps
//
End Rem

Const D3DPTADDRESSCAPS_WRAP           : Int =$00000001
Const D3DPTADDRESSCAPS_MIRROR         : Int =$00000002
Const D3DPTADDRESSCAPS_CLAMP          : Int =$00000004
Const D3DPTADDRESSCAPS_BORDER         : Int =$00000008
Const D3DPTADDRESSCAPS_INDEPENDENTUV  : Int =$00000010
Const D3DPTADDRESSCAPS_MIRRORONCE     : Int =$00000020
Rem
//
// StencilCaps
//
End Rem
Const D3DSTENCILCAPS_KEEP             : Int =$00000001
Const D3DSTENCILCAPS_ZERO             : Int =$00000002
Const D3DSTENCILCAPS_REPLACE          : Int =$00000004
Const D3DSTENCILCAPS_INCRSAT          : Int =$00000008
Const D3DSTENCILCAPS_DECRSAT          : Int =$00000010
Const D3DSTENCILCAPS_INVERT           : Int =$00000020
Const D3DSTENCILCAPS_INCR             : Int =$00000040
Const D3DSTENCILCAPS_DECR             : Int =$00000080
Const D3DSTENCILCAPS_TWOSIDED         : Int =$00000100
Rem
//
// TextureOpCaps
//
End Rem

Const D3DTEXOPCAPS_DISABLE                    : Int =$00000001
Const D3DTEXOPCAPS_SELECTARG1                 : Int =$00000002
Const D3DTEXOPCAPS_SELECTARG2                 : Int =$00000004
Const D3DTEXOPCAPS_MODULATE                   : Int =$00000008
Const D3DTEXOPCAPS_MODULATE2X                 : Int =$00000010
Const D3DTEXOPCAPS_MODULATE4X                 : Int =$00000020
Const D3DTEXOPCAPS_ADD                        : Int =$00000040
Const D3DTEXOPCAPS_ADDSIGNED                  : Int =$00000080
Const D3DTEXOPCAPS_ADDSIGNED2X                : Int =$00000100
Const D3DTEXOPCAPS_SUBTRACT                   : Int =$00000200
Const D3DTEXOPCAPS_ADDSMOOTH                  : Int =$00000400
Const D3DTEXOPCAPS_BLENDDIFFUSEALPHA          : Int =$00000800
Const D3DTEXOPCAPS_BLENDTEXTUREALPHA          : Int =$00001000
Const D3DTEXOPCAPS_BLENDFACTORALPHA           : Int =$00002000
Const D3DTEXOPCAPS_BLENDTEXTUREALPHAPM        : Int =$00004000
Const D3DTEXOPCAPS_BLENDCURRENTALPHA          : Int =$00008000
Const D3DTEXOPCAPS_PREMODULATE                : Int =$00010000
Const D3DTEXOPCAPS_MODULATEALPHA_ADDCOLOR     : Int =$00020000
Const D3DTEXOPCAPS_MODULATECOLOR_ADDALPHA     : Int =$00040000
Const D3DTEXOPCAPS_MODULATEINVALPHA_ADDCOLOR  : Int =$00080000
Const D3DTEXOPCAPS_MODULATEINVCOLOR_ADDALPHA  : Int =$00100000
Const D3DTEXOPCAPS_BUMPENVMAP                 : Int =$00200000
Const D3DTEXOPCAPS_BUMPENVMAPLUMINANCE        : Int =$00400000
Const D3DTEXOPCAPS_DOTPRODUCT3                : Int =$00800000
Const D3DTEXOPCAPS_MULTIPLYADD                : Int =$01000000
Const D3DTEXOPCAPS_LERP                       : Int =$02000000
Rem
//
// FVFCaps
//
End Rem

Const D3DFVFCAPS_TEXCOORDCOUNTMASK    : Int =$0000ffff' /* mask For texture coordinate count Field */
Const D3DFVFCAPS_DONOTSTRIPELEMENTS   : Int =$00080000' /* Device prefers that vertex elements Not be stripped */
Const D3DFVFCAPS_PSIZE                : Int =$00100000' /* Device can receive point size */
Rem
//
// VertexProcessingCaps
//
End Rem
Const D3DVTXPCAPS_TEXGEN              : Int =$00000001' /* device can do texgen */
Const D3DVTXPCAPS_MATERIALSOURCE7     : Int =$00000002' /* device can do DX7-level colormaterialsource ops */
Const D3DVTXPCAPS_DIRECTIONALLIGHTS   : Int =$00000008' /* device can do directional lights */
Const D3DVTXPCAPS_POSITIONALLIGHTS    : Int =$00000010' /* device can do positional lights (includes point And spot) */
Const D3DVTXPCAPS_LOCALVIEWER         : Int =$00000020' /* device can do Local viewer */
Const D3DVTXPCAPS_TWEENING            : Int =$00000040' /* device can do vertex tweening */
Const D3DVTXPCAPS_TEXGEN_SPHEREMAP    : Int =$00000100' /* device supports D3DTSS_TCI_SPHEREMAP */
Const D3DVTXPCAPS_NO_TEXGEN_NONLOCALVIEWER   : Int =$00000200' /* device does Not support TexGen in non-Local
                                                             ' viewer mode */
Rem
//
// DevCaps2
//
End Rem

Const D3DDEVCAPS2_STREAMOFFSET                        : Int =$00000001' /* Device supports offsets in streams. Must be set by DX9 drivers */
Const D3DDEVCAPS2_DMAPNPATCH                          : Int =$00000002' /* Device supports displacement maps For N-Patches*/
Const D3DDEVCAPS2_ADAPTIVETESSRTPATCH                 : Int =$00000004' /* Device supports adaptive tesselation of RT-patches*/
Const D3DDEVCAPS2_ADAPTIVETESSNPATCH                  : Int =$00000008' /* Device supports adaptive tesselation of N-patches*/
Const D3DDEVCAPS2_CAN_STRETCHRECT_FROM_TEXTURES       : Int =$00000010' /* Device supports StretchRect calls with a texture as the source*/
Const D3DDEVCAPS2_PRESAMPLEDDMAPNPATCH                : Int =$00000020' /* Device supports presampled displacement maps For N-Patches */
Const D3DDEVCAPS2_VERTEXELEMENTSCANSHARESTREAMOFFSET  : Int =$00000040' /* Vertex elements in a vertex declaration can share the same stream offset */

Rem
//
// DeclTypes
//
End Rem
Const D3DDTCAPS_UBYTE4     : Int =$00000001
Const D3DDTCAPS_UBYTE4N    : Int =$00000002
Const D3DDTCAPS_SHORT2N    : Int =$00000004
Const D3DDTCAPS_SHORT4N    : Int =$00000008
Const D3DDTCAPS_USHORT2N   : Int =$00000010
Const D3DDTCAPS_USHORT4N   : Int =$00000020
Const D3DDTCAPS_UDEC3      : Int =$00000040
Const D3DDTCAPS_DEC3N      : Int =$00000080
Const D3DDTCAPS_FLOAT16_2  : Int =$00000100
Const D3DDTCAPS_FLOAT16_4  : Int =$00000200

Function D3DSHADER_VERSION_MAJOR:Int(Version:Int)
	Return  (((Version)Shr 8)&$FF)
End Function

Function D3DSHADER_VERSION_MINOR:Int(Version:Int)
	Return (((Version)Shr 0)&$FF)
End Function



