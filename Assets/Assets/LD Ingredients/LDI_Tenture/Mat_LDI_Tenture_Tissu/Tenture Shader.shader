// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Tenture"
{
	Properties
	{
		_LDI_Tenture_Albedo("LDI_Tenture_Albedo", 2D) = "white" {}
		_LDI_Tenture_Normal("LDI_Tenture_Normal", 2D) = "bump" {}
		_LDI_Tenture_Metallic("LDI_Tenture_Metallic", 2D) = "white" {}
		_LDI_Tenture_AO("LDI_Tenture_AO", 2D) = "white" {}
		_Dissolve("Dissolve", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _LDI_Tenture_Normal;
		uniform float4 _LDI_Tenture_Normal_ST;
		uniform sampler2D _LDI_Tenture_Albedo;
		uniform float4 _LDI_Tenture_Albedo_ST;
		uniform sampler2D _LDI_Tenture_Metallic;
		uniform float4 _LDI_Tenture_Metallic_ST;
		uniform sampler2D _LDI_Tenture_AO;
		uniform float4 _LDI_Tenture_AO_ST;
		uniform float _Dissolve;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_LDI_Tenture_Normal = i.uv_texcoord * _LDI_Tenture_Normal_ST.xy + _LDI_Tenture_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _LDI_Tenture_Normal, uv_LDI_Tenture_Normal ) );
			float2 uv_LDI_Tenture_Albedo = i.uv_texcoord * _LDI_Tenture_Albedo_ST.xy + _LDI_Tenture_Albedo_ST.zw;
			o.Albedo = tex2D( _LDI_Tenture_Albedo, uv_LDI_Tenture_Albedo ).rgb;
			float2 uv_LDI_Tenture_Metallic = i.uv_texcoord * _LDI_Tenture_Metallic_ST.xy + _LDI_Tenture_Metallic_ST.zw;
			o.Metallic = tex2D( _LDI_Tenture_Metallic, uv_LDI_Tenture_Metallic ).r;
			float2 uv_LDI_Tenture_AO = i.uv_texcoord * _LDI_Tenture_AO_ST.xy + _LDI_Tenture_AO_ST.zw;
			o.Occlusion = tex2D( _LDI_Tenture_AO, uv_LDI_Tenture_AO ).r;
			float clampResult16 = clamp( ( 1.0 - _Dissolve ) , 0.0 , 1.0 );
			o.Alpha = clampResult16;
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
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/Tenture;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;True;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;1;-841.1373,-333.8327;Inherit;True;Property;_LDI_Tenture_Albedo;LDI_Tenture_Albedo;0;0;Create;True;0;0;0;False;0;False;-1;3c79779a6af5e654b86114c13a704c7e;3c79779a6af5e654b86114c13a704c7e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-840.0327,-139.4597;Inherit;True;Property;_LDI_Tenture_Normal;LDI_Tenture_Normal;1;0;Create;True;0;0;0;False;0;False;-1;347197cc0853b63439d88c55af025458;347197cc0853b63439d88c55af025458;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-836.626,53.42309;Inherit;True;Property;_LDI_Tenture_Metallic;LDI_Tenture_Metallic;2;0;Create;True;0;0;0;False;0;False;-1;8e1a24a1aded5cd45a237bfc0a4d5098;8e1a24a1aded5cd45a237bfc0a4d5098;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-827.3345,253.4512;Inherit;True;Property;_LDI_Tenture_AO;LDI_Tenture_AO;3;0;Create;True;0;0;0;False;0;False;-1;81190c6a4cece4747a6545be13bd1c13;81190c6a4cece4747a6545be13bd1c13;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-816,480;Inherit;False;Property;_Dissolve;Dissolve;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-512,480;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;16;-352,480;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
WireConnection;0;0;1;0
WireConnection;0;1;3;0
WireConnection;0;3;4;0
WireConnection;0;5;5;0
WireConnection;0;9;16;0
WireConnection;14;0;10;0
WireConnection;16;0;14;0
ASEEND*/
//CHKSM=D8A2591D31ED0ABE8944D49D41D09BDF5B7B3EEF