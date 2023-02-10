// Made with Amplify Shader Editor v1.9.0.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/PlagueTalesRat"
{
	Properties
	{
		_CircleSize("CircleSize", Float) = 4
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Disto("Disto", Range( 0 , 0.2)) = 0
		_Speed("Speed", Range( 0 , 0.2)) = 0.2
		_VertexOffestPower("VertexOffestPower", Range( 0 , 1)) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_flowmap("flowmap", 2D) = "white" {}
		_ColorPower("ColorPower", Range( -1 , 5)) = 0
		_Step("Step", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _TextureSample0;
		uniform sampler2D _flowmap;
		uniform float4 _flowmap_ST;
		uniform float _Disto;
		uniform float _Speed;
		uniform float _VertexOffestPower;
		uniform float _ColorPower;
		uniform float _Opacity;
		uniform float _Step;
		uniform float4 positionsArray[20];
		uniform float _CircleSize;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;


		float DistanceCheck95( float3 WorldPos, float3 objectPosition )
		{
			float closest=10000;
			float now=0;
			for(int i=0; i<positionsArray.Length;i++){
				now = distance(WorldPos,positionsArray[i]);
				if(now < closest){
				closest = now;
				}
			}
			return closest;
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
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			v.vertex.xyz += ( tex2DNode2.r * ase_worldNormal * _VertexOffestPower );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_flowmap = i.uv_texcoord * _flowmap_ST.xy + _flowmap_ST.zw;
			float4 lerpResult13 = lerp( float4( i.uv_texcoord, 0.0 , 0.0 ) , tex2D( _flowmap, uv_flowmap ) , _Disto);
			float mulTime10 = _Time.y * _Speed;
			float4 temp_output_8_0 = ( lerpResult13 + mulTime10 );
			float4 tex2DNode2 = tex2D( _TextureSample0, temp_output_8_0.rg );
			float3 temp_cast_2 = (( _ColorPower * tex2DNode2.r )).xxx;
			o.Emission = temp_cast_2;
			float3 ase_worldPos = i.worldPos;
			float3 WorldPos95 = ase_worldPos;
			float3 objectPosition95 = positionsArray[clamp(0,0,(20 - 1))].xyz;
			float localDistanceCheck95 = DistanceCheck95( WorldPos95 , objectPosition95 );
			float temp_output_3_0_g1 = ( _Step - ( localDistanceCheck95 / _CircleSize ) );
			float clampResult97 = clamp( saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) ) , 0.0 , 1.0 );
			o.Alpha = ( _Opacity * ( 1.0 - clampResult97 ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

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
				surfIN.worldPos = worldPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
1920;0;1920;1019;281.1514;269.9665;2.957049;True;False
Node;AmplifyShaderEditor.CommentaryNode;108;1368.117,234.9695;Inherit;False;1044.969;466.6243;substractLava;7;97;96;95;94;92;126;127;substractLava;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;93;801.8563,406.7942;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GlobalArrayNode;92;1371.228,578.0938;Inherit;False;positionsArray;0;20;2;True;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;94;1745.756,511.048;Float;False;Property;_CircleSize;CircleSize;0;0;Create;True;0;0;0;False;0;False;4;12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;95;1613.891,407.2191;Float;False;float closest=10000@$float now=0@$for(int i=0@ i<positionsArray.Length@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;Create;2;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;DistanceCheck;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-622.6161,-64.64378;Inherit;False;Property;_Speed;Speed;9;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;1764.837,607.8349;Inherit;False;Property;_Step;Step;17;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;96;1878.49,409.6216;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;-713.3216,-412.9977;Inherit;True;Property;_flowmap;flowmap;15;0;Create;True;0;0;0;False;0;False;-1;e5fc194be4ef2994a936322b74927473;e5fc194be4ef2994a936322b74927473;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-708.9553,-174.7355;Inherit;False;Property;_Disto;Disto;7;0;Create;True;0;0;0;False;0;False;0;0.1527;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-638.0986,-715.1688;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;10;-294.7989,76.41627;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;-259.5841,-452.5368;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;126;2085.45,401.5357;Inherit;True;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-23.55506,-419.3398;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;97;2314.417,416.0501;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;2579.383,-294.8721;Inherit;False;Property;_Opacity;Opacity;14;0;Create;True;0;0;0;False;0;False;0;0.06;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;54;355.0334,-113.7046;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;142;2604.994,288.818;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;180.6458,-608.8732;Inherit;False;Property;_ColorPower;ColorPower;16;0;Create;True;0;0;0;False;0;False;0;1.87;-1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;168.427,-502.6656;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;f87c01c63a01e86479cd8e93fe81fa69;f87c01c63a01e86479cd8e93fe81fa69;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;55;155.9958,22.1605;Inherit;False;Property;_VertexOffestPower;VertexOffestPower;11;0;Create;True;0;0;0;False;0;False;0;0.528;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;2671.377,410.3536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;2812.137,-335.3448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;812.4667,-174.0522;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;114;1525.031,1206.912;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VoronoiNode;27;-906.4919,-126.1884;Inherit;True;0;4;1;0;4;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-120.299,384.0966;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;33;-345.1644,310.7101;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;701.8695,-636.5918;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-591.0555,31.93046;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-924.9286,138.7996;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;170.2388,-299.0255;Inherit;True;Property;_TextureSample1;Texture Sample 1;13;0;Create;True;0;0;0;False;0;False;-1;668a18a1fe59e944286f64f88f9be2fd;668a18a1fe59e944286f64f88f9be2fd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;109;1196.872,1083.736;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;32;-414.4118,584.9998;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-821.3286,505.899;Inherit;False;Property;_Float3;Float 3;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;111;1207.872,1292.736;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;117;1814.602,1216.071;Float;False;float closest=10000@$float now=0@$for(int i=0@ i<positionsArray.Length@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;Create;2;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;DistanceCheck;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;128;2336.27,1190.342;Inherit;True;Step Antialiasing;-1;;2;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;110;1194.872,1174.736;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;118;2156.973,1240.411;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;119;2552.334,1098.787;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;112;821.1079,1457.876;Inherit;False;Property;_FireballLocation;FireballLocation;12;0;Create;True;0;0;0;False;0;False;0,0,0;2.33,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GlobalArrayNode;139;1483.735,1413.201;Inherit;False;positionsArray;0;3;0;True;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-740.4124,594.9998;Inherit;False;Property;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;0.2352941;0.2352941;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3042.734,-590.5914;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;Custom/PlagueTalesRat;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;0;32;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Spherical;False;True;Relative;0;;-1;-1;-1;1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;95;0;93;0
WireConnection;95;1;92;0
WireConnection;96;0;95;0
WireConnection;96;1;94;0
WireConnection;10;0;9;0
WireConnection;13;0;7;0
WireConnection;13;1;45;0
WireConnection;13;2;14;0
WireConnection;126;1;96;0
WireConnection;126;2;127;0
WireConnection;8;0;13;0
WireConnection;8;1;10;0
WireConnection;97;0;126;0
WireConnection;142;0;97;0
WireConnection;2;1;8;0
WireConnection;124;0;97;0
WireConnection;124;1;119;0
WireConnection;145;0;146;0
WireConnection;145;1;142;0
WireConnection;52;0;2;1
WireConnection;52;1;54;0
WireConnection;52;2;55;0
WireConnection;114;0;109;0
WireConnection;114;1;110;0
WireConnection;114;2;111;0
WireConnection;34;0;33;0
WireConnection;34;1;32;0
WireConnection;33;0;28;0
WireConnection;33;1;29;0
WireConnection;33;2;30;0
WireConnection;50;0;46;0
WireConnection;50;1;2;1
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;26;1;8;0
WireConnection;109;0;93;1
WireConnection;109;1;112;1
WireConnection;32;0;31;0
WireConnection;111;0;93;3
WireConnection;111;1;112;3
WireConnection;117;0;114;0
WireConnection;117;1;139;0
WireConnection;128;1;118;0
WireConnection;128;2;127;0
WireConnection;110;0;93;2
WireConnection;110;1;112;2
WireConnection;118;0;117;0
WireConnection;118;1;94;0
WireConnection;119;0;128;0
WireConnection;0;2;50;0
WireConnection;0;9;145;0
WireConnection;0;11;52;0
ASEEND*/
//CHKSM=A496CBF6BFEF0A69FA33CC556ACCC549FEC38368