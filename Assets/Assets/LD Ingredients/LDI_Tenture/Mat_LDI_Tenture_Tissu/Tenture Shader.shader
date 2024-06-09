// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Tenture"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_LDI_Tenture_Albedo("LDI_Tenture_Albedo", 2D) = "white" {}
		_LDI_Tenture_Normal("LDI_Tenture_Normal", 2D) = "bump" {}
		_LDI_Tenture_Metallic("LDI_Tenture_Metallic", 2D) = "white" {}
		_LDI_Tenture_AO("LDI_Tenture_AO", 2D) = "white" {}
		_OpacityMaskfromMeshProBuilderDefault("Opacity Mask from Mesh ProBuilderDefault", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _LDI_Tenture_Normal;
		uniform float4 _LDI_Tenture_Normal_ST;
		uniform sampler2D _LDI_Tenture_Albedo;
		uniform float4 _LDI_Tenture_Albedo_ST;
		uniform sampler2D _LDI_Tenture_Metallic;
		uniform float4 _LDI_Tenture_Metallic_ST;
		uniform sampler2D _LDI_Tenture_AO;
		uniform float4 _LDI_Tenture_AO_ST;
		uniform sampler2D _OpacityMaskfromMeshProBuilderDefault;
		uniform float4 _OpacityMaskfromMeshProBuilderDefault_ST;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_LDI_Tenture_Normal = i.uv_texcoord * _LDI_Tenture_Normal_ST.xy + _LDI_Tenture_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _LDI_Tenture_Normal, uv_LDI_Tenture_Normal ) );
			float2 uv_LDI_Tenture_Albedo = i.uv_texcoord * _LDI_Tenture_Albedo_ST.xy + _LDI_Tenture_Albedo_ST.zw;
			o.Albedo = tex2D( _LDI_Tenture_Albedo, uv_LDI_Tenture_Albedo ).rgb;
			float2 uv_LDI_Tenture_Metallic = i.uv_texcoord * _LDI_Tenture_Metallic_ST.xy + _LDI_Tenture_Metallic_ST.zw;
			o.Metallic = tex2D( _LDI_Tenture_Metallic, uv_LDI_Tenture_Metallic ).r;
			float2 uv_LDI_Tenture_AO = i.uv_texcoord * _LDI_Tenture_AO_ST.xy + _LDI_Tenture_AO_ST.zw;
			o.Occlusion = tex2D( _LDI_Tenture_AO, uv_LDI_Tenture_AO ).r;
			o.Alpha = 1;
			float2 uv_OpacityMaskfromMeshProBuilderDefault = i.uv_texcoord * _OpacityMaskfromMeshProBuilderDefault_ST.xy + _OpacityMaskfromMeshProBuilderDefault_ST.zw;
			clip( tex2D( _OpacityMaskfromMeshProBuilderDefault, uv_OpacityMaskfromMeshProBuilderDefault ).r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/Tenture;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;1;-841.1373,-333.8327;Inherit;True;Property;_LDI_Tenture_Albedo;LDI_Tenture_Albedo;1;0;Create;True;0;0;0;False;0;False;-1;3c79779a6af5e654b86114c13a704c7e;3c79779a6af5e654b86114c13a704c7e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-840.0327,-139.4597;Inherit;True;Property;_LDI_Tenture_Normal;LDI_Tenture_Normal;2;0;Create;True;0;0;0;False;0;False;-1;347197cc0853b63439d88c55af025458;347197cc0853b63439d88c55af025458;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-836.626,53.42309;Inherit;True;Property;_LDI_Tenture_Metallic;LDI_Tenture_Metallic;3;0;Create;True;0;0;0;False;0;False;-1;8e1a24a1aded5cd45a237bfc0a4d5098;8e1a24a1aded5cd45a237bfc0a4d5098;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-827.3345,253.4512;Inherit;True;Property;_LDI_Tenture_AO;LDI_Tenture_AO;4;0;Create;True;0;0;0;False;0;False;-1;81190c6a4cece4747a6545be13bd1c13;81190c6a4cece4747a6545be13bd1c13;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-871.0191,447.7315;Inherit;True;Property;_OpacityMaskfromMeshProBuilderDefault;Opacity Mask from Mesh ProBuilderDefault;5;0;Create;True;0;0;0;False;0;False;-1;932a5308d02a15e4082119a2f849d4bd;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-1183.458,49.16154;Inherit;True;Property;_LDI_Tenture_Height;LDI_Tenture_Height;6;0;Create;True;0;0;0;False;0;False;-1;5bcd5542e846fba4dade2ac350df80b3;5bcd5542e846fba4dade2ac350df80b3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;0;0;1;0
WireConnection;0;1;3;0
WireConnection;0;3;4;0
WireConnection;0;5;5;0
WireConnection;0;10;6;0
ASEEND*/
//CHKSM=FBB1ACE41ADBA4AEE1F0C60C728FDC575E6897A9