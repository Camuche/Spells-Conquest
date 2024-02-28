// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FireballTrail"
{
	Properties
	{
		_TrailTexture("TrailTexture", 2D) = "white" {}
		_ColorFade("ColorFade", Color) = (1,0,0,0)
		_Color("Color", Color) = (1,0.8579727,0,0)
		_Speed("Speed", Float) = 1
		_TrailLength("TrailLength", Float) = 0.1
		_Opacity("Opacity", Float) = 1
		_ColorIntensity("ColorIntensity", Float) = 1
		_HDR("HDR", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _ColorFade;
		uniform float _HDR;
		uniform float4 _Color;
		uniform sampler2D _TrailTexture;
		uniform float _Speed;
		uniform float _ColorIntensity;
		uniform float _Opacity;
		uniform float _TrailLength;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float smoothstepResult15 = smoothstep( 0.03 , 1.61 , ( 1.0 - i.uv_texcoord.x ));
			float mulTime12 = _Time.y * _Speed;
			float2 uv_TexCoord8 = i.uv_texcoord + ( float2( -1,0 ) * mulTime12 );
			float temp_output_7_0 = ( smoothstepResult15 * tex2D( _TrailTexture, uv_TexCoord8 ).a );
			float4 lerpResult3 = lerp( ( _ColorFade * _HDR ) , ( _Color * _HDR ) , (0.0 + (temp_output_7_0 - 0.0) * (_ColorIntensity - 0.0) / (1.0 - 0.0)));
			o.Albedo = lerpResult3.rgb;
			o.Emission = lerpResult3.rgb;
			float temp_output_3_0_g1 = ( _TrailLength - temp_output_7_0 );
			o.Alpha = ( _Opacity * ( 1.0 - saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) ) ) );
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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
Node;AmplifyShaderEditor.RangedFloatNode;16;-1809.645,340.6257;Inherit;False;Property;_Speed;Speed;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-1642.05,346.8156;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;10;-1617.05,211.8159;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1308.624,-205.7248;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1419.05,216.8157;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;52;-1063.229,-118.3555;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1221.35,165.8933;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-971.8561,133.2488;Inherit;True;Property;_TrailTexture;TrailTexture;0;0;Create;True;0;0;0;False;0;False;-1;f21ba050f6f7b3f40b51bd61c11f29d3;f21ba050f6f7b3f40b51bd61c11f29d3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;15;-895.5919,-174.4843;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.03;False;2;FLOAT;1.61;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-152.8553,533.0145;Inherit;False;Property;_TrailLength;TrailLength;4;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-511.6398,67.83301;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;18;39.9093,459.2789;Inherit;True;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-140.9807,171.9544;Inherit;False;Property;_ColorIntensity;ColorIntensity;6;0;Create;True;0;0;0;False;0;False;1;1.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;266.9093,451.2789;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;297.9093,367.2789;Inherit;False;Property;_Opacity;Opacity;5;0;Create;True;0;0;0;False;0;False;1;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;34;49.01929,81.95444;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;42;66.68845,813.043;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-107.3116,886.043;Inherit;False;Property;_MovementSize;MovementSize;7;0;Create;True;0;0;0;False;0;False;4.22;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;3;401.4847,34.588;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;518.9093,426.2789;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;48;350.6885,1156.043;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-314.3115,787.043;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;489.6886,855.043;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;46;467.0631,649.7281;Inherit;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;41;94.56493,1054.939;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;50;339.6885,995.043;Inherit;False;Constant;_Vector1;Vector 1;9;0;Create;True;0;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;780.3257,44.90301;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;FireballTrail;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ColorNode;4;-209.183,-107.2124;Inherit;False;Property;_Color;Color;2;0;Create;True;0;0;0;False;0;False;1,0.8579727,0,0;1,0.682353,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-207.8897,-293.7437;Inherit;False;Property;_ColorFade;ColorFade;1;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0.2,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;216.9697,-205.1245;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;215.9697,-106.1245;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;55;9.969727,-142.1245;Inherit;False;Property;_HDR;HDR;8;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
WireConnection;12;0;16;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;52;0;1;1
WireConnection;8;1;11;0
WireConnection;6;1;8;0
WireConnection;15;0;52;0
WireConnection;7;0;15;0
WireConnection;7;1;6;4
WireConnection;18;1;7;0
WireConnection;18;2;20;0
WireConnection;19;0;18;0
WireConnection;34;0;7;0
WireConnection;34;4;35;0
WireConnection;42;0;45;0
WireConnection;42;1;43;0
WireConnection;3;0;53;0
WireConnection;3;1;54;0
WireConnection;3;2;34;0
WireConnection;21;0;22;0
WireConnection;21;1;19;0
WireConnection;44;0;42;0
WireConnection;44;1;50;0
WireConnection;44;2;48;4
WireConnection;0;0;3;0
WireConnection;0;2;3;0
WireConnection;0;9;21;0
WireConnection;53;0;5;0
WireConnection;53;1;55;0
WireConnection;54;0;4;0
WireConnection;54;1;55;0
ASEEND*/
//CHKSM=8B6E28EC056F98EE49BBA36D1FF8D405062D6348