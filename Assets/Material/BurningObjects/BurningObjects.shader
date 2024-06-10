// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BurningObjects"
{
	Properties
	{
		_Dissolve("Dissolve", Range( 0 , 1)) = 1
		[HDR]_Color0("Color 0", Color) = (16,0,0,0)
		_Vector1("Vector 1", Vector) = (-2,3,0,0)
		_LDI_Tenture_Albedo("LDI_Tenture_Albedo", 2D) = "white" {}
		_LDI_Tenture_Normal("LDI_Tenture_Normal", 2D) = "bump" {}
		_LDI_Tenture_Metallic("LDI_Tenture_Metallic", 2D) = "white" {}
		_LDI_Tenture_AO("LDI_Tenture_AO", 2D) = "white" {}
		_OpacityMaskfromMeshProBuilderDefault("Opacity Mask from Mesh ProBuilderDefault", 2D) = "white" {}
		_Remap("Remap", Vector) = (5,-30,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _LDI_Tenture_Normal;
		uniform float4 _LDI_Tenture_Normal_ST;
		uniform sampler2D _LDI_Tenture_Albedo;
		uniform float4 _LDI_Tenture_Albedo_ST;
		uniform float4 _Color0;
		uniform float2 _Vector1;
		uniform float _Dissolve;
		uniform float2 _Remap;
		uniform sampler2D _LDI_Tenture_Metallic;
		uniform float4 _LDI_Tenture_Metallic_ST;
		uniform sampler2D _LDI_Tenture_AO;
		uniform float4 _LDI_Tenture_AO_ST;
		uniform sampler2D _OpacityMaskfromMeshProBuilderDefault;
		uniform float4 _OpacityMaskfromMeshProBuilderDefault_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_LDI_Tenture_Normal = i.uv_texcoord * _LDI_Tenture_Normal_ST.xy + _LDI_Tenture_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _LDI_Tenture_Normal, uv_LDI_Tenture_Normal ) );
			float2 uv_LDI_Tenture_Albedo = i.uv_texcoord * _LDI_Tenture_Albedo_ST.xy + _LDI_Tenture_Albedo_ST.zw;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_22_0 = (_Remap.x + (_Dissolve - 0.0) * (_Remap.y - _Remap.x) / (1.0 - 0.0));
			float clampResult23 = clamp( (( _Vector1.x + temp_output_22_0 ) + (ase_vertex3Pos.y - 0.0) * (( _Vector1.y + temp_output_22_0 ) - ( _Vector1.x + temp_output_22_0 )) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float4 lerpResult36 = lerp( tex2D( _LDI_Tenture_Albedo, uv_LDI_Tenture_Albedo ) , _Color0 , ( 1.0 - clampResult23 ));
			o.Albedo = lerpResult36.rgb;
			float2 uv_LDI_Tenture_Metallic = i.uv_texcoord * _LDI_Tenture_Metallic_ST.xy + _LDI_Tenture_Metallic_ST.zw;
			float4 tex2DNode58 = tex2D( _LDI_Tenture_Metallic, uv_LDI_Tenture_Metallic );
			o.Metallic = tex2DNode58.r;
			o.Smoothness = tex2DNode58.a;
			float2 uv_LDI_Tenture_AO = i.uv_texcoord * _LDI_Tenture_AO_ST.xy + _LDI_Tenture_AO_ST.zw;
			o.Occlusion = tex2D( _LDI_Tenture_AO, uv_LDI_Tenture_AO ).r;
			float2 uv_OpacityMaskfromMeshProBuilderDefault = i.uv_texcoord * _OpacityMaskfromMeshProBuilderDefault_ST.xy + _OpacityMaskfromMeshProBuilderDefault_ST.zw;
			o.Alpha = ( clampResult23 * tex2D( _OpacityMaskfromMeshProBuilderDefault, uv_OpacityMaskfromMeshProBuilderDefault ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.LerpOp;36;-844.2591,-5.268936;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;34;-1084.259,42.73106;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;33;-1148.259,-133.2689;Inherit;False;Property;_Color0;Color 0;1;1;[HDR];Create;True;0;0;0;False;0;False;16,0,0,0;16,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;55;-1148.259,-309.2689;Inherit;False;Constant;_Color1;Color 1;3;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-1788.259,282.7311;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1788.259,378.7311;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;6;-2156.26,154.7311;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;12;-1612.259,202.7311;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-10.4,1.3;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;BurningObjects;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;56;-1188.942,-527.3823;Inherit;True;Property;_LDI_Tenture_Albedo;LDI_Tenture_Albedo;3;0;Create;True;0;0;0;False;0;False;-1;3c79779a6af5e654b86114c13a704c7e;3c79779a6af5e654b86114c13a704c7e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;60;-1111.197,732.6828;Inherit;True;Property;_OpacityMaskfromMeshProBuilderDefault;Opacity Mask from Mesh ProBuilderDefault;7;0;Create;True;0;0;0;False;0;False;-1;932a5308d02a15e4082119a2f849d4bd;932a5308d02a15e4082119a2f849d4bd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;57;-487.0095,53.49045;Inherit;True;Property;_LDI_Tenture_Normal;LDI_Tenture_Normal;4;0;Create;True;0;0;0;False;0;False;-1;347197cc0853b63439d88c55af025458;347197cc0853b63439d88c55af025458;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;58;-483.6028,246.3732;Inherit;True;Property;_LDI_Tenture_Metallic;LDI_Tenture_Metallic;5;0;Create;True;0;0;0;False;0;False;-1;8e1a24a1aded5cd45a237bfc0a4d5098;8e1a24a1aded5cd45a237bfc0a4d5098;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;59;-474.3113,446.4016;Inherit;True;Property;_LDI_Tenture_AO;LDI_Tenture_AO;6;0;Create;True;0;0;0;False;0;False;-1;81190c6a4cece4747a6545be13bd1c13;81190c6a4cece4747a6545be13bd1c13;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-494.696,707.7669;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;23;-1316.976,202.7311;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2436.707,458.7311;Inherit;False;Property;_Dissolve;Dissolve;0;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;22;-2141.26,461.7311;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;6;False;4;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;63;-2379.227,546.9367;Inherit;False;Property;_Remap;Remap;8;0;Create;True;0;0;0;False;0;False;5,-30;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;18;-2124.26,330.7311;Inherit;False;Property;_Vector1;Vector 1;2;0;Create;True;0;0;0;False;0;False;-2,3;-2,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
WireConnection;36;0;56;0
WireConnection;36;1;33;0
WireConnection;36;2;34;0
WireConnection;34;0;23;0
WireConnection;17;0;18;1
WireConnection;17;1;22;0
WireConnection;21;0;18;2
WireConnection;21;1;22;0
WireConnection;12;0;6;2
WireConnection;12;3;17;0
WireConnection;12;4;21;0
WireConnection;0;0;36;0
WireConnection;0;1;57;0
WireConnection;0;3;58;1
WireConnection;0;4;58;4
WireConnection;0;5;59;0
WireConnection;0;9;61;0
WireConnection;61;0;23;0
WireConnection;61;1;60;0
WireConnection;23;0;12;0
WireConnection;22;0;19;0
WireConnection;22;3;63;1
WireConnection;22;4;63;2
ASEEND*/
//CHKSM=7A8C493D462CB86351D36463E788E3FA8D0BDA5B