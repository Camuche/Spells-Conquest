// Made with Amplify Shader Editor v1.9.0.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Magical Flower"
{
	Properties
	{
		_fleur_magique_low_fleur_part_trois_high_save3_BaseMap("fleur_magique_low_fleur_part_trois_high_save3_BaseMap", 2D) = "white" {}
		_fleur_magique_low_fleur_part_trois_high_save3_Normal("fleur_magique_low_fleur_part_trois_high_save3_Normal", 2D) = "bump" {}
		_Color0("Color 0", Color) = (1,0,0,0)
		_Emissive("Emissive", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _fleur_magique_low_fleur_part_trois_high_save3_Normal;
		uniform float4 _fleur_magique_low_fleur_part_trois_high_save3_Normal_ST;
		uniform sampler2D _fleur_magique_low_fleur_part_trois_high_save3_BaseMap;
		uniform float4 _fleur_magique_low_fleur_part_trois_high_save3_BaseMap_ST;
		uniform float4 _Color0;
		uniform float _Emissive;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_fleur_magique_low_fleur_part_trois_high_save3_Normal = i.uv_texcoord * _fleur_magique_low_fleur_part_trois_high_save3_Normal_ST.xy + _fleur_magique_low_fleur_part_trois_high_save3_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _fleur_magique_low_fleur_part_trois_high_save3_Normal, uv_fleur_magique_low_fleur_part_trois_high_save3_Normal ) );
			float2 uv_fleur_magique_low_fleur_part_trois_high_save3_BaseMap = i.uv_texcoord * _fleur_magique_low_fleur_part_trois_high_save3_BaseMap_ST.xy + _fleur_magique_low_fleur_part_trois_high_save3_BaseMap_ST.zw;
			float4 tex2DNode4 = tex2D( _fleur_magique_low_fleur_part_trois_high_save3_BaseMap, uv_fleur_magique_low_fleur_part_trois_high_save3_BaseMap );
			o.Albedo = tex2DNode4.rgb;
			float temp_output_3_0_g1 = ( 0.5 - i.uv_texcoord.x );
			float temp_output_8_0 = saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) );
			float temp_output_3_0_g2 = ( 0.36 - ( 1.0 - i.uv_texcoord.y ) );
			float temp_output_9_0 = saturate( ( temp_output_3_0_g2 / fwidth( temp_output_3_0_g2 ) ) );
			o.Emission = ( tex2DNode4 * temp_output_8_0 * temp_output_9_0 * _Color0 * _Emissive ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19001
-1920;0;1920;1019;1222.445;205.0633;1;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1266.714,-421.9618;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;15;-1060.076,-328.9082;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-304.5676,-214.8532;Inherit;False;Property;_Emissive;Emissive;4;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-856.9999,-102.1;Inherit;True;Property;_fleur_magique_low_fleur_part_trois_high_save3_BaseMap;fleur_magique_low_fleur_part_trois_high_save3_BaseMap;0;0;Create;True;0;0;0;False;0;False;-1;c5a6d0a5406cdf94a823057776d6f9fd;c5a6d0a5406cdf94a823057776d6f9fd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;13;-377.368,-507.3528;Inherit;False;Property;_Color0;Color 0;3;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0.04245281,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;8;-886.7137,-686.9619;Inherit;True;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;9;-902.7137,-423.9618;Inherit;True;Step Antialiasing;-1;;2;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.36;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-179.5093,289.6637;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-866,98.5;Inherit;True;Property;_fleur_magique_low_fleur_part_trois_high_save3_MaskMap;fleur_magique_low_fleur_part_trois_high_save3_MaskMap;1;0;Create;True;0;0;0;False;0;False;-1;74ba8111fe29e8a4ab1f32d833e9cc3f;74ba8111fe29e8a4ab1f32d833e9cc3f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;49.55518,290.9367;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;23;-23.44482,549.9367;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-110.8679,-353.9528;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-816,341.5;Inherit;True;Property;_fleur_magique_low_fleur_part_trois_high_save3_Normal;fleur_magique_low_fleur_part_trois_high_save3_Normal;2;0;Create;True;0;0;0;False;0;False;-1;6f80615a743bc304cac7968f4537901c;6f80615a743bc304cac7968f4537901c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;184.5552,342.9367;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-85.39453,156.344;Inherit;False;Property;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;1;0.76;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;32;352.3,9.1;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Magical Flower;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;7;2
WireConnection;8;1;7;1
WireConnection;9;1;15;0
WireConnection;21;0;8;0
WireConnection;21;1;9;0
WireConnection;25;0;20;0
WireConnection;25;1;21;0
WireConnection;23;0;21;0
WireConnection;14;0;4;0
WireConnection;14;1;8;0
WireConnection;14;2;9;0
WireConnection;14;3;13;0
WireConnection;14;4;17;0
WireConnection;24;0;25;0
WireConnection;24;1;23;0
WireConnection;32;0;4;0
WireConnection;32;1;6;0
WireConnection;32;2;14;0
ASEEND*/
//CHKSM=D594ECA7B3284D5B254C648A5A79BECADC323446