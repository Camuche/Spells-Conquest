// Made with Amplify Shader Editor v1.9.2.2
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
		_Spell_Selection("Spell_Selection", 2D) = "white" {}
		[Toggle]_EnableSpell("EnableSpell", Float) = 1
		[Toggle]_EnableSubSpells("EnableSubSpells", Float) = 1
		_SubSpells_Scale("SubSpells_Scale", Float) = 0
		_SubSpell1_Position("SubSpell1_Position", Vector) = (0,0,0,0)
		_SubSpell2_Position("SubSpell2_Position", Vector) = (0,0,0,0)
		_SubSpell4_Position("SubSpell4_Position", Vector) = (0,0,0,0)
		_SubSpell5_Position("SubSpell5_Position", Vector) = (0,0,0,0)
		[Toggle]_SubSpell1Intensity("SubSpell1Intensity", Float) = 0
		[Toggle]_SubSpell2Intensity("SubSpell2Intensity", Float) = 1
		[Toggle]_SubSpell3Intensity("SubSpell3Intensity", Float) = 0
		[Toggle]_SubSpell4Intensity("SubSpell4Intensity", Float) = 0
		[Toggle]_SubSpell1Disable("SubSpell1Disable", Float) = 0
		[Toggle]_SubSpell2Disable("SubSpell2Disable", Float) = 0
		[Toggle]_SubSpell3Disable("SubSpell3Disable", Float) = 0
		[Toggle]_SubSpell4Disable("SubSpell4Disable", Float) = 0
		_AlphaCooldownUI("AlphaCooldownUI", Float) = 0
		_LeftSpellCooldown("LeftSpellCooldown", Range( 0 , 1)) = 0.8414031
		_RightSpellCooldown("RightSpellCooldown", Range( 0 , 1)) = 0.8414031
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
		uniform sampler2D _Spell_Selection;
		uniform float _SubSpells_Scale;
		uniform float2 _SubSpell1_Position;
		uniform float2 _SubSpell2_Position;
		uniform float2 _SubSpell4_Position;
		uniform float2 _SubSpell5_Position;
		uniform float _SubSpell1Intensity;
		uniform float _SubSpell2Intensity;
		uniform float _SubSpell3Intensity;
		uniform float _SubSpell4Intensity;
		uniform float _SubSpell1Disable;
		uniform float _SubSpell2Disable;
		uniform float _SubSpell3Disable;
		uniform float _SubSpell4Disable;
		uniform float _SpellScaleX;
		uniform float _SpellScaleY;
		uniform float _LB_SpellOffsetX;
		uniform float _LB_SpellOffsetY;
		uniform sampler2D _Spell_LB;
		uniform sampler2D _Spell_RB;
		uniform float _RB_SpellOffsetX;
		uniform float _RB_SpellOffsetY;
		uniform float _AlphaCooldownUI;
		uniform float _RightSpellCooldown;
		uniform float _LeftSpellCooldown;
		uniform float _EnableSpell;
		uniform float _EnableSubSpells;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult73 = (float2(_LifeBarScaleX , _LifeBarScaleY));
			float2 appendResult78 = (float2(_LifeBarOffsetX , _LifeBarOffsetY));
			float2 uv_TexCoord70 = i.uv_texcoord * appendResult73 + appendResult78;
			float temp_output_3_0_g263 = ( 1.0 - uv_TexCoord70.x );
			float temp_output_3_0_g264 = ( 1.0 - ( 1.0 - uv_TexCoord70.y ) );
			float4 tex2DNode68 = tex2D( _Empty_LifeBar, uv_TexCoord70 );
			float temp_output_3_0_g261 = ( (0.06 + (_Life - 0.0) * (0.83 - 0.06) / (1.0 - 0.0)) - uv_TexCoord70.x );
			float temp_output_3_0_g260 = ( 0.425 - uv_TexCoord70.y );
			float temp_output_82_0 = saturate( ( temp_output_3_0_g260 / fwidth( temp_output_3_0_g260 ) ) );
			float4 tex2DNode69 = tex2D( _LifeBar, uv_TexCoord70 );
			float temp_output_83_0 = ( saturate( ( temp_output_3_0_g261 / fwidth( temp_output_3_0_g261 ) ) ) * ( 1.0 - temp_output_82_0 ) * tex2DNode69.a );
			float temp_output_3_0_g262 = ( (0.1 + (_Stamina - 0.0) * (0.63 - 0.1) / (1.0 - 0.0)) - uv_TexCoord70.x );
			float temp_output_85_0 = ( temp_output_82_0 * tex2DNode69.a * saturate( ( temp_output_3_0_g262 / fwidth( temp_output_3_0_g262 ) ) ) );
			float4 lerpResult99 = lerp( ( saturate( ( temp_output_3_0_g263 / fwidth( temp_output_3_0_g263 ) ) ) * saturate( ( temp_output_3_0_g264 / fwidth( temp_output_3_0_g264 ) ) ) * tex2DNode68 ) , ( ( _LifeColor * temp_output_83_0 ) + ( temp_output_85_0 * _StaminaColor ) ) , ( temp_output_83_0 + temp_output_85_0 ));
			float2 temp_output_233_0 = ( _SubSpells_Scale * float2( 1.65,1 ) );
			float2 uv_TexCoord215 = i.uv_texcoord * temp_output_233_0 + _SubSpell1_Position;
			float4 tex2DNode214 = tex2D( _Spell_Selection, uv_TexCoord215 );
			float temp_output_3_0_g247 = ( 1.0 - uv_TexCoord215.x );
			float temp_output_3_0_g239 = ( 1.0 - ( 1.0 - uv_TexCoord215.x ) );
			float temp_output_3_0_g238 = ( 1.0 - uv_TexCoord215.y );
			float temp_output_3_0_g244 = ( 1.0 - ( 1.0 - uv_TexCoord215.y ) );
			float temp_output_243_0 = ( saturate( ( temp_output_3_0_g247 / fwidth( temp_output_3_0_g247 ) ) ) * saturate( ( temp_output_3_0_g239 / fwidth( temp_output_3_0_g239 ) ) ) * saturate( ( temp_output_3_0_g238 / fwidth( temp_output_3_0_g238 ) ) ) * saturate( ( temp_output_3_0_g244 / fwidth( temp_output_3_0_g244 ) ) ) );
			float temp_output_245_0 = ( tex2DNode214.a * temp_output_243_0 );
			float4 temp_output_244_0 = ( tex2DNode214 * temp_output_243_0 * temp_output_245_0 );
			float2 uv_TexCoord252 = i.uv_texcoord * temp_output_233_0 + _SubSpell2_Position;
			float4 tex2DNode260 = tex2D( _Spell_Selection, uv_TexCoord252 );
			float temp_output_3_0_g245 = ( 1.0 - uv_TexCoord252.x );
			float temp_output_3_0_g249 = ( 1.0 - ( 1.0 - uv_TexCoord252.x ) );
			float temp_output_3_0_g250 = ( 1.0 - uv_TexCoord252.y );
			float temp_output_3_0_g242 = ( 1.0 - ( 1.0 - uv_TexCoord252.y ) );
			float temp_output_259_0 = ( saturate( ( temp_output_3_0_g245 / fwidth( temp_output_3_0_g245 ) ) ) * saturate( ( temp_output_3_0_g249 / fwidth( temp_output_3_0_g249 ) ) ) * saturate( ( temp_output_3_0_g250 / fwidth( temp_output_3_0_g250 ) ) ) * saturate( ( temp_output_3_0_g242 / fwidth( temp_output_3_0_g242 ) ) ) );
			float temp_output_262_0 = ( tex2DNode260.a * temp_output_259_0 );
			float4 temp_output_261_0 = ( tex2DNode260 * temp_output_259_0 * temp_output_262_0 );
			float2 uv_TexCoord282 = i.uv_texcoord * temp_output_233_0 + _SubSpell4_Position;
			float4 tex2DNode290 = tex2D( _Spell_Selection, uv_TexCoord282 );
			float temp_output_3_0_g236 = ( 1.0 - uv_TexCoord282.x );
			float temp_output_3_0_g241 = ( 1.0 - ( 1.0 - uv_TexCoord282.x ) );
			float temp_output_3_0_g237 = ( 1.0 - uv_TexCoord282.y );
			float temp_output_3_0_g248 = ( 1.0 - ( 1.0 - uv_TexCoord282.y ) );
			float temp_output_289_0 = ( saturate( ( temp_output_3_0_g236 / fwidth( temp_output_3_0_g236 ) ) ) * saturate( ( temp_output_3_0_g241 / fwidth( temp_output_3_0_g241 ) ) ) * saturate( ( temp_output_3_0_g237 / fwidth( temp_output_3_0_g237 ) ) ) * saturate( ( temp_output_3_0_g248 / fwidth( temp_output_3_0_g248 ) ) ) );
			float temp_output_291_0 = ( tex2DNode290.a * temp_output_289_0 );
			float4 temp_output_292_0 = ( tex2DNode290 * temp_output_289_0 * temp_output_291_0 );
			float2 uv_TexCoord294 = i.uv_texcoord * temp_output_233_0 + _SubSpell5_Position;
			float4 tex2DNode302 = tex2D( _Spell_Selection, uv_TexCoord294 );
			float temp_output_3_0_g251 = ( 1.0 - uv_TexCoord294.x );
			float temp_output_3_0_g243 = ( 1.0 - ( 1.0 - uv_TexCoord294.x ) );
			float temp_output_3_0_g246 = ( 1.0 - uv_TexCoord294.y );
			float temp_output_3_0_g240 = ( 1.0 - ( 1.0 - uv_TexCoord294.y ) );
			float temp_output_301_0 = ( saturate( ( temp_output_3_0_g251 / fwidth( temp_output_3_0_g251 ) ) ) * saturate( ( temp_output_3_0_g243 / fwidth( temp_output_3_0_g243 ) ) ) * saturate( ( temp_output_3_0_g246 / fwidth( temp_output_3_0_g246 ) ) ) * saturate( ( temp_output_3_0_g240 / fwidth( temp_output_3_0_g240 ) ) ) );
			float temp_output_303_0 = ( tex2DNode302.a * temp_output_301_0 );
			float4 temp_output_304_0 = ( tex2DNode302 * temp_output_301_0 * temp_output_303_0 );
			float2 appendResult113 = (float2(_SpellScaleX , _SpellScaleY));
			float2 appendResult158 = (float2(_LB_SpellOffsetX , _LB_SpellOffsetY));
			float2 uv_TexCoord106 = i.uv_texcoord * appendResult113 + appendResult158;
			float temp_output_3_0_g257 = ( 1.0 - uv_TexCoord106.x );
			float temp_output_132_0 = saturate( ( temp_output_3_0_g257 / fwidth( temp_output_3_0_g257 ) ) );
			float temp_output_3_0_g258 = ( 1.0 - uv_TexCoord106.y );
			float temp_output_133_0 = saturate( ( temp_output_3_0_g258 / fwidth( temp_output_3_0_g258 ) ) );
			float4 tex2DNode103 = tex2D( _Spell_LB, uv_TexCoord106 );
			float2 appendResult118 = (float2(_RB_SpellOffsetX , _RB_SpellOffsetY));
			float2 uv_TexCoord112 = i.uv_texcoord * appendResult113 + appendResult118;
			float4 tex2DNode104 = tex2D( _Spell_RB, uv_TexCoord112 );
			float temp_output_3_0_g259 = ( 1.0 - ( 1.0 - uv_TexCoord112.x ) );
			float temp_output_137_0 = saturate( ( temp_output_3_0_g259 / fwidth( temp_output_3_0_g259 ) ) );
			float temp_output_3_0_g256 = ( 1.0 - uv_TexCoord112.y );
			float temp_output_138_0 = saturate( ( temp_output_3_0_g256 / fwidth( temp_output_3_0_g256 ) ) );
			float2 uv_TexCoord428 = i.uv_texcoord + float2( -0.5,0.5 );
			float cos427 = cos( UNITY_PI );
			float sin427 = sin( UNITY_PI );
			float2 rotator427 = mul( uv_TexCoord428 - float2( 0.5,0.5 ) , float2x2( cos427 , -sin427 , sin427 , cos427 )) + float2( 0.5,0.5 );
			float2 CenteredUV15_g266 = ( rotator427 - float2( 0.5,0.5 ) );
			float2 break17_g266 = CenteredUV15_g266;
			float2 appendResult23_g266 = (float2(( length( CenteredUV15_g266 ) * 1.0 * 2.0 ) , ( atan2( break17_g266.x , break17_g266.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float lerpResult422 = lerp( _AlphaCooldownUI , 1.0 , step( ( appendResult23_g266.y * -1.0 ) , (( 0.55 * -1.0 ) + ((0.046 + (_RightSpellCooldown - 0.0) * (0.273 - 0.046) / (1.0 - 0.0)) - 0.0) * (0.55 - ( 0.55 * -1.0 )) / (1.0 - 0.0)) ));
			float temp_output_136_0 = ( temp_output_137_0 * temp_output_138_0 * tex2DNode104.a );
			float2 uv_TexCoord389 = i.uv_texcoord + float2( 0.5,0.5 );
			float cos390 = cos( UNITY_PI );
			float sin390 = sin( UNITY_PI );
			float2 rotator390 = mul( uv_TexCoord389 - float2( 0.5,0.5 ) , float2x2( cos390 , -sin390 , sin390 , cos390 )) + float2( 0.5,0.5 );
			float2 CenteredUV15_g265 = ( rotator390 - float2( 0.5,0.5 ) );
			float2 break17_g265 = CenteredUV15_g265;
			float2 appendResult23_g265 = (float2(( length( CenteredUV15_g265 ) * 1.0 * 2.0 ) , ( atan2( break17_g265.x , break17_g265.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float lerpResult411 = lerp( _AlphaCooldownUI , 1.0 , step( appendResult23_g265.y , (( 0.55 * -1.0 ) + ((0.046 + (_LeftSpellCooldown - 0.0) * (0.273 - 0.046) / (1.0 - 0.0)) - 0.0) * (0.55 - ( 0.55 * -1.0 )) / (1.0 - 0.0)) ));
			float temp_output_134_0 = ( temp_output_132_0 * temp_output_133_0 * tex2DNode103.a );
			float temp_output_123_0 = ( temp_output_134_0 + temp_output_136_0 );
			float4 lerpResult347 = lerp( ( temp_output_244_0 + temp_output_261_0 + temp_output_292_0 + temp_output_304_0 + ( ( ( ( ( (( _SubSpell1Intensity )?( temp_output_244_0 ):( float4( 0,0,0,0 ) )) + (( _SubSpell2Intensity )?( temp_output_261_0 ):( float4( 0,0,0,0 ) )) + (( _SubSpell3Intensity )?( temp_output_292_0 ):( float4( 0,0,0,0 ) )) + (( _SubSpell4Intensity )?( temp_output_304_0 ):( float4( 0,0,0,0 ) )) ) - (( _SubSpell1Disable )?( ( temp_output_244_0 * 0.6 ) ):( float4( 0,0,0,0 ) )) ) - (( _SubSpell2Disable )?( ( temp_output_261_0 * 0.6 ) ):( float4( 0,0,0,0 ) )) ) - (( _SubSpell3Disable )?( ( temp_output_292_0 * 0.6 ) ):( float4( 0,0,0,0 ) )) ) - (( _SubSpell4Disable )?( ( temp_output_304_0 * 0.6 ) ):( float4( 0,0,0,0 ) )) ) ) , ( ( ( temp_output_132_0 * temp_output_133_0 * tex2DNode103 ) + ( tex2DNode104 * temp_output_137_0 * temp_output_138_0 ) ) * ( ( lerpResult422 * temp_output_136_0 ) + ( lerpResult411 * temp_output_134_0 ) ) ) , temp_output_123_0);
			o.Emission = ( lerpResult99 + lerpResult347 ).rgb;
			float clampResult348 = clamp( ( temp_output_123_0 + (( _EnableSubSpells )?( ( temp_output_245_0 + temp_output_262_0 + temp_output_291_0 + temp_output_303_0 ) ):( 0.0 )) ) , 0.0 , 1.0 );
			float clampResult349 = clamp( ( tex2DNode68.a + (( _EnableSpell )?( clampResult348 ):( 0.0 )) ) , 0.0 , 1.0 );
			o.Alpha = clampResult349;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;394;-1245.367,-274.8061;Inherit;False;2693.543;1296.727;make cooldown visible like this ;33;434;416;433;413;424;430;429;428;427;426;425;422;421;420;419;418;417;415;398;391;389;390;414;407;387;411;396;409;388;395;380;381;382;make cooldown visible like this ;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;235;-5878.476,4639.982;Inherit;False;Property;_SubSpells_Scale;SubSpells_Scale;24;0;Create;True;0;0;0;False;0;False;0;5.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;223;-6085.042,4668.885;Inherit;False;Constant;_SubSpells_rescale;SubSpells_rescale;27;0;Create;True;0;0;0;False;0;False;1.65,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;328;-2250.729,3606.214;Inherit;False;2231.401;3904.982;SubSpells;4;280;324;325;279;SubSpells;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;-5678.833,4647.16;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;325;-2145.903,6678.772;Inherit;False;2036.588;692.4976;SubSpell5;12;304;303;301;302;297;299;300;298;296;295;294;293;SubSpell5;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;279;-2133.032,3989.338;Inherit;False;2009.407;735.696;SubSpell1;12;245;244;214;243;250;249;247;248;242;241;215;224;SubSpell1;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;324;-2150.265,5795.174;Inherit;False;2026.503;696.002;SubSpell4;12;281;282;284;283;288;285;287;286;290;289;291;292;SubSpell4;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;280;-2171.855,4878.814;Inherit;False;2071.769;712.0043;SubSpell2;13;261;262;259;260;255;256;257;258;253;254;252;251;265;SubSpell2;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;251;-2121.855,5002.319;Inherit;False;Property;_SubSpell2_Position;SubSpell2_Position;26;0;Create;True;0;0;0;False;0;False;0,0;9.809089E-45,9.809089E-45;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;265;-1977.237,5159.895;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;281;-2100.265,5918.679;Inherit;False;Property;_SubSpell4_Position;SubSpell4_Position;27;0;Create;True;0;0;0;False;0;False;0,0;-8.000003,-1.121039E-44;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;224;-2083.032,4114.107;Inherit;False;Property;_SubSpell1_Position;SubSpell1_Position;25;0;Create;True;0;0;0;False;0;False;0,0;-5.605194E-45,-5.605194E-45;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;236;-2304.986,4065.366;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;293;-2085.819,6802.277;Inherit;False;Property;_SubSpell5_Position;SubSpell5_Position;28;0;Create;True;0;0;0;False;0;False;0,0;-7.999996,1.261169E-44;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;215;-1557.184,4039.338;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;252;-1651.515,4953.322;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;294;-1615.479,6753.28;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;282;-1629.927,5869.682;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;202;-2720.502,2067.972;Inherit;False;3313.382;1295.625;Spell_Selection;33;165;182;166;167;181;183;178;177;163;194;172;193;185;187;179;184;198;197;195;162;196;175;188;199;191;201;200;189;190;338;340;339;379;Spell_Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;284;-1312.485,6144.176;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;254;-1334.074,5227.816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;253;-1329.074,5414.816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;165;-2670.502,2462.392;Inherit;False;Property;_SpellSelection_Scale_Offset;SpellSelection_Scale_Offset;20;0;Create;True;0;0;0;False;0;False;0,0,0,0;1.65,1,-7.75,-0.25;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;296;-1298.038,7027.774;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;283;-1307.485,6331.176;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;241;-1344.811,4381.235;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;242;-1339.811,4568.235;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;295;-1293.038,7214.774;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;339;-1517.736,2116.493;Inherit;False;Property;_DebugMiddleOffset;DebugMiddleOffset;30;0;Create;True;0;0;0;False;0;False;0;0;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;288;-1071.008,6048.977;Inherit;False;Step Antialiasing;-1;;236;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-2375.807,2383.403;Inherit;False;Property;_SpellSelection_CommunScale;SpellSelection_CommunScale;21;0;Create;True;0;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;286;-1065.744,6263.479;Inherit;False;Step Antialiasing;-1;;237;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;249;-1098.069,4500.538;Inherit;False;Step Antialiasing;-1;;238;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;166;-2232.502,2490.392;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;248;-1099.386,4386.049;Inherit;False;Step Antialiasing;-1;;239;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;146;-2711.886,1075.036;Inherit;False;4632.629;849.1333;Spells;25;266;144;134;125;143;123;136;137;133;104;132;138;103;139;106;112;158;113;159;160;118;108;131;130;115;Spells;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;338;-1544.736,2215.493;Inherit;False;Constant;_Vector0;Vector 0;33;0;Create;True;0;0;0;False;0;False;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;299;-1068.404,7233.933;Inherit;False;Step Antialiasing;-1;;240;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;285;-1067.061,6148.99;Inherit;False;Step Antialiasing;-1;;241;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;256;-1104.439,5433.975;Inherit;False;Step Antialiasing;-1;;242;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;161;-5786.119,4433.005;Inherit;True;Property;_Spell_Selection;Spell_Selection;18;0;Create;True;0;0;0;False;0;False;None;4bff210abe0bc7f41b336f44a0976ddc;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;-2019.806,2462.403;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;214;-1209.746,4082.233;Inherit;True;Property;_TextureSample1;Texture Sample 1;25;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;167;-2234.502,2594.392;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;259;-819.0729,5320.816;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-2153.086,1313.508;Inherit;False;Property;_SpellScaleY;SpellScaleY;13;0;Create;True;0;0;0;False;0;False;1;3.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;302;-1162.973,6728.772;Inherit;True;Property;_TextureSample5;Texture Sample 5;33;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;290;-1177.42,5845.174;Inherit;True;Property;_TextureSample4;Texture Sample 4;32;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;340;-1330.736,2240.493;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-2328.332,1616.411;Inherit;False;Property;_RB_SpellOffsetX;RB_SpellOffsetX;14;0;Create;True;0;0;0;False;0;False;0;-5.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;-797.4836,6237.176;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-2328.332,1701.411;Inherit;False;Property;_RB_SpellOffsetY;RB_SpellOffsetY;15;0;Create;True;0;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;-783.0377,7120.774;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-2150.885,1233.659;Inherit;False;Property;_SpellScaleX;SpellScaleX;12;0;Create;True;0;0;0;False;0;False;1;6.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;-499.7395,7096.529;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-514.1855,6212.931;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;376;854.4313,4570.168;Inherit;False;1457.903;511.1465;DisableSubSpells;13;362;361;369;370;371;365;367;366;368;364;373;374;375;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;-544.0846,5301.403;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;118;-1967.086,1613.508;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-2332.232,1530.69;Inherit;False;Property;_LB_SpellOffsetY;LB_SpellOffsetY;17;0;Create;True;0;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;245;-523.8611,4447.082;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-2334.232,1449.69;Inherit;False;Property;_LB_SpellOffsetX;LB_SpellOffsetX;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;163;-1714.502,2513.392;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;183;-1190.415,2198.31;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;113;-1950.918,1296.599;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;158;-1980.232,1458.69;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;185;-904.1674,2124.81;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;194;-1456.197,3038.164;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-1616.918,1546.599;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;-271.316,6814.71;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;362;904.4317,4686.236;Inherit;False;Constant;_Float0;Float 0;36;0;Create;True;0;0;0;False;0;False;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;193;-1420.774,2867.118;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;-361.5319,5053.453;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;244;-285.193,4218.482;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;356;838.2256,3998.101;Inherit;False;584.4146;496.7642;HighlightSubSpells;5;357;352;355;354;353;HighlightSubSpells;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;-285.7624,5931.112;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;105;-1617.844,-1768.922;Inherit;False;3049.196;1282.51;LifeAndStamina;33;67;65;64;82;150;149;70;99;148;102;68;98;101;100;20;83;85;94;81;69;28;18;22;73;78;72;77;76;71;153;154;157;155;LifeAndStamina;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;195;-1281.105,2794.247;Inherit;False;Step Antialiasing;-1;;252;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;187;-689.6956,2119.449;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.501;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;355;888.2261,4353.105;Inherit;False;Property;_SubSpell4Intensity;SubSpell4Intensity;34;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-1569.844,-1144.922;Inherit;False;Property;_LifeBarOffsetX;LifeBarOffsetX;8;0;Create;True;0;0;0;False;0;False;0;-0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;361;1198.732,4668.463;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;196;-1282.117,2884.321;Inherit;False;Step Antialiasing;-1;;253;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;184;-909.8784,2222.629;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.501;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1569.844,-1064.922;Inherit;False;Property;_LifeBarOffsetY;LifeBarOffsetY;9;0;Create;True;0;0;0;False;0;False;0;-4.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;198;-1286.165,3063.461;Inherit;False;Step Antialiasing;-1;;254;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;106;-1624.775,1322.759;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-1553.844,-1288.922;Inherit;False;Property;_LifeBarScaleX;LifeBarScaleX;6;0;Create;True;0;0;0;False;0;False;1.13;3.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;353;891.9519,4151.091;Inherit;False;Property;_SubSpell2Intensity;SubSpell2Intensity;32;0;Create;True;0;0;0;False;0;False;1;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1553.844,-1208.922;Inherit;False;Property;_LifeBarScaleY;LifeBarScaleY;7;0;Create;True;0;0;0;False;0;False;1;6.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;213;-2836.868,2374.213;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.OneMinusNode;139;-945.0717,1684.164;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;197;-1284.141,2976.423;Inherit;False;Step Antialiasing;-1;;255;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;354;891.524,4250.337;Inherit;False;Property;_SubSpell3Intensity;SubSpell3Intensity;33;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;352;898.7258,4048.101;Inherit;False;Property;_SubSpell1Intensity;SubSpell1Intensity;31;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;103;-812.2717,1310.709;Inherit;True;Property;_Spell_LB;Spell_LB;10;0;Create;True;0;0;0;False;0;False;-1;9550229004d2a5649a26bb8a904e1022;9550229004d2a5649a26bb8a904e1022;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;138;-707.7655,1777.14;Inherit;False;Step Antialiasing;-1;;256;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;162;-1412.502,2406.392;Inherit;True;Property;_TextureSample0;Texture Sample 0;19;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;132;-708.2679,1125.036;Inherit;False;Step Antialiasing;-1;;257;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;365;1375.773,4639.916;Inherit;False;Property;_SubSpell1Disable;SubSpell1Disable;35;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;104;-812.1393,1500.792;Inherit;True;Property;_Spell_RB;Spell_RB;11;0;Create;True;0;0;0;False;0;False;-1;d540565bd16c8d14e82bd637a9a40e6d;d540565bd16c8d14e82bd637a9a40e6d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-349.105,2117.972;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;133;-709.2679,1216.037;Inherit;False;Step Antialiasing;-1;;258;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;137;-706.2865,1686.93;Inherit;False;Step Antialiasing;-1;;259;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;369;1200.137,4760.464;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;78;-1361.844,-1128.922;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;73;-1361.844,-1224.922;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;357;1272.235,4295.038;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-1020.341,2794.221;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1185.844,-696.9221;Inherit;False;Property;_Stamina;Stamina;3;0;Create;True;0;0;0;False;0;False;0.4504158;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;367;1376.246,4732.689;Inherit;False;Property;_SubSpell2Disable;SubSpell2Disable;36;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;364;1601.335,4620.168;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;370;1199.382,4854.777;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1201.844,-1720.922;Inherit;False;Property;_Life;Life;2;0;Create;True;0;0;0;False;0;False;0.4999876;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;191;-101.286,2205.77;Inherit;False;Property;_DebugMiddle;DebugMiddle;29;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;70;-1137.844,-1256.922;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;58.83928,2588.92;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;366;1377.718,4826.302;Inherit;False;Property;_SubSpell3Disable;SubSpell3Disable;37;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;18;-913.8439,-1704.922;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.06;False;4;FLOAT;0.83;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;189;333.1068,2562.859;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;65;-881.8439,-696.9221;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;0.63;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;371;1200.117,4946.314;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;373;1788.275,4711.656;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;82;-609.844,-1576.922;Inherit;False;Step Antialiasing;-1;;260;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.425;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;177;-1034.209,2970.622;Inherit;False;Constant;_Color0;Color 0;22;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;178;-1047.179,3151.597;Inherit;False;Constant;_Color1;Color 1;22;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;264;2709.475,6034.182;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;172;-1400.068,2596.171;Inherit;True;Property;_Spell_Selection_Mask;Spell_Selection_Mask;19;0;Create;True;0;0;0;False;0;False;-1;2a6878d0c446f584d94678d0f61a3eb2;2a6878d0c446f584d94678d0f61a3eb2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;368;1376.718,4918.302;Inherit;False;Property;_SubSpell4Disable;SubSpell4Disable;38;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;344;2989.622,6021.217;Inherit;False;Property;_EnableSubSpells;EnableSubSpells;23;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;28;-641.844,-1704.922;Inherit;False;Step Antialiasing;-1;;261;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;81;-257.8444,-1384.922;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;67;-641.844,-712.9221;Inherit;False;Step Antialiasing;-1;;262;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;154;-753.844,-1368.922;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;379;-743.0369,2968.318;Inherit;False;Property;_SpellAvailable;SpellAvailable;39;0;Create;True;0;0;0;False;0;False;1;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;374;1962.784,4814.732;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;149;-609.844,-1464.922;Inherit;False;Step Antialiasing;-1;;263;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-81.8444,-1608.922;Inherit;False;Property;_LifeColor;LifeColor;4;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;377;782.7554,5138.295;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;94;-49.84438,-776.9221;Inherit;False;Property;_StaminaColor;StaminaColor;5;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;346;4091.744,4098.303;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-97.84436,-1016.922;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-81.8444,-1416.922;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;378;785.3957,5347.51;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-416.7706,2478.95;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;150;-609.844,-1368.922;Inherit;False;Step Antialiasing;-1;;264;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;375;2146.332,4911.931;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;263;2547.506,5256.739;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;175;-28.09585,2428.976;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;206.1556,-1416.922;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;238.1556,-808.9221;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;348;4270.125,4100.948;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;157;-321.8444,-1288.922;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;148;1278.156,-984.9221;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;350;3740.737,4000.486;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;670.1559,-1032.922;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;670.1559,-1416.922;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;798.156,-1320.922;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;295.33,2423.608;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;345;4463.011,4075.708;Inherit;False;Property;_EnableSpell;EnableSpell;22;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;4939.191,3886.213;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;99;1182.156,-1320.922;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;347;4476.225,3787.564;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;190;440.8795,2337.893;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;120;4945.701,3741.224;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;349;5106.111,3885.821;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;6;5612.429,3688.402;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;UI;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;1198.11,1147.062;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;1403.081,1147.3;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;1200.487,1291.569;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;1694.415,1148.878;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;382;-123.2611,530.8915;Inherit;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StepOpNode;381;196.7389,546.8912;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;-0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;380;-411.2614,530.8915;Inherit;True;Polar Coordinates;-1;;265;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;395;-635.2615,834.891;Inherit;False;Constant;_Float4;Float 4;40;0;Create;True;0;0;0;False;0;False;0.55;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;388;-91.26125,756.191;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.55;False;4;FLOAT;0.55;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;409;-305.2518,929.7736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;396;-347.2612,834.891;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;411;481.5507,497.2694;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;387;-1102.448,753.2689;Inherit;False;Property;_LeftSpellCooldown;LeftSpellCooldown;41;0;Create;True;0;0;0;False;0;False;0.8414031;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;407;-830.4487,753.2689;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.046;False;4;FLOAT;0.273;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;414;854.5806,501.5528;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;390;-649.4194,533.5528;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;389;-889.4191,533.5528;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PiNode;391;-857.4194,661.5528;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;398;-1081.419,581.5528;Inherit;False;Constant;_Vector1;Vector 1;40;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.BreakToComponentsNode;415;-125.3915,-155.0123;Inherit;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;417;-413.3927,-155.0123;Inherit;True;Polar Coordinates;-1;;266;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;418;-637.3928,148.9874;Inherit;False;Constant;_Float5;Float 4;40;0;Create;True;0;0;0;False;0;False;0.55;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;419;-93.39169,70.28713;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.55;False;4;FLOAT;0.55;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;420;-307.3824,243.87;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;421;-349.3921,148.9874;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;422;479.4202,-188.6343;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;425;-832.5797,67.36509;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.046;False;4;FLOAT;0.273;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;426;852.4493,-184.351;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;427;-651.5507,-152.351;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;428;-891.5496,-152.351;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PiNode;429;-859.5499,-24.35086;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;430;-1083.549,-104.3509;Inherit;False;Constant;_Vector2;Vector 1;40;0;Create;True;0;0;0;False;0;False;-0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;424;-1104.578,67.36509;Inherit;False;Property;_RightSpellCooldown;RightSpellCooldown;42;0;Create;True;0;0;0;False;0;False;0.8414031;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;413;155.1847,412.5157;Inherit;False;Property;_AlphaCooldownUI;AlphaCooldownUI;40;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;433;70.58071,-138.4473;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;416;230.5807,-138.4473;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;-0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;434;1222.581,485.5527;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;256,1632;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-96,1632;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-96,1760;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;68;-705.844,-1288.922;Inherit;True;Property;_Empty_LifeBar;Empty_LifeBar;0;0;Create;True;0;0;0;False;0;False;-1;e553f9ae2353fb84ba10b20fe0b9b322;e553f9ae2353fb84ba10b20fe0b9b322;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;69;-705.844,-1096.922;Inherit;True;Property;_LifeBar;LifeBar;1;0;Create;True;0;0;0;False;0;False;-1;6d5591ed0712b514b815492dc9f86b7c;6d5591ed0712b514b815492dc9f86b7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;156;-306.5696,-1322.144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;155;-808.5375,-1388.289;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
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
WireConnection;166;0;165;1
WireConnection;166;1;165;2
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
WireConnection;181;0;182;0
WireConnection;181;1;166;0
WireConnection;214;0;161;0
WireConnection;214;1;215;0
WireConnection;167;0;165;3
WireConnection;167;1;165;4
WireConnection;259;0;258;0
WireConnection;259;1;255;0
WireConnection;259;2;257;0
WireConnection;259;3;256;0
WireConnection;302;0;161;0
WireConnection;302;1;294;0
WireConnection;290;0;161;0
WireConnection;290;1;282;0
WireConnection;340;0;339;0
WireConnection;340;1;338;0
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
WireConnection;163;0;181;0
WireConnection;163;1;167;0
WireConnection;183;1;340;0
WireConnection;113;0;108;0
WireConnection;113;1;115;0
WireConnection;158;0;159;0
WireConnection;158;1;160;0
WireConnection;185;0;183;1
WireConnection;194;0;163;2
WireConnection;112;0;113;0
WireConnection;112;1;118;0
WireConnection;304;0;302;0
WireConnection;304;1;301;0
WireConnection;304;2;303;0
WireConnection;193;0;163;1
WireConnection;261;0;260;0
WireConnection;261;1;259;0
WireConnection;261;2;262;0
WireConnection;244;0;214;0
WireConnection;244;1;243;0
WireConnection;244;2;245;0
WireConnection;292;0;290;0
WireConnection;292;1;289;0
WireConnection;292;2;291;0
WireConnection;195;1;163;1
WireConnection;187;0;185;0
WireConnection;355;1;304;0
WireConnection;361;0;244;0
WireConnection;361;1;362;0
WireConnection;196;1;193;0
WireConnection;184;0;183;1
WireConnection;198;1;194;0
WireConnection;106;0;113;0
WireConnection;106;1;158;0
WireConnection;353;1;261;0
WireConnection;213;0;161;0
WireConnection;139;0;112;1
WireConnection;197;1;163;2
WireConnection;354;1;292;0
WireConnection;352;1;244;0
WireConnection;103;1;106;0
WireConnection;138;1;112;2
WireConnection;162;0;213;0
WireConnection;162;1;163;0
WireConnection;132;1;106;1
WireConnection;365;1;361;0
WireConnection;104;1;112;0
WireConnection;188;0;187;0
WireConnection;188;1;184;0
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
WireConnection;199;0;195;0
WireConnection;199;1;196;0
WireConnection;199;2;197;0
WireConnection;199;3;198;0
WireConnection;367;1;369;0
WireConnection;364;0;357;0
WireConnection;364;1;365;0
WireConnection;370;0;292;0
WireConnection;370;1;362;0
WireConnection;191;0;188;0
WireConnection;70;0;73;0
WireConnection;70;1;78;0
WireConnection;200;0;162;4
WireConnection;200;1;199;0
WireConnection;366;1;370;0
WireConnection;18;0;22;0
WireConnection;189;0;191;0
WireConnection;189;1;200;0
WireConnection;65;0;64;0
WireConnection;371;0;304;0
WireConnection;371;1;362;0
WireConnection;373;0;364;0
WireConnection;373;1;367;0
WireConnection;82;1;70;2
WireConnection;264;0;245;0
WireConnection;264;1;262;0
WireConnection;264;2;291;0
WireConnection;264;3;303;0
WireConnection;172;1;163;0
WireConnection;368;1;371;0
WireConnection;344;1;264;0
WireConnection;28;1;70;1
WireConnection;28;2;18;0
WireConnection;81;0;82;0
WireConnection;67;1;70;1
WireConnection;67;2;65;0
WireConnection;154;0;70;2
WireConnection;379;0;177;0
WireConnection;379;1;178;0
WireConnection;374;0;373;0
WireConnection;374;1;366;0
WireConnection;149;1;155;0
WireConnection;377;0;244;0
WireConnection;346;0;123;0
WireConnection;346;1;344;0
WireConnection;85;0;82;0
WireConnection;85;1;69;4
WireConnection;85;2;67;0
WireConnection;83;0;28;0
WireConnection;83;1;81;0
WireConnection;83;2;69;4
WireConnection;378;0;261;0
WireConnection;179;0;172;4
WireConnection;179;1;379;0
WireConnection;150;1;154;0
WireConnection;375;0;374;0
WireConnection;375;1;368;0
WireConnection;263;0;377;0
WireConnection;263;1;378;0
WireConnection;263;2;292;0
WireConnection;263;3;304;0
WireConnection;263;4;375;0
WireConnection;175;0;162;0
WireConnection;175;1;179;0
WireConnection;175;2;172;4
WireConnection;100;0;20;0
WireConnection;100;1;83;0
WireConnection;101;0;85;0
WireConnection;101;1;94;0
WireConnection;348;0;346;0
WireConnection;157;0;150;0
WireConnection;148;0;68;4
WireConnection;350;0;263;0
WireConnection;98;0;83;0
WireConnection;98;1;85;0
WireConnection;102;0;100;0
WireConnection;102;1;101;0
WireConnection;153;0;156;0
WireConnection;153;1;157;0
WireConnection;153;2;68;0
WireConnection;201;0;175;0
WireConnection;201;1;199;0
WireConnection;345;1;348;0
WireConnection;121;0;148;0
WireConnection;121;1;345;0
WireConnection;99;0;153;0
WireConnection;99;1;102;0
WireConnection;99;2;98;0
WireConnection;347;0;350;0
WireConnection;347;1;266;0
WireConnection;347;2;123;0
WireConnection;190;0;191;0
WireConnection;190;1;201;0
WireConnection;120;0;99;0
WireConnection;120;1;347;0
WireConnection;349;0;121;0
WireConnection;6;2;120;0
WireConnection;6;9;349;0
WireConnection;143;0;132;0
WireConnection;143;1;133;0
WireConnection;143;2;103;0
WireConnection;125;0;143;0
WireConnection;125;1;144;0
WireConnection;144;0;104;0
WireConnection;144;1;137;0
WireConnection;144;2;138;0
WireConnection;266;0;125;0
WireConnection;266;1;434;0
WireConnection;382;0;380;0
WireConnection;381;0;382;1
WireConnection;381;1;388;0
WireConnection;380;1;390;0
WireConnection;388;0;407;0
WireConnection;388;3;396;0
WireConnection;388;4;409;0
WireConnection;409;0;395;0
WireConnection;396;0;395;0
WireConnection;411;0;413;0
WireConnection;411;2;381;0
WireConnection;407;0;387;0
WireConnection;414;0;411;0
WireConnection;414;1;134;0
WireConnection;390;0;389;0
WireConnection;390;2;391;0
WireConnection;389;1;398;0
WireConnection;415;0;417;0
WireConnection;417;1;427;0
WireConnection;419;0;425;0
WireConnection;419;3;421;0
WireConnection;419;4;420;0
WireConnection;420;0;418;0
WireConnection;421;0;418;0
WireConnection;422;0;413;0
WireConnection;422;2;416;0
WireConnection;425;0;424;0
WireConnection;426;0;422;0
WireConnection;426;1;136;0
WireConnection;427;0;428;0
WireConnection;427;2;429;0
WireConnection;428;1;430;0
WireConnection;433;0;415;1
WireConnection;416;0;433;0
WireConnection;416;1;419;0
WireConnection;434;0;426;0
WireConnection;434;1;414;0
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
WireConnection;156;0;149;0
WireConnection;155;0;70;1
ASEEND*/
//CHKSM=DF027A36BABF64304A69878DEDC49B0332981D1B