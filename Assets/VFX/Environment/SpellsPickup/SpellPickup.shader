// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpellPickup"
{
	Properties
	{
		_Color("Color", Color) = (1,0.7882353,0,0)
		_Fresnel_Bias("Fresnel_Bias", Float) = 0
		_Fresnel_Scale("Fresnel_Scale", Float) = 1
		_Fresnel_Power("Fresnel_Power", Float) = 5
		[Toggle]_hasLogo("hasLogo", Float) = 1
		_Logo("Logo", 2D) = "white" {}
		_Bloom("Bloom", Float) = 1
		_Logo_Offset("Logo_Offset", Vector) = (0,0,0,0)
		_Logo_Tiling("Logo_Tiling", Float) = 1.83
		_Whirl_Offset("Whirl_Offset", Vector) = (0.03,0,0,0)
		_Whirl_Fade("Whirl_Fade", Float) = 0
		_Whirl_Color("Whirl_Color", Color) = (1,0,0,0)
		_WhirlSpeed("WhirlSpeed", Float) = 0
		_WhirlRotationIntensity("WhirlRotationIntensity", Float) = 0
		_hdr("hdr", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _hasLogo;
		uniform float4 _Color;
		uniform float _hdr;
		uniform float4 _Whirl_Color;
		uniform float _Whirl_Fade;
		uniform float2 _Whirl_Offset;
		uniform float _WhirlSpeed;
		uniform float _WhirlRotationIntensity;
		uniform sampler2D _Logo;
		uniform float _Logo_Tiling;
		uniform float2 _Logo_Offset;
		uniform float _Bloom;
		uniform float _Fresnel_Bias;
		uniform float _Fresnel_Scale;
		uniform float _Fresnel_Power;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TexCoord84 = i.uv_texcoord + _Whirl_Offset;
			float2 CenteredUV15_g1 = ( uv_TexCoord84 - float2( 0.5,0.5 ) );
			float2 break17_g1 = CenteredUV15_g1;
			float2 appendResult23_g1 = (float2(( length( CenteredUV15_g1 ) * 1.0 * 2.0 ) , ( atan2( break17_g1.x , break17_g1.y ) * ( 1.0 / 6.28318548202515 ) * 0.0 )));
			float2 CenteredUV15_g3 = ( ( i.uv_texcoord * float2( 1,1 ) ) - ( 1.0 - ( _Whirl_Offset + float2( 0.5,0.5 ) ) ) );
			float2 break17_g3 = CenteredUV15_g3;
			float2 appendResult23_g3 = (float2(( length( CenteredUV15_g3 ) * 1.0 * 2.0 ) , ( atan2( break17_g3.x , break17_g3.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 break12_g2 = appendResult23_g3;
			float mulTime94 = _Time.y * _WhirlSpeed;
			float temp_output_15_0_g2 = ( ( break12_g2.y - ( ( ( sin( mulTime94 ) * _WhirlRotationIntensity ) / 6.28318548202515 ) * break12_g2.x ) ) * 8.0 );
			float temp_output_20_0_g2 = ( abs( ( temp_output_15_0_g2 - round( temp_output_15_0_g2 ) ) ) * 2.0 );
			float smoothstepResult22_g2 = smoothstep( 0.45 , 0.55 , temp_output_20_0_g2);
			float smoothstepResult89 = smoothstep( 0.0 , _Whirl_Fade , ( ( 1.0 - appendResult23_g1.x ) * smoothstepResult22_g2 ));
			float4 lerpResult75 = lerp( ( _Color * _hdr ) , ( _Whirl_Color * _hdr ) , smoothstepResult89);
			float2 temp_cast_0 = (_Logo_Tiling).xx;
			float2 uv_TexCoord23 = i.uv_texcoord * temp_cast_0 + _Logo_Offset;
			float4 tex2DNode22 = tex2D( _Logo, uv_TexCoord23 );
			float4 lerpResult21 = lerp( lerpResult75 , tex2DNode22 , tex2DNode22.a);
			float4 temp_cast_1 = (_Bloom).xxxx;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV3 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode3 = ( _Fresnel_Bias + _Fresnel_Scale * pow( 1.0 - fresnelNdotV3, _Fresnel_Power ) );
			float clampResult5 = clamp( fresnelNode3 , 0.0 , 1.0 );
			float4 lerpResult4 = lerp( (( _hasLogo )?( lerpResult21 ):( lerpResult75 )) , temp_cast_1 , clampResult5);
			o.Emission = lerpResult4.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;262,-1;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SpellPickup;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-1215.966,-206.0067;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;43;-1480.693,-103.4955;Inherit;False;Property;_Logo_Offset;Logo_Offset;7;0;Create;True;0;0;0;False;0;False;0,0;-0.55,-1.52;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;45;-1531.533,-182.6039;Inherit;False;Property;_Logo_Tiling;Logo_Tiling;8;0;Create;True;0;0;0;False;0;False;1.83;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;73;-1730.477,-852.4302;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1547.76,-851.3465;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;72;-1874.693,-854.6696;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;84;-2373.234,-857.3911;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;85;-2626.036,-807.2911;Inherit;False;Property;_Whirl_Offset;Whirl_Offset;9;0;Create;True;0;0;0;False;0;False;0.03,0;0.24,0.03;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-2209.232,-710.3911;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;88;-2086.23,-710.3911;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;97;-2223.231,-602.7913;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-2583.234,-603.7913;Inherit;False;Property;_WhirlSpeed;WhirlSpeed;12;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;94;-2406.233,-603.7913;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-2349.232,-529.7912;Inherit;False;Property;_WhirlRotationIntensity;WhirlRotationIntensity;13;0;Create;True;0;0;0;False;0;False;0;3.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-2085.329,-602.1913;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;89;-1279.628,-853.8911;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-1492.228,-631.991;Inherit;False;Property;_Whirl_Fade;Whirl_Fade;10;0;Create;True;0;0;0;False;0;False;0;4.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;75;-927.8585,-461.821;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1037.863,144.6658;Inherit;False;Property;_Fresnel_Bias;Fresnel_Bias;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1037.863,211.6657;Inherit;False;Property;_Fresnel_Scale;Fresnel_Scale;2;0;Create;True;0;0;0;False;0;False;1;0.015;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1040.863,278.6658;Inherit;False;Property;_Fresnel_Power;Fresnel_Power;3;0;Create;True;0;0;0;False;0;False;5;1.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;3;-726.865,96.66575;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;5;-381.0927,97.10204;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-384.8886,18.08771;Inherit;False;Property;_Bloom;Bloom;6;0;Create;True;0;0;0;False;0;False;1;65.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1792.929,-553.7101;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;0;False;0;False;1,0.7882353,0,0;1,0.6392157,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;78;-1800.969,-382.4481;Inherit;False;Property;_Whirl_Color;Whirl_Color;11;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;112;-1542.092,-428.8684;Inherit;False;Property;_hdr;hdr;14;0;Create;True;0;0;0;False;0;False;0;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-1260.092,-554.8684;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-1201.092,-383.8684;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;22;-977.1183,-229.6918;Inherit;True;Property;_Logo;Logo;5;0;Create;True;0;0;0;False;0;False;-1;e884b778de9e6244c964bd0092b20791;8b64123dc25195d4db22894407fdb0f0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;21;-602.0092,-182.469;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;114;-394.8651,-205.5957;Inherit;False;Property;_hasLogo;hasLogo;4;0;Create;True;0;0;0;False;0;False;1;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;4;-85.1036,47.80294;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;116;-1796.318,-735.3306;Inherit;False;Whirl;-1;;2;7d75aee9e4d352a4299928ac98404afc;2,26,0,25,1;6;27;FLOAT2;0,0;False;1;FLOAT2;1,1;False;7;FLOAT2;0.5,0.5;False;16;FLOAT;8;False;21;FLOAT;2;False;10;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;115;-2121.301,-855.3401;Inherit;False;Polar Coordinates;-1;;1;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT2;0
WireConnection;0;2;4;0
WireConnection;23;0;45;0
WireConnection;23;1;43;0
WireConnection;73;0;72;0
WireConnection;69;0;73;0
WireConnection;69;1;116;0
WireConnection;72;0;115;0
WireConnection;84;1;85;0
WireConnection;87;0;85;0
WireConnection;88;0;87;0
WireConnection;97;0;94;0
WireConnection;94;0;98;0
WireConnection;99;0;97;0
WireConnection;99;1;100;0
WireConnection;89;0;69;0
WireConnection;89;2;90;0
WireConnection;75;0;111;0
WireConnection;75;1;113;0
WireConnection;75;2;89;0
WireConnection;3;1;7;0
WireConnection;3;2;10;0
WireConnection;3;3;11;0
WireConnection;5;0;3;0
WireConnection;111;0;2;0
WireConnection;111;1;112;0
WireConnection;113;0;78;0
WireConnection;113;1;112;0
WireConnection;22;1;23;0
WireConnection;21;0;75;0
WireConnection;21;1;22;0
WireConnection;21;2;22;4
WireConnection;114;0;75;0
WireConnection;114;1;21;0
WireConnection;4;0;114;0
WireConnection;4;1;12;0
WireConnection;4;2;5;0
WireConnection;116;7;88;0
WireConnection;116;10;99;0
WireConnection;115;1;84;0
ASEEND*/
//CHKSM=809F3FBC0D354700EE963187EEF0BC34A8B34D73