// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ParticleRedYellow"
{
	Properties
	{
		[HDR]_Color1("Color 1", Color) = (1,1,1,0)
		[HDR]_Color0("Color 0", Color) = (1,1,0,0)
		_EllipseSize("EllipseSize", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		AlphaToMask On
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _EllipseSize;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult11_g1 = (float2(0.9 , 0.9));
			float temp_output_17_0_g1 = length( ( (i.uv_texcoord*2.0 + -1.0) / appendResult11_g1 ) );
			float temp_output_5_0 = saturate( ( ( 1.0 - temp_output_17_0_g1 ) / fwidth( temp_output_17_0_g1 ) ) );
			float4 lerpResult2 = lerp( float4( 0,0,0,0 ) , _Color0 , temp_output_5_0);
			float2 appendResult11_g2 = (float2(_EllipseSize , _EllipseSize));
			float temp_output_17_0_g2 = length( ( (i.uv_texcoord*2.0 + -1.0) / appendResult11_g2 ) );
			float4 lerpResult1 = lerp( lerpResult2 , _Color1 , saturate( ( ( 1.0 - temp_output_17_0_g2 ) / fwidth( temp_output_17_0_g2 ) ) ));
			o.Emission = lerpResult1.rgb;
			o.Alpha = ( temp_output_5_0 * i.vertexColor.a );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ParticleRedYellow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;2;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;True;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.LerpOp;1;-422.8505,17.73898;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2;-697.8505,17.73898;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;3;-685.8505,-151.261;Inherit;False;Property;_Color1;Color 1;0;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;5.992157,5.458824,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-1075.851,-188.261;Inherit;False;Property;_Color0;Color 0;2;1;[HDR];Create;True;0;0;0;False;0;False;1,1,0,0;7.129737,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;5;-1233.851,44.73898;Inherit;True;Ellipse;-1;;1;3ba94b7b3cfd5f447befde8107c04d52;0;3;2;FLOAT2;0,0;False;7;FLOAT;0.9;False;9;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;6;-721.8505,244.739;Inherit;True;Ellipse;-1;;2;3ba94b7b3cfd5f447befde8107c04d52;0;3;2;FLOAT2;0,0;False;7;FLOAT;0.7;False;9;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-974.8505,302.739;Inherit;False;Property;_EllipseSize;EllipseSize;3;0;Create;True;0;0;0;False;0;False;0;0.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;8;-590.5236,480.6636;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-319.5235,360.6636;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
WireConnection;0;2;1;0
WireConnection;0;9;9;0
WireConnection;1;0;2;0
WireConnection;1;1;3;0
WireConnection;1;2;6;0
WireConnection;2;1;4;0
WireConnection;2;2;5;0
WireConnection;6;7;7;0
WireConnection;6;9;7;0
WireConnection;9;0;5;0
WireConnection;9;1;8;4
ASEEND*/
//CHKSM=0E7BA6B9DA79B7D62A53DCC86F12AE288B08592A