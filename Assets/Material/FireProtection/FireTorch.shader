// Made with Amplify Shader Editor v1.9.0.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FireTorch"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 12
		_TessMin( "Tess Min Distance", Float ) = 0
		_TessMax( "Tess Max Distance", Float ) = 10
		_FireProtectionText("FireProtectionText", 2D) = "white" {}
		_Color0("Color 0", Color) = (1,0.09565188,0,0)
		_Color1("Color 1", Color) = (1,0.49695,0,0)
		_Color2("Color 2", Color) = (1,0.9027058,0,0)
		_StepR("StepR", Range( 0 , 1)) = 0.76
		_StepG("StepG", Range( 0 , 1)) = 0
		_StepB("StepB", Range( 0 , 1)) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_Start("Start", Range( -1 , 1)) = 0
		_Smoothstep("Smoothstep", Range( 0 , 2)) = 1.86
		_Remap("Remap", Range( -1 , 1)) = -0.11
		_VOffsetIntensity("VOffsetIntensity", Vector) = (0,0,0,0)
		_NoiseScale("NoiseScale", Float) = 1.47
		_NoiseSpeed("NoiseSpeed", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit alpha:fade keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Smoothstep;
		uniform float _Remap;
		uniform float _NoiseSpeed;
		uniform float _NoiseScale;
		uniform float3 _VOffsetIntensity;
		uniform float4 _Color0;
		uniform float _StepR;
		uniform sampler2D _FireProtectionText;
		uniform float4 _FireProtectionText_ST;
		uniform float4 _Color1;
		uniform float _StepG;
		uniform float4 _Color2;
		uniform float _StepB;
		uniform float _Opacity;
		uniform float _Start;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;


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
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float smoothstepResult21 = smoothstep( 0.0 , _Smoothstep , (_Remap + (v.texcoord.xy.y - 0.0) * (1.0 - _Remap) / (1.0 - 0.0)));
			float2 uv_TexCoord4 = v.texcoord.xy + ( float2( 0,-1 ) * ( _Time.y + 1000.0 ) * _NoiseSpeed );
			float simplePerlin2D61 = snoise( uv_TexCoord4*_NoiseScale );
			simplePerlin2D61 = simplePerlin2D61*0.5 + 0.5;
			v.vertex.xyz += ( ( smoothstepResult21 * simplePerlin2D61 ) * _VOffsetIntensity );
			v.vertex.w = 1;
			//Calculate new billboard vertex position and normal;
			float3 upCamVec = float3( 0, 1, 0 );
			float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
			float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
			float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
			v.normal = normalize( mul( float4( v.normal , 0 ), rotationCamMatrix )).xyz;
			v.tangent.xyz = normalize( mul( float4( v.tangent.xyz , 0 ), rotationCamMatrix )).xyz;
			//This unfortunately must be made to take non-uniform scaling into account;
			//Transform to world coords, apply rotation and transform back to local;
			v.vertex = mul( v.vertex , unity_ObjectToWorld );
			v.vertex = mul( v.vertex , rotationCamMatrix );
			v.vertex = mul( v.vertex , unity_WorldToObject );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_FireProtectionText = i.uv_texcoord * _FireProtectionText_ST.xy + _FireProtectionText_ST.zw;
			float4 tex2DNode22 = tex2D( _FireProtectionText, uv_FireProtectionText );
			float temp_output_3_0_g1 = ( _StepR - tex2DNode22.r );
			float4 lerpResult72 = lerp( float4( 0,0,0,0 ) , _Color0 , ( 1.0 - saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) ) ));
			float temp_output_3_0_g3 = ( _StepG - tex2DNode22.g );
			float4 lerpResult73 = lerp( lerpResult72 , _Color1 , ( 1.0 - saturate( ( temp_output_3_0_g3 / fwidth( temp_output_3_0_g3 ) ) ) ));
			float temp_output_3_0_g2 = ( _StepB - tex2DNode22.b );
			float4 lerpResult74 = lerp( lerpResult73 , _Color2 , ( 1.0 - saturate( ( temp_output_3_0_g2 / fwidth( temp_output_3_0_g2 ) ) ) ));
			o.Emission = lerpResult74.rgb;
			float clampResult100 = clamp( ( _Start + (-1.0 + (( 1.0 - i.uv_texcoord.y ) - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) , 0.0 , 1.0 );
			o.Alpha = ( tex2DNode22.a * _Opacity * clampResult100 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19001
1920;0;1920;1019;1943.026;565.9359;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;93;-1110.297,529.6019;Inherit;False;1961.672;924.3547;;16;5;23;6;35;16;7;20;4;62;34;21;61;79;19;29;103;VertexOffset;1,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;94;-1437.01,-1396.921;Inherit;False;2223.096;1333.053;;17;83;80;87;44;88;84;82;72;45;89;81;70;73;90;74;92;91;Emissive;1,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;5;-1060.297,1227.456;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-1387.01,-1089.897;Inherit;False;Property;_StepR;StepR;9;0;Create;True;0;0;0;False;0;False;0.76;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1047.537,1312.075;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;18;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-723.86,571.7842;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-870.3173,1165.641;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1000;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-1843.832,-1180.96;Inherit;True;Property;_FireProtectionText;FireProtectionText;5;0;Create;True;0;0;0;False;0;False;-1;8cee8893963379a4aba100198d766a13;e884b778de9e6244c964bd0092b20791;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;6;-1057.493,1083.556;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;0,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;80;-1068.621,-1151.419;Inherit;False;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-1015.1,-721.6376;Inherit;False;Property;_StepG;StepG;10;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;97;-443.7005,340.7333;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-735.099,693.5483;Inherit;False;Property;_Remap;Remap;15;0;Create;True;0;0;0;False;0;False;-0.11;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-657.4931,1090.056;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-486.0988,793.5479;Inherit;False;Property;_Smoothstep;Smoothstep;14;0;Create;True;0;0;0;False;0;False;1.86;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-539.9075,-258.7991;Inherit;False;Property;_StepB;StepB;11;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;101;-263.0753,339.8906;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;44;-859.0908,-1346.921;Inherit;False;Property;_Color0;Color 0;6;0;Create;True;0;0;0;False;0;False;1,0.09565188,0,0;1,0.6744842,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;99;-484.412,161.2285;Inherit;False;Property;_Start;Start;13;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;20;-395.9538,624.6016;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.11;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-451.3939,1042.856;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;84;-822.5024,-1150.301;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-420.8878,1187.586;Inherit;False;Property;_NoiseScale;NoiseScale;17;0;Create;True;0;0;0;False;0;False;1.47;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;82;-665.7578,-738.9751;Inherit;False;Step Antialiasing;-1;;3;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;91;-978.5643,-591.1815;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;61;-97.21248,1040.619;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;89;-356.3536,-737.533;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;6.214903,316.4335;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;-410.0974,-925.0671;Inherit;False;Property;_Color1;Color 1;7;0;Create;True;0;0;0;False;0;False;1,0.49695,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;81;-83.40701,-269.842;Inherit;False;Step Antialiasing;-1;;2;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;72;-484.7094,-1192.664;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;21;-157.9544,626.3029;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.86;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;79;415.5303,1265.956;Inherit;False;Property;_VOffsetIntensity;VOffsetIntensity;16;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;90;218.7375,-268.089;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;92;-633.0341,-198.9238;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;100;395.1171,315.7115;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;368.3383,217.1198;Inherit;False;Property;_Opacity;Opacity;12;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;70;109.8725,-447.1814;Inherit;False;Property;_Color2;Color 2;8;0;Create;True;0;0;0;False;0;False;1,0.9027058,0,0;1,0.9027058,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;73;14.75906,-782.1611;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;316.2237,1024.995;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;102;338.8151,71.91763;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;689.3765,1023.388;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;910.3628,196.1741;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;74;521.0857,-317.8677;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1104.643,3.97685;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;FireTorch;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;0;12;0;10;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;True;Cylindrical;False;True;Relative;0;;-1;-1;-1;0;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;103;0;5;0
WireConnection;80;1;22;1
WireConnection;80;2;83;0
WireConnection;97;0;16;2
WireConnection;7;0;6;0
WireConnection;7;1;103;0
WireConnection;7;2;23;0
WireConnection;101;0;97;0
WireConnection;20;0;16;2
WireConnection;20;3;35;0
WireConnection;4;1;7;0
WireConnection;84;0;80;0
WireConnection;82;1;22;2
WireConnection;82;2;87;0
WireConnection;91;0;22;3
WireConnection;61;0;4;0
WireConnection;61;1;62;0
WireConnection;89;0;82;0
WireConnection;96;0;99;0
WireConnection;96;1;101;0
WireConnection;81;1;91;0
WireConnection;81;2;88;0
WireConnection;72;1;44;0
WireConnection;72;2;84;0
WireConnection;21;0;20;0
WireConnection;21;2;34;0
WireConnection;90;0;81;0
WireConnection;92;0;22;4
WireConnection;100;0;96;0
WireConnection;73;0;72;0
WireConnection;73;1;45;0
WireConnection;73;2;89;0
WireConnection;19;0;21;0
WireConnection;19;1;61;0
WireConnection;29;0;19;0
WireConnection;29;1;79;0
WireConnection;63;0;92;0
WireConnection;63;1;64;0
WireConnection;63;2;100;0
WireConnection;74;0;73;0
WireConnection;74;1;70;0
WireConnection;74;2;90;0
WireConnection;0;2;74;0
WireConnection;0;9;63;0
WireConnection;0;11;29;0
ASEEND*/
//CHKSM=D906BCEF82D173EF1520F91EB9E1EFFFCFC6D1BA