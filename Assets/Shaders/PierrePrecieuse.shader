// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PierrePrecieuse"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_AO("AO", 2D) = "white" {}
		_EmissiveIntensity("EmissiveIntensity", Float) = 0
		_isEnlightened("isEnlightened", Range( 0 , 1)) = 0
		_Metallic("Metallic", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
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
		uniform float _isEnlightened;
		uniform sampler2D _Metallic;
		uniform float4 _Metallic_ST;
		uniform float _EmissiveIntensity;
		uniform sampler2D _AO;
		uniform float4 _AO_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = ( tex2D( _Albedo, uv_Albedo ) * _isEnlightened ).rgb;
			float clampResult18 = clamp( ( _SinTime.w + 1.0 ) , 0.0 , 1.0 );
			float2 uv_Metallic = i.uv_texcoord * _Metallic_ST.xy + _Metallic_ST.zw;
			float4 tex2DNode45 = tex2D( _Metallic, uv_Metallic );
			float3 temp_cast_1 = (( clampResult18 * ( 1.0 - tex2DNode45.a ) * _EmissiveIntensity * _isEnlightened )).xxx;
			o.Emission = temp_cast_1;
			o.Metallic = tex2DNode45.r;
			o.Smoothness = tex2DNode45.a;
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
Node;AmplifyShaderEditor.OneMinusNode;8;-1327.88,147.147;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;21;-1129.773,144.7238;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1162.743,264.1125;Inherit;False;Property;_Fresnel_Intensity;Fresnel_Intensity;7;0;Create;True;0;0;0;False;0;False;1.01;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-931.5383,143.0431;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;5;-1611.712,148.4438;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;-1341.572,-197.5045;Inherit;False;Property;_Emissive_Color;Emissive _Color;9;0;Create;True;0;0;0;False;0;False;0,1,0.8893785,0;0,1,0.8901961,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-2326.57,-374.6894;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;34;-1734.466,-397.9894;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.3490566,0.3490566,0.3490566,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1416.779,-399.1596;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-2095.423,-398.9925;Inherit;True;Property;_Albedo_Noise;Albedo_Noise;3;0;Create;True;0;0;0;False;0;False;-1;86c5756d68f2fc943931cccfda0be742;86c5756d68f2fc943931cccfda0be742;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-2514.269,-350.0893;Inherit;False;Property;_NoiseScale;NoiseScale;4;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1749.934,-78.82169;Inherit;False;Constant;_Float1;Float 1;11;0;Create;True;0;0;0;False;0;False;0.8;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-1774.368,-276.5759;Inherit;False;Property;_Color0;Color 0;8;0;Create;True;0;0;0;False;0;False;0,1,0.8893785,0;0,0.6588235,0.5882353,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;878.0763,0.8437093;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;PierrePrecieuse;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1885.274,222.8439;Inherit;False;Property;_Fresnel_Scale;Fresnel_Scale;5;0;Create;True;0;0;0;False;0;False;8.55;2.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1884.274,288.844;Inherit;False;Property;_Fresnel_Power;Fresnel_Power;6;0;Create;True;0;0;0;False;0;False;2.4;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-384,-416;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;eb7bedf5cf535bd4dacc8ab5054c3a8a;39eec6c39daefe54083a63c6909a60a2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-384,-240;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;-1;2db1ee02c203c8340b1153a8ebc4b108;ed931a1aedcf6e64aa8cbafaf0c9b331;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;432,-240;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;38;78.2626,535.9085;Inherit;True;Property;_AO;AO;2;0;Create;True;0;0;0;False;0;False;-1;4bffd572c8ea4bf4caf96d5c41c418fd;59b66886e081f9a43ae61b454eddb623;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;272,48;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-713.2397,-17.20581;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;45;-304,128;Inherit;True;Property;_Metallic;Metallic;12;0;Create;True;0;0;0;False;0;False;-1;None;430a42014bf944c4094b747faf308eed;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;51;323.0929,179.0929;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;49;80,272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;18;32,-32;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-128,-32;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;7;-320,-32;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;39;-16,96;Inherit;False;Property;_EmissiveIntensity;EmissiveIntensity;10;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-204.5444,-531.741;Inherit;False;Property;_isEnlightened;isEnlightened;11;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
WireConnection;8;0;5;0
WireConnection;21;0;8;0
WireConnection;15;0;21;0
WireConnection;15;1;16;0
WireConnection;5;2;10;0
WireConnection;5;3;11;0
WireConnection;27;0;28;0
WireConnection;34;0;1;0
WireConnection;29;0;34;0
WireConnection;29;1;12;0
WireConnection;29;2;35;0
WireConnection;1;1;27;0
WireConnection;0;0;42;0
WireConnection;0;1;2;0
WireConnection;0;2;48;0
WireConnection;0;3;51;0
WireConnection;0;4;45;4
WireConnection;0;5;38;0
WireConnection;42;0;36;0
WireConnection;42;1;41;0
WireConnection;48;0;18;0
WireConnection;48;1;49;0
WireConnection;48;2;39;0
WireConnection;48;3;41;0
WireConnection;17;0;29;0
WireConnection;17;1;26;0
WireConnection;17;2;15;0
WireConnection;51;0;45;1
WireConnection;49;0;45;4
WireConnection;18;0;44;0
WireConnection;44;0;7;4
ASEEND*/
//CHKSM=2E836DF731D0B69CC3D1255B6317FCA268D01FB3