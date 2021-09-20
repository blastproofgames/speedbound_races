Shader "Custom/Projector/Shadow" 
	{
		Properties {
			[NoScaleOffset] _ShadowTex ("Cookie", 2D) = "gray" {}
			[NoScaleOffset] _FalloffTex ("FallOff", 2D) = "white" {}
			_Offset ("Offset", Range (-1, -10)) = -1.0
		}
		SubShader
		{
			Tags {"Queue"="Transparent-1"}
			Pass
			{
				ZWrite Off
				Fog { Color (1, 1, 1) }
				ColorMask RGB
				Blend DstColor Zero
				Offset -1, [_Offset]
	
				HLSLPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma shader_feature_local FSR_PROJECTOR_FOR_LWRP
				#pragma multi_compile_local _ FSR_RECEIVER
				#pragma multi_compile_fog
				#include "Assets/_Speedbound/Shaders/P4LWRP.cginc"
	
				P4LWRP_V2F_PROJECTOR vert(float4 vertex : POSITION)
				{
					P4LWRP_V2F_PROJECTOR o;
					fsrTransformVertex(vertex, o.pos, o.uvShadow);
					UNITY_TRANSFER_FOG(o, o.pos);
					return o;
				}

				fixed4 frag(P4LWRP_V2F_PROJECTOR i) : SV_Target
				{
					fixed4 col;
 					fixed falloff = tex2D(_FalloffTex, i.uvShadow.zz).a;
					col.rgb = tex2Dproj(_ShadowTex, UNITY_PROJ_COORD(i.uvShadow)).rgb;
					col.a = 1.0f;
					col.rgb = lerp(fixed3(1,1,1), col.rgb, falloff);
					UNITY_APPLY_FOG_COLOR(i.fogCoord, col, fixed4(1,1,1,1));
					return col;
				}
	
				ENDHLSL
			}
		} 
	}