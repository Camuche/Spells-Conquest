// Made with Amplify Shader Editor v1.9.0.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FireBallMat"
{
	Properties
	{
		_Vector1("Vector 1", Vector) = (1,1,0,0)
		_VoronoiScale("VoronoiScale", Float) = 10
		_Color0("Color 0", Color) = (0.7735849,0.4994757,0.1642044,0)
		_Transparency("Transparency", Range( 0 , 1)) = 0.5
		_Tess("Tess", Float) = 0
		_VOffsetIntensity("VOffsetIntensity", Float) = 1
		_NoiseScaleVoffset("NoiseScaleVoffset", Float) = 3.47
		_BorderColor("BorderColor", Color) = (0.8784314,0.1669172,0.1215686,0)
		_OutlineScale("OutlineScale", Float) = 0.65
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _NoiseScaleVoffset;
		uniform float _VOffsetIntensity;
		uniform float4 _Color0;
		uniform float _OutlineScale;
		uniform float _VoronoiScale;
		uniform float2 _Vector1;
		uniform float4 _BorderColor;
		uniform float _Transparency;
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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_1 = (_Tess).xxxx;
			return temp_cast_1;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_TexCoord39 = v.texcoord.xy + ( float2( -1,0 ) * _Time.y );
			float simplePerlin2D40 = snoise( uv_TexCoord39*_NoiseScaleVoffset );
			simplePerlin2D40 = simplePerlin2D40*0.5 + 0.5;
			float clampResult58 = clamp( simplePerlin2D40 , 0.0 , 1.0 );
			float3 temp_cast_0 = (( clampResult58 * _VOffsetIntensity * v.texcoord.xy.x )).xxx;
			v.vertex.xyz += temp_cast_0;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time1 = 0.0;
			float2 voronoiSmoothId1 = 0;
			float2 uv_TexCoord2 = i.uv_texcoord * _Vector1 + ( float2( -1,0 ) * _Time.y );
			float2 coords1 = uv_TexCoord2 * _VoronoiScale;
			float2 id1 = 0;
			float2 uv1 = 0;
			float voroi1 = voronoi1( coords1, time1, id1, uv1, 0, voronoiSmoothId1 );
			float clampResult5 = clamp( ( i.uv_texcoord.x + (0.0 + (voroi1 - 0.0) * (0.73 - 0.0) / (1.0 - 0.0)) ) , 0.0 , 1.0 );
			float temp_output_3_0_g13 = ( _OutlineScale - clampResult5 );
			float temp_output_62_0 = saturate( ( temp_output_3_0_g13 / fwidth( temp_output_3_0_g13 ) ) );
			float temp_output_3_0_g14 = ( 0.75 - clampResult5 );
			float temp_output_14_0 = saturate( ( temp_output_3_0_g14 / fwidth( temp_output_3_0_g14 ) ) );
			float4 temp_output_72_0 = ( ( _Color0 * temp_output_62_0 ) + ( ( temp_output_14_0 - temp_output_62_0 ) * _BorderColor ) );
			o.Albedo = temp_output_72_0.rgb;
			o.Emission = temp_output_72_0.rgb;
			o.Alpha = ( temp_output_14_0 * _Transparency );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19001
1920;0;1920;1019;2497.097;1006.34;2.118044;True;True
Node;AmplifyShaderEditor.CommentaryNode;75;-2301.986,-973.7591;Inherit;False;3452.996;991.9998;Comment;20;20;19;29;22;3;2;1;26;25;4;5;73;14;62;71;37;64;63;34;72;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;19;-2235.986,-331.7588;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;20;-2251.986,-203.7589;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1995.989,-235.7588;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;29;-2011.988,-363.7588;Inherit;False;Property;_Vector1;Vector 1;0;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1771.99,-283.7589;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-1547.99,-203.7589;Inherit;False;Property;_VoronoiScale;VoronoiScale;1;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;1;-1371.99,-283.7589;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TFHCRemapNode;26;-1147.99,-283.7589;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.73;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-1211.99,-427.7587;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;74;-679.4903,398.7853;Inherit;False;1876.217;476.9097;Comment;10;53;58;40;39;52;54;56;48;49;42;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-907.99,-411.7587;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;49;-615.7471,634.0061;Inherit;False;Constant;_Vector2;Vector 2;5;0;Create;True;0;0;0;False;0;False;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;42;-629.4903,764.6951;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-539.9899,-603.7585;Inherit;False;Property;_OutlineScale;OutlineScale;8;0;Create;True;0;0;0;False;0;False;0.65;0.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;5;-651.9901,-411.7587;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-368.1781,639.4478;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;14;-299.9894,-411.7587;Inherit;True;Step Antialiasing;-1;;14;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;62;-283.9894,-619.7584;Inherit;True;Step Antialiasing;-1;;13;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.65;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-169.4788,589.8395;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;52;-184.3584,712.7477;Inherit;False;Property;_NoiseScaleVoffset;NoiseScaleVoffset;6;0;Create;True;0;0;0;False;0;False;3.47;3.47;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;71;260.0106,-555.7584;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;64;260.0106,-331.7588;Inherit;False;Property;_BorderColor;BorderColor;7;0;Create;True;0;0;0;False;0;False;0.8784314,0.1669172,0.1215686,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;40;305.7171,448.7853;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;37;228.0106,-923.7591;Inherit;False;Property;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;0.7735849,0.4994757,0.1642044,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;580.0102,-555.7584;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;580.0102,-827.7591;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-121.3751,177.7178;Inherit;False;Property;_Transparency;Transparency;3;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;605.2847,662.7079;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;58;681.4838,453.7676;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;634.4235,579.2021;Inherit;False;Property;_VOffsetIntensity;VOffsetIntensity;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;916.0099,-587.7582;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;183.2212,158.6453;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;1548.703,373.6529;Inherit;False;Property;_Tess;Tess;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;1034.728,451.088;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1776.971,-56.55722;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;FireBallMat;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;5;True;True;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;19;0
WireConnection;22;1;20;0
WireConnection;2;0;29;0
WireConnection;2;1;22;0
WireConnection;1;0;2;0
WireConnection;1;2;3;0
WireConnection;26;0;1;0
WireConnection;4;0;25;1
WireConnection;4;1;26;0
WireConnection;5;0;4;0
WireConnection;48;0;49;0
WireConnection;48;1;42;0
WireConnection;14;1;5;0
WireConnection;62;1;5;0
WireConnection;62;2;73;0
WireConnection;39;1;48;0
WireConnection;71;0;14;0
WireConnection;71;1;62;0
WireConnection;40;0;39;0
WireConnection;40;1;52;0
WireConnection;63;0;71;0
WireConnection;63;1;64;0
WireConnection;34;0;37;0
WireConnection;34;1;62;0
WireConnection;58;0;40;0
WireConnection;72;0;34;0
WireConnection;72;1;63;0
WireConnection;32;0;14;0
WireConnection;32;1;30;0
WireConnection;53;0;58;0
WireConnection;53;1;54;0
WireConnection;53;2;56;1
WireConnection;0;0;72;0
WireConnection;0;2;72;0
WireConnection;0;9;32;0
WireConnection;0;11;53;0
WireConnection;0;14;45;0
ASEEND*/
//CHKSM=E85B02CF942F9582D22539E397A8070CC2A499C8