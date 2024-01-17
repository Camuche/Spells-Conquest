// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/DoubleSided"
{
	Properties
	{
		_Foliagelow_Albedo("Foliage low_Albedo", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Foliagelow_AO("Foliage low_AO", 2D) = "white" {}
		_Foliagelow_Metallic("Foliage low_Metallic", 2D) = "white" {}
		_Foliagelow_Normal("Foliage low_Normal", 2D) = "bump" {}
		_Masquedopacite("Masque d'opacite", 2D) = "white" {}
		_Tesselation("Tesselation", Float) = 0
		_Speed("Speed", Float) = 0.2
		_NoiseScale("NoiseScale", Float) = 3.73
		_intensity("intensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Speed;
		uniform float _NoiseScale;
		uniform float _intensity;
		uniform sampler2D _Foliagelow_Normal;
		uniform float4 _Foliagelow_Normal_ST;
		uniform sampler2D _Foliagelow_Albedo;
		uniform float4 _Foliagelow_Albedo_ST;
		uniform sampler2D _Foliagelow_Metallic;
		uniform float4 _Foliagelow_Metallic_ST;
		uniform sampler2D _Foliagelow_AO;
		uniform float4 _Foliagelow_AO_ST;
		uniform sampler2D _Masquedopacite;
		uniform float4 _Masquedopacite_ST;
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
			float2 uv_TexCoord8 = v.texcoord.xy + ( float2( 1,0 ) * _Time.y * _Speed );
			float simplePerlin2D7 = snoise( uv_TexCoord8*_NoiseScale );
			simplePerlin2D7 = simplePerlin2D7*0.5 + 0.5;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 temp_cast_0 = (( simplePerlin2D7 * ase_vertex3Pos.y * _intensity )).xxx;
			v.vertex.xyz += temp_cast_0;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Foliagelow_Normal = i.uv_texcoord * _Foliagelow_Normal_ST.xy + _Foliagelow_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Foliagelow_Normal, uv_Foliagelow_Normal ) );
			float2 uv_Foliagelow_Albedo = i.uv_texcoord * _Foliagelow_Albedo_ST.xy + _Foliagelow_Albedo_ST.zw;
			o.Albedo = tex2D( _Foliagelow_Albedo, uv_Foliagelow_Albedo ).rgb;
			float2 uv_Foliagelow_Metallic = i.uv_texcoord * _Foliagelow_Metallic_ST.xy + _Foliagelow_Metallic_ST.zw;
			o.Metallic = tex2D( _Foliagelow_Metallic, uv_Foliagelow_Metallic ).r;
			float2 uv_Foliagelow_AO = i.uv_texcoord * _Foliagelow_AO_ST.xy + _Foliagelow_AO_ST.zw;
			o.Occlusion = tex2D( _Foliagelow_AO, uv_Foliagelow_AO ).r;
			o.Alpha = 1;
			float2 uv_Masquedopacite = i.uv_texcoord * _Masquedopacite_ST.xy + _Masquedopacite_ST.zw;
			clip( tex2D( _Masquedopacite, uv_Masquedopacite ).r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Custom/DoubleSided;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;6;-1811.235,291.3484;Inherit;True;Property;_Masquedopacite;Masque d'opacite;5;0;Create;True;0;0;0;False;0;False;-1;342e2220d0cabf142bb78e120bce5ae9;342e2220d0cabf142bb78e120bce5ae9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1815.316,95.25963;Inherit;True;Property;_Foliagelow_AO;Foliage low_AO;2;0;Create;True;0;0;0;False;0;False;-1;07c39a96080050447a8e3fba5c8f04a7;07c39a96080050447a8e3fba5c8f04a7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-1813.316,-90.74046;Inherit;True;Property;_Foliagelow_Metallic;Foliage low_Metallic;3;0;Create;True;0;0;0;False;0;False;-1;c3ed1cf8c557869469464fbe76a47fcc;c3ed1cf8c557869469464fbe76a47fcc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-1810.316,-281.7404;Inherit;True;Property;_Foliagelow_Normal;Foliage low_Normal;4;0;Create;True;0;0;0;False;0;False;-1;ac61aa8ffc4cd7a4db361f4e2245a06d;ac61aa8ffc4cd7a4db361f4e2245a06d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1809.316,-476.7403;Inherit;True;Property;_Foliagelow_Albedo;Foliage low_Albedo;0;0;Create;True;0;0;0;False;0;False;-1;37dfecf8ebbca544ab95e48d75dd7741;37dfecf8ebbca544ab95e48d75dd7741;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1070.104,433.5764;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;7;-725.8227,433.1143;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1258.857,479.1708;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;12;-1507.337,475.3595;Inherit;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;10;-1550.249,594.9681;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1521.597,671.9681;Inherit;False;Property;_Speed;Speed;7;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1033.698,554.4891;Inherit;False;Property;_NoiseScale;NoiseScale;8;0;Create;True;0;0;0;False;0;False;3.73;3.73;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-416.6347,435.371;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;24;-683.8407,646.4293;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-658.2372,785.7668;Inherit;False;Property;_intensity;intensity;9;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-373.375,355.536;Inherit;False;Property;_Tesselation;Tesselation;6;0;Create;True;0;0;0;False;0;False;0;4.42;0;0;0;1;FLOAT;0
WireConnection;0;0;1;0
WireConnection;0;1;5;0
WireConnection;0;3;4;0
WireConnection;0;5;2;0
WireConnection;0;10;6;0
WireConnection;0;11;19;0
WireConnection;0;14;21;0
WireConnection;8;1;11;0
WireConnection;7;0;8;0
WireConnection;7;1;9;0
WireConnection;11;0;12;0
WireConnection;11;1;10;0
WireConnection;11;2;13;0
WireConnection;19;0;7;0
WireConnection;19;1;24;2
WireConnection;19;2;22;0
ASEEND*/
//CHKSM=DCB7B8058CCB8A0FEB2B43A64CE5DA8DA4C8CA48