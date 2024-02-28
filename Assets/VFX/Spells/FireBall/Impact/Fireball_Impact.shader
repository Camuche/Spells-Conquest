// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Fireball_Impact"
{
	Properties
	{
		_Fresnel_Power("Fresnel_Power", Float) = 0
		_Fresnel_Scale("Fresnel_Scale", Float) = 0
		_Opacity("Opacity", Float) = 0
		_Float0("Float 0", Float) = 0
		_Float1("Float 1", Float) = 0
		_Impact_Star("Impact_Star", 2D) = "white" {}
		_Offset_Image("Offset_Image", Vector) = (0,0,0,0)
		_HDR("HDR", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			float4 vertexColor : COLOR;
		};

		uniform float _HDR;
		uniform sampler2D _Impact_Star;
		uniform float2 _Offset_Image;
		uniform float _Fresnel_Scale;
		uniform float _Fresnel_Power;
		uniform float _Float0;
		uniform float _Float1;
		uniform float _Opacity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 color3 = IsGammaSpace() ? float4(1,1,0,0) : float4(1,1,0,0);
			float2 uv_TexCoord62 = i.uv_texcoord + _Offset_Image;
			float4 tex2DNode55 = tex2D( _Impact_Star, uv_TexCoord62 );
			float4 lerpResult60 = lerp( ( color3 * _HDR ) , tex2DNode55 , tex2DNode55.a);
			float4 color4 = IsGammaSpace() ? float4(1,0.5607843,0,0) : float4(1,0.2746773,0,0);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1 = ( 0.0 + _Fresnel_Scale * pow( 1.0 - fresnelNdotV1, _Fresnel_Power ) );
			float4 lerpResult5 = lerp( lerpResult60 , ( color4 * _HDR ) , fresnelNode1);
			float4 color16 = IsGammaSpace() ? float4(1,0,0,0) : float4(1,0,0,0);
			float fresnelNdotV50 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode50 = ( 0.0 + _Float0 * pow( 1.0 - fresnelNdotV50, _Float1 ) );
			float4 lerpResult53 = lerp( lerpResult5 , color16 , fresnelNode50);
			float4 clampResult54 = clamp( lerpResult53 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Emission = clampResult54.rgb;
			o.Alpha = ( _Opacity * i.vertexColor.a );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.FresnelNode;1;-1368.768,210.9609;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1564.077,444.0343;Inherit;False;Property;_Fresnel_Power;Fresnel_Power;0;0;Create;True;0;0;0;False;0;False;0;0.52;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1584.077,326.034;Inherit;False;Property;_Fresnel_Scale;Fresnel_Scale;1;0;Create;True;0;0;0;False;0;False;0;1.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;5;-977.2341,70.79073;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-346.951,227.1514;Inherit;False;Property;_Opacity;Opacity;2;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;50;-1370.608,594.7732;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1618.149,631.439;Inherit;False;Property;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;0;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1585.149,717.439;Inherit;False;Property;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;0;33.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;53;-597.0615,114.811;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;54;-275.9318,75.32326;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;16;-1058.892,225.1652;Inherit;False;Constant;_Color2;Color 2;4;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;55;-1549.576,-422.6123;Inherit;True;Property;_Impact_Star;Impact_Star;5;0;Create;True;0;0;0;False;0;False;-1;f8d708ba0178fe243becac3ff3e34a36;f8d708ba0178fe243becac3ff3e34a36;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;60;-1176.786,-272.5313;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-8.800014,29.1;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Fireball_Impact;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.VertexColorNode;73;-532.589,411.1988;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-169.8889,256.499;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-1791.021,-398.8434;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;64;-1998.825,-350.5406;Inherit;False;Property;_Offset_Image;Offset_Image;6;0;Create;True;0;0;0;False;0;False;0,0;0.26,0.04;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;3;-1791.534,-212.1089;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;1,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-1779.834,-43.10919;Inherit;False;Constant;_Color1;Color 1;1;0;Create;True;0;0;0;False;0;False;1,0.5607843,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;-1582.946,-88.75653;Inherit;False;Property;_HDR;HDR;7;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-1432.946,-209.7565;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1341.946,-38.75653;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
WireConnection;1;2;6;0
WireConnection;1;3;7;0
WireConnection;5;0;60;0
WireConnection;5;1;76;0
WireConnection;5;2;1;0
WireConnection;50;2;51;0
WireConnection;50;3;52;0
WireConnection;53;0;5;0
WireConnection;53;1;16;0
WireConnection;53;2;50;0
WireConnection;54;0;53;0
WireConnection;55;1;62;0
WireConnection;60;0;75;0
WireConnection;60;1;55;0
WireConnection;60;2;55;4
WireConnection;0;2;54;0
WireConnection;0;9;74;0
WireConnection;74;0;49;0
WireConnection;74;1;73;4
WireConnection;62;1;64;0
WireConnection;75;0;3;0
WireConnection;75;1;77;0
WireConnection;76;0;4;0
WireConnection;76;1;77;0
ASEEND*/
//CHKSM=396CC97AD16A0CE97AE49376F6891023CDD1519C