// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Lave"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Disto("Disto", Range( 0 , 0.1)) = 0
		_Speed("Speed", Range( 0 , 0.2)) = 0.2
		_Float2("Float 2", Range( 0 , 1)) = 0
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_flowmap("flowmap", 2D) = "white" {}
		_Float0("Float 0", Range( -1 , 5)) = 0
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		uniform sampler2D _flowmap;
		uniform float4 _flowmap_ST;
		uniform float _Disto;
		uniform float _Speed;
		uniform float _Float2;
		uniform sampler2D _TextureSample1;
		uniform float _Float0;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;


		float2 voronoihash27( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi27( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash27( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.500 * pow( ( pow( abs( r.x ), 1 ) + pow( abs( r.y ), 1 ) ), 1.000 );
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
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_flowmap = v.texcoord * _flowmap_ST.xy + _flowmap_ST.zw;
			float4 lerpResult13 = lerp( float4( v.texcoord.xy, 0.0 , 0.0 ) , tex2Dlod( _flowmap, float4( uv_flowmap, 0, 0.0) ) , _Disto);
			float mulTime10 = _Time.y * _Speed;
			float4 temp_output_8_0 = ( lerpResult13 + mulTime10 );
			float4 tex2DNode2 = tex2Dlod( _TextureSample0, float4( temp_output_8_0.rg, 0, 0.0) );
			float3 temp_cast_2 = (_Float2).xxx;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
			float3x3 tangentToWorld = CreateTangentToWorldPerVertex( ase_worldNormal, ase_worldTangent, v.tangent.w );
			float3 tangentNormal54 = temp_cast_2;
			float3 modWorldNormal54 = (tangentToWorld[0] * tangentNormal54.x + tangentToWorld[1] * tangentNormal54.y + tangentToWorld[2] * tangentNormal54.z);
			float time27 = 0.0;
			float2 voronoiSmoothId27 = 0;
			float2 coords27 = v.texcoord.xy * 1.0;
			float2 id27 = 0;
			float2 uv27 = 0;
			float fade27 = 0.5;
			float voroi27 = 0;
			float rest27 = 0;
			for( int it27 = 0; it27 <4; it27++ ){
			voroi27 += fade27 * voronoi27( coords27, time27, id27, uv27, 0,voronoiSmoothId27 );
			rest27 += fade27;
			coords27 *= 2;
			fade27 *= 0.5;
			}//Voronoi27
			voroi27 /= rest27;
			v.vertex.xyz += ( tex2DNode2 * float4( modWorldNormal54 , 0.0 ) * voroi27 ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_flowmap = i.uv_texcoord * _flowmap_ST.xy + _flowmap_ST.zw;
			float4 lerpResult13 = lerp( float4( i.uv_texcoord, 0.0 , 0.0 ) , tex2D( _flowmap, uv_flowmap ) , _Disto);
			float mulTime10 = _Time.y * _Speed;
			float4 temp_output_8_0 = ( lerpResult13 + mulTime10 );
			o.Normal = UnpackNormal( tex2D( _TextureSample1, temp_output_8_0.rg ) );
			float4 tex2DNode2 = tex2D( _TextureSample0, temp_output_8_0.rg );
			o.Albedo = tex2DNode2.rgb;
			o.Emission = ( _Float0 * tex2DNode2 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18921
311.2;73.6;946.8;426.2;2405.132;929.8854;2.795402;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-638.0986,-715.1688;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-708.9553,-174.7355;Inherit;False;Property;_Disto;Disto;6;0;Create;True;0;0;0;False;0;False;0;0;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-622.6161,-64.64378;Inherit;False;Property;_Speed;Speed;8;0;Create;True;0;0;0;False;0;False;0.2;0.2352941;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;-713.3216,-412.9977;Inherit;True;Property;_flowmap;flowmap;12;0;Create;True;0;0;0;False;0;False;-1;e5fc194be4ef2994a936322b74927473;e5fc194be4ef2994a936322b74927473;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;13;-259.5841,-452.5368;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-294.7989,76.41627;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;144.2958,-9.039497;Inherit;False;Property;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-23.55506,-419.3398;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;54;442.1333,-47.4046;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;2;168.427,-502.6656;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;f87c01c63a01e86479cd8e93fe81fa69;f87c01c63a01e86479cd8e93fe81fa69;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;27;-906.4919,-126.1884;Inherit;True;0;4;1;0;4;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;46;180.6458,-608.8732;Inherit;False;Property;_Float0;Float 0;13;0;Create;True;0;0;0;False;0;False;0;0;-1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;-345.1644,310.7101;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;701.8695,-636.5918;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;26;170.2388,-299.0255;Inherit;True;Property;_TextureSample1;Texture Sample 1;11;0;Create;True;0;0;0;False;0;False;-1;668a18a1fe59e944286f64f88f9be2fd;668a18a1fe59e944286f64f88f9be2fd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-740.4124,594.9998;Inherit;False;Property;_Float1;Float 1;9;0;Create;True;0;0;0;False;0;False;0.2352941;0.2352941;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-924.9286,138.7996;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-591.0555,31.93046;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;687.6667,-172.7522;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;32;-414.4118,584.9998;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-821.3286,505.899;Inherit;False;Property;_Float3;Float 3;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-120.299,384.0966;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;995.7784,-575.0943;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Custom/Lave;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;32;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;7;0
WireConnection;13;1;45;0
WireConnection;13;2;14;0
WireConnection;10;0;9;0
WireConnection;8;0;13;0
WireConnection;8;1;10;0
WireConnection;54;0;55;0
WireConnection;2;1;8;0
WireConnection;33;0;28;0
WireConnection;33;1;29;0
WireConnection;33;2;30;0
WireConnection;50;0;46;0
WireConnection;50;1;2;0
WireConnection;26;1;8;0
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;52;0;2;0
WireConnection;52;1;54;0
WireConnection;52;2;27;0
WireConnection;32;0;31;0
WireConnection;34;0;33;0
WireConnection;34;1;32;0
WireConnection;0;0;2;0
WireConnection;0;1;26;0
WireConnection;0;2;50;0
WireConnection;0;11;52;0
ASEEND*/
//CHKSM=37E8272E54997198039CE7270028CD45C6B09371