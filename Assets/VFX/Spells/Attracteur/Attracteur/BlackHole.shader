// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BlackHole"
{
	Properties
	{
		_NoiseSpeed("NoiseSpeed", Float) = 1
		_VertexOffset_Intensity("VertexOffset_Intensity", Float) = 0
		_Tesselation("Tesselation", Float) = 10
		_SideColor("SideColor", Color) = (0.1881378,1,0,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_NoiseScale("Noise-Scale", Float) = 0
		_GreenZoneScale("GreenZoneScale", Range( 0 , 1)) = 0.8
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _NoiseSpeed;
		uniform float _NoiseScale;
		uniform float _VertexOffset_Intensity;
		uniform float4 _SideColor;
		uniform float _GreenZoneScale;
		uniform float _Tesselation;
		uniform float _Cutoff = 0.5;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_1 = (_Tesselation).xxxx;
			return temp_cast_1;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float mulTime27 = _Time.y * _NoiseSpeed;
			float2 temp_cast_0 = (mulTime27).xx;
			float2 uv_TexCoord26 = v.texcoord.xy + temp_cast_0;
			float simplePerlin2D19 = snoise( uv_TexCoord26*_NoiseScale );
			simplePerlin2D19 = simplePerlin2D19*0.5 + 0.5;
			float3 ase_vertex3Pos = v.vertex.xyz;
			v.vertex.xyz += ( simplePerlin2D19 * _VertexOffset_Intensity * ase_vertex3Pos );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult11_g1 = (float2(0.9 , 0.9));
			float temp_output_17_0_g1 = length( ( (i.uv_texcoord*2.0 + -1.0) / appendResult11_g1 ) );
			float temp_output_1_0 = saturate( ( ( 1.0 - temp_output_17_0_g1 ) / fwidth( temp_output_17_0_g1 ) ) );
			float temp_output_39_0 = ( ( _SinTime.w / 10.0 ) + _GreenZoneScale );
			float2 appendResult11_g24 = (float2(temp_output_39_0 , temp_output_39_0));
			float temp_output_17_0_g24 = length( ( (i.uv_texcoord*2.0 + -1.0) / appendResult11_g24 ) );
			float temp_output_18_0 = ( temp_output_1_0 - saturate( ( ( 1.0 - temp_output_17_0_g24 ) / fwidth( temp_output_17_0_g24 ) ) ) );
			o.Emission = ( _SideColor * temp_output_18_0 ).rgb;
			o.Alpha = 1;
			clip( temp_output_1_0 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-740.6,73.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;-179.58,249.4029;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1;-470.5999,83.5;Inherit;True;Ellipse;-1;;1;3ba94b7b3cfd5f447befde8107c04d52;0;3;2;FLOAT2;0,0;False;7;FLOAT;0.9;False;9;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;524,-13;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;BlackHole;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;4;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;89.4986,252.6046;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-578.5015,630.6046;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;27;-811.5015,680.6046;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-985.5015,702.6046;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;64.49854,620.6046;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;370.341,526.9785;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;19;-205.3569,621.2155;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-419.269,859.0438;Inherit;False;Property;_NoiseScale;Noise-Scale;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;15;-481.58,288.4029;Inherit;True;Ellipse;-1;;24;3ba94b7b3cfd5f447befde8107c04d52;0;3;2;FLOAT2;0,0;False;7;FLOAT;0.8;False;9;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-740.8135,309.3292;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;38;-926.1127,311.1291;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;34;-1153.159,238.406;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-1081.678,411.0498;Inherit;False;Property;_GreenZoneScale;GreenZoneScale;6;0;Create;True;0;0;0;False;0;False;0.8;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;-142.5014,-80.39536;Inherit;False;Property;_SideColor;SideColor;3;0;Create;True;0;0;0;False;0;False;0.1881378,1,0,0;0.1881378,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;32;88.9697,907.5046;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;21.46624,835.6527;Inherit;False;Property;_VertexOffset_Intensity;VertexOffset_Intensity;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;293.9431,330.784;Inherit;False;Property;_Tesselation;Tesselation;2;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
WireConnection;18;0;1;0
WireConnection;18;1;15;0
WireConnection;1;2;2;0
WireConnection;0;2;22;0
WireConnection;0;10;1;0
WireConnection;0;11;30;0
WireConnection;0;14;20;0
WireConnection;22;0;25;0
WireConnection;22;1;18;0
WireConnection;26;1;27;0
WireConnection;27;0;28;0
WireConnection;29;0;18;0
WireConnection;29;1;19;0
WireConnection;30;0;19;0
WireConnection;30;1;31;0
WireConnection;30;2;32;0
WireConnection;19;0;26;0
WireConnection;19;1;33;0
WireConnection;15;2;2;0
WireConnection;15;7;39;0
WireConnection;15;9;39;0
WireConnection;39;0;38;0
WireConnection;39;1;35;0
WireConnection;38;0;34;4
ASEEND*/
//CHKSM=EB5F79D2D60C5A1B9FBEAA90B2238213138CF40A