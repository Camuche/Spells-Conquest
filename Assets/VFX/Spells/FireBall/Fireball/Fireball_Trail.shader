// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Fireball_Trail"
{
	Properties
	{
		_Tess("Tess", Float) = 10
		_Color0("Color 0", Color) = (1,0.7960784,0,0)
		_VoronoisScale("VoronoisScale", Float) = 10
		_VertexOffset_Intensity("VertexOffset_Intensity", Float) = 1
		_NoiseScale("NoiseScale", Float) = 0
		_Speed("Speed", Float) = 0
		_Offset_Higher("Offset_Higher", Float) = 1
		_Offsett_Lower("Offsett_Lower", Float) = 0
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
		};

		uniform float _VertexOffset_Intensity;
		uniform float _Speed;
		uniform float _NoiseScale;
		uniform float _Offsett_Lower;
		uniform float _Offset_Higher;
		uniform float4 _Color0;
		uniform float _VoronoisScale;
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


		float2 voronoihash7( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi7( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash7( n + g );
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
			float4 temp_cast_2 = (_Tess).xxxx;
			return temp_cast_2;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 temp_cast_0 = (( _Speed * -1.0 * _Time.y )).xx;
			float2 uv_TexCoord17 = v.texcoord.xy + temp_cast_0;
			float2 temp_cast_1 = (uv_TexCoord17.y).xx;
			float simplePerlin2D22 = snoise( temp_cast_1*_NoiseScale );
			simplePerlin2D22 = simplePerlin2D22*0.5 + 0.5;
			v.vertex.xyz += ( _VertexOffset_Intensity * float3(0,1,0) * (_Offsett_Lower + (simplePerlin2D22 - 0.0) * (_Offset_Higher - _Offsett_Lower) / (1.0 - 0.0)) * ( v.texcoord.xy.y * (0.0 + (( 1.0 - v.texcoord.xy.y ) - -0.2) * (1.0 - 0.0) / (1.0 - -0.2)) ) );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 color13 = IsGammaSpace() ? float4(1,0,0,0) : float4(1,0,0,0);
			float time7 = 0.0;
			float2 voronoiSmoothId7 = 0;
			float2 uv_TexCoord4 = i.uv_texcoord + ( float2( 0,-1 ) * _Time.y );
			float2 coords7 = uv_TexCoord4 * _VoronoisScale;
			float2 id7 = 0;
			float2 uv7 = 0;
			float voroi7 = voronoi7( coords7, time7, id7, uv7, 0, voronoiSmoothId7 );
			float4 lerpResult12 = lerp( _Color0 , color13 , (0.0 + (voroi7 - 0.0) * (0.6 - 0.0) / (1.0 - 0.0)));
			o.Emission = lerpResult12.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;Fireball_Trail;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ColorNode;13;-836.2526,-278.0099;Inherit;False;Constant;_Color1;Color 1;2;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;12;-493.2526,-116.51;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;-832.5002,-446.7;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;1,0.7960784,0,0;1,0.6652648,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1359.326,-67.04694;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1566.925,-19.30023;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;6;-1827.637,-19.80923;Inherit;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.VoronoiNode;7;-1088.326,-68.04695;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;13.21;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;8;-1331.441,61.82601;Inherit;False;Property;_VoronoisScale;VoronoisScale;2;0;Create;True;0;0;0;False;0;False;10;6.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;9;-880.0294,-66.79572;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-1861.464,103.5027;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-580.4716,276.511;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1033.719,282.9326;Inherit;False;Property;_VertexOffset_Intensity;VertexOffset_Intensity;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;26;-971.1395,351.8703;Inherit;False;Constant;_Vector1;Vector 1;2;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;41;-965.3967,493.06;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1229.641,563.6366;Inherit;False;Property;_Offsett_Lower;Offsett_Lower;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1225.214,636.3511;Inherit;False;Property;_Offset_Higher;Offset_Higher;6;0;Create;True;0;0;0;False;0;False;1;0.84;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;22;-1486.105,491.4344;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1745.603,442.0479;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-1715.22,564.8918;Inherit;False;Property;_NoiseScale;NoiseScale;4;0;Create;True;0;0;0;False;0;False;0;0.77;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1950.168,491.1804;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2182.836,489.1938;Inherit;False;Property;_Speed;Speed;5;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2178.927,561.4916;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;32;-2209.709,634.0046;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-980.4191,812.923;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;47;-1284.797,894.9091;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;-0.2;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;44;-1477.266,895.1829;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-1764.296,764.7917;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-261.2603,337.9704;Inherit;False;Property;_Tess;Tess;0;0;Create;True;0;0;0;False;0;False;10;6.07;0;0;0;1;FLOAT;0
WireConnection;0;2;12;0
WireConnection;0;11;36;0
WireConnection;0;14;2;0
WireConnection;12;0;1;0
WireConnection;12;1;13;0
WireConnection;12;2;9;0
WireConnection;4;1;5;0
WireConnection;5;0;6;0
WireConnection;5;1;11;0
WireConnection;7;0;4;0
WireConnection;7;2;8;0
WireConnection;9;0;7;0
WireConnection;36;0;28;0
WireConnection;36;1;26;0
WireConnection;36;2;41;0
WireConnection;36;3;45;0
WireConnection;41;0;22;0
WireConnection;41;3;43;0
WireConnection;41;4;42;0
WireConnection;22;0;17;2
WireConnection;22;1;29;0
WireConnection;17;1;33;0
WireConnection;33;0;35;0
WireConnection;33;1;40;0
WireConnection;33;2;32;0
WireConnection;45;0;37;2
WireConnection;45;1;47;0
WireConnection;47;0;44;0
WireConnection;44;0;37;2
ASEEND*/
//CHKSM=55540A2B23866AA7F690AA573BBB4FE05D812E8B