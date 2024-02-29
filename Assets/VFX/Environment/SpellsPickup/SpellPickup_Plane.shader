// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpellPickup_Plane"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		_VertexOffset_UV_Intensity("VertexOffset_UV_Intensity", Float) = 1
		_Voronoi_Scale("Voronoi_Scale", Float) = 5.7
		[HDR]_Color0("Color 0", Color) = (1,0.6627451,0,0)
		_HDR("HDR", Float) = 0
		[Toggle(_KEYWORD0_ON)] _Keyword0("Keyword 0", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HDR]_Color1("Color 1", Color) = (1,0.5452945,0,0)
		_Color_Noise_Scale("Color_Noise_Scale", Float) = 0
		_Time_Scale("Time_Scale", Float) = 0
		_Float1("Float 1", Float) = 0
		_VertexOffset_Intensity("VertexOffset_Intensity", Float) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.55
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma shader_feature_local _KEYWORD0_ON
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Voronoi_Scale;
		uniform float _Time_Scale;
		uniform float _Float1;
		uniform float _VertexOffset_Intensity;
		uniform float _VertexOffset_UV_Intensity;
		uniform float4 _Color0;
		uniform float _HDR;
		uniform float4 _Color1;
		uniform float _Color_Noise_Scale;
		uniform sampler2D _TextureSample0;
		uniform float _Cutoff = 0.55;
		uniform float _EdgeLength;


		float2 voronoihash1( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi1( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash1( n + g );
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
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float time1 = 13.43;
			float2 voronoiSmoothId1 = 0;
			float2 _Vector0 = float2(0,-1);
			float mulTime4 = _Time.y * _Time_Scale;
			#ifdef _KEYWORD0_ON
				float staticSwitch80 = ( mulTime4 + _Float1 );
			#else
				float staticSwitch80 = mulTime4;
			#endif
			float2 uv_TexCoord5 = v.texcoord.xy + ( _Vector0 * staticSwitch80 );
			float2 coords1 = uv_TexCoord5 * _Voronoi_Scale;
			float2 id1 = 0;
			float2 uv1 = 0;
			float voroi1 = voronoi1( coords1, time1, id1, uv1, 0, voronoiSmoothId1 );
			float temp_output_21_0 = ( 1.0 - voroi1 );
			float3 ase_vertexNormal = v.normal.xyz;
			float2 appendResult23 = (float2(ase_vertexNormal.y , ase_vertexNormal.z));
			float3 ase_vertex3Pos = v.vertex.xyz;
			v.vertex.xyz += ( temp_output_21_0 * _VertexOffset_Intensity * ( v.texcoord.xy.y * _VertexOffset_UV_Intensity ) * float3( appendResult23 ,  0.0 ) * ase_vertex3Pos );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime4 = _Time.y * _Time_Scale;
			float2 _Vector0 = float2(0,-1);
			float2 uv_TexCoord86 = i.uv_texcoord * float2( 1,0.1 ) + ( mulTime4 * _Vector0 );
			float simplePerlin2D84 = snoise( uv_TexCoord86*_Color_Noise_Scale );
			simplePerlin2D84 = simplePerlin2D84*0.5 + 0.5;
			float4 lerpResult89 = lerp( ( _Color0 * _HDR ) , ( _Color1 * _HDR ) , simplePerlin2D84);
			o.Emission = lerpResult89.rgb;
			o.Alpha = 1;
			float time1 = 13.43;
			float2 voronoiSmoothId1 = 0;
			#ifdef _KEYWORD0_ON
				float staticSwitch80 = ( mulTime4 + _Float1 );
			#else
				float staticSwitch80 = mulTime4;
			#endif
			float2 uv_TexCoord5 = i.uv_texcoord + ( _Vector0 * staticSwitch80 );
			float2 coords1 = uv_TexCoord5 * _Voronoi_Scale;
			float2 id1 = 0;
			float2 uv1 = 0;
			float voroi1 = voronoi1( coords1, time1, id1, uv1, 0, voronoiSmoothId1 );
			float temp_output_21_0 = ( 1.0 - voroi1 );
			clip( ( tex2D( _TextureSample0, i.uv_texcoord ).a * temp_output_21_0 ) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-281,166.5;Inherit;True;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-257.4959,-125.2928;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-984.1816,-308.3505;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;0;False;0;False;-1;e884b778de9e6244c964bd0092b20791;e884b778de9e6244c964bd0092b20791;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;2;-1562.83,83.37473;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;0,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1391.831,84.37473;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1236.831,37.37513;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;23;-863.4049,528.3839;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-948.0103,266.0223;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;24;-1140.634,478.7737;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-708.4902,312.2234;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;-559.602,90.84058;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;1;-1006.832,38.37513;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;13.43;False;2;FLOAT;5.7;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;31;-1334.221,303.114;Inherit;False;Property;_Voronoi_Scale;Voronoi_Scale;6;0;Create;True;0;0;0;False;0;False;5.7;5.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;25;-895.0701,628.7151;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-1256.49,-293.8171;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-663.7364,209.8263;Inherit;False;Property;_VertexOffset_Intensity;VertexOffset_Intensity;15;0;Create;True;0;0;0;False;0;False;1;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-889.4902,384.2234;Inherit;False;Property;_VertexOffset_UV_Intensity;VertexOffset_UV_Intensity;5;0;Create;True;0;0;0;False;0;False;1;-21.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;292.9087,-101.8759;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;SpellPickup_Plane;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.55;True;False;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;2;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;16;-1;-1;0;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.StaticSwitch;80;-1630.27,205.3821;Inherit;False;Property;_Keyword0;Keyword 0;9;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-2085.124,201.1956;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-2059.592,291.1656;Inherit;False;Property;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;0;-21.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;86;-1382.525,-560.8295;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;87;-1546.459,-588.3055;Inherit;False;Constant;_Vector1;Vector 1;10;0;Create;True;0;0;0;False;0;False;1,0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-1820.853,270.4212;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-1534.177,-440.0908;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;89;-27.61323,-285.2796;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;84;-1012.691,-583.9865;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-1299.954,-433.3958;Inherit;False;Property;_Color_Noise_Scale;Color_Noise_Scale;12;0;Create;True;0;0;0;False;0;False;0;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-409.8901,-357.4462;Inherit;False;Property;_HDR;HDR;8;0;Create;True;0;0;0;False;0;False;0;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-230.0028,-426.3975;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-224.8028,-332.7975;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-2297.128,202.5995;Inherit;False;Property;_Time_Scale;Time_Scale;13;0;Create;True;0;0;0;False;0;False;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;102;-794.3877,928.187;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;101;-179.8832,784.5351;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;90;-659.7782,-316.8307;Inherit;False;Property;_Color1;Color 1;11;1;[HDR];Create;True;0;0;0;False;0;False;1,0.5452945,0,0;1,0.7873625,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;43;-633.926,-512.3162;Inherit;False;Property;_Color0;Color 0;7;1;[HDR];Create;True;0;0;0;False;0;False;1,0.6627451,0,0;1,0.5458695,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;6;0;21;0
WireConnection;6;1;10;0
WireConnection;6;2;28;0
WireConnection;6;3;23;0
WireConnection;6;4;25;0
WireConnection;18;0;17;4
WireConnection;18;1;21;0
WireConnection;17;1;35;0
WireConnection;3;0;2;0
WireConnection;3;1;80;0
WireConnection;5;1;3;0
WireConnection;23;0;24;2
WireConnection;23;1;24;3
WireConnection;28;0;8;2
WireConnection;28;1;27;0
WireConnection;21;0;1;0
WireConnection;1;0;5;0
WireConnection;1;2;31;0
WireConnection;0;2;89;0
WireConnection;0;10;18;0
WireConnection;0;11;6;0
WireConnection;80;1;4;0
WireConnection;80;0;82;0
WireConnection;4;0;100;0
WireConnection;86;0;87;0
WireConnection;86;1;88;0
WireConnection;82;0;4;0
WireConnection;82;1;83;0
WireConnection;88;0;4;0
WireConnection;88;1;2;0
WireConnection;89;0;98;0
WireConnection;89;1;99;0
WireConnection;89;2;84;0
WireConnection;84;0;86;0
WireConnection;84;1;91;0
WireConnection;98;0;43;0
WireConnection;98;1;78;0
WireConnection;99;0;90;0
WireConnection;99;1;78;0
WireConnection;101;2;102;1
ASEEND*/
//CHKSM=D84D0759EBF02F2AC0763D1D130681F76D55264F