// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/DoubleSided"
{
	Properties
	{
		_Foliagelow_Albedo("Foliage low_Albedo", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Foliagelow_AO("Foliage low_AO", 2D) = "white" {}
		_Foliagelow_Metallic("Foliage low_Metallic", 2D) = "white" {}
		_Foliagelow_Normal("Foliage low_Normal", 2D) = "bump" {}
		_Masquedopacite("Masque d'opacite", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Foliagelow_Normal;
		uniform float4 _Foliagelow_Normal_ST;
		uniform sampler2D _Foliagelow_Albedo;
		uniform float4 _Foliagelow_Albedo_ST;
		uniform sampler2D _Foliagelow_Metallic;
		uniform float4 _Foliagelow_Metallic_ST;
		uniform sampler2D _Foliagelow_AO;
		uniform float4 _Foliagelow_AO_ST;
		uniform sampler2D _Masquedopacite;
		uniform float4 _Masquedopacite_ST;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Foliagelow_Normal = i.uv_texcoord * _Foliagelow_Normal_ST.xy + _Foliagelow_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Foliagelow_Normal, uv_Foliagelow_Normal ) );
			float2 uv_Foliagelow_Albedo = i.uv_texcoord * _Foliagelow_Albedo_ST.xy + _Foliagelow_Albedo_ST.zw;
			o.Albedo = tex2D( _Foliagelow_Albedo, uv_Foliagelow_Albedo ).rgb;
			float2 uv_Foliagelow_Metallic = i.uv_texcoord * _Foliagelow_Metallic_ST.xy + _Foliagelow_Metallic_ST.zw;
			o.Metallic = tex2D( _Foliagelow_Metallic, uv_Foliagelow_Metallic ).r;
			float2 uv_Foliagelow_AO = i.uv_texcoord * _Foliagelow_AO_ST.xy + _Foliagelow_AO_ST.zw;
			o.Occlusion = tex2D( _Foliagelow_AO, uv_Foliagelow_AO ).r;
			o.Alpha = 1;
			float2 uv_Masquedopacite = i.uv_texcoord * _Masquedopacite_ST.xy + _Masquedopacite_ST.zw;
			clip( tex2D( _Masquedopacite, uv_Masquedopacite ).r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.SamplerNode;1;-457.3132,17.09744;Inherit;True;Property;_Foliagelow_Albedo;Foliage low_Albedo;0;0;Create;True;0;0;0;False;0;False;-1;37dfecf8ebbca544ab95e48d75dd7741;37dfecf8ebbca544ab95e48d75dd7741;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-457.3132,210.0974;Inherit;True;Property;_Foliagelow_AO;Foliage low_AO;2;0;Create;True;0;0;0;False;0;False;-1;07c39a96080050447a8e3fba5c8f04a7;07c39a96080050447a8e3fba5c8f04a7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-742.3132,330.0974;Inherit;True;Property;_Foliagelow_Normal;Foliage low_Normal;4;0;Create;True;0;0;0;False;0;False;-1;ac61aa8ffc4cd7a4db361f4e2245a06d;ac61aa8ffc4cd7a4db361f4e2245a06d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-739.3132,128.0974;Inherit;True;Property;_Foliagelow_Metallic;Foliage low_Metallic;3;0;Create;True;0;0;0;False;0;False;-1;c3ed1cf8c557869469464fbe76a47fcc;c3ed1cf8c557869469464fbe76a47fcc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/DoubleSided;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;False;Transparent;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;6;-453.2324,406.1861;Inherit;True;Property;_Masquedopacite;Masque d'opacite;5;0;Create;True;0;0;0;False;0;False;-1;342e2220d0cabf142bb78e120bce5ae9;342e2220d0cabf142bb78e120bce5ae9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;0;0;1;0
WireConnection;0;1;5;0
WireConnection;0;3;4;0
WireConnection;0;5;2;0
WireConnection;0;10;6;0
ASEEND*/
//CHKSM=26AAE5B784A184E0075EBBB98D42947971CA5873