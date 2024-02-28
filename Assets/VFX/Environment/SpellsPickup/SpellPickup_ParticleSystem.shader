// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpellPickup_ParticleSystem"
{
	Properties
	{
		_Ellipse_Size("Ellipse_Size", Range( 0 , 1)) = 0.2
		_HDRParticle("HDR Particle", Float) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
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
			float4 vertexColor : COLOR;
		};

		uniform float _Ellipse_Size;
		uniform float _HDRParticle;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult11_g1 = (float2(_Ellipse_Size , _Ellipse_Size));
			float temp_output_17_0_g1 = length( ( (i.uv_texcoord*2.0 + -1.0) / appendResult11_g1 ) );
			float temp_output_1_0 = saturate( ( ( 1.0 - temp_output_17_0_g1 ) / fwidth( temp_output_17_0_g1 ) ) );
			float3 appendResult27 = (float3(i.vertexColor.r , i.vertexColor.g , i.vertexColor.b));
			o.Emission = ( ( ( temp_output_1_0 * _HDRParticle ) + 1.0 ) * appendResult27 );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode32 = tex2D( _TextureSample0, uv_TextureSample0 );
			float lerpResult13 = lerp( 0.0 , tex2DNode32.a , ( 1.0 - step( tex2DNode32.a , 0.0 ) ));
			float clampResult20 = clamp( ( temp_output_1_0 + lerpResult13 ) , 0.0 , 1.0 );
			o.Alpha = ( i.vertexColor.a * clampResult20 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.VertexColorNode;24;60.80672,74.00842;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;27;307.7294,97.33856;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;574.6203,171.9683;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;890.818,-21.88478;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SpellPickup_ParticleSystem;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;611.05,-44.55493;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;1;-897.5554,-52.1922;Inherit;True;Ellipse;-1;;1;3ba94b7b3cfd5f447befde8107c04d52;0;3;2;FLOAT2;0,0;False;7;FLOAT;0.5;False;9;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1278.508,-52.95408;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-1340.015,70.29913;Inherit;False;Property;_Ellipse_Size;Ellipse_Size;0;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;356.668,-42.5994;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-34.60631,-49.41527;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-260.8302,15.31098;Inherit;False;Property;_HDRParticle;HDR Particle;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;20;404.6544,242.4265;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;162.9575,239.5102;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;-178.6397,261.3278;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;36;-350.3328,350.8324;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;37;-468.762,350.5256;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;32;-801.3783,191.7909;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;9a7aaac80d61f084ea9c5e139650da27;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;27;0;24;1
WireConnection;27;1;24;2
WireConnection;27;2;24;3
WireConnection;25;0;24;4
WireConnection;25;1;20;0
WireConnection;0;2;26;0
WireConnection;0;9;25;0
WireConnection;26;0;19;0
WireConnection;26;1;27;0
WireConnection;1;2;2;0
WireConnection;1;7;3;0
WireConnection;1;9;3;0
WireConnection;19;0;18;0
WireConnection;18;0;1;0
WireConnection;18;1;17;0
WireConnection;20;0;9;0
WireConnection;9;0;1;0
WireConnection;9;1;13;0
WireConnection;13;1;32;4
WireConnection;13;2;36;0
WireConnection;36;0;37;0
WireConnection;37;0;32;4
ASEEND*/
//CHKSM=7F756F6831688DB3D48A386D6993CFF6F4130E73