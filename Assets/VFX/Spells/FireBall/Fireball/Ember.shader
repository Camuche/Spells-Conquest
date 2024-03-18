// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ember"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HDR]_Color1("Color 1", Color) = (1,1,1,0)
		[HDR]_Color0("Color 0", Color) = (1,1,0,0)
		_EllipseSize("EllipseSize", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
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
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult11_g1 = (float2(0.9 , 0.9));
			float temp_output_17_0_g1 = length( ( (i.uv_texcoord*2.0 + -1.0) / appendResult11_g1 ) );
			float temp_output_1_0 = saturate( ( ( 1.0 - temp_output_17_0_g1 ) / fwidth( temp_output_17_0_g1 ) ) );
			float4 lerpResult5 = lerp( float4( 0,0,0,0 ) , _Color0 , temp_output_1_0);
			float2 appendResult11_g2 = (float2(_EllipseSize , _EllipseSize));
			float temp_output_17_0_g2 = length( ( (i.uv_texcoord*2.0 + -1.0) / appendResult11_g2 ) );
			float4 lerpResult8 = lerp( lerpResult5 , _Color1 , saturate( ( ( 1.0 - temp_output_17_0_g2 ) / fwidth( temp_output_17_0_g2 ) ) ));
			float3 appendResult13 = (float3(i.vertexColor.r , i.vertexColor.g , i.vertexColor.b));
			o.Emission = ( lerpResult8 * float4( appendResult13 , 0.0 ) ).rgb;
			o.Alpha = 1;
			clip( ( temp_output_1_0 * i.vertexColor.a ) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.LerpOp;8;-254,-9.5;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;5;-529,-9.5;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;7;-517,-178.5;Inherit;False;Property;_Color1;Color 1;1;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;5.992157,5.458824,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;1;-1065,17.5;Inherit;True;Ellipse;-1;;1;3ba94b7b3cfd5f447befde8107c04d52;0;3;2;FLOAT2;0,0;False;7;FLOAT;0.9;False;9;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;199.8529,6.056149;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Ember;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ColorNode;6;-842.0001,-179.0999;Inherit;False;Property;_Color0;Color 0;2;1;[HDR];Create;True;0;0;0;False;0;False;1,1,0,0;7.129737,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;33.09384,-9.701222;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;2;-482.8,205.7999;Inherit;False;Ellipse;-1;;2;3ba94b7b3cfd5f447befde8107c04d52;0;3;2;FLOAT2;0,0;False;7;FLOAT;0.7;False;9;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-698.1002,224.8;Inherit;False;Property;_EllipseSize;EllipseSize;3;0;Create;True;0;0;0;False;0;False;0;0.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-148.1361,602.0807;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;14;-738.0929,496.2244;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;10;-502.1986,407.4759;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;13;-257.1974,432.0677;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
WireConnection;8;0;5;0
WireConnection;8;1;7;0
WireConnection;8;2;2;0
WireConnection;5;1;6;0
WireConnection;5;2;1;0
WireConnection;0;2;12;0
WireConnection;0;10;11;0
WireConnection;12;0;8;0
WireConnection;12;1;13;0
WireConnection;2;7;9;0
WireConnection;2;9;9;0
WireConnection;11;0;14;0
WireConnection;11;1;10;4
WireConnection;14;0;1;0
WireConnection;13;0;10;1
WireConnection;13;1;10;2
WireConnection;13;2;10;3
ASEEND*/
//CHKSM=7847C642B9A006632A8F5813C75EB5009F133106