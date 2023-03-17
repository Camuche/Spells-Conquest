// Made with Amplify Shader Editor v1.9.0.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UI"
{
	Properties
	{
		_LifeLostColor("LifeLostColor", Color) = (0,0,0,0)
		_LifeColor("LifeColor", Color) = (0,0,0,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Life("Life", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _LifeLostColor;
		uniform float4 _LifeColor;
		uniform float _Life;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_3_0_g5 = ( (0.05 + (_Life - 0.0) * (0.34 - 0.05) / (1.0 - 0.0)) - i.uv_texcoord.x );
			float4 lerpResult19 = lerp( _LifeLostColor , _LifeColor , saturate( ( temp_output_3_0_g5 / fwidth( temp_output_3_0_g5 ) ) ));
			float temp_output_3_0_g1 = ( 0.34 - i.uv_texcoord.x );
			float temp_output_3_0_g2 = ( 0.95 - ( 1.0 - i.uv_texcoord.x ) );
			float temp_output_3_0_g3 = ( 0.94 - i.uv_texcoord.y );
			float temp_output_3_0_g4 = ( 0.13 - ( 1.0 - i.uv_texcoord.y ) );
			float temp_output_29_0 = ( saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) ) * saturate( ( temp_output_3_0_g2 / fwidth( temp_output_3_0_g2 ) ) ) * saturate( ( temp_output_3_0_g3 / fwidth( temp_output_3_0_g3 ) ) ) * saturate( ( temp_output_3_0_g4 / fwidth( temp_output_3_0_g4 ) ) ) );
			o.Albedo = ( lerpResult19 * temp_output_29_0 ).rgb;
			o.Alpha = 1;
			clip( temp_output_29_0 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19001
1920;0;1920;1019;2483.194;652.737;1.843224;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1997.59,-92.18801;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-1977.982,-442.7586;Inherit;False;Property;_Life;Life;3;0;Create;True;0;0;0;False;0;False;0;0.57;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;18;-1578.182,-378.3587;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.05;False;4;FLOAT;0.34;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;9;-1674.633,125.3886;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;10;-1683.633,373.3887;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;-941.9819,-617.1586;Inherit;False;Property;_LifeLostColor;LifeLostColor;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;20;-942.5817,-399.5586;Inherit;False;Property;_LifeColor;LifeColor;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;28;-1286.282,-329.1351;Inherit;False;Step Antialiasing;-1;;5;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;24;-1477.325,35.44144;Inherit;False;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.34;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;25;-1449.325,171.4415;Inherit;False;Step Antialiasing;-1;;2;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;26;-1415.325,318.4416;Inherit;False;Step Antialiasing;-1;;3;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.94;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;27;-1428.325,460.4416;Inherit;False;Step Antialiasing;-1;;4;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.13;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-590.1821,-237.7586;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1180.534,250.8777;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-221.3999,-13.04556;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;6;66.85648,16.76571;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;UI;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Geometry;All;18;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;2;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;22;0
WireConnection;9;0;8;1
WireConnection;10;0;8;2
WireConnection;28;1;8;1
WireConnection;28;2;18;0
WireConnection;24;1;8;1
WireConnection;25;1;9;0
WireConnection;26;1;8;2
WireConnection;27;1;10;0
WireConnection;19;0;21;0
WireConnection;19;1;20;0
WireConnection;19;2;28;0
WireConnection;29;0;24;0
WireConnection;29;1;25;0
WireConnection;29;2;26;0
WireConnection;29;3;27;0
WireConnection;23;0;19;0
WireConnection;23;1;29;0
WireConnection;6;0;23;0
WireConnection;6;10;29;0
ASEEND*/
//CHKSM=1B5D5FAC11381972E63F1D048CA5BAAA170DCCA9