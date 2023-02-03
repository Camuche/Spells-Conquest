// Made with Amplify Shader Editor v1.9.0.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Lave"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Disto("Disto", Range( 0 , 0.1)) = 0
		_Speed("Speed", Range( 0 , 0.2)) = 0.2
		_Float2("Float 2", Range( 0 , 1)) = 0
		[Toggle(_VISUALISEPOSITION_ON)] _VisualisePosition("Visualise Position", Float) = 0
		_Size("Size", Float) = 0
		_SpherePosition("Sphere Position", Vector) = (0,0,0,0)
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_flowmap("flowmap", 2D) = "white" {}
		_Float0("Float 0", Range( -1 , 5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma shader_feature_local _VISUALISEPOSITION_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
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
		uniform float _Float2;
		uniform sampler2D _TextureSample1;
		uniform float _Float0;
		uniform float3 _SpherePosition;
		uniform float _Size;
		uniform float _Cutoff = 0.5;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;

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
			v.vertex.xyz += ( tex2DNode2.r * ase_worldNormal * _Float2 );
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
			float3 ase_worldPos = i.worldPos;
			float temp_output_72_0 = ( ( -1.0 * _SpherePosition.x ) + ase_worldPos.x );
			float temp_output_73_0 = ( ( -1.0 * _SpherePosition.y ) + ase_worldPos.y );
			float2 appendResult59 = (float2(temp_output_72_0 , temp_output_73_0));
			float2 CenteredUV15_g1 = ( appendResult59 - float2( 0.5,0.5 ) );
			float2 break17_g1 = CenteredUV15_g1;
			float2 appendResult23_g1 = (float2(( length( CenteredUV15_g1 ) * 1.0 * 2.0 ) , ( atan2( break17_g1.x , break17_g1.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float temp_output_74_0 = ( ( -1.0 * _SpherePosition.z ) + ase_worldPos.z );
			float2 appendResult61 = (float2(temp_output_72_0 , temp_output_74_0));
			float2 CenteredUV15_g2 = ( appendResult61 - float2( 0.5,0.5 ) );
			float2 break17_g2 = CenteredUV15_g2;
			float2 appendResult23_g2 = (float2(( length( CenteredUV15_g2 ) * 1.0 * 2.0 ) , ( atan2( break17_g2.x , break17_g2.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 appendResult62 = (float2(temp_output_73_0 , temp_output_74_0));
			float2 CenteredUV15_g3 = ( appendResult62 - float2( 0.5,0.5 ) );
			float2 break17_g3 = CenteredUV15_g3;
			float2 appendResult23_g3 = (float2(( length( CenteredUV15_g3 ) * 1.0 * 2.0 ) , ( atan2( break17_g3.x , break17_g3.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float temp_output_67_0 = ( (appendResult23_g1).x * (appendResult23_g2).x * (appendResult23_g3).x );
			float4 temp_cast_4 = (temp_output_67_0).xxxx;
			#ifdef _VISUALISEPOSITION_ON
				float4 staticSwitch56 = temp_cast_4;
			#else
				float4 staticSwitch56 = ( _Float0 * tex2DNode2 );
			#endif
			o.Emission = staticSwitch56.rgb;
			o.Alpha = 1;
			float clampResult68 = clamp( step( _Size , temp_output_67_0 ) , 0.0 , 1.0 );
			clip( clampResult68 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19001
1920;0;1920;1019;-404.7562;1549.055;1.435759;True;False
Node;AmplifyShaderEditor.Vector3Node;71;-175.6469,-1339.705;Inherit;False;Property;_SpherePosition;Sphere Position;14;0;Create;True;0;0;0;False;0;False;0,0,0;-9.29,1,1.96;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;94.06238,-1164.318;Inherit;False;2;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;57;-204.1271,-1066.048;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;159.3531,-1383.705;Inherit;False;2;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;94.35315,-1263.705;Inherit;False;2;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;278.3531,-1129.705;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;286.3531,-1008.705;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;280.3531,-1263.705;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;-713.3216,-412.9977;Inherit;True;Property;_flowmap;flowmap;16;0;Create;True;0;0;0;False;0;False;-1;e5fc194be4ef2994a936322b74927473;e5fc194be4ef2994a936322b74927473;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-622.6161,-64.64378;Inherit;False;Property;_Speed;Speed;9;0;Create;True;0;0;0;False;0;False;0.2;0.008;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;59;546.3871,-1197.269;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-708.9553,-174.7355;Inherit;False;Property;_Disto;Disto;7;0;Create;True;0;0;0;False;0;False;0;0.1;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-638.0986,-715.1688;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;62;553.2718,-870.4865;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;61;546.387,-1002.531;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;63;733.9096,-1018.399;Inherit;False;Polar Coordinates;-1;;2;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-294.7989,76.41627;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;-259.5841,-452.5368;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;58;739.6791,-1198.711;Inherit;False;Polar Coordinates;-1;;1;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;64;735.3518,-832.3185;Inherit;False;Polar Coordinates;-1;;3;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;65;1058.467,-1084.753;Inherit;True;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;66;1100.368,-869.2109;Inherit;True;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;60;1074.406,-1324.614;Inherit;True;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-23.55506,-419.3398;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;168.427,-502.6656;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;f87c01c63a01e86479cd8e93fe81fa69;f87c01c63a01e86479cd8e93fe81fa69;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;46;180.6458,-608.8732;Inherit;False;Property;_Float0;Float 0;17;0;Create;True;0;0;0;False;0;False;0;1.16;-1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;1556.617,-820.1331;Inherit;False;Property;_Size;Size;13;0;Create;True;0;0;0;False;0;False;0;79.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;1558.025,-1116.987;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;155.9958,22.1605;Inherit;False;Property;_Float2;Float 2;11;0;Create;True;0;0;0;False;0;False;0;0.14;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;69;2326.468,-959.4744;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;701.8695,-636.5918;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;54;355.0334,-113.7046;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-591.0555,31.93046;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;2897.631,-1313.499;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-821.3286,505.899;Inherit;False;Property;_Float3;Float 3;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-924.9286,138.7996;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;83;1741.792,-1595.802;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.2,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;68;2457.359,-637.076;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;56;2031.181,-797.3419;Inherit;False;Property;_VisualisePosition;Visualise Position;12;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;85;2386.292,-1759.589;Inherit;True;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-120.299,384.0966;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;32;-414.4118,584.9998;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;-345.1644,310.7101;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendOpsNode;78;2832.428,-1634.207;Inherit;True;LinearBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;1723.15,-1723.636;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-0.03,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;1434.19,-1674.364;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;86;2351.67,-1495.93;Inherit;True;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;80;1949.526,-1763.584;Inherit;True;Polar Coordinates;-1;;4;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;84;1964.171,-1519.898;Inherit;True;Polar Coordinates;-1;;5;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;26;170.2388,-299.0255;Inherit;True;Property;_TextureSample1;Texture Sample 1;15;0;Create;True;0;0;0;False;0;False;-1;668a18a1fe59e944286f64f88f9be2fd;668a18a1fe59e944286f64f88f9be2fd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-740.4124,594.9998;Inherit;False;Property;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;0.2352941;0.2352941;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;812.4667,-174.0522;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VoronoiNode;27;-906.4919,-126.1884;Inherit;True;0;4;1;0;4;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3070.734,-600.5914;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Custom/Lave;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;False;TransparentCutout;;Geometry;All;18;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;0;32;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Spherical;False;True;Relative;0;;0;-1;-1;1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;77;1;71;3
WireConnection;75;1;71;1
WireConnection;76;1;71;2
WireConnection;73;0;76;0
WireConnection;73;1;57;2
WireConnection;74;0;77;0
WireConnection;74;1;57;3
WireConnection;72;0;75;0
WireConnection;72;1;57;1
WireConnection;59;0;72;0
WireConnection;59;1;73;0
WireConnection;62;0;73;0
WireConnection;62;1;74;0
WireConnection;61;0;72;0
WireConnection;61;1;74;0
WireConnection;63;1;61;0
WireConnection;10;0;9;0
WireConnection;13;0;7;0
WireConnection;13;1;45;0
WireConnection;13;2;14;0
WireConnection;58;1;59;0
WireConnection;64;1;62;0
WireConnection;65;0;63;0
WireConnection;66;0;64;0
WireConnection;60;0;58;0
WireConnection;8;0;13;0
WireConnection;8;1;10;0
WireConnection;2;1;8;0
WireConnection;67;0;60;0
WireConnection;67;1;65;0
WireConnection;67;2;66;0
WireConnection;69;0;70;0
WireConnection;69;1;67;0
WireConnection;50;0;46;0
WireConnection;50;1;2;0
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;87;0;85;0
WireConnection;87;1;86;0
WireConnection;83;0;79;0
WireConnection;68;0;69;0
WireConnection;56;1;50;0
WireConnection;56;0;67;0
WireConnection;85;0;80;0
WireConnection;34;0;33;0
WireConnection;34;1;32;0
WireConnection;32;0;31;0
WireConnection;33;0;28;0
WireConnection;33;1;29;0
WireConnection;33;2;30;0
WireConnection;78;0;85;0
WireConnection;78;1;86;0
WireConnection;82;0;79;0
WireConnection;86;0;84;0
WireConnection;80;1;82;0
WireConnection;84;1;83;0
WireConnection;26;1;8;0
WireConnection;52;0;2;1
WireConnection;52;1;54;0
WireConnection;52;2;55;0
WireConnection;0;0;2;0
WireConnection;0;1;26;0
WireConnection;0;2;56;0
WireConnection;0;10;68;0
WireConnection;0;11;52;0
ASEEND*/
//CHKSM=CC3FFCA9EA24359EB929BE4FD504DFBFB4EB8F78