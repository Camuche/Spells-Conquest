// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EnemyLife"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_UI_BarreDeVieEnnemis("UI_BarreDeVieEnnemis", 2D) = "white" {}
		_UI_MasqueVieEnnemis("UI_MasqueVieEnnemis", 2D) = "white" {}
		_Life("Life", Range( 0 , 1)) = 0.5760869
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
		};

		uniform sampler2D _UI_BarreDeVieEnnemis;
		uniform float4 _UI_BarreDeVieEnnemis_ST;
		uniform float _Life;
		uniform sampler2D _UI_MasqueVieEnnemis;
		uniform float4 _UI_MasqueVieEnnemis_ST;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_UI_BarreDeVieEnnemis = i.uv_texcoord * _UI_BarreDeVieEnnemis_ST.xy + _UI_BarreDeVieEnnemis_ST.zw;
			float4 tex2DNode1 = tex2D( _UI_BarreDeVieEnnemis, uv_UI_BarreDeVieEnnemis );
			float4 color12 = IsGammaSpace() ? float4(0,1,0,0) : float4(0,1,0,0);
			float2 uv_UI_MasqueVieEnnemis = i.uv_texcoord * _UI_MasqueVieEnnemis_ST.xy + _UI_MasqueVieEnnemis_ST.zw;
			float temp_output_11_0 = ( step( i.uv_texcoord.x , _Life ) * tex2D( _UI_MasqueVieEnnemis, uv_UI_MasqueVieEnnemis ).a );
			float4 lerpResult14 = lerp( tex2DNode1 , color12 , temp_output_11_0);
			o.Emission = lerpResult14.rgb;
			o.Alpha = 1;
			clip( saturate( ( tex2DNode1.a + temp_output_11_0 ) ) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;EnemyLife;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-368,336;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1328,272;Inherit;True;Property;_UI_MasqueVieEnnemis;UI_MasqueVieEnnemis;2;0;Create;True;0;0;0;False;0;False;-1;83ab67f9081e1ba47bbd972ec95500f8;83ab67f9081e1ba47bbd972ec95500f8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1328,80;Inherit;True;Property;_UI_BarreDeVieEnnemis;UI_BarreDeVieEnnemis;1;0;Create;True;0;0;0;False;0;False;-1;468d88525758b684cb2be868c1c44f9f;292132002b04d9e49ad5d26642ec63dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;14;-336,48;Inherit;True;3;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;8;-976,-80;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-1072,-272;Inherit;False;Constant;_Color0;Color 0;4;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1296,-176;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-1360,-48;Inherit;False;Property;_Life;Life;3;0;Create;True;0;0;0;False;0;False;0.5760869;0.421;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;16;-160,336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-776,-106;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
WireConnection;0;2;14;0
WireConnection;0;10;16;0
WireConnection;4;0;1;4
WireConnection;4;1;11;0
WireConnection;14;0;1;0
WireConnection;14;1;12;0
WireConnection;14;2;11;0
WireConnection;8;0;5;1
WireConnection;8;1;9;0
WireConnection;16;0;4;0
WireConnection;11;0;8;0
WireConnection;11;1;2;4
ASEEND*/
//CHKSM=FDAA2E76D1C1DAF10D2FD67F04A516CA1484E761