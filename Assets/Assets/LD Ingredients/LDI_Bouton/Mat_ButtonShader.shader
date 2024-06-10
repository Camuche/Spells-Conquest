// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Mat_ButtonShader"
{
	Properties
	{
		_LDI_Tenture_Albedo("LDI_Tenture_Albedo", 2D) = "white" {}
		_LDI_Tenture_Normal("LDI_Tenture_Normal", 2D) = "bump" {}
		_LDI_Tenture_Metallic("LDI_Tenture_Metallic", 2D) = "white" {}
		_LDI_Tenture_AO("LDI_Tenture_AO", 2D) = "white" {}
		_Emissive("Emissive", Range( 0 , 1)) = 0
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

		uniform sampler2D _LDI_Tenture_Normal;
		uniform float4 _LDI_Tenture_Normal_ST;
		uniform sampler2D _LDI_Tenture_Albedo;
		uniform float4 _LDI_Tenture_Albedo_ST;
		uniform float _Emissive;
		uniform sampler2D _LDI_Tenture_Metallic;
		uniform float4 _LDI_Tenture_Metallic_ST;
		uniform sampler2D _LDI_Tenture_AO;
		uniform float4 _LDI_Tenture_AO_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_LDI_Tenture_Normal = i.uv_texcoord * _LDI_Tenture_Normal_ST.xy + _LDI_Tenture_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _LDI_Tenture_Normal, uv_LDI_Tenture_Normal ) );
			float2 uv_LDI_Tenture_Albedo = i.uv_texcoord * _LDI_Tenture_Albedo_ST.xy + _LDI_Tenture_Albedo_ST.zw;
			float4 tex2DNode1 = tex2D( _LDI_Tenture_Albedo, uv_LDI_Tenture_Albedo );
			o.Albedo = tex2DNode1.rgb;
			float2 uv_LDI_Tenture_Metallic = i.uv_texcoord * _LDI_Tenture_Metallic_ST.xy + _LDI_Tenture_Metallic_ST.zw;
			float4 tex2DNode3 = tex2D( _LDI_Tenture_Metallic, uv_LDI_Tenture_Metallic );
			o.Emission = ( tex2DNode1 * _Emissive * ( 1.0 - tex2DNode3.a ) * 10.0 ).rgb;
			o.Metallic = tex2DNode3.r;
			o.Smoothness = tex2DNode3.a;
			float2 uv_LDI_Tenture_AO = i.uv_texcoord * _LDI_Tenture_AO_ST.xy + _LDI_Tenture_AO_ST.zw;
			o.Occlusion = tex2D( _LDI_Tenture_AO, uv_LDI_Tenture_AO ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Mat_ButtonShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;1;-1072,-288;Inherit;True;Property;_LDI_Tenture_Albedo;LDI_Tenture_Albedo;0;0;Create;True;0;0;0;False;0;False;-1;3c79779a6af5e654b86114c13a704c7e;3c79779a6af5e654b86114c13a704c7e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1072,-96;Inherit;True;Property;_LDI_Tenture_Normal;LDI_Tenture_Normal;1;0;Create;True;0;0;0;False;0;False;-1;347197cc0853b63439d88c55af025458;347197cc0853b63439d88c55af025458;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-1088,112;Inherit;False;Property;_Emissive;Emissive;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-528,96;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;7;-752,144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-960,192;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1088,304;Inherit;True;Property;_LDI_Tenture_Metallic;LDI_Tenture_Metallic;2;0;Create;True;0;0;0;False;0;False;-1;8e1a24a1aded5cd45a237bfc0a4d5098;8e1a24a1aded5cd45a237bfc0a4d5098;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-1088,512;Inherit;True;Property;_LDI_Tenture_AO;LDI_Tenture_AO;3;0;Create;True;0;0;0;False;0;False;-1;81190c6a4cece4747a6545be13bd1c13;81190c6a4cece4747a6545be13bd1c13;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;0;0;1;0
WireConnection;0;1;2;0
WireConnection;0;2;5;0
WireConnection;0;3;3;1
WireConnection;0;4;3;4
WireConnection;0;5;4;0
WireConnection;5;0;1;0
WireConnection;5;1;6;0
WireConnection;5;2;7;0
WireConnection;5;3;8;0
WireConnection;7;0;3;4
ASEEND*/
//CHKSM=7BA1E2ED22CACC646B85C34AD31EFD924664597D