// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UI"
{
	Properties
	{
		_Life("Life", Range( 0 , 1)) = 0.4999876
		_LifeColor("LifeColor", Color) = (0,1,0,0)
		_LeftSpellCooldown("LeftSpellCooldown", Range( 0 , 1)) = 0.8414031
		_RightSpellCooldown("RightSpellCooldown", Range( 0 , 1)) = 0.8414031
		_UI_BarreDeVie_et_Spells("UI_BarreDeVie_et_Spells", 2D) = "white" {}
		_scale("scale", Float) = 1
		_Pos("Pos", Vector) = (0,0,0,0)
		_UI_Viseur("UI_Viseur", 2D) = "white" {}
		_Float1("Float 1", Float) = 0
		_2("2", Float) = 0
		_UI_MasqueVie("UI_MasqueVie", 2D) = "white" {}
		[Toggle]_ShowAimpoint("ShowAimpoint", Float) = 1
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

		uniform sampler2D _UI_BarreDeVie_et_Spells;
		uniform float4 _LifeColor;
		uniform float _Life;
		uniform sampler2D _UI_MasqueVie;
		uniform float4 _UI_MasqueVie_ST;
		uniform float2 _Pos;
		uniform float _scale;
		uniform float _LeftSpellCooldown;
		uniform float _RightSpellCooldown;
		uniform sampler2D _UI_Viseur;
		uniform float _Float1;
		uniform float _2;
		uniform float _ShowAimpoint;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 tex2DNode438 = tex2D( _UI_BarreDeVie_et_Spells, i.uv_texcoord );
			float temp_output_3_0_g261 = ( (0.3 + (_Life - 0.0) * (0.7 - 0.3) / (1.0 - 0.0)) - i.uv_texcoord.x );
			float temp_output_28_0 = saturate( ( temp_output_3_0_g261 / fwidth( temp_output_3_0_g261 ) ) );
			float2 uv_UI_MasqueVie = i.uv_texcoord * _UI_MasqueVie_ST.xy + _UI_MasqueVie_ST.zw;
			float4 tex2DNode550 = tex2D( _UI_MasqueVie, uv_UI_MasqueVie );
			float4 lerpResult454 = lerp( tex2DNode438 , ( _LifeColor * temp_output_28_0 * tex2DNode550.a ) , tex2DNode550.a);
			float2 uv_TexCoord462 = i.uv_texcoord + _Pos;
			float2 _Vector3 = float2(0.09,0.16);
			float2 appendResult11_g263 = (float2(( _Vector3.x * _scale ) , ( _Vector3.y * _scale )));
			float temp_output_17_0_g263 = length( ( (uv_TexCoord462*2.0 + -1.0) / appendResult11_g263 ) );
			float temp_output_456_0 = saturate( ( ( 1.0 - temp_output_17_0_g263 ) / fwidth( temp_output_17_0_g263 ) ) );
			float cos480 = cos( UNITY_PI );
			float sin480 = sin( UNITY_PI );
			float2 rotator480 = mul( uv_TexCoord462 - float2( 0.5,0.5 ) , float2x2( cos480 , -sin480 , sin480 , cos480 )) + float2( 0.5,0.5 );
			float2 CenteredUV15_g1 = ( rotator480 - float2( 0.5,0.5 ) );
			float2 break17_g1 = CenteredUV15_g1;
			float2 appendResult23_g1 = (float2(( length( CenteredUV15_g1 ) * 1.0 * 2.0 ) , ( atan2( break17_g1.x , break17_g1.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 appendResult510 = (float2(( _Pos.x * -1.0 ) , _Pos.y));
			float2 uv_TexCoord494 = i.uv_texcoord + appendResult510;
			float2 appendResult11_g264 = (float2(( _Vector3.x * _scale ) , ( _Vector3.y * _scale )));
			float temp_output_17_0_g264 = length( ( (uv_TexCoord494*2.0 + -1.0) / appendResult11_g264 ) );
			float temp_output_514_0 = saturate( ( ( 1.0 - temp_output_17_0_g264 ) / fwidth( temp_output_17_0_g264 ) ) );
			float cos488 = cos( UNITY_PI );
			float sin488 = sin( UNITY_PI );
			float2 rotator488 = mul( uv_TexCoord494 - float2( 0.5,0.5 ) , float2x2( cos488 , -sin488 , sin488 , cos488 )) + float2( 0.5,0.5 );
			float2 CenteredUV15_g2 = ( rotator488 - float2( 0.5,0.5 ) );
			float2 break17_g2 = CenteredUV15_g2;
			float2 appendResult23_g2 = (float2(( length( CenteredUV15_g2 ) * 1.0 * 2.0 ) , ( atan2( break17_g2.x , break17_g2.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float4 temp_cast_0 = (( ( temp_output_456_0 * step( appendResult23_g1.y , (-0.5 + (_LeftSpellCooldown - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) ) ) + ( temp_output_514_0 * step( appendResult23_g2.y , (-0.5 + (_RightSpellCooldown - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) ) ) )).xxxx;
			float4 lerpResult483 = lerp( lerpResult454 , temp_cast_0 , ( temp_output_456_0 + temp_output_514_0 ));
			float2 _Vector4 = float2(9,16);
			float2 appendResult524 = (float2(( _Vector4.y * 2.0 ) , ( _Vector4.x * 2.0 )));
			float2 break534 = appendResult524;
			float2 appendResult533 = (float2(( break534.x * _Float1 ) , ( break534.y * _2 )));
			float2 uv_TexCoord519 = i.uv_texcoord * appendResult524 + appendResult533;
			float4 tex2DNode518 = tex2D( _UI_Viseur, uv_TexCoord519 );
			float4 lerpResult542 = lerp( lerpResult483 , tex2DNode518 , tex2DNode518.a);
			o.Emission = lerpResult542.rgb;
			o.Alpha = saturate( ( tex2DNode438.a + ( temp_output_28_0 * tex2DNode550.a ) + (( _ShowAimpoint )?( tex2DNode518.a ):( 0.0 )) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;549;2888.882,449.9431;Inherit;False;1961.999;482.9999;Aimpoint;13;518;519;535;528;533;529;536;534;524;520;521;530;523;Aimpoint;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;394;-1630.26,-289.9992;Inherit;False;2701.003;1477.061;make cooldown visible;30;515;514;480;488;462;467;469;512;473;510;504;507;481;502;468;495;494;491;490;489;482;387;456;470;479;476;463;424;500;556;make cooldown visible;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;235;-5878.476,4639.982;Inherit;False;Property;_SubSpells_Scale;SubSpells_Scale;19;0;Create;True;0;0;0;False;0;False;0;5.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;223;-6085.042,4668.885;Inherit;False;Constant;_SubSpells_rescale;SubSpells_rescale;27;0;Create;True;0;0;0;False;0;False;1.65,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;328;-2250.729,3606.214;Inherit;False;2231.401;3904.982;SubSpells;4;280;324;325;279;SubSpells;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;-5678.833,4647.16;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;325;-2145.903,6678.772;Inherit;False;2036.588;692.4976;SubSpell5;12;304;303;301;302;297;299;300;298;296;295;294;293;SubSpell5;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;279;-2133.032,3989.338;Inherit;False;2009.407;735.696;SubSpell1;12;245;244;214;243;250;249;247;248;242;241;215;224;SubSpell1;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;324;-2150.265,5795.174;Inherit;False;2026.503;696.002;SubSpell4;12;281;282;284;283;288;285;287;286;290;289;291;292;SubSpell4;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;280;-2171.855,4878.814;Inherit;False;2071.769;712.0043;SubSpell2;13;261;262;259;260;255;256;257;258;253;254;252;251;265;SubSpell2;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;251;-2121.855,5002.319;Inherit;False;Property;_SubSpell2_Position;SubSpell2_Position;21;0;Create;True;0;0;0;False;0;False;0,0;9.809089E-45,9.809089E-45;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;265;-1977.237,5159.895;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;281;-2100.265,5918.679;Inherit;False;Property;_SubSpell4_Position;SubSpell4_Position;22;0;Create;True;0;0;0;False;0;False;0,0;-8.000003,-1.121039E-44;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;224;-2083.032,4114.107;Inherit;False;Property;_SubSpell1_Position;SubSpell1_Position;20;0;Create;True;0;0;0;False;0;False;0,0;-5.605194E-45,-5.605194E-45;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;236;-2304.986,4065.366;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;293;-2085.819,6802.277;Inherit;False;Property;_SubSpell5_Position;SubSpell5_Position;23;0;Create;True;0;0;0;False;0;False;0,0;-7.999996,1.261169E-44;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;215;-1557.184,4039.338;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;252;-1651.515,4953.322;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;294;-1615.479,6753.28;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;282;-1629.927,5869.682;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;284;-1312.485,6144.176;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;254;-1334.074,5227.816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;253;-1329.074,5414.816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;296;-1298.038,7027.774;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;283;-1307.485,6331.176;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;241;-1344.811,4381.235;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;242;-1339.811,4568.235;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;295;-1293.038,7214.774;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;288;-1071.008,6048.977;Inherit;False;Step Antialiasing;-1;;236;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;286;-1065.744,6263.479;Inherit;False;Step Antialiasing;-1;;237;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;249;-1098.069,4500.538;Inherit;False;Step Antialiasing;-1;;238;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;248;-1099.386,4386.049;Inherit;False;Step Antialiasing;-1;;239;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;146;-2742.273,1692.889;Inherit;False;4632.629;849.1333;Spells;25;266;144;134;125;143;123;136;137;133;104;132;138;103;139;106;112;158;113;159;160;118;108;131;130;115;Spells;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;299;-1068.404,7233.933;Inherit;False;Step Antialiasing;-1;;240;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;285;-1067.061,6148.99;Inherit;False;Step Antialiasing;-1;;241;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;256;-1104.439,5433.975;Inherit;False;Step Antialiasing;-1;;242;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;161;-5786.119,4433.005;Inherit;True;Property;_Spell_Selection;Spell_Selection;16;0;Create;True;0;0;0;False;0;False;None;4bff210abe0bc7f41b336f44a0976ddc;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;297;-1052.614,7032.588;Inherit;False;Step Antialiasing;-1;;243;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;250;-1115.176,4587.395;Inherit;False;Step Antialiasing;-1;;244;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;258;-1092.596,5132.617;Inherit;False;Step Antialiasing;-1;;245;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;298;-1051.297,7147.077;Inherit;False;Step Antialiasing;-1;;246;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;247;-1103.333,4286.036;Inherit;False;Step Antialiasing;-1;;247;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;287;-1082.851,6350.335;Inherit;False;Step Antialiasing;-1;;248;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;255;-1088.649,5232.63;Inherit;False;Step Antialiasing;-1;;249;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;257;-1087.332,5347.119;Inherit;False;Step Antialiasing;-1;;250;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;300;-1056.561,6932.575;Inherit;False;Step Antialiasing;-1;;251;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;-829.8103,4474.235;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;260;-1199.009,4928.814;Inherit;True;Property;_TextureSample2;Texture Sample 2;27;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;214;-1209.746,4082.233;Inherit;True;Property;_TextureSample1;Texture Sample 1;25;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;259;-819.0729,5320.816;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-2183.473,1931.361;Inherit;False;Property;_SpellScaleY;SpellScaleY;11;0;Create;True;0;0;0;False;0;False;1;3.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;302;-1162.973,6728.772;Inherit;True;Property;_TextureSample5;Texture Sample 5;33;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;290;-1177.42,5845.174;Inherit;True;Property;_TextureSample4;Texture Sample 4;32;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;130;-2358.719,2234.265;Inherit;False;Property;_RB_SpellOffsetX;RB_SpellOffsetX;12;0;Create;True;0;0;0;False;0;False;0;-5.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;-797.4836,6237.176;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-2358.719,2319.265;Inherit;False;Property;_RB_SpellOffsetY;RB_SpellOffsetY;13;0;Create;True;0;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;-783.0377,7120.774;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-2181.272,1851.512;Inherit;False;Property;_SpellScaleX;SpellScaleX;10;0;Create;True;0;0;0;False;0;False;1;6.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;-499.7395,7096.529;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-514.1855,6212.931;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;376;854.4313,4570.168;Inherit;False;1457.903;511.1465;DisableSubSpells;13;362;361;369;370;371;365;367;366;368;364;373;374;375;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;-544.0846,5301.403;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;118;-1997.472,2231.362;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-2362.619,2148.543;Inherit;False;Property;_LB_SpellOffsetY;LB_SpellOffsetY;15;0;Create;True;0;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;245;-523.8611,4447.082;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-2364.619,2067.543;Inherit;False;Property;_LB_SpellOffsetX;LB_SpellOffsetX;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;113;-1981.304,1914.452;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;158;-2010.618,2076.543;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-1647.304,2164.453;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;-271.316,6814.71;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;362;904.4317,4686.236;Inherit;False;Constant;_Float0;Float 0;36;0;Create;True;0;0;0;False;0;False;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;-361.5319,5053.453;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;244;-285.193,4218.482;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;356;838.2256,3998.101;Inherit;False;584.4146;496.7642;HighlightSubSpells;5;357;352;355;354;353;HighlightSubSpells;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;-285.7624,5931.112;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;105;-1617.844,-1768.922;Inherit;False;3049.196;1282.51;Life;22;70;148;68;100;20;69;28;22;73;78;72;77;76;71;440;442;443;444;446;455;550;551;Life;1,1,1,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;355;888.2261,4353.105;Inherit;False;Property;_SubSpell4Intensity;SubSpell4Intensity;27;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-1569.844,-1144.922;Inherit;False;Property;_LifeBarOffsetX;LifeBarOffsetX;6;0;Create;True;0;0;0;False;0;False;0;-0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;361;1198.732,4668.463;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1569.844,-1064.922;Inherit;False;Property;_LifeBarOffsetY;LifeBarOffsetY;7;0;Create;True;0;0;0;False;0;False;0;-4.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;106;-1655.161,1940.612;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-1553.844,-1288.922;Inherit;False;Property;_LifeBarScaleX;LifeBarScaleX;4;0;Create;True;0;0;0;False;0;False;1.13;3.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;353;891.9519,4151.091;Inherit;False;Property;_SubSpell2Intensity;SubSpell2Intensity;25;0;Create;True;0;0;0;False;0;False;1;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1553.844,-1208.922;Inherit;False;Property;_LifeBarScaleY;LifeBarScaleY;5;0;Create;True;0;0;0;False;0;False;1;6.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;139;-975.4581,2302.018;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;354;891.524,4250.337;Inherit;False;Property;_SubSpell3Intensity;SubSpell3Intensity;26;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;352;898.7258,4048.101;Inherit;False;Property;_SubSpell1Intensity;SubSpell1Intensity;24;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;103;-842.6581,1928.562;Inherit;True;Property;_Spell_LB;Spell_LB;8;0;Create;True;0;0;0;False;0;False;-1;9550229004d2a5649a26bb8a904e1022;9550229004d2a5649a26bb8a904e1022;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;138;-738.1519,2394.993;Inherit;False;Step Antialiasing;-1;;256;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;132;-738.6542,1742.889;Inherit;False;Step Antialiasing;-1;;257;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;365;1375.773,4639.916;Inherit;False;Property;_SubSpell1Disable;SubSpell1Disable;28;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;133;-739.6542,1833.89;Inherit;False;Step Antialiasing;-1;;258;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;137;-736.6729,2304.784;Inherit;False;Step Antialiasing;-1;;259;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;369;1200.137,4760.464;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;78;-1361.844,-1128.922;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;73;-1361.844,-1224.922;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;357;1272.235,4295.038;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;367;1376.246,4732.689;Inherit;False;Property;_SubSpell2Disable;SubSpell2Disable;29;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;364;1601.335,4620.168;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;370;1199.382,4854.777;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;70;-1137.844,-1256.922;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;366;1377.718,4826.302;Inherit;False;Property;_SubSpell3Disable;SubSpell3Disable;30;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;371;1200.117,4946.314;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;373;1788.275,4711.656;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;264;2709.475,6034.182;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;368;1376.718,4918.302;Inherit;False;Property;_SubSpell4Disable;SubSpell4Disable;31;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;28;-641.844,-1704.922;Inherit;True;Step Antialiasing;-1;;261;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;374;1962.784,4814.732;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;20;-81.8444,-1608.922;Inherit;False;Property;_LifeColor;LifeColor;3;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;377;782.7554,5138.295;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;346;4091.744,4098.303;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;378;785.3957,5347.51;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;375;2146.332,4911.931;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;263;2547.506,5256.739;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;348;4270.125,4100.948;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;148;1278.156,-984.9221;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;350;3740.737,4000.486;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;4939.191,3886.213;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;347;4476.225,3787.564;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;120;4945.701,3741.224;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;349;5106.111,3885.821;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;1167.724,1764.915;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;1372.695,1765.153;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;1170.101,1909.422;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;1664.029,1766.731;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;225.6137,2249.854;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-126.3863,2249.854;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-126.3863,2377.854;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;68;-705.844,-1288.922;Inherit;True;Property;_Empty_LifeBar;Empty_LifeBar;0;0;Create;True;0;0;0;False;0;False;-1;e553f9ae2353fb84ba10b20fe0b9b322;e553f9ae2353fb84ba10b20fe0b9b322;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;69;-705.844,-1096.922;Inherit;True;Property;_LifeBar;LifeBar;1;0;Create;True;0;0;0;False;0;False;-1;6d5591ed0712b514b815492dc9f86b7c;6d5591ed0712b514b815492dc9f86b7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;344;2989.622,6021.217;Inherit;False;Property;_EnableSubSpells;EnableSubSpells;18;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;104;-842.5256,2119.646;Inherit;True;Property;_Spell_RB;Spell_RB;9;0;Create;True;0;0;0;False;0;False;-1;d540565bd16c8d14e82bd637a9a40e6d;d540565bd16c8d14e82bd637a9a40e6d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;442;-152.8337,-949.1378;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;443;-360.8334,-901.1379;Inherit;False;Constant;_Vector0;Vector 0;38;0;Create;True;0;0;0;False;0;False;0,0.432;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StepOpNode;444;-1127.81,-1490.93;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;446;-1414.81,-1610.93;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;446.6556,-1409.122;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;440;103.1661,-949.1378;Inherit;True;Rectangle;-1;;262;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.38;False;3;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;455;-920.682,-1684.365;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.3;False;4;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;345;4463.011,4075.708;Inherit;False;Property;_EnableSpell;EnableSpell;17;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;6;5745.696,-60.67988;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;UI;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.LerpOp;483;5108.633,-108.5559;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;449;5312,128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;447;5104,128;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;500;-16,976;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;424;-304,976;Inherit;False;Property;_RightSpellCooldown;RightSpellCooldown;33;0;Create;True;0;0;0;False;0;False;0.8414031;Infinity;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;463;416,48;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;476;176,112;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;479;16,96;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;456;-464,-144;Inherit;True;Ellipse;-1;;263;3ba94b7b3cfd5f447befde8107c04d52;0;3;2;FLOAT2;0,0;False;7;FLOAT;0.09;False;9;FLOAT;0.16;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;387;-448,320;Inherit;False;Property;_LeftSpellCooldown;LeftSpellCooldown;32;0;Create;True;0;0;0;False;0;False;0.8414031;1.021725;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;482;-160,320;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;489;560,704;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;490;320,768;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;491;160,752;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;494;-832,752;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;495;-672,592;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;502;-672,480;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;481;-848,224;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;507;896,48;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;504;752,-144;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;510;-1024,800;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;473;-1456,144;Inherit;False;Property;_Pos;Pos;36;0;Create;True;0;0;0;False;0;False;0,0;0.427,0.355;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;512;-1232,800;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;462;-912,96;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;480;-464,96;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;514;-272,496;Inherit;True;Ellipse;-1;;264;3ba94b7b3cfd5f447befde8107c04d52;0;3;2;FLOAT2;0,0;False;7;FLOAT;0.5;False;9;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;515;528,352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;454;4448,-288;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;438;3760,128;Inherit;True;Property;_UI_BarreDeVie_et_Spells;UI_BarreDeVie_et_Spells;34;0;Create;True;0;0;0;False;0;False;-1;None;5158049efc6141d46835db7eb65814f2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;459;3504,144;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;488;-320,752;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;470;-816,-64;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;468;-816,-160;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;469;-1360,-48;Inherit;False;Property;_scale;scale;35;0;Create;True;0;0;0;False;0;False;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;467;-1392,-176;Inherit;False;Constant;_Vector3;Vector 3;36;0;Create;True;0;0;0;False;0;False;0.09,0.16;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;543;5365.466,371.364;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;542;5552,-112;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;544;5356.458,309.0977;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;518;4538.881,499.9431;Inherit;True;Property;_UI_Viseur;UI_Viseur;37;0;Create;True;0;0;0;False;0;False;-1;None;4f6064c8e9970594c99a0d095aa1e75e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;519;4314.881,531.9431;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;535;3930.882,787.9431;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;528;3930.882,691.9431;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;533;4090.881,723.9431;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;529;3578.882,723.9431;Inherit;False;Property;_Float1;Float 1;38;0;Create;True;0;0;0;False;0;False;0;-0.484275;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;536;3578.882,819.9431;Inherit;False;Property;_2;2;39;0;Create;True;0;0;0;False;0;False;0;-0.4725;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;534;3642.882,627.9431;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;524;3418.882,563.9431;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;520;3194.882,627.9431;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;521;3194.882,531.9431;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;530;2938.882,643.9431;Inherit;False;Constant;_Float2;Float 2;39;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;523;2938.882,515.9431;Inherit;False;Constant;_Vector4;Vector 3;36;0;Create;True;0;0;0;False;0;False;9,16;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;550;-128.4735,-1178.596;Inherit;True;Property;_UI_MasqueVie;UI_MasqueVie;40;0;Create;True;0;0;0;False;0;False;-1;d1d89c9183af5a84b96f1af4485d2d63;d1d89c9183af5a84b96f1af4485d2d63;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;551;432,-1104;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1295.444,-1713.122;Inherit;False;Property;_Life;Life;2;0;Create;True;0;0;0;False;0;False;0.4999876;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;554;4896.494,359.4021;Inherit;False;Property;_ShowAimpoint;ShowAimpoint;41;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;555;-183.3717,167.7136;Inherit;False;Polar Coordinates;-1;;1;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;556;-75.3717,758.7136;Inherit;False;Polar Coordinates;-1;;2;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
WireConnection;233;0;235;0
WireConnection;233;1;223;0
WireConnection;265;0;233;0
WireConnection;236;0;233;0
WireConnection;215;0;236;0
WireConnection;215;1;224;0
WireConnection;252;0;265;0
WireConnection;252;1;251;0
WireConnection;294;0;233;0
WireConnection;294;1;293;0
WireConnection;282;0;233;0
WireConnection;282;1;281;0
WireConnection;284;0;282;1
WireConnection;254;0;252;1
WireConnection;253;0;252;2
WireConnection;296;0;294;1
WireConnection;283;0;282;2
WireConnection;241;0;215;1
WireConnection;242;0;215;2
WireConnection;295;0;294;2
WireConnection;288;1;282;1
WireConnection;286;1;282;2
WireConnection;249;1;215;2
WireConnection;248;1;241;0
WireConnection;299;1;295;0
WireConnection;285;1;284;0
WireConnection;256;1;253;0
WireConnection;297;1;296;0
WireConnection;250;1;242;0
WireConnection;258;1;252;1
WireConnection;298;1;294;2
WireConnection;247;1;215;1
WireConnection;287;1;283;0
WireConnection;255;1;254;0
WireConnection;257;1;252;2
WireConnection;300;1;294;1
WireConnection;243;0;247;0
WireConnection;243;1;248;0
WireConnection;243;2;249;0
WireConnection;243;3;250;0
WireConnection;260;0;161;0
WireConnection;260;1;252;0
WireConnection;214;0;161;0
WireConnection;214;1;215;0
WireConnection;259;0;258;0
WireConnection;259;1;255;0
WireConnection;259;2;257;0
WireConnection;259;3;256;0
WireConnection;302;0;161;0
WireConnection;302;1;294;0
WireConnection;290;0;161;0
WireConnection;290;1;282;0
WireConnection;289;0;288;0
WireConnection;289;1;285;0
WireConnection;289;2;286;0
WireConnection;289;3;287;0
WireConnection;301;0;300;0
WireConnection;301;1;297;0
WireConnection;301;2;298;0
WireConnection;301;3;299;0
WireConnection;303;0;302;4
WireConnection;303;1;301;0
WireConnection;291;0;290;4
WireConnection;291;1;289;0
WireConnection;262;0;260;4
WireConnection;262;1;259;0
WireConnection;118;0;130;0
WireConnection;118;1;131;0
WireConnection;245;0;214;4
WireConnection;245;1;243;0
WireConnection;113;0;108;0
WireConnection;113;1;115;0
WireConnection;158;0;159;0
WireConnection;158;1;160;0
WireConnection;112;0;113;0
WireConnection;112;1;118;0
WireConnection;304;0;302;0
WireConnection;304;1;301;0
WireConnection;304;2;303;0
WireConnection;261;0;260;0
WireConnection;261;1;259;0
WireConnection;261;2;262;0
WireConnection;244;0;214;0
WireConnection;244;1;243;0
WireConnection;244;2;245;0
WireConnection;292;0;290;0
WireConnection;292;1;289;0
WireConnection;292;2;291;0
WireConnection;355;1;304;0
WireConnection;361;0;244;0
WireConnection;361;1;362;0
WireConnection;106;0;113;0
WireConnection;106;1;158;0
WireConnection;353;1;261;0
WireConnection;139;0;112;1
WireConnection;354;1;292;0
WireConnection;352;1;244;0
WireConnection;103;1;106;0
WireConnection;138;1;112;2
WireConnection;132;1;106;1
WireConnection;365;1;361;0
WireConnection;133;1;106;2
WireConnection;137;1;139;0
WireConnection;369;0;261;0
WireConnection;369;1;362;0
WireConnection;78;0;76;0
WireConnection;78;1;77;0
WireConnection;73;0;71;0
WireConnection;73;1;72;0
WireConnection;357;0;352;0
WireConnection;357;1;353;0
WireConnection;357;2;354;0
WireConnection;357;3;355;0
WireConnection;367;1;369;0
WireConnection;364;0;357;0
WireConnection;364;1;365;0
WireConnection;370;0;292;0
WireConnection;370;1;362;0
WireConnection;70;0;73;0
WireConnection;70;1;78;0
WireConnection;366;1;370;0
WireConnection;371;0;304;0
WireConnection;371;1;362;0
WireConnection;373;0;364;0
WireConnection;373;1;367;0
WireConnection;264;0;245;0
WireConnection;264;1;262;0
WireConnection;264;2;291;0
WireConnection;264;3;303;0
WireConnection;368;1;371;0
WireConnection;28;1;446;1
WireConnection;28;2;455;0
WireConnection;374;0;373;0
WireConnection;374;1;366;0
WireConnection;377;0;244;0
WireConnection;346;0;123;0
WireConnection;346;1;344;0
WireConnection;378;0;261;0
WireConnection;375;0;374;0
WireConnection;375;1;368;0
WireConnection;263;0;377;0
WireConnection;263;1;378;0
WireConnection;263;2;292;0
WireConnection;263;3;304;0
WireConnection;263;4;375;0
WireConnection;348;0;346;0
WireConnection;148;0;68;4
WireConnection;350;0;263;0
WireConnection;121;0;148;0
WireConnection;121;1;345;0
WireConnection;347;0;350;0
WireConnection;347;1;266;0
WireConnection;347;2;123;0
WireConnection;120;1;347;0
WireConnection;349;0;121;0
WireConnection;143;0;132;0
WireConnection;143;1;133;0
WireConnection;143;2;103;0
WireConnection;125;0;143;0
WireConnection;125;1;144;0
WireConnection;144;0;104;0
WireConnection;144;1;137;0
WireConnection;144;2;138;0
WireConnection;266;0;125;0
WireConnection;123;0;134;0
WireConnection;123;1;136;0
WireConnection;134;0;132;0
WireConnection;134;1;133;0
WireConnection;134;2;103;4
WireConnection;136;0;137;0
WireConnection;136;1;138;0
WireConnection;136;2;104;4
WireConnection;68;1;70;0
WireConnection;69;1;70;0
WireConnection;344;1;264;0
WireConnection;104;1;112;0
WireConnection;442;1;443;0
WireConnection;444;0;70;1
WireConnection;444;1;22;0
WireConnection;100;0;20;0
WireConnection;100;1;28;0
WireConnection;100;2;550;4
WireConnection;440;1;442;0
WireConnection;455;0;22;0
WireConnection;345;1;348;0
WireConnection;6;2;542;0
WireConnection;6;9;449;0
WireConnection;483;0;454;0
WireConnection;483;1;507;0
WireConnection;483;2;504;0
WireConnection;449;0;447;0
WireConnection;447;0;438;4
WireConnection;447;1;551;0
WireConnection;447;2;554;0
WireConnection;500;0;424;0
WireConnection;463;0;456;0
WireConnection;463;1;476;0
WireConnection;476;0;479;1
WireConnection;476;1;482;0
WireConnection;479;0;555;0
WireConnection;456;2;462;0
WireConnection;456;7;468;0
WireConnection;456;9;470;0
WireConnection;482;0;387;0
WireConnection;489;0;514;0
WireConnection;489;1;490;0
WireConnection;490;0;491;1
WireConnection;490;1;500;0
WireConnection;491;0;556;0
WireConnection;494;1;510;0
WireConnection;495;0;467;2
WireConnection;495;1;469;0
WireConnection;502;0;467;1
WireConnection;502;1;469;0
WireConnection;507;0;463;0
WireConnection;507;1;489;0
WireConnection;504;0;456;0
WireConnection;504;1;515;0
WireConnection;510;0;512;0
WireConnection;510;1;473;2
WireConnection;512;0;473;1
WireConnection;462;1;473;0
WireConnection;480;0;462;0
WireConnection;480;2;481;0
WireConnection;514;2;494;0
WireConnection;514;7;502;0
WireConnection;514;9;495;0
WireConnection;515;0;514;0
WireConnection;454;0;438;0
WireConnection;454;1;100;0
WireConnection;454;2;550;4
WireConnection;438;1;459;0
WireConnection;488;0;494;0
WireConnection;488;2;481;0
WireConnection;470;0;467;2
WireConnection;470;1;469;0
WireConnection;468;0;467;1
WireConnection;468;1;469;0
WireConnection;543;0;518;4
WireConnection;542;0;483;0
WireConnection;542;1;544;0
WireConnection;542;2;543;0
WireConnection;544;0;518;0
WireConnection;518;1;519;0
WireConnection;519;0;524;0
WireConnection;519;1;533;0
WireConnection;535;0;534;1
WireConnection;535;1;536;0
WireConnection;528;0;534;0
WireConnection;528;1;529;0
WireConnection;533;0;528;0
WireConnection;533;1;535;0
WireConnection;534;0;524;0
WireConnection;524;0;520;0
WireConnection;524;1;521;0
WireConnection;520;0;523;2
WireConnection;520;1;530;0
WireConnection;521;0;523;1
WireConnection;521;1;530;0
WireConnection;551;0;28;0
WireConnection;551;1;550;4
WireConnection;554;1;518;4
WireConnection;555;1;480;0
WireConnection;556;1;488;0
ASEEND*/
//CHKSM=064D6D8BDA50A535D1F79B704E8E4A0191B7EE7D