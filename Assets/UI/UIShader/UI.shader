// Made with Amplify Shader Editor v1.9.0.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UI"
{
	Properties
	{
		_Empty_LifeBar("Empty_LifeBar", 2D) = "white" {}
		_LifeBar("LifeBar", 2D) = "white" {}
		_Life("Life", Range( 0 , 1)) = 0.4999876
		_Stamina("Stamina", Range( 0 , 1)) = 0.4504158
		_LifeColor("LifeColor", Color) = (0,1,0,0)
		_StaminaColor("StaminaColor", Color) = (1,1,0,0)
		_LifeBarScaleX("LifeBarScaleX", Float) = 1.13
		_LifeBarScaleY("LifeBarScaleY", Float) = 1
		_LifeBarOffsetX("LifeBarOffsetX", Float) = 0
		_LifeBarOffsetY("LifeBarOffsetY", Float) = 0
		_Spell_LB("Spell_LB", 2D) = "white" {}
		_Spell_RB("Spell_RB", 2D) = "white" {}
		_SpellScaleX("SpellScaleX", Float) = 1
		_SpellScaleY("SpellScaleY", Float) = 1
		_RB_SpellOffsetX("RB_SpellOffsetX", Float) = 0
		_RB_SpellOffsetY("RB_SpellOffsetY", Float) = 0
		_LB_SpellOffsetX("LB_SpellOffsetX", Float) = 0
		_LB_SpellOffsetY("LB_SpellOffsetY", Float) = 0
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
		};

		uniform float _LifeBarScaleX;
		uniform float _LifeBarScaleY;
		uniform float _LifeBarOffsetX;
		uniform float _LifeBarOffsetY;
		uniform sampler2D _Empty_LifeBar;
		uniform float4 _LifeColor;
		uniform float _Life;
		uniform sampler2D _LifeBar;
		uniform float _Stamina;
		uniform float4 _StaminaColor;
		uniform float _SpellScaleX;
		uniform float _SpellScaleY;
		uniform float _LB_SpellOffsetX;
		uniform float _LB_SpellOffsetY;
		uniform sampler2D _Spell_LB;
		uniform sampler2D _Spell_RB;
		uniform float _RB_SpellOffsetX;
		uniform float _RB_SpellOffsetY;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult73 = (float2(_LifeBarScaleX , _LifeBarScaleY));
			float2 appendResult78 = (float2(_LifeBarOffsetX , _LifeBarOffsetY));
			float2 uv_TexCoord70 = i.uv_texcoord * appendResult73 + appendResult78;
			float temp_output_3_0_g38 = ( 1.0 - uv_TexCoord70.x );
			float temp_output_3_0_g39 = ( 1.0 - ( 1.0 - uv_TexCoord70.y ) );
			float4 tex2DNode68 = tex2D( _Empty_LifeBar, uv_TexCoord70 );
			float temp_output_3_0_g35 = ( (0.06 + (_Life - 0.0) * (0.83 - 0.06) / (1.0 - 0.0)) - uv_TexCoord70.x );
			float temp_output_3_0_g31 = ( 0.425 - uv_TexCoord70.y );
			float temp_output_82_0 = saturate( ( temp_output_3_0_g31 / fwidth( temp_output_3_0_g31 ) ) );
			float4 tex2DNode69 = tex2D( _LifeBar, uv_TexCoord70 );
			float temp_output_83_0 = ( saturate( ( temp_output_3_0_g35 / fwidth( temp_output_3_0_g35 ) ) ) * ( 1.0 - temp_output_82_0 ) * tex2DNode69.a );
			float temp_output_3_0_g36 = ( (0.1 + (_Stamina - 0.0) * (0.63 - 0.1) / (1.0 - 0.0)) - uv_TexCoord70.x );
			float temp_output_85_0 = ( temp_output_82_0 * tex2DNode69.a * saturate( ( temp_output_3_0_g36 / fwidth( temp_output_3_0_g36 ) ) ) );
			float4 lerpResult99 = lerp( ( saturate( ( temp_output_3_0_g38 / fwidth( temp_output_3_0_g38 ) ) ) * saturate( ( temp_output_3_0_g39 / fwidth( temp_output_3_0_g39 ) ) ) * tex2DNode68 ) , ( ( _LifeColor * temp_output_83_0 ) + ( temp_output_85_0 * _StaminaColor ) ) , ( temp_output_83_0 + temp_output_85_0 ));
			float2 appendResult113 = (float2(_SpellScaleX , _SpellScaleY));
			float2 appendResult158 = (float2(_LB_SpellOffsetX , _LB_SpellOffsetY));
			float2 uv_TexCoord106 = i.uv_texcoord * appendResult113 + appendResult158;
			float temp_output_3_0_g46 = ( 1.0 - uv_TexCoord106.x );
			float temp_output_132_0 = saturate( ( temp_output_3_0_g46 / fwidth( temp_output_3_0_g46 ) ) );
			float temp_output_3_0_g44 = ( 1.0 - uv_TexCoord106.y );
			float temp_output_133_0 = saturate( ( temp_output_3_0_g44 / fwidth( temp_output_3_0_g44 ) ) );
			float4 tex2DNode103 = tex2D( _Spell_LB, uv_TexCoord106 );
			float2 appendResult118 = (float2(_RB_SpellOffsetX , _RB_SpellOffsetY));
			float2 uv_TexCoord112 = i.uv_texcoord * appendResult113 + appendResult118;
			float4 tex2DNode104 = tex2D( _Spell_RB, uv_TexCoord112 );
			float temp_output_3_0_g47 = ( 1.0 - ( 1.0 - uv_TexCoord112.x ) );
			float temp_output_137_0 = saturate( ( temp_output_3_0_g47 / fwidth( temp_output_3_0_g47 ) ) );
			float temp_output_3_0_g45 = ( 1.0 - uv_TexCoord112.y );
			float temp_output_138_0 = saturate( ( temp_output_3_0_g45 / fwidth( temp_output_3_0_g45 ) ) );
			o.Emission = ( lerpResult99 + ( ( temp_output_132_0 * temp_output_133_0 * tex2DNode103 ) + ( tex2DNode104 * temp_output_137_0 * temp_output_138_0 ) ) ).rgb;
			o.Alpha = ( tex2DNode68.a + ( ( temp_output_132_0 * temp_output_133_0 * tex2DNode103.a ) + ( temp_output_137_0 * temp_output_138_0 * tex2DNode104.a ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19001
0;6;2560;1373;3108.232;-664.6896;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;105;-2739.046,-330.469;Inherit;False;3049.196;1282.51;LifeAndStamina;32;67;65;64;82;150;149;70;99;148;102;68;98;101;100;20;83;85;94;81;69;28;18;22;73;78;72;77;76;71;153;154;157;LifeAndStamina;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2684.885,161.8709;Inherit;False;Property;_LifeBarScaleX;LifeBarScaleX;6;0;Create;True;0;0;0;False;0;False;1.13;3.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-2687.792,304.5627;Inherit;False;Property;_LifeBarOffsetX;LifeBarOffsetX;8;0;Create;True;0;0;0;False;0;False;0;-0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-2689.046,375.2236;Inherit;False;Property;_LifeBarOffsetY;LifeBarOffsetY;9;0;Create;True;0;0;0;False;0;False;0;-4.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-2684.055,234.8711;Inherit;False;Property;_LifeBarScaleY;LifeBarScaleY;7;0;Create;True;0;0;0;False;0;False;1;6.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;73;-2488.716,217.9218;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;78;-2486.284,309.7494;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;146;-2711.886,1075.036;Inherit;False;3057.153;839.746;Spells;24;108;115;131;130;113;118;112;106;139;137;103;138;133;104;132;143;136;134;144;125;123;158;159;160;Spells;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-2305.209,744.0888;Inherit;False;Property;_Stamina;Stamina;3;0;Create;True;0;0;0;False;0;False;0.4504158;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-2150.885,1233.659;Inherit;False;Property;_SpellScaleX;SpellScaleX;12;0;Create;True;0;0;0;False;0;False;1;5.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;70;-2265.563,193.9899;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-2331.489,-280.469;Inherit;False;Property;_Life;Life;2;0;Create;True;0;0;0;False;0;False;0.4999876;0.3400017;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-2153.086,1313.508;Inherit;False;Property;_SpellScaleY;SpellScaleY;13;0;Create;True;0;0;0;False;0;False;1;3.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-2328.332,1616.411;Inherit;False;Property;_RB_SpellOffsetX;RB_SpellOffsetX;14;0;Create;True;0;0;0;False;0;False;0;-4.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-2328.332,1701.411;Inherit;False;Property;_RB_SpellOffsetY;RB_SpellOffsetY;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-2334.232,1449.69;Inherit;False;Property;_LB_SpellOffsetX;LB_SpellOffsetX;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;113;-1950.918,1296.599;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-2332.232,1530.69;Inherit;False;Property;_LB_SpellOffsetY;LB_SpellOffsetY;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;18;-2030.956,-266.5759;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.06;False;4;FLOAT;0.83;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;118;-1967.086,1613.508;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;82;-1731.222,-127.268;Inherit;False;Step Antialiasing;-1;;31;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.425;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;65;-2004.684,751.5408;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;0.63;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;155;-1879.5,42.24591;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;69;-1835.116,354.3085;Inherit;True;Property;_LifeBar;LifeBar;1;0;Create;True;0;0;0;False;0;False;-1;6d5591ed0712b514b815492dc9f86b7c;6d5591ed0712b514b815492dc9f86b7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;154;-1874.905,76.4045;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;28;-1768.469,-257.4345;Inherit;False;Step Antialiasing;-1;;35;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;67;-1767.125,726.6765;Inherit;False;Step Antialiasing;-1;;36;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-1616.918,1546.599;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;81;-1383.621,59.17019;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;158;-1980.232,1458.69;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;94;-1177.367,661.3012;Inherit;False;Property;_StaminaColor;StaminaColor;5;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;150;-1734.192,74.98042;Inherit;False;Step Antialiasing;-1;;39;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;139;-945.0717,1684.164;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-1203.55,35.58717;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-1202.823,-157.7998;Inherit;False;Property;_LifeColor;LifeColor;4;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1225.71,434.1942;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;149;-1733.192,-13.01959;Inherit;False;Step Antialiasing;-1;;38;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;106;-1624.775,1322.759;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-913.5322,22.66031;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;156;-1455.139,125.5174;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;104;-812.1393,1500.792;Inherit;True;Property;_Spell_RB;Spell_RB;11;0;Create;True;0;0;0;False;0;False;-1;d540565bd16c8d14e82bd637a9a40e6d;d540565bd16c8d14e82bd637a9a40e6d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;137;-706.2865,1686.93;Inherit;False;Step Antialiasing;-1;;47;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;132;-708.2679,1125.036;Inherit;False;Step Antialiasing;-1;;46;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;138;-707.7655,1777.14;Inherit;False;Step Antialiasing;-1;;45;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;133;-709.2679,1216.037;Inherit;False;Step Antialiasing;-1;;44;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;103;-812.2717,1310.709;Inherit;True;Property;_Spell_LB;Spell_LB;10;0;Create;True;0;0;0;False;0;False;-1;9550229004d2a5649a26bb8a904e1022;9550229004d2a5649a26bb8a904e1022;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;157;-1452.139,156.5174;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;68;-1836.736,164.817;Inherit;True;Property;_Empty_LifeBar;Empty_LifeBar;0;0;Create;True;0;0;0;False;0;False;-1;e553f9ae2353fb84ba10b20fe0b9b322;e553f9ae2353fb84ba10b20fe0b9b322;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-886.1526,641.3318;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-461.5009,407.7255;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-326.8379,122.9276;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-93.03946,1639.507;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-94.6525,1755.782;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-451.5798,23.25435;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-96.32632,1246.018;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-94.70255,1127.511;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;110.2679,1127.749;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;99;50.47482,121.7896;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;148;151.4397,457.8196;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;74.0536,1638.231;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;1141.218,991.7309;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;120;1137.327,679.0392;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;6;1431.214,632.8027;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;UI;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;73;0;71;0
WireConnection;73;1;72;0
WireConnection;78;0;76;0
WireConnection;78;1;77;0
WireConnection;70;0;73;0
WireConnection;70;1;78;0
WireConnection;113;0;108;0
WireConnection;113;1;115;0
WireConnection;18;0;22;0
WireConnection;118;0;130;0
WireConnection;118;1;131;0
WireConnection;82;1;70;2
WireConnection;65;0;64;0
WireConnection;155;0;70;1
WireConnection;69;1;70;0
WireConnection;154;0;70;2
WireConnection;28;1;70;1
WireConnection;28;2;18;0
WireConnection;67;1;70;1
WireConnection;67;2;65;0
WireConnection;112;0;113;0
WireConnection;112;1;118;0
WireConnection;81;0;82;0
WireConnection;158;0;159;0
WireConnection;158;1;160;0
WireConnection;150;1;154;0
WireConnection;139;0;112;1
WireConnection;83;0;28;0
WireConnection;83;1;81;0
WireConnection;83;2;69;4
WireConnection;85;0;82;0
WireConnection;85;1;69;4
WireConnection;85;2;67;0
WireConnection;149;1;155;0
WireConnection;106;0;113;0
WireConnection;106;1;158;0
WireConnection;100;0;20;0
WireConnection;100;1;83;0
WireConnection;156;0;149;0
WireConnection;104;1;112;0
WireConnection;137;1;139;0
WireConnection;132;1;106;1
WireConnection;138;1;112;2
WireConnection;133;1;106;2
WireConnection;103;1;106;0
WireConnection;157;0;150;0
WireConnection;68;1;70;0
WireConnection;101;0;85;0
WireConnection;101;1;94;0
WireConnection;98;0;83;0
WireConnection;98;1;85;0
WireConnection;153;0;156;0
WireConnection;153;1;157;0
WireConnection;153;2;68;0
WireConnection;134;0;132;0
WireConnection;134;1;133;0
WireConnection;134;2;103;4
WireConnection;136;0;137;0
WireConnection;136;1;138;0
WireConnection;136;2;104;4
WireConnection;102;0;100;0
WireConnection;102;1;101;0
WireConnection;144;0;104;0
WireConnection;144;1;137;0
WireConnection;144;2;138;0
WireConnection;143;0;132;0
WireConnection;143;1;133;0
WireConnection;143;2;103;0
WireConnection;125;0;143;0
WireConnection;125;1;144;0
WireConnection;99;0;153;0
WireConnection;99;1;102;0
WireConnection;99;2;98;0
WireConnection;148;0;68;4
WireConnection;123;0;134;0
WireConnection;123;1;136;0
WireConnection;121;0;148;0
WireConnection;121;1;123;0
WireConnection;120;0;99;0
WireConnection;120;1;125;0
WireConnection;6;2;120;0
WireConnection;6;9;121;0
ASEEND*/
//CHKSM=A188551ABD65CBA9B3A8ACBD4DCF7A7FD54E463F