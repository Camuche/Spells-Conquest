// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FireballPreform"
{
	Properties
	{
		_Fresnel_power("Fresnel_power", Float) = 1.21
		_Color0("Color 0", Color) = (1,0,0,0)
		_Color1("Color 1", Color) = (1,1,0,0)
		_Fresnel_scale("Fresnel_scale", Float) = 1
		_Voronoi_Scale("Voronoi_Scale", Float) = 10
		_Center_Scale("Center_Scale", Float) = 1.41
		_Center_Power("Center_Power", Float) = 0.18
		_Vertex_Offset_Intnsity("Vertex_Offset_Intnsity", Float) = 0.1
		_Noise_Scale("Noise_Scale", Float) = 4.29
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
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _Vertex_Offset_Intnsity;
		uniform float _Noise_Scale;
		uniform float4 _Color1;
		uniform float4 _Color0;
		uniform float _Voronoi_Scale;
		uniform float _Fresnel_scale;
		uniform float _Fresnel_power;
		uniform float _Center_Scale;
		uniform float _Center_Power;


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


		float2 voronoihash12( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi12( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash12( n + g );
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (( _Time.y * 0.2 )).xx;
			float2 uv_TexCoord27 = v.texcoord.xy + temp_cast_0;
			float simplePerlin2D25 = snoise( uv_TexCoord27*_Noise_Scale );
			simplePerlin2D25 = simplePerlin2D25*0.5 + 0.5;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			v.vertex.xyz += ( _Vertex_Offset_Intnsity * simplePerlin2D25 * ase_worldNormal );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float time12 = 0.0;
			float2 voronoiSmoothId12 = 0;
			float2 coords12 = i.uv_texcoord * _Voronoi_Scale;
			float2 id12 = 0;
			float2 uv12 = 0;
			float voroi12 = voronoi12( coords12, time12, id12, uv12, 0, voronoiSmoothId12 );
			float4 lerpResult20 = lerp( _Color0 , _Color1 , voroi12);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV2 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode2 = ( 0.0 + _Fresnel_scale * pow( 1.0 - fresnelNdotV2, _Fresnel_power ) );
			float4 lerpResult5 = lerp( _Color1 , lerpResult20 , fresnelNode2);
			float fresnelNdotV8 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode8 = ( 0.0 + _Center_Scale * pow( 1.0 - fresnelNdotV8, _Center_Power ) );
			float4 lerpResult24 = lerp( lerpResult5 , _Color0 , ( 1.0 - fresnelNode8 ));
			o.Emission = lerpResult24.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;373,3.814697E-06;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;FireballPreform;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.LerpOp;24;10.35379,45.33695;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;5;-619.6173,36.48798;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;20;-1164.445,-124.7004;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VoronoiNode;12;-1594.75,-71.29473;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;18;-1853.346,-25.96136;Inherit;False;Property;_Voronoi_Scale;Voronoi_Scale;4;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;2;-1282.892,133.453;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1567.869,262.0556;Inherit;False;Property;_Fresnel_power;Fresnel_power;0;0;Create;True;0;0;0;False;0;False;1.21;1.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1598.869,189.0555;Inherit;False;Property;_Fresnel_scale;Fresnel_scale;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;8;-741.0234,350.1517;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;-323.9727,277.0432;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-953.7635,412.3814;Inherit;False;Property;_Center_Scale;Center_Scale;5;0;Create;True;0;0;0;False;0;False;1.41;1.41;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-946.7634,505.3813;Inherit;False;Property;_Center_Power;Center_Power;6;0;Create;True;0;0;0;False;0;False;0.18;0.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;-1691.219,-544.5256;Inherit;False;Property;_Color1;Color 1;2;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-1683.342,-366.5866;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;25;-67.20142,573.0732;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-493.988,597.4764;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;28;-1017.988,695.1767;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-807.0723,757.4781;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-970.8723,879.6782;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;244.6279,487.0779;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;34;-450.7723,823.8779;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalVertexDataNode;33;-458.3723,1002.678;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;91.22784,438.9779;Inherit;False;Property;_Vertex_Offset_Intnsity;Vertex_Offset_Intnsity;7;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-241.988,650.4764;Inherit;False;Property;_Noise_Scale;Noise_Scale;8;0;Create;True;0;0;0;False;0;False;4.29;4.29;0;0;0;1;FLOAT;0
WireConnection;0;2;24;0
WireConnection;0;11;31;0
WireConnection;24;0;5;0
WireConnection;24;1;4;0
WireConnection;24;2;21;0
WireConnection;5;0;6;0
WireConnection;5;1;20;0
WireConnection;5;2;2;0
WireConnection;20;0;4;0
WireConnection;20;1;6;0
WireConnection;20;2;12;0
WireConnection;12;2;18;0
WireConnection;2;2;10;0
WireConnection;2;3;7;0
WireConnection;8;2;22;0
WireConnection;8;3;23;0
WireConnection;21;0;8;0
WireConnection;25;0;27;0
WireConnection;25;1;26;0
WireConnection;27;1;29;0
WireConnection;29;0;28;0
WireConnection;29;1;30;0
WireConnection;31;0;32;0
WireConnection;31;1;25;0
WireConnection;31;2;34;0
ASEEND*/
//CHKSM=EB1BAFDE0634A9F1D6DCDDF482F2DA1FEA374458