// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpellPickupFlame"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		_Fresnel_Bias("Fresnel_Bias", Float) = 0
		_Fresnel_Scale("Fresnel_Scale", Float) = 1
		_Float4("Float 4", Float) = 0.06
		_Float5("Float 5", Float) = 1
		_HDR("HDR", Float) = 0
		_ColorFresnel("ColorFresnel", Color) = (0,0,0,0)
		_Color_Fresnel_Scale("Color_Fresnel_Scale", Float) = 0
		_Color_Fresnel_Power("Color_Fresnel_Power", Float) = 0
		_Fresnel_Power("Fresnel_Power", Float) = 5
		_Color("Color", Color) = (0,0,0,0)
		_VertexOffsetIntensity("VertexOffsetIntensity", Float) = 0.2
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
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
		};

		uniform float _Fresnel_Bias;
		uniform float _Fresnel_Scale;
		uniform float _Fresnel_Power;
		uniform float _Float4;
		uniform float _Float5;
		uniform float _VertexOffsetIntensity;
		uniform float4 _Color;
		uniform float _HDR;
		uniform float4 _ColorFresnel;
		uniform float _Color_Fresnel_Scale;
		uniform float _Color_Fresnel_Power;
		uniform float _EdgeLength;


		float2 voronoihash3( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi3( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash3( n + g );
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


		float2 voronoihash57( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi57( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash57( n + g );
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
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float fresnelNdotV5 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode5 = ( _Fresnel_Bias + _Fresnel_Scale * pow( 1.0 - fresnelNdotV5, _Fresnel_Power ) );
			float clampResult10 = clamp( fresnelNode5 , 0.0 , 1.0 );
			float time3 = 13.43;
			float2 voronoiSmoothId3 = 0;
			float2 uv_TexCoord17 = v.texcoord.xy + ( float2( 0,-1 ) * _Time.y );
			float2 coords3 = uv_TexCoord17 * 5.7;
			float2 id3 = 0;
			float2 uv3 = 0;
			float voroi3 = voronoi3( coords3, time3, id3, uv3, 0, voronoiSmoothId3 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( clampResult10 * voroi3 * ( 1.91 * ase_vertex3Pos.y ) * ase_vertexNormal * (_Float4 + (v.texcoord.xy.y - 0.0) * (_Float5 - _Float4) / (1.0 - 0.0)) * _VertexOffsetIntensity );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV74 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode74 = ( 0.0 + _Color_Fresnel_Scale * pow( 1.0 - fresnelNdotV74, _Color_Fresnel_Power ) );
			float clampResult81 = clamp( fresnelNode74 , 0.0 , 1.0 );
			float4 lerpResult77 = lerp( ( _Color * _HDR ) , ( _ColorFresnel * _HDR ) , clampResult81);
			o.Emission = lerpResult77.rgb;
			float fresnelNdotV5 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode5 = ( _Fresnel_Bias + _Fresnel_Scale * pow( 1.0 - fresnelNdotV5, _Fresnel_Power ) );
			float clampResult10 = clamp( fresnelNode5 , 0.0 , 1.0 );
			float time57 = 13.43;
			float2 voronoiSmoothId57 = 0;
			float2 uv_TexCoord62 = i.uv_texcoord * float2( 5.32,0.65 ) + ( float2( 0,-0.7 ) * _Time.y );
			float2 coords57 = uv_TexCoord62 * 5.7;
			float2 id57 = 0;
			float2 uv57 = 0;
			float voroi57 = voronoi57( coords57, time57, id57, uv57, 0, voronoiSmoothId57 );
			float temp_output_3_0_g1 = ( 0.28 - voroi57 );
			float clampResult44 = clamp( ( clampResult10 + ( 1.0 - saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) ) ) ) , 0.0 , 1.0 );
			o.Alpha = clampResult44;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;73;-1671.149,-489.7667;Inherit;False;1280.148;713.9889;Opacity;14;7;8;6;10;5;62;57;47;49;43;60;50;71;61;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;72;-1590.994,261.6054;Inherit;False;1113.179;850.324;Vertex Offset;14;28;31;2;23;32;38;36;37;24;3;18;19;20;17;Vertex Offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-100,212.5;Inherit;False;6;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-350.2307,-66.62078;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;44;-133.1902,-67.19729;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;2;-1172.434,651.7696;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;23;-923.1959,686.1353;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-1228.731,807.1288;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;38;-1004.229,857.3288;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1172.831,928.9295;Inherit;False;Property;_Float4;Float 4;7;0;Create;True;0;0;0;False;0;False;0.06;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1171.831,998.9301;Inherit;False;Property;_Float5;Float 5;8;0;Create;True;0;0;0;False;0;False;1;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-751.8147,423.1644;Inherit;False;Property;_VertexOffsetIntensity;VertexOffsetIntensity;15;0;Create;True;0;0;0;False;0;False;0.2;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1341.462,42.22228;Inherit;False;Property;_Fresnel_Scale;Fresnel_Scale;6;0;Create;True;0;0;0;False;0;False;1;52.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1342.462,111.2222;Inherit;False;Property;_Fresnel_Power;Fresnel_Power;13;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1341.462,-24.77776;Inherit;False;Property;_Fresnel_Bias;Fresnel_Bias;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;10;-786.4622,-70.7778;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;5;-1083.462,-70.7778;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-1239.738,-361.6678;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;57;-1009.423,-361.0312;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;13.43;False;2;FLOAT;5.7;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.FunctionNode;47;-799.1677,-360.2544;Inherit;True;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1008.27,-244.8245;Inherit;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;0;False;0;False;0.28;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;43;-569.0001,-362.0833;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1421.267,-314.6678;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;50;-1459.403,-439.7667;Inherit;False;Constant;_Vector1;Vector 1;9;0;Create;True;0;0;0;False;0;False;5.32,0.65;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;71;-1621.149,-314.6392;Inherit;False;Constant;_Vector2;Vector 2;9;0;Create;True;0;0;0;False;0;False;0,-0.7;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;61;-1618.846,-198.3731;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1081.318,580.3954;Inherit;False;Constant;_Float3;Float 3;8;0;Create;True;0;0;0;False;0;False;1.91;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-921.324,580.1951;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;3;-956.9934,312.6051;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;13.43;False;2;FLOAT;5.7;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.Vector2Node;18;-1512.994,357.6047;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;0,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1341.994,358.6047;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;20;-1540.994,476.6049;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1186.994,311.6051;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;78;-884.0132,-908.611;Inherit;False;Property;_ColorFresnel;ColorFresnel;10;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0.4486697,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;74;-682.1664,-1126.88;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-964.465,-1117.521;Inherit;False;Property;_Color_Fresnel_Scale;Color_Fresnel_Scale;11;0;Create;True;0;0;0;False;0;False;0;3.85;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-958.2515,-1035.598;Inherit;False;Property;_Color_Fresnel_Power;Color_Fresnel_Power;12;0;Create;True;0;0;0;False;0;False;0;5.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;81;-364.6369,-1128.941;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-466.8438,-717.5648;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-476.8963,-909.4611;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-672.6173,-813.0604;Inherit;False;Property;_HDR;HDR;9;0;Create;True;0;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;-886.5328,-715.5692;Inherit;False;Property;_Color;Color;14;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0.6641017,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;77;-160.7353,-934.8171;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;216.3947,-49.08405;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;SpellPickupFlame;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;2;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;0;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;10;0
WireConnection;21;1;3;0
WireConnection;21;2;31;0
WireConnection;21;3;23;0
WireConnection;21;4;38;0
WireConnection;21;5;24;0
WireConnection;40;0;10;0
WireConnection;40;1;43;0
WireConnection;44;0;40;0
WireConnection;38;0;32;2
WireConnection;38;3;36;0
WireConnection;38;4;37;0
WireConnection;10;0;5;0
WireConnection;5;1;6;0
WireConnection;5;2;7;0
WireConnection;5;3;8;0
WireConnection;62;0;50;0
WireConnection;62;1;60;0
WireConnection;57;0;62;0
WireConnection;47;1;57;0
WireConnection;47;2;49;0
WireConnection;43;0;47;0
WireConnection;60;0;71;0
WireConnection;60;1;61;0
WireConnection;31;0;28;0
WireConnection;31;1;2;2
WireConnection;3;0;17;0
WireConnection;19;0;18;0
WireConnection;19;1;20;0
WireConnection;17;1;19;0
WireConnection;74;2;82;0
WireConnection;74;3;84;0
WireConnection;81;0;74;0
WireConnection;75;0;11;0
WireConnection;75;1;76;0
WireConnection;79;0;78;0
WireConnection;79;1;76;0
WireConnection;77;0;75;0
WireConnection;77;1;79;0
WireConnection;77;2;81;0
WireConnection;0;2;77;0
WireConnection;0;9;44;0
WireConnection;0;11;21;0
ASEEND*/
//CHKSM=AEAF916E5B851750E71CDA410D26D338755721B9