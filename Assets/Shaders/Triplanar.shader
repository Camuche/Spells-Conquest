// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Triplanar"
{
	Properties
	{
		_TextureIntensity("TextureIntensity", Float) = 0
		[Toggle]_Bot_Is_Top_Texture("Bot_Is_Top_Texture", Float) = 1
		[Toggle]_Bot_Is_Top_Normal("Bot_Is_Top_Normal", Float) = 1
		_Texture_Tiling_TOP("Texture_Tiling_TOP", Range( -6 , 1)) = 0
		_Triplanar_Texture_TOP("Triplanar_Texture_TOP", 2D) = "white" {}
		_Triplanar_Normal_TOP("Triplanar_Normal_TOP", 2D) = "bump" {}
		_Texture_Tiling_FORWARD("Texture_Tiling_FORWARD", Range( -6 , 1)) = 0
		_Triplanar_Texture_FORWARD("Triplanar_Texture_FORWARD", 2D) = "white" {}
		_Triplanar_Normal_FORWARD("Triplanar_Normal_FORWARD", 2D) = "bump" {}
		_Texture_Tiling_RIGHT("Texture_Tiling_RIGHT", Range( -6 , 1)) = 0
		_Triplanar_Texture_Right("Triplanar_Texture_Right", 2D) = "white" {}
		_Triplanar_Normal_Right("Triplanar_Normal_Right", 2D) = "bump" {}
		_Texture_Tiling_BOT("Texture_Tiling_BOT", Range( -6 , 1)) = 0
		_Triplanar_Texture_BOT("Triplanar_Texture_BOT", 2D) = "white" {}
		_Triplanar_Normal_BOT("Triplanar_Normal_BOT", 2D) = "bump" {}
		_Triplanar_Smooth_Min("Triplanar_Smooth_Min", Range( 0 , 1)) = 0.2
		_Triplanar_Smooth_Max("Triplanar_Smooth_Max", Range( 0 , 2)) = 0.2
		_Normal("Height", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Triplanar_Normal_Right;
		uniform float _Texture_Tiling_RIGHT;
		uniform float _Triplanar_Smooth_Min;
		uniform float _Triplanar_Smooth_Max;
		uniform float _Bot_Is_Top_Normal;
		uniform sampler2D _Triplanar_Normal_TOP;
		uniform float _Texture_Tiling_TOP;
		uniform sampler2D _Triplanar_Normal_BOT;
		uniform float _Texture_Tiling_BOT;
		uniform sampler2D _Triplanar_Normal_FORWARD;
		uniform float _Texture_Tiling_FORWARD;
		uniform sampler2D _Triplanar_Texture_Right;
		uniform float _Bot_Is_Top_Texture;
		uniform sampler2D _Triplanar_Texture_TOP;
		uniform sampler2D _Triplanar_Texture_BOT;
		uniform sampler2D _Triplanar_Texture_FORWARD;
		uniform float _TextureIntensity;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_0 = (1.0).xxxx;
			return temp_cast_0;
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float2 temp_output_2_0_g2 = uv_Normal;
			float2 break6_g2 = temp_output_2_0_g2;
			float temp_output_25_0_g2 = ( pow( 0.5 , 3.0 ) * 0.1 );
			float2 appendResult8_g2 = (float2(( break6_g2.x + temp_output_25_0_g2 ) , break6_g2.y));
			float4 tex2DNode14_g2 = tex2D( _Normal, temp_output_2_0_g2 );
			float temp_output_4_0_g2 = 2.0;
			float3 appendResult13_g2 = (float3(1.0 , 0.0 , ( ( tex2D( _Normal, appendResult8_g2 ).g - tex2DNode14_g2.g ) * temp_output_4_0_g2 )));
			float2 appendResult9_g2 = (float2(break6_g2.x , ( break6_g2.y + temp_output_25_0_g2 )));
			float3 appendResult16_g2 = (float3(0.0 , 1.0 , ( ( tex2D( _Normal, appendResult9_g2 ).g - tex2DNode14_g2.g ) * temp_output_4_0_g2 )));
			float3 normalizeResult22_g2 = normalize( cross( appendResult13_g2 , appendResult16_g2 ) );
			float3 temp_output_177_0 = normalizeResult22_g2;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult144 = (float2(ase_worldPos.y , ase_worldPos.z));
			float TilingRight204 = _Texture_Tiling_RIGHT;
			float SmoothMin168 = _Triplanar_Smooth_Min;
			float SmoothMax169 = _Triplanar_Smooth_Max;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float smoothstepResult128 = smoothstep( SmoothMin168 , SmoothMax169 , ase_worldNormal.x);
			float smoothstepResult129 = smoothstep( SmoothMin168 , SmoothMax169 , ( ase_worldNormal.x * -1.0 ));
			float3 lerpResult132 = lerp( temp_output_177_0 , UnpackNormal( tex2D( _Triplanar_Normal_Right, ( appendResult144 * ( 1.0 - TilingRight204 ) ) ) ) , ( smoothstepResult128 + smoothstepResult129 ));
			float2 appendResult154 = (float2(ase_worldPos.x , ase_worldPos.z));
			float TilingTop205 = _Texture_Tiling_TOP;
			float3 tex2DNode153 = UnpackNormal( tex2D( _Triplanar_Normal_TOP, ( appendResult154 * ( 1.0 - TilingTop205 ) ) ) );
			float smoothstepResult138 = smoothstep( SmoothMin168 , SmoothMax169 , ase_worldNormal.y);
			float3 lerpResult134 = lerp( temp_output_177_0 , tex2DNode153 , smoothstepResult138);
			float2 appendResult157 = (float2(ase_worldPos.x , ase_worldPos.z));
			float TilingBot207 = _Texture_Tiling_BOT;
			float smoothstepResult139 = smoothstep( 0.0 , 1.0 , ( ase_worldNormal.y * -1.0 ));
			float3 lerpResult127 = lerp( temp_output_177_0 , UnpackNormal( tex2D( _Triplanar_Normal_BOT, ( appendResult157 * ( 1.0 - TilingBot207 ) ) ) ) , smoothstepResult139);
			float3 lerpResult136 = lerp( temp_output_177_0 , tex2DNode153 , ( smoothstepResult138 + smoothstepResult139 ));
			float2 appendResult149 = (float2(ase_worldPos.x , ase_worldPos.y));
			float TilingForward206 = _Texture_Tiling_FORWARD;
			float smoothstepResult123 = smoothstep( SmoothMax169 , SmoothMax169 , ase_worldNormal.z);
			float smoothstepResult124 = smoothstep( SmoothMin168 , SmoothMax169 , ( ase_worldNormal.z * -1.0 ));
			float3 lerpResult122 = lerp( temp_output_177_0 , UnpackNormal( tex2D( _Triplanar_Normal_FORWARD, ( appendResult149 * ( 1.0 - TilingForward206 ) ) ) ) , ( smoothstepResult123 + smoothstepResult124 ));
			o.Normal = BlendNormals( BlendNormals( lerpResult132 , (( _Bot_Is_Top_Normal )?( lerpResult136 ):( BlendNormals( lerpResult134 , lerpResult127 ) )) ) , lerpResult122 );
			float2 appendResult85 = (float2(ase_worldPos.y , ase_worldPos.z));
			float smoothstepResult43 = smoothstep( _Triplanar_Smooth_Min , _Triplanar_Smooth_Max , ase_worldNormal.x);
			float smoothstepResult57 = smoothstep( _Triplanar_Smooth_Min , _Triplanar_Smooth_Max , ( ase_worldNormal.x * -1.0 ));
			float4 lerpResult36 = lerp( float4( 0,0,0,0 ) , tex2D( _Triplanar_Texture_Right, ( appendResult85 * ( 1.0 - _Texture_Tiling_RIGHT ) ) ) , ( smoothstepResult43 + smoothstepResult57 ));
			float2 appendResult72 = (float2(ase_worldPos.x , ase_worldPos.z));
			float4 tex2DNode90 = tex2D( _Triplanar_Texture_TOP, ( appendResult72 * ( 1.0 - _Texture_Tiling_TOP ) ) );
			float smoothstepResult40 = smoothstep( _Triplanar_Smooth_Min , _Triplanar_Smooth_Max , ase_worldNormal.y);
			float4 lerpResult69 = lerp( float4( 0,0,0,0 ) , tex2DNode90 , smoothstepResult40);
			float2 appendResult102 = (float2(ase_worldPos.x , ase_worldPos.z));
			float smoothstepResult62 = smoothstep( 0.0 , 1.0 , ( ase_worldNormal.y * -1.0 ));
			float4 lerpResult70 = lerp( float4( 0,0,0,0 ) , tex2D( _Triplanar_Texture_BOT, ( appendResult102 * ( 1.0 - _Texture_Tiling_BOT ) ) ) , smoothstepResult62);
			float4 lerpResult18 = lerp( float4( 0,0,0,0 ) , tex2DNode90 , ( smoothstepResult40 + smoothstepResult62 ));
			float2 appendResult82 = (float2(ase_worldPos.x , ase_worldPos.y));
			float smoothstepResult42 = smoothstep( _Triplanar_Smooth_Min , _Triplanar_Smooth_Max , ase_worldNormal.z);
			float smoothstepResult60 = smoothstep( _Triplanar_Smooth_Min , _Triplanar_Smooth_Max , ( ase_worldNormal.z * -1.0 ));
			float4 lerpResult37 = lerp( float4( 0,0,0,0 ) , tex2D( _Triplanar_Texture_FORWARD, ( appendResult82 * ( 1.0 - _Texture_Tiling_FORWARD ) ) ) , ( smoothstepResult42 + smoothstepResult60 ));
			o.Albedo = ( ( lerpResult36 + (( _Bot_Is_Top_Texture )?( lerpResult18 ):( ( lerpResult69 + lerpResult70 ) )) + lerpResult37 ) * _TextureIntensity ).rgb;
			o.Metallic = 0.0;
			o.Smoothness = 0.0;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				vertexDataFunc( v );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
Node;AmplifyShaderEditor.CommentaryNode;100;-3252.908,-1162.234;Inherit;False;3343.114;2327.344;Blend Texture With Normals;25;15;37;42;60;61;59;70;43;57;56;58;36;71;69;68;18;63;40;62;64;41;44;162;168;169;Blend Texture With Normals;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;99;-7536.365,-964.4861;Inherit;False;2186.483;1003.877;World Position Texture;25;95;105;77;96;204;207;206;205;101;73;90;94;104;103;102;81;79;72;32;84;83;82;87;86;85;World Position Texture;0,1,0.9510725,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;120;-3240.752,1405.08;Inherit;False;3666.861;2317.433;Blend Normal With Normals;25;179;174;178;177;171;170;138;135;140;139;137;136;134;132;131;130;129;128;127;126;125;124;123;122;121;Blend Normal With Normals;0.3800626,0,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;15;-3202.908,-32.65319;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;37;-847.5311,710.7423;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;42;-1420.417,698.971;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;60;-1440.615,911.1106;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-1200.615,799.111;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-1760.655,903.9897;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;70;-1358.38,-181.1225;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;43;-1599.678,-1065.603;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;57;-1601.6,-945.6;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-2048,-947.1998;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-1404.604,-1064.869;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;36;-1202.303,-1112.234;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-958.7242,-214.835;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;69;-1359.727,-301.3171;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;68;-612.1942,-68.74501;Inherit;False;Property;_Bot_Is_Top_Texture;Bot_Is_Top_Texture;1;0;Create;True;0;0;0;False;0;False;1;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;18;-974.1673,26.55548;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-1279.914,73.76907;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;40;-1749.947,-257.6255;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.19;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;62;-1742.526,96.26965;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1958.326,96.77134;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-143.7941,-96.33955;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;121;-3190.752,2534.662;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;122;-835.3754,3278.057;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;123;-1408.262,3266.286;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;124;-1428.46,3478.426;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;-1188.46,3366.426;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-1748.5,3471.305;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;127;-1346.225,2386.192;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;128;-1587.523,1501.711;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;129;-1589.445,1621.714;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-2035.844,1620.114;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;131;-1392.449,1502.445;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;132;-1190.148,1455.08;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;134;-1347.572,2265.998;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;136;-962.0118,2593.87;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;137;-1267.759,2641.084;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;139;-1730.371,2663.584;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-1946.171,2664.086;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;85;-6091.451,-908.9685;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-5934.45,-908.9683;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;87;-6092.451,-816.968;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;82;-6054.648,-488.0113;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-5897.647,-488.011;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;84;-6055.648,-396.0106;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;32;-6990.364,-756.3436;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;72;-6069.102,-693.865;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;79;-6069.676,-600.1277;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-5918.101,-692.865;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;102;-6072.32,-153.6518;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;103;-6072.895,-59.91485;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-5921.319,-152.6518;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;143;-7092.821,219.3996;Inherit;False;1690.483;1013.477;World Position Normal;21;160;159;158;157;156;155;154;153;152;151;150;149;148;147;146;145;144;208;211;210;209;World Position Normal;0,1,0.4193454,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;135;-600.0392,2498.57;Inherit;False;Property;_Bot_Is_Top_Normal;Bot_Is_Top_Normal;2;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;138;-1737.792,2309.689;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.19;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2570.042,-11.43773;Inherit;False;Property;_Triplanar_Smooth_Min;Triplanar_Smooth_Min;19;0;Create;True;0;0;0;False;0;False;0.2;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-2579.774,118.1978;Inherit;False;Property;_Triplanar_Smooth_Max;Triplanar_Smooth_Max;20;0;Create;True;0;0;0;False;0;False;0.2;1.2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1947.713,1009.127;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Triplanar;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;94;-5668.504,-914.4865;Inherit;True;Property;_Triplanar_Texture_Right;Triplanar_Texture_Right;12;0;Create;True;0;0;0;False;0;False;-1;None;f58707fb38ad36848a59af69d1e92cf2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;90;-5669.581,-717.8136;Inherit;True;Property;_Triplanar_Texture_TOP;Triplanar_Texture_TOP;4;0;Create;True;0;0;0;False;0;False;-1;None;f58707fb38ad36848a59af69d1e92cf2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;73;-5665.158,-510.3871;Inherit;True;Property;_Triplanar_Texture_FORWARD;Triplanar_Texture_FORWARD;8;0;Create;True;0;0;0;False;0;False;-1;None;f58707fb38ad36848a59af69d1e92cf2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;101;-5672.8,-177.6005;Inherit;True;Property;_Triplanar_Texture_BOT;Triplanar_Texture_BOT;16;0;Create;True;0;0;0;False;0;False;-1;None;f58707fb38ad36848a59af69d1e92cf2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;168;-1974.778,-3.52484;Inherit;False;SmoothMin;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;169;-1967.053,197.4045;Inherit;False;SmoothMax;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;170;-2724.018,2437.738;Inherit;False;168;SmoothMin;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;171;-2698.764,2577.534;Inherit;False;169;SmoothMax;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;178;-975.9504,2332.697;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;174;-276.5453,2473.064;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;179;143.9406,2465.426;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;144;-6143.907,274.9172;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-5986.906,274.9174;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;146;-6144.907,366.9177;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;149;-6107.104,695.8741;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-5950.104,695.8744;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;151;-6108.104,787.8748;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;152;-7042.82,427.5421;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;154;-6121.559,490.0207;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;155;-6122.132,583.7577;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;-5970.558,491.0207;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;157;-6124.776,1030.234;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;158;-6125.352,1123.971;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;-5973.775,1031.234;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;147;-5720.96,269.3992;Inherit;True;Property;_Triplanar_Normal_Right;Triplanar_Normal_Right;14;0;Create;True;0;0;0;False;0;False;-1;None;bf2f78f9030892d449cf72ead8f64abc;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;153;-5722.038,466.0721;Inherit;True;Property;_Triplanar_Normal_TOP;Triplanar_Normal_TOP;6;0;Create;True;0;0;0;False;0;False;-1;None;bf2f78f9030892d449cf72ead8f64abc;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;148;-5717.616,673.4984;Inherit;True;Property;_Triplanar_Normal_FORWARD;Triplanar_Normal_FORWARD;10;0;Create;True;0;0;0;False;0;False;-1;None;bf2f78f9030892d449cf72ead8f64abc;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;160;-5725.256,1006.285;Inherit;True;Property;_Triplanar_Normal_BOT;Triplanar_Normal_BOT;17;0;Create;True;0;0;0;False;0;False;-1;None;bf2f78f9030892d449cf72ead8f64abc;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;180;-7077.79,1373.408;Inherit;False;1690.483;1013.477;World Position MRHAO;21;197;196;195;194;193;192;191;190;189;188;187;186;185;184;183;182;181;212;213;214;215;World Position MRHAO;0.951696,1,0,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;181;-6128.876,1428.925;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-5971.875,1428.926;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;183;-6129.876,1520.926;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;184;-6092.073,1849.881;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-5935.073,1849.882;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;186;-6093.073,1941.882;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;187;-7027.789,1581.55;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;188;-6106.528,1644.028;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;189;-6107.101,1737.765;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-5955.527,1645.028;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;191;-6109.745,2184.24;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;192;-6110.321,2277.977;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;-5958.744,2185.24;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;197;-5710.225,2160.291;Inherit;True;Property;_Triplanar_Normal_BOT1;Triplanar_Normal_BOT;18;0;Create;True;0;0;0;False;0;False;-1;None;83f03b3c2b2d5df40898d8c2123239ae;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;475.0921,-91.17126;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;201;1781.896,1375.762;Inherit;False;Constant;_Float1;Float 1;24;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;165;160.9191,3.292818;Inherit;False;Property;_TextureIntensity;TextureIntensity;0;0;Create;True;0;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;177;-1689.87,1913.761;Inherit;False;NormalCreate;21;;2;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-7450.479,-825.9131;Inherit;False;Property;_Texture_Tiling_RIGHT;Texture_Tiling_RIGHT;11;0;Create;True;0;0;0;False;0;False;0;0.9;-6;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-7458.728,-608.4005;Inherit;False;Property;_Texture_Tiling_TOP;Texture_Tiling_TOP;3;0;Create;True;0;0;0;False;0;False;0;0.9;-6;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-7488.816,-65.56213;Inherit;False;Property;_Texture_Tiling_BOT;Texture_Tiling_BOT;15;0;Create;True;0;0;0;False;0;False;0;0.9;-6;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-7466.034,-400.2879;Inherit;False;Property;_Texture_Tiling_FORWARD;Texture_Tiling_FORWARD;7;0;Create;True;0;0;0;False;0;False;0;0.9;-6;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;204;-7067.535,-902.9421;Inherit;False;TilingRight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;206;-6687.332,-318.1414;Inherit;False;TilingForward;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;205;-6867.328,-524.3414;Inherit;False;TilingTop;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;207;-7202.534,-127.5415;Inherit;False;TilingBot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;208;-6392.851,1122.203;Inherit;False;207;TilingBot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;-6364.067,788.4691;Inherit;False;206;TilingForward;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;210;-6338.015,581.8702;Inherit;False;205;TilingTop;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;-6366.741,368.469;Inherit;False;204;TilingRight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;212;-6383.191,2271.812;Inherit;False;207;TilingBot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;213;-6354.407,1938.079;Inherit;False;206;TilingForward;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;-6328.355,1731.48;Inherit;False;205;TilingTop;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;215;-6357.082,1518.079;Inherit;False;204;TilingRight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;194;-5705.929,1423.407;Inherit;True;Property;_Triplanar_MRHAO_Right;Triplanar_MRHAO_Right;13;0;Create;True;0;0;0;False;0;False;-1;None;83f03b3c2b2d5df40898d8c2123239ae;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;195;-5707.007,1620.08;Inherit;True;Property;_Triplanar_MRHAO_TOP;Triplanar_MRHAO_TOP;5;0;Create;True;0;0;0;False;0;False;-1;None;83f03b3c2b2d5df40898d8c2123239ae;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;196;-5702.585,1827.506;Inherit;True;Property;_Triplanar__FORWARD;Triplanar_'_FORWARD;9;0;Create;True;0;0;0;False;0;False;-1;None;83f03b3c2b2d5df40898d8c2123239ae;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;217;-5823.693,2439.901;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;218;-6509.436,2451.704;Inherit;True;Property;_Texture0;Texture 0;23;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;219;-6472.851,2681.016;Inherit;True;Property;_TextureSample3;Texture Sample 3;24;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;202;1587.849,1033.632;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;220;1526.122,1144.32;Inherit;False;Constant;_Float0;Float 0;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;221;1517.122,1219.32;Inherit;False;Constant;_Float2;Float 2;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
WireConnection;37;1;73;0
WireConnection;37;2;61;0
WireConnection;42;0;15;3
WireConnection;42;1;41;0
WireConnection;42;2;162;0
WireConnection;60;0;59;0
WireConnection;60;1;41;0
WireConnection;60;2;162;0
WireConnection;61;0;42;0
WireConnection;61;1;60;0
WireConnection;59;0;15;3
WireConnection;70;1;101;0
WireConnection;70;2;62;0
WireConnection;43;0;15;1
WireConnection;43;1;41;0
WireConnection;43;2;162;0
WireConnection;57;0;56;0
WireConnection;57;1;41;0
WireConnection;57;2;162;0
WireConnection;56;0;15;1
WireConnection;58;0;43;0
WireConnection;58;1;57;0
WireConnection;36;1;94;0
WireConnection;36;2;58;0
WireConnection;71;0;69;0
WireConnection;71;1;70;0
WireConnection;69;1;90;0
WireConnection;69;2;40;0
WireConnection;68;0;71;0
WireConnection;68;1;18;0
WireConnection;18;1;90;0
WireConnection;18;2;63;0
WireConnection;63;0;40;0
WireConnection;63;1;62;0
WireConnection;40;0;15;2
WireConnection;40;1;41;0
WireConnection;40;2;162;0
WireConnection;62;0;64;0
WireConnection;64;0;15;2
WireConnection;44;0;36;0
WireConnection;44;1;68;0
WireConnection;44;2;37;0
WireConnection;122;0;177;0
WireConnection;122;1;148;0
WireConnection;122;2;125;0
WireConnection;123;0;121;3
WireConnection;123;1;171;0
WireConnection;123;2;171;0
WireConnection;124;0;126;0
WireConnection;124;1;170;0
WireConnection;124;2;171;0
WireConnection;125;0;123;0
WireConnection;125;1;124;0
WireConnection;126;0;121;3
WireConnection;127;0;177;0
WireConnection;127;1;160;0
WireConnection;127;2;139;0
WireConnection;128;0;121;1
WireConnection;128;1;170;0
WireConnection;128;2;171;0
WireConnection;129;0;130;0
WireConnection;129;1;170;0
WireConnection;129;2;171;0
WireConnection;130;0;121;1
WireConnection;131;0;128;0
WireConnection;131;1;129;0
WireConnection;132;0;177;0
WireConnection;132;1;147;0
WireConnection;132;2;131;0
WireConnection;134;0;177;0
WireConnection;134;1;153;0
WireConnection;134;2;138;0
WireConnection;136;0;177;0
WireConnection;136;1;153;0
WireConnection;136;2;137;0
WireConnection;137;0;138;0
WireConnection;137;1;139;0
WireConnection;139;0;140;0
WireConnection;140;0;121;2
WireConnection;85;0;32;2
WireConnection;85;1;32;3
WireConnection;86;0;85;0
WireConnection;86;1;87;0
WireConnection;87;0;96;0
WireConnection;82;0;32;1
WireConnection;82;1;32;2
WireConnection;83;0;82;0
WireConnection;83;1;84;0
WireConnection;84;0;95;0
WireConnection;72;0;32;1
WireConnection;72;1;32;3
WireConnection;79;0;77;0
WireConnection;81;0;72;0
WireConnection;81;1;79;0
WireConnection;102;0;32;1
WireConnection;102;1;32;3
WireConnection;103;0;105;0
WireConnection;104;0;102;0
WireConnection;104;1;103;0
WireConnection;135;0;178;0
WireConnection;135;1;136;0
WireConnection;138;0;121;2
WireConnection;138;1;170;0
WireConnection;138;2;171;0
WireConnection;0;0;164;0
WireConnection;0;1;179;0
WireConnection;0;3;220;0
WireConnection;0;4;221;0
WireConnection;0;14;201;0
WireConnection;94;1;86;0
WireConnection;90;1;81;0
WireConnection;73;1;83;0
WireConnection;101;1;104;0
WireConnection;168;0;41;0
WireConnection;169;0;162;0
WireConnection;178;0;134;0
WireConnection;178;1;127;0
WireConnection;174;0;132;0
WireConnection;174;1;135;0
WireConnection;179;0;174;0
WireConnection;179;1;122;0
WireConnection;144;0;152;2
WireConnection;144;1;152;3
WireConnection;145;0;144;0
WireConnection;145;1;146;0
WireConnection;146;0;211;0
WireConnection;149;0;152;1
WireConnection;149;1;152;2
WireConnection;150;0;149;0
WireConnection;150;1;151;0
WireConnection;151;0;209;0
WireConnection;154;0;152;1
WireConnection;154;1;152;3
WireConnection;155;0;210;0
WireConnection;156;0;154;0
WireConnection;156;1;155;0
WireConnection;157;0;152;1
WireConnection;157;1;152;3
WireConnection;158;0;208;0
WireConnection;159;0;157;0
WireConnection;159;1;158;0
WireConnection;147;1;145;0
WireConnection;153;1;156;0
WireConnection;148;1;150;0
WireConnection;160;1;159;0
WireConnection;181;0;187;2
WireConnection;181;1;187;3
WireConnection;182;0;181;0
WireConnection;182;1;183;0
WireConnection;183;0;215;0
WireConnection;184;0;187;1
WireConnection;184;1;187;2
WireConnection;185;0;184;0
WireConnection;185;1;186;0
WireConnection;186;0;213;0
WireConnection;188;0;187;1
WireConnection;188;1;187;3
WireConnection;189;0;214;0
WireConnection;190;0;188;0
WireConnection;190;1;189;0
WireConnection;191;0;187;1
WireConnection;191;1;187;3
WireConnection;192;0;212;0
WireConnection;193;0;191;0
WireConnection;193;1;192;0
WireConnection;197;1;193;0
WireConnection;164;0;44;0
WireConnection;164;1;165;0
WireConnection;204;0;96;0
WireConnection;206;0;95;0
WireConnection;205;0;77;0
WireConnection;207;0;105;0
WireConnection;194;1;182;0
WireConnection;195;1;190;0
WireConnection;196;1;185;0
ASEEND*/
//CHKSM=DFE45DF7180173EC65052AB45DFA95CFE246FEA7