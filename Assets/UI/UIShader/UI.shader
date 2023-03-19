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
		_Spell_Selection("Spell_Selection", 2D) = "white" {}
		_Spell_Selection_Mask("Spell_Selection_Mask", 2D) = "white" {}
		_SpellSelection_Scale_Offset("SpellSelection_Scale_Offset", Vector) = (0,0,0,0)
		_SpellSelection_CommunScale("SpellSelection_CommunScale", Float) = 0
		[Toggle(_SPELLAVAILABLE_ON)] _SpellAvailable("SpellAvailable", Float) = 0
		[Toggle(_ENABLESPELL_ON)] _EnableSpell("EnableSpell", Float) = 0
		[Toggle(_ENABLESUBSPELLS_ON)] _EnableSubSpells("EnableSubSpells", Float) = 0
		_SubSpells_Scale("SubSpells_Scale", Float) = 0
		_SubSpell1_Position("SubSpell1_Position", Vector) = (0,0,0,0)
		_SubSpell2_Position("SubSpell2_Position", Vector) = (0,0,0,0)
		_SubSpell3_Position("SubSpell3_Position", Vector) = (0,0,0,0)
		_SubSpell4_Position("SubSpell4_Position", Vector) = (0,0,0,0)
		_SubSpell5_Position("SubSpell5_Position", Vector) = (0,0,0,0)
		_SubSpell6_Position("SubSpell6_Position", Vector) = (0,0,0,0)
		[Toggle(_DEBUGMIDDLE_ON)] _DebugMiddle("DebugMiddle", Float) = 0
		_DebugMiddleOffset("DebugMiddleOffset", Range( -0.5 , 0.5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature_local _DEBUGMIDDLE_ON
		#pragma shader_feature_local _SPELLAVAILABLE_ON
		#pragma shader_feature_local _ENABLESPELL_ON
		#pragma shader_feature_local _ENABLESUBSPELLS_ON
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
		uniform float _DebugMiddleOffset;
		uniform sampler2D _Spell_Selection;
		uniform float _SpellSelection_CommunScale;
		uniform float4 _SpellSelection_Scale_Offset;
		uniform sampler2D _Spell_Selection_Mask;
		uniform float _SubSpells_Scale;
		uniform float2 _SubSpell1_Position;
		uniform float2 _SubSpell2_Position;
		uniform float2 _SubSpell3_Position;
		uniform float2 _SubSpell4_Position;
		uniform float2 _SubSpell5_Position;
		uniform float2 _SubSpell6_Position;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult73 = (float2(_LifeBarScaleX , _LifeBarScaleY));
			float2 appendResult78 = (float2(_LifeBarOffsetX , _LifeBarOffsetY));
			float2 uv_TexCoord70 = i.uv_texcoord * appendResult73 + appendResult78;
			float temp_output_3_0_g170 = ( 1.0 - uv_TexCoord70.x );
			float temp_output_3_0_g169 = ( 1.0 - ( 1.0 - uv_TexCoord70.y ) );
			float4 tex2DNode68 = tex2D( _Empty_LifeBar, uv_TexCoord70 );
			float temp_output_3_0_g168 = ( (0.06 + (_Life - 0.0) * (0.83 - 0.06) / (1.0 - 0.0)) - uv_TexCoord70.x );
			float temp_output_3_0_g160 = ( 0.425 - uv_TexCoord70.y );
			float temp_output_82_0 = saturate( ( temp_output_3_0_g160 / fwidth( temp_output_3_0_g160 ) ) );
			float4 tex2DNode69 = tex2D( _LifeBar, uv_TexCoord70 );
			float temp_output_83_0 = ( saturate( ( temp_output_3_0_g168 / fwidth( temp_output_3_0_g168 ) ) ) * ( 1.0 - temp_output_82_0 ) * tex2DNode69.a );
			float temp_output_3_0_g167 = ( (0.1 + (_Stamina - 0.0) * (0.63 - 0.1) / (1.0 - 0.0)) - uv_TexCoord70.x );
			float temp_output_85_0 = ( temp_output_82_0 * tex2DNode69.a * saturate( ( temp_output_3_0_g167 / fwidth( temp_output_3_0_g167 ) ) ) );
			float4 lerpResult99 = lerp( ( saturate( ( temp_output_3_0_g170 / fwidth( temp_output_3_0_g170 ) ) ) * saturate( ( temp_output_3_0_g169 / fwidth( temp_output_3_0_g169 ) ) ) * tex2DNode68 ) , ( ( _LifeColor * temp_output_83_0 ) + ( temp_output_85_0 * _StaminaColor ) ) , ( temp_output_83_0 + temp_output_85_0 ));
			float2 appendResult113 = (float2(_SpellScaleX , _SpellScaleY));
			float2 appendResult158 = (float2(_LB_SpellOffsetX , _LB_SpellOffsetY));
			float2 uv_TexCoord106 = i.uv_texcoord * appendResult113 + appendResult158;
			float temp_output_3_0_g165 = ( 1.0 - uv_TexCoord106.x );
			float temp_output_132_0 = saturate( ( temp_output_3_0_g165 / fwidth( temp_output_3_0_g165 ) ) );
			float temp_output_3_0_g163 = ( 1.0 - uv_TexCoord106.y );
			float temp_output_133_0 = saturate( ( temp_output_3_0_g163 / fwidth( temp_output_3_0_g163 ) ) );
			float4 tex2DNode103 = tex2D( _Spell_LB, uv_TexCoord106 );
			float2 appendResult118 = (float2(_RB_SpellOffsetX , _RB_SpellOffsetY));
			float2 uv_TexCoord112 = i.uv_texcoord * appendResult113 + appendResult118;
			float4 tex2DNode104 = tex2D( _Spell_RB, uv_TexCoord112 );
			float temp_output_3_0_g166 = ( 1.0 - ( 1.0 - uv_TexCoord112.x ) );
			float temp_output_137_0 = saturate( ( temp_output_3_0_g166 / fwidth( temp_output_3_0_g166 ) ) );
			float temp_output_3_0_g164 = ( 1.0 - uv_TexCoord112.y );
			float temp_output_138_0 = saturate( ( temp_output_3_0_g164 / fwidth( temp_output_3_0_g164 ) ) );
			float temp_output_123_0 = ( ( temp_output_132_0 * temp_output_133_0 * tex2DNode103.a ) + ( temp_output_137_0 * temp_output_138_0 * tex2DNode104.a ) );
			float2 uv_TexCoord183 = i.uv_texcoord + ( _DebugMiddleOffset * float2( -1,0 ) );
			#ifdef _DEBUGMIDDLE_ON
				float staticSwitch191 = ( step( ( 1.0 - uv_TexCoord183.x ) , 0.501 ) * step( uv_TexCoord183.x , 0.501 ) );
			#else
				float staticSwitch191 = 0.0;
			#endif
			float2 appendResult166 = (float2(_SpellSelection_Scale_Offset.x , _SpellSelection_Scale_Offset.y));
			float2 appendResult167 = (float2(_SpellSelection_Scale_Offset.z , _SpellSelection_Scale_Offset.w));
			float2 uv_TexCoord163 = i.uv_texcoord * ( _SpellSelection_CommunScale * appendResult166 ) + appendResult167;
			float4 tex2DNode162 = tex2D( _Spell_Selection, uv_TexCoord163 );
			float4 tex2DNode172 = tex2D( _Spell_Selection_Mask, uv_TexCoord163 );
			float4 color177 = IsGammaSpace() ? float4(1,0,0,0) : float4(1,0,0,0);
			float4 color178 = IsGammaSpace() ? float4(0,1,0,0) : float4(0,1,0,0);
			#ifdef _SPELLAVAILABLE_ON
				float4 staticSwitch176 = color178;
			#else
				float4 staticSwitch176 = color177;
			#endif
			float4 lerpResult175 = lerp( tex2DNode162 , ( tex2DNode172.a * staticSwitch176 ) , tex2DNode172.a);
			float temp_output_3_0_g159 = ( 1.0 - uv_TexCoord163.x );
			float temp_output_3_0_g162 = ( 1.0 - ( 1.0 - uv_TexCoord163.x ) );
			float temp_output_3_0_g161 = ( 1.0 - uv_TexCoord163.y );
			float temp_output_3_0_g158 = ( 1.0 - ( 1.0 - uv_TexCoord163.y ) );
			float temp_output_199_0 = ( saturate( ( temp_output_3_0_g159 / fwidth( temp_output_3_0_g159 ) ) ) * saturate( ( temp_output_3_0_g162 / fwidth( temp_output_3_0_g162 ) ) ) * saturate( ( temp_output_3_0_g161 / fwidth( temp_output_3_0_g161 ) ) ) * saturate( ( temp_output_3_0_g158 / fwidth( temp_output_3_0_g158 ) ) ) );
			float2 temp_output_233_0 = ( _SubSpells_Scale * float2( 1.65,1 ) );
			float2 uv_TexCoord215 = i.uv_texcoord * temp_output_233_0 + _SubSpell1_Position;
			float4 tex2DNode214 = tex2D( _Spell_Selection, uv_TexCoord215 );
			float temp_output_3_0_g139 = ( 1.0 - uv_TexCoord215.x );
			float temp_output_3_0_g150 = ( 1.0 - ( 1.0 - uv_TexCoord215.x ) );
			float temp_output_3_0_g154 = ( 1.0 - uv_TexCoord215.y );
			float temp_output_3_0_g151 = ( 1.0 - ( 1.0 - uv_TexCoord215.y ) );
			float temp_output_243_0 = ( saturate( ( temp_output_3_0_g139 / fwidth( temp_output_3_0_g139 ) ) ) * saturate( ( temp_output_3_0_g150 / fwidth( temp_output_3_0_g150 ) ) ) * saturate( ( temp_output_3_0_g154 / fwidth( temp_output_3_0_g154 ) ) ) * saturate( ( temp_output_3_0_g151 / fwidth( temp_output_3_0_g151 ) ) ) );
			float temp_output_245_0 = ( tex2DNode214.a * temp_output_243_0 );
			float2 uv_TexCoord252 = i.uv_texcoord * temp_output_233_0 + _SubSpell2_Position;
			float4 tex2DNode260 = tex2D( _Spell_Selection, uv_TexCoord252 );
			float temp_output_3_0_g143 = ( 1.0 - uv_TexCoord252.x );
			float temp_output_3_0_g152 = ( 1.0 - ( 1.0 - uv_TexCoord252.x ) );
			float temp_output_3_0_g136 = ( 1.0 - uv_TexCoord252.y );
			float temp_output_3_0_g144 = ( 1.0 - ( 1.0 - uv_TexCoord252.y ) );
			float temp_output_259_0 = ( saturate( ( temp_output_3_0_g143 / fwidth( temp_output_3_0_g143 ) ) ) * saturate( ( temp_output_3_0_g152 / fwidth( temp_output_3_0_g152 ) ) ) * saturate( ( temp_output_3_0_g136 / fwidth( temp_output_3_0_g136 ) ) ) * saturate( ( temp_output_3_0_g144 / fwidth( temp_output_3_0_g144 ) ) ) );
			float temp_output_262_0 = ( tex2DNode260.a * temp_output_259_0 );
			float2 uv_TexCoord268 = i.uv_texcoord * temp_output_233_0 + _SubSpell3_Position;
			float4 tex2DNode275 = tex2D( _Spell_Selection, uv_TexCoord268 );
			float temp_output_3_0_g145 = ( 1.0 - uv_TexCoord268.x );
			float temp_output_3_0_g141 = ( 1.0 - ( 1.0 - uv_TexCoord268.x ) );
			float temp_output_3_0_g153 = ( 1.0 - uv_TexCoord268.y );
			float temp_output_3_0_g147 = ( 1.0 - ( 1.0 - uv_TexCoord268.y ) );
			float temp_output_276_0 = ( saturate( ( temp_output_3_0_g145 / fwidth( temp_output_3_0_g145 ) ) ) * saturate( ( temp_output_3_0_g141 / fwidth( temp_output_3_0_g141 ) ) ) * saturate( ( temp_output_3_0_g153 / fwidth( temp_output_3_0_g153 ) ) ) * saturate( ( temp_output_3_0_g147 / fwidth( temp_output_3_0_g147 ) ) ) );
			float temp_output_277_0 = ( tex2DNode275.a * temp_output_276_0 );
			float2 uv_TexCoord282 = i.uv_texcoord * temp_output_233_0 + _SubSpell4_Position;
			float4 tex2DNode290 = tex2D( _Spell_Selection, uv_TexCoord282 );
			float temp_output_3_0_g137 = ( 1.0 - uv_TexCoord282.x );
			float temp_output_3_0_g142 = ( 1.0 - ( 1.0 - uv_TexCoord282.x ) );
			float temp_output_3_0_g138 = ( 1.0 - uv_TexCoord282.y );
			float temp_output_3_0_g155 = ( 1.0 - ( 1.0 - uv_TexCoord282.y ) );
			float temp_output_289_0 = ( saturate( ( temp_output_3_0_g137 / fwidth( temp_output_3_0_g137 ) ) ) * saturate( ( temp_output_3_0_g142 / fwidth( temp_output_3_0_g142 ) ) ) * saturate( ( temp_output_3_0_g138 / fwidth( temp_output_3_0_g138 ) ) ) * saturate( ( temp_output_3_0_g155 / fwidth( temp_output_3_0_g155 ) ) ) );
			float temp_output_291_0 = ( tex2DNode290.a * temp_output_289_0 );
			float2 uv_TexCoord294 = i.uv_texcoord * temp_output_233_0 + _SubSpell5_Position;
			float4 tex2DNode302 = tex2D( _Spell_Selection, uv_TexCoord294 );
			float temp_output_3_0_g146 = ( 1.0 - uv_TexCoord294.x );
			float temp_output_3_0_g135 = ( 1.0 - ( 1.0 - uv_TexCoord294.x ) );
			float temp_output_3_0_g157 = ( 1.0 - uv_TexCoord294.y );
			float temp_output_3_0_g156 = ( 1.0 - ( 1.0 - uv_TexCoord294.y ) );
			float temp_output_301_0 = ( saturate( ( temp_output_3_0_g146 / fwidth( temp_output_3_0_g146 ) ) ) * saturate( ( temp_output_3_0_g135 / fwidth( temp_output_3_0_g135 ) ) ) * saturate( ( temp_output_3_0_g157 / fwidth( temp_output_3_0_g157 ) ) ) * saturate( ( temp_output_3_0_g156 / fwidth( temp_output_3_0_g156 ) ) ) );
			float temp_output_303_0 = ( tex2DNode302.a * temp_output_301_0 );
			float2 uv_TexCoord306 = i.uv_texcoord * temp_output_233_0 + _SubSpell6_Position;
			float4 tex2DNode314 = tex2D( _Spell_Selection, uv_TexCoord306 );
			float temp_output_3_0_g149 = ( 1.0 - uv_TexCoord306.x );
			float temp_output_3_0_g140 = ( 1.0 - ( 1.0 - uv_TexCoord306.x ) );
			float temp_output_3_0_g134 = ( 1.0 - uv_TexCoord306.y );
			float temp_output_3_0_g148 = ( 1.0 - ( 1.0 - uv_TexCoord306.y ) );
			float temp_output_313_0 = ( saturate( ( temp_output_3_0_g149 / fwidth( temp_output_3_0_g149 ) ) ) * saturate( ( temp_output_3_0_g140 / fwidth( temp_output_3_0_g140 ) ) ) * saturate( ( temp_output_3_0_g134 / fwidth( temp_output_3_0_g134 ) ) ) * saturate( ( temp_output_3_0_g148 / fwidth( temp_output_3_0_g148 ) ) ) );
			float temp_output_315_0 = ( tex2DNode314.a * temp_output_313_0 );
			o.Emission = ( lerpResult99 + ( ( ( temp_output_132_0 * temp_output_133_0 * tex2DNode103 ) + ( tex2DNode104 * temp_output_137_0 * temp_output_138_0 ) ) * temp_output_123_0 ) + ( staticSwitch191 + ( lerpResult175 * temp_output_199_0 ) ) + ( ( tex2DNode214 * temp_output_243_0 * temp_output_245_0 ) + ( tex2DNode260 * temp_output_259_0 * temp_output_262_0 ) + ( tex2DNode275 * temp_output_276_0 * temp_output_277_0 ) + ( tex2DNode290 * temp_output_289_0 * temp_output_291_0 ) + ( tex2DNode302 * temp_output_301_0 * temp_output_303_0 ) + ( tex2DNode314 * temp_output_313_0 * temp_output_315_0 ) ) ).rgb;
			#ifdef _ENABLESUBSPELLS_ON
				float staticSwitch322 = ( temp_output_245_0 + temp_output_262_0 + temp_output_277_0 + temp_output_291_0 + temp_output_303_0 + temp_output_315_0 );
			#else
				float staticSwitch322 = 0.0;
			#endif
			#ifdef _ENABLESPELL_ON
				float staticSwitch203 = ( temp_output_123_0 + ( staticSwitch191 + ( tex2DNode162.a * temp_output_199_0 ) ) + staticSwitch322 );
			#else
				float staticSwitch203 = 0.0;
			#endif
			o.Alpha = ( tex2DNode68.a + staticSwitch203 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19001
0;0;2560;1379;3432.063;-3480.1;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;202;-2720.502,2067.972;Inherit;False;3313.382;1295.625;Spell_Selection;33;165;182;166;167;181;183;178;177;163;176;194;172;193;185;187;179;184;198;197;195;162;196;175;188;199;191;201;200;189;190;338;340;339;Spell_Selection;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;235;-5878.476,4639.982;Inherit;False;Property;_SubSpells_Scale;SubSpells_Scale;25;0;Create;True;0;0;0;False;0;False;0;5.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;223;-6085.042,4668.885;Inherit;False;Constant;_SubSpells_rescale;SubSpells_rescale;27;0;Create;True;0;0;0;False;0;False;1.65,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;328;-2250.729,3606.214;Inherit;False;2231.401;5401.179;SubSpells;7;319;279;324;280;325;326;323;SubSpells;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;280;-2171.855,4878.814;Inherit;False;2071.769;712.0043;SubSpell2;13;261;262;259;260;255;256;257;258;253;254;252;251;265;SubSpell2;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;324;-2236.069,6615.673;Inherit;False;2026.503;696.002;SubSpell4;12;281;282;284;283;288;285;287;286;290;289;291;292;SubSpell4;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;325;-2215.619,7386.65;Inherit;False;2036.588;692.4976;SubSpell5;12;304;303;301;302;297;299;300;298;296;295;294;293;SubSpell5;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;165;-2670.502,2462.392;Inherit;False;Property;_SpellSelection_Scale_Offset;SpellSelection_Scale_Offset;20;0;Create;True;0;0;0;False;0;False;0,0,0,0;1.65,1,-7.75,-0.25;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;323;-2201.177,5727.047;Inherit;False;2026.503;696.002;SubSpell3;12;267;268;270;269;274;272;271;273;276;275;277;278;SubSpell3;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;279;-2133.032,3989.338;Inherit;False;2009.407;735.696;SubSpell1;12;245;244;214;243;250;249;247;248;242;241;215;224;SubSpell1;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;326;-2186.45,8184.348;Inherit;False;2026.503;696.002;SubSpell6;12;305;306;307;308;311;310;312;309;314;313;315;316;SubSpell6;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;-5678.833,4647.16;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-2375.807,2383.403;Inherit;False;Property;_SpellSelection_CommunScale;SpellSelection_CommunScale;21;0;Create;True;0;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;339;-1517.736,2116.493;Inherit;False;Property;_DebugMiddleOffset;DebugMiddleOffset;33;0;Create;True;0;0;0;False;0;False;0;0;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;265;-1977.237,5159.895;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;105;-2724.629,-373.7185;Inherit;False;3049.196;1282.51;LifeAndStamina;32;67;65;64;82;150;149;70;99;148;102;68;98;101;100;20;83;85;94;81;69;28;18;22;73;78;72;77;76;71;153;154;157;LifeAndStamina;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;146;-2711.886,1075.036;Inherit;False;3308.045;832.0261;Spells;25;125;123;143;144;134;136;137;132;138;104;133;103;106;139;112;158;113;159;160;118;130;115;108;131;266;Spells;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;338;-1544.736,2215.493;Inherit;False;Constant;_Vector0;Vector 0;33;0;Create;True;0;0;0;False;0;False;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;224;-2083.032,4114.107;Inherit;False;Property;_SubSpell1_Position;SubSpell1_Position;26;0;Create;True;0;0;0;False;0;False;0,0;-0.66,-1.21;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;251;-2121.855,5002.319;Inherit;False;Property;_SubSpell2_Position;SubSpell2_Position;27;0;Create;True;0;0;0;False;0;False;0,0;-1.36,-0.43;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;293;-2155.535,7510.155;Inherit;False;Property;_SubSpell5_Position;SubSpell5_Position;30;0;Create;True;0;0;0;False;0;False;0,0;-6.72,-0.43;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;305;-2136.45,8307.85;Inherit;False;Property;_SubSpell6_Position;SubSpell6_Position;31;0;Create;True;0;0;0;False;0;False;0,0;-1.81,99;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;267;-2151.177,5850.552;Inherit;False;Property;_SubSpell3_Position;SubSpell3_Position;28;0;Create;True;0;0;0;False;0;False;0,0;-6.255,99;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;236;-2304.986,4065.366;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;281;-2186.069,6739.178;Inherit;False;Property;_SubSpell4_Position;SubSpell4_Position;29;0;Create;True;0;0;0;False;0;False;0,0;-7.41,-1.21;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;166;-2232.502,2490.392;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;215;-1557.184,4039.338;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;72;-2669.638,191.6216;Inherit;False;Property;_LifeBarScaleY;LifeBarScaleY;7;0;Create;True;0;0;0;False;0;False;1;6.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;340;-1330.736,2240.493;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2670.469,118.6214;Inherit;False;Property;_LifeBarScaleX;LifeBarScaleX;6;0;Create;True;0;0;0;False;0;False;1.13;3.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;306;-1666.111,8258.853;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;282;-1715.73,6690.181;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;294;-1685.194,7461.158;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;115;-2153.086,1313.508;Inherit;False;Property;_SpellScaleY;SpellScaleY;13;0;Create;True;0;0;0;False;0;False;1;3.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-2673.375,261.3132;Inherit;False;Property;_LifeBarOffsetX;LifeBarOffsetX;8;0;Create;True;0;0;0;False;0;False;0;-0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-2328.332,1616.411;Inherit;False;Property;_RB_SpellOffsetX;RB_SpellOffsetX;14;0;Create;True;0;0;0;False;0;False;0;-5.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-2328.332,1701.411;Inherit;False;Property;_RB_SpellOffsetY;RB_SpellOffsetY;15;0;Create;True;0;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;268;-1680.838,5801.555;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;252;-1651.515,4953.322;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;167;-2234.502,2594.392;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-2150.885,1233.659;Inherit;False;Property;_SpellScaleX;SpellScaleX;12;0;Create;True;0;0;0;False;0;False;1;6.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;-2019.806,2462.403;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-2674.629,331.9741;Inherit;False;Property;_LifeBarOffsetY;LifeBarOffsetY;9;0;Create;True;0;0;0;False;0;False;0;-4.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-2334.232,1449.69;Inherit;False;Property;_LB_SpellOffsetX;LB_SpellOffsetX;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;113;-1950.918,1296.599;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;254;-1334.074,5227.816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;295;-1362.753,7922.652;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;73;-2474.3,174.6723;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;308;-1348.67,8533.348;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;161;-5786.119,4433.005;Inherit;True;Property;_Spell_Selection;Spell_Selection;18;0;Create;True;0;0;0;False;0;False;None;4bff210abe0bc7f41b336f44a0976ddc;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.OneMinusNode;296;-1367.753,7735.652;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;307;-1343.67,8720.348;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;241;-1344.811,4381.235;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;242;-1339.811,4568.235;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;118;-1967.086,1613.508;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;270;-1363.397,6076.049;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;78;-2471.867,266.4999;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;283;-1393.288,7151.675;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;269;-1358.397,6263.049;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;284;-1398.288,6964.675;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;163;-1714.502,2513.392;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;183;-1190.415,2198.31;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;160;-2332.232,1530.69;Inherit;False;Property;_LB_SpellOffsetY;LB_SpellOffsetY;17;0;Create;True;0;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;253;-1329.074,5414.816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;255;-1088.649,5232.63;Inherit;False;Step Antialiasing;-1;;152;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;319;-2246.219,7617.638;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;329;-2404.445,6758.791;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2317.073,-323.7185;Inherit;False;Property;_Life;Life;2;0;Create;True;0;0;0;False;0;False;0.4999876;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;248;-1099.386,4386.049;Inherit;False;Step Antialiasing;-1;;150;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;250;-1115.176,4587.395;Inherit;False;Step Antialiasing;-1;;151;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;274;-1116.656,6195.352;Inherit;False;Step Antialiasing;-1;;153;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-1616.918,1546.599;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;287;-1168.654,7170.834;Inherit;False;Step Antialiasing;-1;;155;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;158;-1980.232,1458.69;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;299;-1138.119,7941.811;Inherit;False;Step Antialiasing;-1;;156;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;298;-1121.012,7854.955;Inherit;False;Step Antialiasing;-1;;157;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;70;-2251.146,150.7404;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;194;-1456.197,3038.164;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;249;-1098.069,4500.538;Inherit;False;Step Antialiasing;-1;;154;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;312;-1107.193,8438.148;Inherit;False;Step Antialiasing;-1;;149;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-2290.792,700.8393;Inherit;False;Property;_Stamina;Stamina;3;0;Create;True;0;0;0;False;0;False;0.4504158;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;272;-1133.763,6282.208;Inherit;False;Step Antialiasing;-1;;147;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;310;-1101.929,8652.651;Inherit;False;Step Antialiasing;-1;;134;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;297;-1122.329,7740.466;Inherit;False;Step Antialiasing;-1;;135;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;257;-1087.332,5347.119;Inherit;False;Step Antialiasing;-1;;136;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;288;-1156.811,6869.476;Inherit;False;Step Antialiasing;-1;;137;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;286;-1151.547,7083.978;Inherit;False;Step Antialiasing;-1;;138;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;185;-904.1674,2124.81;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;247;-1103.333,4286.036;Inherit;False;Step Antialiasing;-1;;139;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;311;-1119.036,8739.506;Inherit;False;Step Antialiasing;-1;;148;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;273;-1117.973,6080.863;Inherit;False;Step Antialiasing;-1;;141;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;285;-1152.864,6969.489;Inherit;False;Step Antialiasing;-1;;142;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;258;-1092.596,5132.617;Inherit;False;Step Antialiasing;-1;;143;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;256;-1104.439,5433.975;Inherit;False;Step Antialiasing;-1;;144;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;193;-1420.774,2867.118;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;271;-1121.92,5980.85;Inherit;False;Step Antialiasing;-1;;145;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;300;-1126.276,7640.453;Inherit;False;Step Antialiasing;-1;;146;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;309;-1103.246,8538.161;Inherit;False;Step Antialiasing;-1;;140;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;302;-1232.688,7436.65;Inherit;True;Property;_TextureSample5;Texture Sample 5;33;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;197;-1284.141,2976.423;Inherit;False;Step Antialiasing;-1;;161;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;260;-1199.009,4928.814;Inherit;True;Property;_TextureSample2;Texture Sample 2;27;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;-848.3965,6169.049;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;-883.2873,7057.675;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;314;-1213.605,8234.347;Inherit;True;Property;_TextureSample6;Texture Sample 6;34;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;259;-819.0729,5320.816;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;-852.753,7828.652;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;196;-1282.117,2884.321;Inherit;False;Step Antialiasing;-1;;162;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;213;-2836.868,2374.213;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;-829.8103,4474.235;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;313;-833.6695,8626.349;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;178;-1047.179,3151.597;Inherit;False;Constant;_Color1;Color 1;22;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;65;-1990.267,708.2913;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;0.63;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;290;-1263.223,6665.673;Inherit;True;Property;_TextureSample4;Texture Sample 4;32;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;18;-2016.54,-309.8254;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.06;False;4;FLOAT;0.83;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;184;-909.8784,2222.629;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.501;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;198;-1286.165,3063.461;Inherit;False;Step Antialiasing;-1;;158;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;195;-1281.105,2794.247;Inherit;False;Step Antialiasing;-1;;159;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;139;-945.0717,1684.164;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;275;-1228.332,5777.047;Inherit;True;Property;_TextureSample3;Texture Sample 3;29;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;82;-1716.806,-170.5175;Inherit;False;Step Antialiasing;-1;;160;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0.425;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;187;-689.6956,2119.449;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.501;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;177;-1034.209,2970.622;Inherit;False;Constant;_Color0;Color 0;22;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;214;-1209.746,4082.233;Inherit;True;Property;_TextureSample1;Texture Sample 1;25;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;106;-1624.775,1322.759;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;-544.0846,5301.403;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;69;-1820.699,311.059;Inherit;True;Property;_LifeBar;LifeBar;1;0;Create;True;0;0;0;False;0;False;-1;6d5591ed0712b514b815492dc9f86b7c;6d5591ed0712b514b815492dc9f86b7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;28;-1754.052,-300.684;Inherit;False;Step Antialiasing;-1;;168;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;162;-1412.502,2406.392;Inherit;True;Property;_TextureSample0;Texture Sample 0;19;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;155;-1879.5,42.24591;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-349.105,2117.972;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;277;-565.0984,6144.804;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;172;-1400.068,2596.171;Inherit;True;Property;_Spell_Selection_Mask;Spell_Selection_Mask;19;0;Create;True;0;0;0;False;0;False;-1;2a6878d0c446f584d94678d0f61a3eb2;2a6878d0c446f584d94678d0f61a3eb2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;67;-1752.708,683.427;Inherit;False;Step Antialiasing;-1;;167;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;137;-706.2865,1686.93;Inherit;False;Step Antialiasing;-1;;166;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;103;-812.2717,1310.709;Inherit;True;Property;_Spell_LB;Spell_LB;10;0;Create;True;0;0;0;False;0;False;-1;9550229004d2a5649a26bb8a904e1022;9550229004d2a5649a26bb8a904e1022;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;132;-708.2679,1125.036;Inherit;False;Step Antialiasing;-1;;165;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;176;-773.6675,2929.524;Inherit;False;Property;_SpellAvailable;SpellAvailable;22;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;315;-550.3713,8602.104;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-599.9892,7033.43;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;-569.4548,7804.407;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;245;-523.8611,4447.082;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;81;-1369.204,15.92066;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;104;-812.1393,1500.792;Inherit;True;Property;_Spell_RB;Spell_RB;11;0;Create;True;0;0;0;False;0;False;-1;d540565bd16c8d14e82bd637a9a40e6d;d540565bd16c8d14e82bd637a9a40e6d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-1020.341,2794.221;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;154;-1860.489,33.15498;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;138;-707.7655,1777.14;Inherit;False;Step Antialiasing;-1;;164;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;133;-709.2679,1216.037;Inherit;False;Step Antialiasing;-1;;163;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;149;-1718.776,-56.26912;Inherit;False;Step Antialiasing;-1;;170;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-416.7706,2478.95;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-94.6525,1755.782;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-1189.134,-7.662359;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-1188.406,-201.0493;Inherit;False;Property;_LifeColor;LifeColor;4;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;150;-1719.776,31.7309;Inherit;False;Step Antialiasing;-1;;169;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;94;-1162.95,618.0517;Inherit;False;Property;_StaminaColor;StaminaColor;5;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;58.83928,2588.92;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;191;-101.286,2205.77;Inherit;False;Property;_DebugMiddle;DebugMiddle;32;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1211.293,390.9447;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;264;2535,5644.769;Inherit;False;6;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-93.03946,1639.507;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;-371.5656,6751.611;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;244;-285.193,4218.482;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;-341.0312,7522.588;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;175;-28.09585,2428.976;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;316;-321.9477,8320.283;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;-361.5319,5053.453;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;74.0536,1638.231;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-899.1157,-20.58922;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;-336.6747,5862.985;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-94.70255,1127.511;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;156;-1455.139,125.5174;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;157;-1437.723,113.2679;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-96.32632,1246.018;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-871.7361,598.0823;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;322;2700.121,5617.938;Inherit;False;Property;_EnableSubSpells;EnableSubSpells;24;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;189;333.1068,2562.859;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;68;-1822.319,121.5675;Inherit;True;Property;_Empty_LifeBar;Empty_LifeBar;0;0;Create;True;0;0;0;False;0;False;-1;e553f9ae2353fb84ba10b20fe0b9b322;e553f9ae2353fb84ba10b20fe0b9b322;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-312.4214,79.67807;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-437.1633,-19.99518;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;295.33,2423.608;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;205;4107.323,4108.579;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-447.0844,364.476;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;263;2547.506,5256.739;Inherit;False;6;6;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;110.2679,1127.749;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;148;165.8562,414.5701;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;343;3691.979,4027.153;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;439.6016,1151.327;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;190;440.8795,2337.893;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;203;4294.412,4076.3;Inherit;False;Property;_EnableSpell;EnableSpell;23;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;99;64.89133,78.54007;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;120;4858.601,3745.124;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;4862.492,4057.814;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;6;5179.68,3693.681;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;UI;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;233;0;235;0
WireConnection;233;1;223;0
WireConnection;265;0;233;0
WireConnection;236;0;233;0
WireConnection;166;0;165;1
WireConnection;166;1;165;2
WireConnection;215;0;236;0
WireConnection;215;1;224;0
WireConnection;340;0;339;0
WireConnection;340;1;338;0
WireConnection;306;0;233;0
WireConnection;306;1;305;0
WireConnection;282;0;233;0
WireConnection;282;1;281;0
WireConnection;294;0;233;0
WireConnection;294;1;293;0
WireConnection;268;0;233;0
WireConnection;268;1;267;0
WireConnection;252;0;265;0
WireConnection;252;1;251;0
WireConnection;167;0;165;3
WireConnection;167;1;165;4
WireConnection;181;0;182;0
WireConnection;181;1;166;0
WireConnection;113;0;108;0
WireConnection;113;1;115;0
WireConnection;254;0;252;1
WireConnection;295;0;294;2
WireConnection;73;0;71;0
WireConnection;73;1;72;0
WireConnection;308;0;306;1
WireConnection;296;0;294;1
WireConnection;307;0;306;2
WireConnection;241;0;215;1
WireConnection;242;0;215;2
WireConnection;118;0;130;0
WireConnection;118;1;131;0
WireConnection;270;0;268;1
WireConnection;78;0;76;0
WireConnection;78;1;77;0
WireConnection;283;0;282;2
WireConnection;269;0;268;2
WireConnection;284;0;282;1
WireConnection;163;0;181;0
WireConnection;163;1;167;0
WireConnection;183;1;340;0
WireConnection;253;0;252;2
WireConnection;255;1;254;0
WireConnection;319;0;161;0
WireConnection;329;0;161;0
WireConnection;248;1;241;0
WireConnection;250;1;242;0
WireConnection;274;1;268;2
WireConnection;112;0;113;0
WireConnection;112;1;118;0
WireConnection;287;1;283;0
WireConnection;158;0;159;0
WireConnection;158;1;160;0
WireConnection;299;1;295;0
WireConnection;298;1;294;2
WireConnection;70;0;73;0
WireConnection;70;1;78;0
WireConnection;194;0;163;2
WireConnection;249;1;215;2
WireConnection;312;1;306;1
WireConnection;272;1;269;0
WireConnection;310;1;306;2
WireConnection;297;1;296;0
WireConnection;257;1;252;2
WireConnection;288;1;282;1
WireConnection;286;1;282;2
WireConnection;185;0;183;1
WireConnection;247;1;215;1
WireConnection;311;1;307;0
WireConnection;273;1;270;0
WireConnection;285;1;284;0
WireConnection;258;1;252;1
WireConnection;256;1;253;0
WireConnection;193;0;163;1
WireConnection;271;1;268;1
WireConnection;300;1;294;1
WireConnection;309;1;308;0
WireConnection;302;0;329;0
WireConnection;302;1;294;0
WireConnection;197;1;163;2
WireConnection;260;0;161;0
WireConnection;260;1;252;0
WireConnection;276;0;271;0
WireConnection;276;1;273;0
WireConnection;276;2;274;0
WireConnection;276;3;272;0
WireConnection;289;0;288;0
WireConnection;289;1;285;0
WireConnection;289;2;286;0
WireConnection;289;3;287;0
WireConnection;314;0;319;0
WireConnection;314;1;306;0
WireConnection;259;0;258;0
WireConnection;259;1;255;0
WireConnection;259;2;257;0
WireConnection;259;3;256;0
WireConnection;301;0;300;0
WireConnection;301;1;297;0
WireConnection;301;2;298;0
WireConnection;301;3;299;0
WireConnection;196;1;193;0
WireConnection;213;0;161;0
WireConnection;243;0;247;0
WireConnection;243;1;248;0
WireConnection;243;2;249;0
WireConnection;243;3;250;0
WireConnection;313;0;312;0
WireConnection;313;1;309;0
WireConnection;313;2;310;0
WireConnection;313;3;311;0
WireConnection;65;0;64;0
WireConnection;290;0;161;0
WireConnection;290;1;282;0
WireConnection;18;0;22;0
WireConnection;184;0;183;1
WireConnection;198;1;194;0
WireConnection;195;1;163;1
WireConnection;139;0;112;1
WireConnection;275;0;161;0
WireConnection;275;1;268;0
WireConnection;82;1;70;2
WireConnection;187;0;185;0
WireConnection;214;0;161;0
WireConnection;214;1;215;0
WireConnection;106;0;113;0
WireConnection;106;1;158;0
WireConnection;262;0;260;4
WireConnection;262;1;259;0
WireConnection;69;1;70;0
WireConnection;28;1;70;1
WireConnection;28;2;18;0
WireConnection;162;0;213;0
WireConnection;162;1;163;0
WireConnection;155;0;70;1
WireConnection;188;0;187;0
WireConnection;188;1;184;0
WireConnection;277;0;275;4
WireConnection;277;1;276;0
WireConnection;172;1;163;0
WireConnection;67;1;70;1
WireConnection;67;2;65;0
WireConnection;137;1;139;0
WireConnection;103;1;106;0
WireConnection;132;1;106;1
WireConnection;176;1;177;0
WireConnection;176;0;178;0
WireConnection;315;0;314;4
WireConnection;315;1;313;0
WireConnection;291;0;290;4
WireConnection;291;1;289;0
WireConnection;303;0;302;4
WireConnection;303;1;301;0
WireConnection;245;0;214;4
WireConnection;245;1;243;0
WireConnection;81;0;82;0
WireConnection;104;1;112;0
WireConnection;199;0;195;0
WireConnection;199;1;196;0
WireConnection;199;2;197;0
WireConnection;199;3;198;0
WireConnection;154;0;70;2
WireConnection;138;1;112;2
WireConnection;133;1;106;2
WireConnection;149;1;155;0
WireConnection;179;0;172;4
WireConnection;179;1;176;0
WireConnection;136;0;137;0
WireConnection;136;1;138;0
WireConnection;136;2;104;4
WireConnection;83;0;28;0
WireConnection;83;1;81;0
WireConnection;83;2;69;4
WireConnection;150;1;154;0
WireConnection;200;0;162;4
WireConnection;200;1;199;0
WireConnection;191;0;188;0
WireConnection;85;0;82;0
WireConnection;85;1;69;4
WireConnection;85;2;67;0
WireConnection;264;0;245;0
WireConnection;264;1;262;0
WireConnection;264;2;277;0
WireConnection;264;3;291;0
WireConnection;264;4;303;0
WireConnection;264;5;315;0
WireConnection;134;0;132;0
WireConnection;134;1;133;0
WireConnection;134;2;103;4
WireConnection;292;0;290;0
WireConnection;292;1;289;0
WireConnection;292;2;291;0
WireConnection;244;0;214;0
WireConnection;244;1;243;0
WireConnection;244;2;245;0
WireConnection;304;0;302;0
WireConnection;304;1;301;0
WireConnection;304;2;303;0
WireConnection;175;0;162;0
WireConnection;175;1;179;0
WireConnection;175;2;172;4
WireConnection;316;0;314;0
WireConnection;316;1;313;0
WireConnection;316;2;315;0
WireConnection;261;0;260;0
WireConnection;261;1;259;0
WireConnection;261;2;262;0
WireConnection;123;0;134;0
WireConnection;123;1;136;0
WireConnection;100;0;20;0
WireConnection;100;1;83;0
WireConnection;278;0;275;0
WireConnection;278;1;276;0
WireConnection;278;2;277;0
WireConnection;143;0;132;0
WireConnection;143;1;133;0
WireConnection;143;2;103;0
WireConnection;156;0;149;0
WireConnection;157;0;150;0
WireConnection;144;0;104;0
WireConnection;144;1;137;0
WireConnection;144;2;138;0
WireConnection;101;0;85;0
WireConnection;101;1;94;0
WireConnection;322;0;264;0
WireConnection;189;0;191;0
WireConnection;189;1;200;0
WireConnection;68;1;70;0
WireConnection;153;0;156;0
WireConnection;153;1;157;0
WireConnection;153;2;68;0
WireConnection;102;0;100;0
WireConnection;102;1;101;0
WireConnection;201;0;175;0
WireConnection;201;1;199;0
WireConnection;205;0;123;0
WireConnection;205;1;189;0
WireConnection;205;2;322;0
WireConnection;98;0;83;0
WireConnection;98;1;85;0
WireConnection;263;0;244;0
WireConnection;263;1;261;0
WireConnection;263;2;278;0
WireConnection;263;3;292;0
WireConnection;263;4;304;0
WireConnection;263;5;316;0
WireConnection;125;0;143;0
WireConnection;125;1;144;0
WireConnection;148;0;68;4
WireConnection;343;0;263;0
WireConnection;266;0;125;0
WireConnection;266;1;123;0
WireConnection;190;0;191;0
WireConnection;190;1;201;0
WireConnection;203;0;205;0
WireConnection;99;0;153;0
WireConnection;99;1;102;0
WireConnection;99;2;98;0
WireConnection;120;0;99;0
WireConnection;120;1;266;0
WireConnection;120;2;190;0
WireConnection;120;3;343;0
WireConnection;121;0;148;0
WireConnection;121;1;203;0
WireConnection;6;2;120;0
WireConnection;6;9;121;0
ASEEND*/
//CHKSM=078645DE3899EF9F0BEAD3A67B064844EEC47D53