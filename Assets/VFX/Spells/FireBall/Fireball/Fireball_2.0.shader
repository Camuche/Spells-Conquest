// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Fireball_2.0"
{
	Properties
	{
		_Fresnel_Scale("Fresnel_Scale", Float) = 1
		_Color0("Color 0", Color) = (1,1,0,0)
		_Fresnel_Power("Fresnel_Power", Float) = 5
		_VertexOffset_Intensity("VertexOffset_Intensity", Range( 0 , 0.2)) = 0
		_NoiseScale("NoiseScale", Float) = 13.25
		_Time_Speed("Time_Speed", Float) = 0
		_Tess("Tess", Float) = 0
		_SmoothStep("SmoothStep", Float) = 0.29
		_SmoothStepWave("SmoothStepWave", Float) = 0.29
		_VoronoisScale("VoronoisScale", Float) = 10
		_WaveIntensity("WaveIntensity", Float) = 1
		_Float0("Float 0", Float) = 1
		_Float1("Float 1", Float) = 0
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
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _VertexOffset_Intensity;
		uniform float _Time_Speed;
		uniform float _NoiseScale;
		uniform float _SmoothStep;
		uniform float _WaveIntensity;
		uniform float _SmoothStepWave;
		uniform float4 _Color0;
		uniform float _hdr;
		uniform float _VoronoisScale;
		uniform float _Fresnel_Scale;
		uniform float _Fresnel_Power;
		uniform float _Float1;
		uniform float _Float0;
		uniform float _Tess;


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


		float2 voronoihash43( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi43( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash43( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_1 = (_Tess).xxxx;
			return temp_cast_1;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float temp_output_14_0 = ( _Time.y * _Time_Speed );
			float2 temp_cast_0 = (temp_output_14_0).xx;
			float2 uv_TexCoord9 = v.texcoord.xy + temp_cast_0;
			float simplePerlin2D7 = snoise( uv_TexCoord9*_NoiseScale );
			simplePerlin2D7 = simplePerlin2D7*0.5 + 0.5;
			float3 ase_vertexNormal = v.normal.xyz;
			float smoothstepResult34 = smoothstep( _SmoothStep , 1.0 , ( 1.0 - v.texcoord.xy.y ));
			float smoothstepResult68 = smoothstep( _SmoothStepWave , 1.0 , ( 1.0 - v.texcoord.xy.y ));
			float mulTime96 = _Time.y * 8.0;
			v.vertex.xyz += ( ( _VertexOffset_Intensity * simplePerlin2D7 * ase_vertexNormal * smoothstepResult34 ) + ( _WaveIntensity * smoothstepResult68 * sin( mulTime96 ) * float3(1,0,0) ) );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 color4 = IsGammaSpace() ? float4(1,0.6666667,0,0) : float4(1,0.4019779,0,0);
			float4 temp_output_107_0 = ( color4 * _hdr );
			float time43 = 0.0;
			float2 voronoiSmoothId43 = 0;
			float temp_output_14_0 = ( _Time.y * _Time_Speed );
			float2 uv_TexCoord44 = i.uv_texcoord + ( float2( 0,3 ) * temp_output_14_0 );
			float2 coords43 = uv_TexCoord44 * _VoronoisScale;
			float2 id43 = 0;
			float2 uv43 = 0;
			float voroi43 = voronoi43( coords43, time43, id43, uv43, 0, voronoiSmoothId43 );
			float4 lerpResult46 = lerp( ( _Color0 * _hdr ) , temp_output_107_0 , (0.0 + (voroi43 - 0.0) * (3.0 - 0.0) / (1.0 - 0.0)));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1 = ( 0.0 + _Fresnel_Scale * pow( 1.0 - fresnelNdotV1, _Fresnel_Power ) );
			float4 lerpResult2 = lerp( lerpResult46 , temp_output_107_0 , fresnelNode1);
			float4 temp_cast_0 = (1.0).xxxx;
			float fresnelNdotV52 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode52 = ( 0.0 + 1.37 * pow( 1.0 - fresnelNdotV52, 0.38 ) );
			float clampResult57 = clamp( ( 1.0 - fresnelNode52 ) , 0.0 , 1.0 );
			float4 lerpResult54 = lerp( lerpResult2 , temp_cast_0 , clampResult57);
			float4 temp_cast_1 = (_Float1).xxxx;
			float4 temp_cast_2 = (_Float0).xxxx;
			o.Emission = (temp_cast_1 + (lerpResult54 - float4( 0,0,0,0 )) * (temp_cast_2 - temp_cast_1) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.LerpOp;54;58.05305,55.32305;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2;-583.1459,37.45132;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;46;-1034.854,30.16847;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-6.339434,360.3115;Inherit;False;Property;_Tess;Tess;6;0;Create;True;0;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-148.4435,631.1586;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-704.0779,632.6927;Inherit;False;Property;_VertexOffset_Intensity;VertexOffset_Intensity;3;0;Create;True;0;0;0;False;0;False;0;0.05;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;7;-662.2743,705.4246;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;17;-617.9325,919.5454;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1041.275,704.4246;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-1016.274,826.4246;Inherit;False;Property;_NoiseScale;NoiseScale;4;0;Create;True;0;0;0;False;0;False;13.25;14.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-2499.205,389.3304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-2709.574,391.1901;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2704.767,465.3484;Inherit;False;Property;_Time_Speed;Time_Speed;5;0;Create;True;0;0;0;False;0;False;0;0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;1;-965.2823,307.2728;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1203.118,380.8742;Inherit;False;Property;_Fresnel_Scale;Fresnel_Scale;0;0;Create;True;0;0;0;False;0;False;1;2.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1204.818,452.8741;Inherit;False;Property;_Fresnel_Power;Fresnel_Power;2;0;Create;True;0;0;0;False;0;False;5;1.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-1693.211,-455.8105;Inherit;False;Constant;_Color1;Color 1;0;0;Create;True;0;0;0;False;0;False;1,0.6666667,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;58;-215.1937,130.1383;Inherit;False;Constant;_Float2;Float 2;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;57;-136.8682,-308.6012;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;53;-334.868,-312.0012;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;52;-670.3651,-311.1545;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1.37;False;3;FLOAT;0.38;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;34;-660.9291,1074.224;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.12;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;30;-849.929,1072.224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-1120.929,1024.224;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-887.929,1153.224;Inherit;False;Property;_SmoothStep;SmoothStep;7;0;Create;True;0;0;0;False;0;False;0.29;0.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-288.065,1554.633;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-570.4646,1551.256;Inherit;False;Property;_WaveIntensity;WaveIntensity;10;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;69;-796.0546,1621.848;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;70;-1067.054,1573.848;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-834.0547,1702.848;Inherit;False;Property;_SmoothStepWave;SmoothStepWave;8;0;Create;True;0;0;0;False;0;False;0.29;0.74;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;68;-609.5545,1622.448;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.12;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;95;-562.4445,1837.39;Inherit;True;1;0;FLOAT;18.98;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;96;-785.7899,1835.67;Inherit;False;1;0;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;64;-568.045,2046.89;Inherit;False;Constant;_Vector1;Vector 1;8;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;100;56.24264,673.5556;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-1913.707,71.99273;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-2121.306,119.7394;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;50;-2382.019,119.2304;Inherit;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.VoronoiNode;43;-1642.707,70.99271;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;13.21;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;48;-1885.822,200.8656;Inherit;False;Property;_VoronoisScale;VoronoisScale;9;0;Create;True;0;0;0;False;0;False;10;7.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;47;-1434.41,72.24395;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;101;259.0205,-217.7593;Inherit;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;103;70.02051,-64.75934;Inherit;False;Property;_Float0;Float 0;11;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;70.02051,-135.7593;Inherit;False;Property;_Float1;Float 1;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;574.4446,26.29801;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;Fireball_2.0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ColorNode;3;-1691.558,-624.7281;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-1320.651,-554.7037;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-1547.999,-214.155;Inherit;False;Property;_hdr;hdr;13;0;Create;True;0;0;0;False;0;False;0;1.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-1305.999,-305.155;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
WireConnection;54;0;2;0
WireConnection;54;1;58;0
WireConnection;54;2;57;0
WireConnection;2;0;46;0
WireConnection;2;1;107;0
WireConnection;2;2;1;0
WireConnection;46;0;105;0
WireConnection;46;1;107;0
WireConnection;46;2;47;0
WireConnection;12;0;13;0
WireConnection;12;1;7;0
WireConnection;12;2;17;0
WireConnection;12;3;34;0
WireConnection;7;0;9;0
WireConnection;7;1;8;0
WireConnection;9;1;14;0
WireConnection;14;0;11;0
WireConnection;14;1;15;0
WireConnection;1;2;5;0
WireConnection;1;3;6;0
WireConnection;57;0;53;0
WireConnection;53;0;52;0
WireConnection;34;0;30;0
WireConnection;34;1;35;0
WireConnection;30;0;29;2
WireConnection;65;0;66;0
WireConnection;65;1;68;0
WireConnection;65;2;95;0
WireConnection;65;3;64;0
WireConnection;69;0;70;2
WireConnection;68;0;69;0
WireConnection;68;1;71;0
WireConnection;95;0;96;0
WireConnection;100;0;12;0
WireConnection;100;1;65;0
WireConnection;44;1;49;0
WireConnection;49;0;50;0
WireConnection;49;1;14;0
WireConnection;43;0;44;0
WireConnection;43;2;48;0
WireConnection;47;0;43;0
WireConnection;101;0;54;0
WireConnection;101;3;104;0
WireConnection;101;4;103;0
WireConnection;0;2;101;0
WireConnection;0;11;100;0
WireConnection;0;14;16;0
WireConnection;105;0;3;0
WireConnection;105;1;106;0
WireConnection;107;0;4;0
WireConnection;107;1;106;0
ASEEND*/
//CHKSM=B2D379E86CB4BA73C755691921AA1F2165B6B2DE