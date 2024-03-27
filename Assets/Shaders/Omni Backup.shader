// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Amplify Streams 2/Omni"
{
	Properties
	{
		_AutumnLeaf28_2K_back_BaseColor("AutumnLeaf28_2K_back_BaseColor", 2D) = "white" {}
		[Toggle(_FADE_FROM_CENTER_ON)] _Fade_From_Center("Fade_From_Center", Float) = 0
		_Fade_From_Center_Value("Fade_From_Center_Value", Range( 0 , 1)) = 1
		[HDR]_Color("Color", Color) = (0,0,0,0)
		_Fade("Fade", Range( 0 , 1)) = 1
		_Level_Black("Level_Black", Float) = 0
		_Level_White("Level_White", Float) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One OneMinusSrcAlpha
		AlphaToMask Off
		Cull Front
		ColorMask RGBA
		ZWrite Off
		ZTest Always
		
		
		
		Pass
		{
			Name "Unlit"

			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#pragma shader_feature_local _FADE_FROM_CENTER_ON


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _Level_Black;
			uniform float _Level_White;
			uniform sampler2D _AutumnLeaf28_2K_back_BaseColor;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _Fade_From_Center_Value;
			uniform float4 _Color;
			uniform float _Fade;
			float2 UnStereo( float2 UV )
			{
				#if UNITY_SINGLE_PASS_STEREO
				float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
				UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
				#endif
				return UV;
			}
			
			float3 InvertDepthDir72_g11( float3 In )
			{
				float3 result = In;
				#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301
				result *= float3(1,1,-1);
				#endif
				return result;
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord1 = screenPos;
				
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float4 temp_cast_0 = (_Level_Black).xxxx;
				float4 temp_cast_1 = (_Level_White).xxxx;
				float4 screenPos = i.ase_texcoord1;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 UV22_g12 = ase_screenPosNorm.xy;
				float2 localUnStereo22_g12 = UnStereo( UV22_g12 );
				float2 break64_g11 = localUnStereo22_g12;
				float clampDepth69_g11 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy );
				#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g11 = ( 1.0 - clampDepth69_g11 );
				#else
				float staticSwitch38_g11 = clampDepth69_g11;
				#endif
				float3 appendResult39_g11 = (float3(break64_g11.x , break64_g11.y , staticSwitch38_g11));
				float4 appendResult42_g11 = (float4((appendResult39_g11*2.0 + -1.0) , 1.0));
				float4 temp_output_43_0_g11 = mul( unity_CameraInvProjection, appendResult42_g11 );
				float3 temp_output_46_0_g11 = ( (temp_output_43_0_g11).xyz / (temp_output_43_0_g11).w );
				float3 In72_g11 = temp_output_46_0_g11;
				float3 localInvertDepthDir72_g11 = InvertDepthDir72_g11( In72_g11 );
				float4 appendResult49_g11 = (float4(localInvertDepthDir72_g11 , 1.0));
				float3 worldToObj52 = mul( unity_WorldToObject, float4( mul( unity_CameraToWorld, appendResult49_g11 ).xyz, 1 ) ).xyz;
				float2 appendResult58 = (float2(worldToObj52.x , worldToObj52.z));
				float2 lerpResult76 = lerp( float2( 0,0 ) , ( appendResult58 + float2( 0.5,0.5 ) ) , step( worldToObj52.y , 0.0 ));
				float4 tex2DNode57 = tex2D( _AutumnLeaf28_2K_back_BaseColor, lerpResult76 );
				float4 smoothstepResult91 = smoothstep( temp_cast_0 , temp_cast_1 , tex2DNode57);
				float2 CenteredUV15_g1 = ( lerpResult76 - float2( 0.5,0.5 ) );
				float2 break17_g1 = CenteredUV15_g1;
				float2 appendResult23_g1 = (float2(( length( CenteredUV15_g1 ) * (20.0 + (_Fade_From_Center_Value - 0.0) * (0.0 - 20.0) / (1.0 - 0.0)) * 2.0 ) , ( atan2( break17_g1.x , break17_g1.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
				float clampResult85 = clamp( (0.0 + (( 1.0 - appendResult23_g1.x ) - 0.0) * (2.5 - 0.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
				#ifdef _FADE_FROM_CENTER_ON
				float staticSwitch77 = clampResult85;
				#else
				float staticSwitch77 = 1.0;
				#endif
				
				
				finalColor = ( smoothstepResult91 * pow( tex2DNode57.a , 10.0 ) * staticSwitch77 * _Color * (0.0 + (_Fade - 0.0) * (0.5 - 0.0) / (1.0 - 0.0)) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-522.1877,236.5092;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-166.3672,232.03;Float;False;True;-1;2;ASEMaterialInspector;100;5;Amplify Streams 2/Omni;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;3;1;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;1;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;2;False;;True;7;False;;True;False;0;False;;0;False;;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.TFHCRemapNode;82;-1328,528;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;81;-1504,528;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;80;-1616,528;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ClampOpNode;85;-1056,528;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-1056,432;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;77;-880,432;Inherit;False;Property;_Fade_From_Center;Fade_From_Center;1;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;61;-748.2943,336.478;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;76;-2192,272;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-2336,272;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;-2512,272;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;75;-2480,368;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;52;-2848,240;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;4;-3200,240;Inherit;False;Reconstruct World Position From Depth;-1;;11;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;86;-786.5348,38.11108;Inherit;False;Property;_Color;Color;3;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;5.992157,2.854902,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;84;-2384,576;Inherit;False;Property;_Fade_From_Center_Value;Fade_From_Center_Value;2;0;Create;True;0;0;0;False;0;False;1;0.945;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;83;-2096,576;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;20;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-880,560;Inherit;False;Property;_Fade;Fade;4;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;90;-543.3309,606.0991;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;57;-1408,240;Inherit;True;Property;_AutumnLeaf28_2K_back_BaseColor;AutumnLeaf28_2K_back_BaseColor;0;0;Create;True;0;0;0;False;0;False;-1;None;02d1602e04c26a646bdd82a9b1b7888b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;91;-992,240;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-1280,160;Inherit;False;Property;_Level_White;Level_White;6;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-1280,80;Inherit;False;Property;_Level_Black;Level_Black;5;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;94;-1888,528;Inherit;False;Polar Coordinates;-1;;1;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
WireConnection;59;0;91;0
WireConnection;59;1;61;0
WireConnection;59;2;77;0
WireConnection;59;3;86;0
WireConnection;59;4;90;0
WireConnection;0;0;59;0
WireConnection;82;0;81;0
WireConnection;81;0;80;0
WireConnection;80;0;94;0
WireConnection;85;0;82;0
WireConnection;77;1;78;0
WireConnection;77;0;85;0
WireConnection;61;0;57;4
WireConnection;76;1;60;0
WireConnection;76;2;75;0
WireConnection;60;0;58;0
WireConnection;58;0;52;1
WireConnection;58;1;52;3
WireConnection;75;0;52;2
WireConnection;52;0;4;0
WireConnection;83;0;84;0
WireConnection;90;0;89;0
WireConnection;57;1;76;0
WireConnection;91;0;57;0
WireConnection;91;1;92;0
WireConnection;91;2;93;0
WireConnection;94;1;76;0
WireConnection;94;3;83;0
ASEEND*/
//CHKSM=8769BB6AEA33CC3B689C8D0D4B3DCD8399708077