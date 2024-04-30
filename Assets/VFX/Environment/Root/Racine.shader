// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Racine"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Grow("Grow", Range( 0 , 2)) = 0.4727595
		_PushPull("PushPull", Float) = -0.1
		_AddOpacity("AddOpacity", Float) = 0
		_MultiplyOpacity("MultiplyOpacity", Float) = 1
		_Texture_Albedo("Texture_Albedo", 2D) = "white" {}
		_Texture_Normal("Texture_Normal", 2D) = "white" {}
		_Texture_AO("Texture_AO", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Grow;
		uniform float _PushPull;
		uniform sampler2D _Texture_Normal;
		uniform float4 _Texture_Normal_ST;
		uniform sampler2D _Texture_Albedo;
		uniform float4 _Texture_Albedo_ST;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform sampler2D _Texture_AO;
		uniform float4 _Texture_AO_ST;
		uniform float _MultiplyOpacity;
		uniform float _AddOpacity;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( saturate( ( (0.0 + (_Grow - 0.0) * (1.3 - 0.0) / (1.0 - 0.0)) - v.texcoord.xy.y ) ) * ase_vertexNormal ) * _PushPull );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture_Normal = i.uv_texcoord * _Texture_Normal_ST.xy + _Texture_Normal_ST.zw;
			o.Normal = tex2D( _Texture_Normal, uv_Texture_Normal ).rgb;
			float2 uv_Texture_Albedo = i.uv_texcoord * _Texture_Albedo_ST.xy + _Texture_Albedo_ST.zw;
			o.Albedo = tex2D( _Texture_Albedo, uv_Texture_Albedo ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			float2 uv_Texture_AO = i.uv_texcoord * _Texture_AO_ST.xy + _Texture_AO_ST.zw;
			o.Occlusion = tex2D( _Texture_AO, uv_Texture_AO ).r;
			o.Alpha = 1;
			clip( ( 1.0 - saturate( ( ( _MultiplyOpacity * ( _AddOpacity + _Grow ) ) - i.uv_texcoord.y ) ) ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;33;-1312.303,-1071.56;Inherit;False;1017.906;505.8571;Dissolve;8;27;28;29;26;32;1;31;30;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Racine;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.StepOpNode;27;-527.3969,-1021.56;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;28;-713.3973,-1017.56;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-680.3973,-942.5598;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;26;-943.6628,-1011.828;Inherit;False;0;0;1;4;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;10.25;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;32;-1140.289,-965.1838;Inherit;False;Property;_Dissolve_Scale;Dissolve_Scale;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-975.4042,-893.6312;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;31;-944.3035,-774.7027;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1262.303,-774.7026;Inherit;False;Property;_Dissolve;Dissolve;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;50;-1093.658,546.9838;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;52;-883.5941,547.1307;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-1464.063,428.6451;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;61;-1436.88,547.6189;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;104;-1089.6,240.2972;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-1396.6,242.4428;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;-1576.163,267.7034;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;105;-880.5994,239.1518;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;58;-709.4608,240.3601;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-653.0234,553.6004;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-396.6252,556.2299;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-650.758,652.2295;Inherit;False;Property;_PushPull;PushPull;6;0;Create;True;0;0;0;False;0;False;-0.1;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-2012.751,549.3555;Inherit;False;Property;_Grow;Grow;5;0;Create;True;0;0;0;False;0;False;0.4727595;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-1772.465,264.4427;Inherit;False;Property;_AddOpacity;AddOpacity;7;0;Create;True;0;0;0;False;0;False;0;0.91;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-1609.115,191.4614;Inherit;False;Property;_MultiplyOpacity;MultiplyOpacity;8;0;Create;True;0;0;0;False;0;False;1;0.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;15;-913.5577,629.0508;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;113;-682.6437,-310.6903;Inherit;True;Property;_Texture_Normal;Texture_Normal;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;112;-687.4441,-501.0903;Inherit;True;Property;_Texture_Albedo;Texture_Albedo;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-681.3864,138.0742;Inherit;False;Property;_Smoothness;Smoothness;1;0;Create;True;0;0;0;False;0;False;0;0.214;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-681.3864,70.07426;Inherit;False;Property;_Metallic;Metallic;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-684.8875,-119.6882;Inherit;True;Property;_Texture_AO;Texture_AO;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;0;0;112;0
WireConnection;0;1;113;0
WireConnection;0;3;6;0
WireConnection;0;4;7;0
WireConnection;0;5;114;0
WireConnection;0;10;58;0
WireConnection;0;11;56;0
WireConnection;27;0;28;0
WireConnection;27;1;29;0
WireConnection;28;0;26;0
WireConnection;29;0;1;2
WireConnection;29;1;31;0
WireConnection;26;2;32;0
WireConnection;31;0;30;0
WireConnection;50;0;61;0
WireConnection;50;1;43;2
WireConnection;52;0;50;0
WireConnection;61;0;51;0
WireConnection;104;0;108;0
WireConnection;104;1;43;2
WireConnection;108;0;110;0
WireConnection;108;1;107;0
WireConnection;107;0;109;0
WireConnection;107;1;51;0
WireConnection;105;0;104;0
WireConnection;58;0;105;0
WireConnection;53;0;52;0
WireConnection;53;1;15;0
WireConnection;56;0;53;0
WireConnection;56;1;57;0
ASEEND*/
//CHKSM=DD1D332035EA1EF50682886FD64DB94AC39A3B34