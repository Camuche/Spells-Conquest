// Made with Amplify Shader Editor v1.9.0.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MagicalFlowerMat"
{
	Properties
	{
		_fleur_magique_low_fleur_part_trois_high_save3_BaseMap("fleur_magique_low_fleur_part_trois_high_save3_BaseMap", 2D) = "white" {}
		_fleur_magique_low_fleur_part_trois_high_save3_Normal("fleur_magique_low_fleur_part_trois_high_save3_Normal", 2D) = "bump" {}
		_Smoothness("Smoothness", Float) = 0
		_ColorEmi("ColorEmi", Color) = (0.6781712,0,1,0)
		_SmoothnessEmi("SmoothnessEmi", Float) = 1
		_EmissiveIntensity("EmissiveIntensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		AlphaToMask On
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _fleur_magique_low_fleur_part_trois_high_save3_Normal;
		uniform float4 _fleur_magique_low_fleur_part_trois_high_save3_Normal_ST;
		uniform sampler2D _fleur_magique_low_fleur_part_trois_high_save3_BaseMap;
		uniform float4 _fleur_magique_low_fleur_part_trois_high_save3_BaseMap_ST;
		uniform float4 _ColorEmi;
		uniform float _EmissiveIntensity;
		uniform float _Smoothness;
		uniform float _SmoothnessEmi;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_fleur_magique_low_fleur_part_trois_high_save3_Normal = i.uv_texcoord * _fleur_magique_low_fleur_part_trois_high_save3_Normal_ST.xy + _fleur_magique_low_fleur_part_trois_high_save3_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _fleur_magique_low_fleur_part_trois_high_save3_Normal, uv_fleur_magique_low_fleur_part_trois_high_save3_Normal ) );
			float2 uv_fleur_magique_low_fleur_part_trois_high_save3_BaseMap = i.uv_texcoord * _fleur_magique_low_fleur_part_trois_high_save3_BaseMap_ST.xy + _fleur_magique_low_fleur_part_trois_high_save3_BaseMap_ST.zw;
			o.Albedo = tex2D( _fleur_magique_low_fleur_part_trois_high_save3_BaseMap, uv_fleur_magique_low_fleur_part_trois_high_save3_BaseMap ).rgb;
			float temp_output_3_0_g2 = ( 0.54 - i.uv_texcoord.x );
			float temp_output_3_0_g3 = ( 0.35 - ( 1.0 - i.uv_texcoord.y ) );
			float temp_output_15_0 = ( saturate( ( temp_output_3_0_g2 / fwidth( temp_output_3_0_g2 ) ) ) * saturate( ( temp_output_3_0_g3 / fwidth( temp_output_3_0_g3 ) ) ) );
			o.Emission = ( temp_output_15_0 * _ColorEmi * _EmissiveIntensity ).rgb;
			float lerpResult19 = lerp( _Smoothness , _SmoothnessEmi , temp_output_15_0);
			o.Smoothness = lerpResult19;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
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
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19001
1920;0;1920;1019;2581.968;737.0773;1.6;True;True
Node;AmplifyShaderEditor.CommentaryNode;16;-2089.424,-588.9653;Inherit;False;1189.672;451.1699;MaskEmi;8;15;17;10;13;11;12;14;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-2039.422,-538.9655;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-1737.022,-434.1659;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;0.54;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;12;-1737.022,-354.1659;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1736.022,-281.1659;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;0.35;0.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;13;-1522.022,-512.1658;Inherit;False;Step Antialiasing;-1;;2;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;10;-1512.022,-365.1659;Inherit;False;Step Antialiasing;-1;;3;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-506.8014,-167.1019;Inherit;False;Property;_EmissiveIntensity;EmissiveIntensity;5;0;Create;True;0;0;0;False;0;False;0;0.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-1273.833,-323.4669;Inherit;False;Property;_ColorEmi;ColorEmi;3;0;Create;True;0;0;0;False;0;False;0.6781712,0,1,0;0,0.4232011,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1047.26,-514.2705;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-777.7455,17.66439;Inherit;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-796.5793,90.381;Inherit;False;Property;_SmoothnessEmi;SmoothnessEmi;4;0;Create;True;0;0;0;False;0;False;1;1.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-305.8866,-264.0822;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-1325,-76.1;Inherit;True;Property;_fleur_magique_low_fleur_part_trois_high_save3_BaseMap;fleur_magique_low_fleur_part_trois_high_save3_BaseMap;0;0;Create;True;0;0;0;False;0;False;-1;c5a6d0a5406cdf94a823057776d6f9fd;c5a6d0a5406cdf94a823057776d6f9fd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;19;-466.633,42.80301;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-1333,324.9;Inherit;True;Property;_fleur_magique_low_fleur_part_trois_high_save3_Normal;fleur_magique_low_fleur_part_trois_high_save3_Normal;1;0;Create;True;0;0;0;False;0;False;-1;6f80615a743bc304cac7968f4537901c;6f80615a743bc304cac7968f4537901c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MagicalFlowerMat;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;18;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;True;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;9;2
WireConnection;13;1;9;1
WireConnection;13;2;14;0
WireConnection;10;1;12;0
WireConnection;10;2;11;0
WireConnection;15;0;13;0
WireConnection;15;1;10;0
WireConnection;20;0;15;0
WireConnection;20;1;17;0
WireConnection;20;2;27;0
WireConnection;19;0;8;0
WireConnection;19;1;21;0
WireConnection;19;2;15;0
WireConnection;0;0;2;0
WireConnection;0;1;4;0
WireConnection;0;2;20;0
WireConnection;0;4;19;0
ASEEND*/
//CHKSM=92B47940F6D32CE9C3799D8637310BB677F93FEC