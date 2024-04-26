// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Aura"
{
	Properties
	{
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		_DepthFade_Distance("DepthFade_Distance", Float) = 2
		_Fresnel_Parameters("Fresnel_Parameters", Vector) = (0,1,5,0)
		_Inside_Fade("Inside_Fade", Range( 0 , 1)) = 0.1
		_Noise_Scale("Noise_Scale", Float) = 30
		_Noise_Speed("Noise_Speed", Range( 0 , 1)) = 0.1
		_Rotator_Anchor("Rotator_Anchor", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float3 worldNormal;
			float4 screenPosition1;
			float3 worldPos;
			float3 viewDir;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color0;
		uniform float _Rotator_Anchor;
		uniform float _Noise_Speed;
		uniform float _Noise_Scale;
		uniform float _Inside_Fade;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFade_Distance;
		uniform float3 _Fresnel_Parameters;


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos1 = ase_vertex3Pos;
			float4 ase_screenPos1 = ComputeScreenPos( UnityObjectToClipPos( vertexPos1 ) );
			o.screenPosition1 = ase_screenPos1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = i.worldNormal;
			float2 appendResult73 = (float2(ase_worldNormal.x , ase_worldNormal.z));
			float2 temp_cast_0 = (_Rotator_Anchor).xx;
			float mulTime68 = _Time.y * _Noise_Speed;
			float cos71 = cos( mulTime68 );
			float sin71 = sin( mulTime68 );
			float2 rotator71 = mul( appendResult73 - temp_cast_0 , float2x2( cos71 , -sin71 , sin71 , cos71 )) + temp_cast_0;
			float simpleNoise21 = SimpleNoise( rotator71*_Noise_Scale );
			float2 appendResult31 = (float2(ase_worldNormal.x , ase_worldNormal.y));
			float2 temp_cast_1 = (_Rotator_Anchor).xx;
			float mulTime77 = _Time.y * _Noise_Speed;
			float cos76 = cos( mulTime77 );
			float sin76 = sin( mulTime77 );
			float2 rotator76 = mul( appendResult31 - temp_cast_1 , float2x2( cos76 , -sin76 , sin76 , cos76 )) + temp_cast_1;
			float simpleNoise34 = SimpleNoise( rotator76*_Noise_Scale );
			float2 appendResult32 = (float2(ase_worldNormal.y , ase_worldNormal.z));
			float2 temp_cast_2 = (_Rotator_Anchor).xx;
			float mulTime75 = _Time.y * _Noise_Speed;
			float cos74 = cos( mulTime75 );
			float sin74 = sin( mulTime75 );
			float2 rotator74 = mul( appendResult32 - temp_cast_2 , float2x2( cos74 , -sin74 , sin74 , cos74 )) + temp_cast_2;
			float simpleNoise35 = SimpleNoise( rotator74*_Noise_Scale );
			float temp_output_49_0 = saturate( ( ( saturate( ( simpleNoise21 * abs( ase_worldNormal.y ) ) ) + saturate( ( simpleNoise34 * abs( ase_worldNormal.z ) ) ) + saturate( ( simpleNoise35 * abs( ase_worldNormal.x ) ) ) ) / 3.0 ) );
			o.Emission = ( _Color0 * temp_output_49_0 ).rgb;
			float4 ase_screenPos1 = i.screenPosition1;
			float4 ase_screenPosNorm1 = ase_screenPos1 / ase_screenPos1.w;
			ase_screenPosNorm1.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm1.z : ase_screenPosNorm1.z * 0.5 + 0.5;
			float screenDepth1 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm1.xy ));
			float distanceDepth1 = saturate( abs( ( screenDepth1 - LinearEyeDepth( ase_screenPosNorm1.z ) ) / ( _DepthFade_Distance ) ) );
			float fresnelNdotV10 = dot( ase_worldNormal, i.viewDir );
			float fresnelNode10 = ( _Fresnel_Parameters.x + _Fresnel_Parameters.y * pow( 1.0 - fresnelNdotV10, _Fresnel_Parameters.z ) );
			float lerpResult20 = lerp( _Inside_Fade , 1.0 , saturate( ( ( 1.0 - distanceDepth1 ) + saturate( fresnelNode10 ) ) ));
			o.Alpha = ( lerpResult20 * step( (0.0 + (temp_output_49_0 - 0.0) * (1.0 - 0.0) / (0.45 - 0.0)) , i.vertexColor.a ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,-16;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Aura;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.PosVertexDataNode;2;-2224,112;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;1;-2000,112;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2256,256;Inherit;False;Property;_DepthFade_Distance;DepthFade_Distance;1;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;4;-1744,112;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;12;-1744,352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;15;-2336,496;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;19;-2336,640;Inherit;False;Property;_Fresnel_Parameters;Fresnel_Parameters;2;0;Create;True;0;0;0;False;0;False;0,1,5;0,1,5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;10;-2032,352;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1568,112;Inherit;False;Property;_Inside_Fade;Inside_Fade;3;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1568,192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;17;-1440,192;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;-1280,144;Inherit;False;3;0;FLOAT;0.075;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;57;-2453.378,538.1655;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-208,208;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;46;-2144,1392;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1984,1312;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;40;-1824,1312;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;34;-2400,1312;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1984,1696;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;47;-2144,1776;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;41;-1808,1696;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;35;-2400,1696;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;45;-2144,1008;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1984,928;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;37;-1824,928;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;21;-2400,928;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-2688,1056;Inherit;False;Property;_Noise_Scale;Noise_Scale;4;0;Create;True;0;0;0;False;0;False;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;55;-2208,1552;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;56;-2192,1664;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;54;-2208,1168;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-1568,928;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;50;-1456,928;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;49;-1344,928;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;62;-784,928;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.27;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-208,32;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;9;-688,32;Inherit;False;Property;_Color0;Color 0;0;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;66;-1008,1152;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;14;-4320,1280;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;73;-3136,928;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;68;-3168,1024;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;31;-2944,1312;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;75;-2960,1808;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;-2928,1696;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;77;-2976,1424;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-3600,1808;Inherit;False;Property;_Noise_Speed;Noise_Speed;5;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;74;-2736,1696;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;76;-2736,1312;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;71;-2944,928;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-3168,1168;Inherit;False;Property;_Rotator_Anchor;Rotator_Anchor;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;60;-1088,928;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.45;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
WireConnection;0;2;52;0
WireConnection;0;9;53;0
WireConnection;1;1;2;0
WireConnection;1;0;3;0
WireConnection;4;0;1;0
WireConnection;12;0;10;0
WireConnection;10;0;57;0
WireConnection;10;4;15;0
WireConnection;10;1;19;1
WireConnection;10;2;19;2
WireConnection;10;3;19;3
WireConnection;16;0;4;0
WireConnection;16;1;12;0
WireConnection;17;0;16;0
WireConnection;20;0;23;0
WireConnection;20;2;17;0
WireConnection;57;0;14;0
WireConnection;53;0;20;0
WireConnection;53;1;62;0
WireConnection;46;0;55;0
WireConnection;38;0;34;0
WireConnection;38;1;46;0
WireConnection;40;0;38;0
WireConnection;34;0;76;0
WireConnection;34;1;51;0
WireConnection;39;0;35;0
WireConnection;39;1;47;0
WireConnection;47;0;56;0
WireConnection;41;0;39;0
WireConnection;35;0;74;0
WireConnection;35;1;51;0
WireConnection;45;0;54;0
WireConnection;36;0;21;0
WireConnection;36;1;45;0
WireConnection;37;0;36;0
WireConnection;21;0;71;0
WireConnection;21;1;51;0
WireConnection;55;0;14;3
WireConnection;56;0;14;1
WireConnection;54;0;14;2
WireConnection;48;0;37;0
WireConnection;48;1;40;0
WireConnection;48;2;41;0
WireConnection;50;0;48;0
WireConnection;49;0;50;0
WireConnection;62;0;60;0
WireConnection;62;1;66;4
WireConnection;52;0;9;0
WireConnection;52;1;49;0
WireConnection;73;0;14;1
WireConnection;73;1;14;3
WireConnection;68;0;79;0
WireConnection;31;0;14;1
WireConnection;31;1;14;2
WireConnection;75;0;79;0
WireConnection;32;0;14;2
WireConnection;32;1;14;3
WireConnection;77;0;79;0
WireConnection;74;0;32;0
WireConnection;74;1;80;0
WireConnection;74;2;75;0
WireConnection;76;0;31;0
WireConnection;76;1;80;0
WireConnection;76;2;77;0
WireConnection;71;0;73;0
WireConnection;71;1;80;0
WireConnection;71;2;68;0
WireConnection;60;0;49;0
ASEEND*/
//CHKSM=E4D1E710470996AAAE44A859C4075AAA0D124685