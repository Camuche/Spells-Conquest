// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Mat_CharacterBody"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Metallic("Metallic", 2D) = "white" {}
		_AO("AO", 2D) = "white" {}
		_CharacterTatooEmissive1("CharacterTatooEmissive", 2D) = "white" {}
		[HDR]_Right_ArmColor("Right_ArmColor", Color) = (0,0,0,0)
		[HDR]_Left_ArmColor("Left_ArmColor", Color) = (0,0,0,0)
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

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _CharacterTatooEmissive1;
		uniform float4 _CharacterTatooEmissive1_ST;
		uniform float4 _Right_ArmColor;
		uniform float4 _Left_ArmColor;
		uniform sampler2D _Metallic;
		uniform float4 _Metallic_ST;
		uniform sampler2D _AO;
		uniform float4 _AO_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
			float2 uv_CharacterTatooEmissive1 = i.uv_texcoord * _CharacterTatooEmissive1_ST.xy + _CharacterTatooEmissive1_ST.zw;
			float4 tex2DNode12 = tex2D( _CharacterTatooEmissive1, uv_CharacterTatooEmissive1 );
			float temp_output_11_0 = step( i.uv_texcoord.x , 0.3 );
			o.Emission = ( ( tex2DNode12 * temp_output_11_0 * _Right_ArmColor ) + ( tex2DNode12 * ( 1.0 - temp_output_11_0 ) * _Left_ArmColor ) ).rgb;
			float2 uv_Metallic = i.uv_texcoord * _Metallic_ST.xy + _Metallic_ST.zw;
			float4 tex2DNode3 = tex2D( _Metallic, uv_Metallic );
			o.Metallic = tex2DNode3.r;
			o.Smoothness = tex2DNode3.a;
			float2 uv_AO = i.uv_texcoord * _AO_ST.xy + _AO_ST.zw;
			o.Occlusion = tex2D( _AO, uv_AO ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Mat_CharacterBody;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;1;-528,-96;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;-1;None;fd2f441cfefb1f3448f01f3761f2792c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-528,-288;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;6fa55b7e626e947478ac0a1625444417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-528,224;Inherit;True;Property;_Metallic;Metallic;2;0;Create;True;0;0;0;False;0;False;-1;None;a34deaf88579fe546ab04f324db52c91;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-528,416;Inherit;True;Property;_AO;AO;3;0;Create;True;0;0;0;False;0;False;-1;None;0a32d5bf672b245468905407ed32da97;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-688,64;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1712,64;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;11;-1488,80;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-1680,-160;Inherit;True;Property;_CharacterTatooEmissive1;CharacterTatooEmissive;4;0;Create;True;0;0;0;False;0;False;-1;None;ce5e1d2271c27ae4aad41d46cdf4e3e2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;13;-1312,304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1072,288;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1072,64;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;17;-1616,-336;Inherit;False;Property;_Right_ArmColor;Right_ArmColor;5;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;16;-1600,336;Inherit;False;Property;_Left_ArmColor;Left_ArmColor;6;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;0;0;2;0
WireConnection;0;1;1;0
WireConnection;0;2;9;0
WireConnection;0;3;3;1
WireConnection;0;4;3;4
WireConnection;0;5;4;0
WireConnection;9;0;15;0
WireConnection;9;1;14;0
WireConnection;11;0;10;1
WireConnection;13;0;11;0
WireConnection;14;0;12;0
WireConnection;14;1;13;0
WireConnection;14;2;16;0
WireConnection;15;0;12;0
WireConnection;15;1;11;0
WireConnection;15;2;17;0
ASEEND*/
//CHKSM=8900FEAB4E68709CFD302A4D092C4B8B348555B1