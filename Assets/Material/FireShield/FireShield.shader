// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FireShield2"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Texture("Texture", 2D) = "white" {}
		[HDR]_Color("Color", Color) = (1,0.5235949,0,0)
		[HDR]_Color2("Color2", Color) = (1,0,0,0)
		[HDR]_Color3("Color3", Color) = (0,0,0,0)
		_StepColor("StepColor", Float) = 0.8
		_StepColor2("StepColor2", Float) = 0.7
		_SpeedColor("SpeedColor", Float) = 1
		_SpeedColor2("SpeedColor2", Float) = 3
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_OpacitySpeed("OpacitySpeed", Float) = 2
		_DepthFade("DepthFade", Float) = 0
		_Disto("Disto", Float) = 0
		_DistoNoiseScale("DistoNoiseScale", Float) = 6.75
		_DistortionSpeed("DistortionSpeed", Float) = 1
		_DepthFadeColor("DepthFadeColor", Color) = (0.04060721,1,0,0)
		[Toggle]_DepthFadeOpacity("DepthFadeOpacity", Float) = 1
		_Dissolve("Dissolve", Range( 0 , 1)) = 0.73
		_CameraDepthFade_FallOff("CameraDepthFade_FallOff", Float) = 0
		_CameraDepthFade_Distance("CameraDepthFade_Distance", Float) = 10
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPosition21;
			float eyeDepth;
		};

		uniform float _DistoNoiseScale;
		uniform float _DistortionSpeed;
		uniform float _Disto;
		uniform float4 _Color;
		uniform float4 _Color2;
		uniform float _StepColor;
		uniform sampler2D _Texture;
		uniform float _SpeedColor;
		uniform float4 _Color3;
		uniform float _StepColor2;
		uniform float _SpeedColor2;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFade;
		uniform float4 _DepthFadeColor;
		uniform float _DepthFadeOpacity;
		uniform float _Opacity;
		uniform float _OpacitySpeed;
		uniform float _Dissolve;
		uniform float _CameraDepthFade_FallOff;
		uniform float _CameraDepthFade_Distance;
		uniform float _Cutoff = 0.5;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float2 temp_cast_0 = (_DistoNoiseScale).xx;
			float mulTime25 = _Time.y * _DistortionSpeed;
			float2 uv_TexCoord28 = v.texcoord.xy * temp_cast_0 + ( float2( 0,1 ) * mulTime25 );
			float simplePerlin2D29 = snoise( uv_TexCoord28 );
			simplePerlin2D29 = simplePerlin2D29*0.5 + 0.5;
			v.vertex.xyz += ( ase_vertexNormal * simplePerlin2D29 * _Disto );
			v.vertex.w = 1;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos21 = ase_vertex3Pos;
			float4 ase_screenPos21 = ComputeScreenPos( UnityObjectToClipPos( vertexPos21 ) );
			o.screenPosition21 = ase_screenPos21;
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float cos10 = cos( ( _SpeedColor * _Time.y ) );
			float sin10 = sin( ( _SpeedColor * _Time.y ) );
			float2 rotator10 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos10 , -sin10 , sin10 , cos10 )) + float2( 0.5,0.5 );
			float temp_output_3_0_g3 = ( _StepColor - (0.0 + (tex2D( _Texture, rotator10 ).a - 0.0) * (0.93 - 0.0) / (1.0 - 0.0)) );
			float temp_output_8_0 = saturate( ( temp_output_3_0_g3 / fwidth( temp_output_3_0_g3 ) ) );
			float4 lerpResult7 = lerp( _Color , _Color2 , temp_output_8_0);
			float cos77 = cos( ( _SpeedColor2 * _Time.y ) );
			float sin77 = sin( ( _SpeedColor2 * _Time.y ) );
			float2 rotator77 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos77 , -sin77 , sin77 , cos77 )) + float2( 0.5,0.5 );
			float temp_output_3_0_g4 = ( _StepColor2 - (0.0 + (tex2D( _Texture, rotator77 ).a - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) );
			float4 lerpResult63 = lerp( lerpResult7 , _Color3 , ( temp_output_8_0 * saturate( ( temp_output_3_0_g4 / fwidth( temp_output_3_0_g4 ) ) ) ));
			float4 ase_screenPos21 = i.screenPosition21;
			float4 ase_screenPosNorm21 = ase_screenPos21 / ase_screenPos21.w;
			ase_screenPosNorm21.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm21.z : ase_screenPosNorm21.z * 0.5 + 0.5;
			float screenDepth21 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm21.xy ));
			float distanceDepth21 = abs( ( screenDepth21 - LinearEyeDepth( ase_screenPosNorm21.z ) ) / ( _DepthFade ) );
			float clampResult18 = clamp( distanceDepth21 , 0.0 , 1.0 );
			o.Emission = ( ( lerpResult63 * clampResult18 ) + ( ( 1.0 - clampResult18 ) * _DepthFadeColor ) ).rgb;
			o.Alpha = 1;
			float cos53 = cos( ( _OpacitySpeed * _Time.y ) );
			float sin53 = sin( ( _OpacitySpeed * _Time.y ) );
			float2 rotator53 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos53 , -sin53 , sin53 , cos53 )) + float2( 0.5,0.5 );
			float temp_output_55_0 = (0.0 + (tex2D( _Texture, rotator53 ).a - 0.0) * (0.93 - 0.0) / (1.0 - 0.0));
			float temp_output_3_0_g5 = ( _Dissolve - temp_output_55_0 );
			float cameraDepthFade99 = (( i.eyeDepth -_ProjectionParams.y - _CameraDepthFade_Distance ) / _CameraDepthFade_FallOff);
			float clampResult94 = clamp( ( (( _DepthFadeOpacity )?( clampResult18 ):( 1.0 )) * _Opacity * (0.0 + (temp_output_55_0 - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) * saturate( ( temp_output_3_0_g5 / fwidth( temp_output_3_0_g5 ) ) ) * cameraDepthFade99 ) , 0.0 , 1.0 );
			clip( clampResult94 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;81;-2753.938,-889.8478;Inherit;False;3561.77;1193.588;;30;40;41;44;63;22;7;62;64;5;6;60;8;15;61;58;9;1;78;77;10;79;76;75;12;3;73;13;11;74;86;Emissive;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;73;-2676.45,192.7404;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2470.14,-340.9024;Inherit;False;Property;_SpeedColor;SpeedColor;7;0;Create;True;0;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-2480.882,-260.925;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-2675.121,107.7394;Inherit;False;Property;_SpeedColor2;SpeedColor2;8;0;Create;True;0;0;0;False;0;False;3;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-2362.7,-478.743;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-2452.623,112.6011;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-2268.207,-336.4783;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;65;-3128.841,-559.0149;Inherit;True;Property;_Texture;Texture;1;0;Create;True;0;0;0;False;0;False;13615781fccb69d439454c6e912d1376;13615781fccb69d439454c6e912d1376;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-2495.836,-26.78173;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;83;-2348.787,930.2614;Inherit;False;2053.342;628.951;;15;101;100;99;2;92;91;20;46;55;54;53;52;51;49;50;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.RotatorNode;10;-2089.635,-479.2167;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;77;-2222.007,-26.06362;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;79;-2519.87,-183.3885;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;82;-1916.433,415.7788;Inherit;False;953.8529;471.028;;4;17;21;18;16;DepthFade;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;1;-1850.752,-553.3652;Inherit;True;Property;_TextureFireShield;TextureFireShield;0;0;Create;True;0;0;0;False;0;False;-1;13615781fccb69d439454c6e912d1376;13615781fccb69d439454c6e912d1376;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;78;-1967.956,-93.9469;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;13615781fccb69d439454c6e912d1376;13615781fccb69d439454c6e912d1376;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;50;-2298.787,1195.787;Inherit;False;Property;_OpacitySpeed;OpacitySpeed;10;0;Create;True;0;0;0;False;0;False;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;49;-2289.814,1274.841;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;84;-1380.628,1616.692;Inherit;False;1718.979;550.9806;;10;23;25;24;26;27;28;32;29;31;30;Distortion;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1155.713,-20.27498;Inherit;False;Property;_StepColor2;StepColor2;6;0;Create;True;0;0;0;False;0;False;0.7;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;58;-1461.851,-88.75449;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1426.292,-232.1583;Inherit;False;Property;_StepColor;StepColor;5;0;Create;True;0;0;0;False;0;False;0.8;0.81;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;15;-1505.768,-452.9061;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.93;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1330.628,2035.118;Inherit;False;Property;_DistortionSpeed;DistortionSpeed;14;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-2107.763,1070.355;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-2046.116,1198.786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;16;-1866.433,619.2073;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;8;-1169.939,-450.1147;Inherit;True;Step Antialiasing;-1;;3;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;60;-962.383,-121.0838;Inherit;True;Step Antialiasing;-1;;4;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;24;-1053.151,1913.164;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DepthFade;21;-1586.965,618.4969;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;53;-1779.006,1072.602;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;25;-1076.945,2041.773;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;80;-2605.458,812.4632;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-848.1003,1839.434;Inherit;False;Property;_DistoNoiseScale;DistoNoiseScale;13;0;Create;True;0;0;0;False;0;False;6.75;6.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-1481.023,986.562;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;13615781fccb69d439454c6e912d1376;13615781fccb69d439454c6e912d1376;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;7;-372.0468,-555.4581;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-816.6777,1919.127;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;18;-1216.578,465.7788;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-658.9035,-139.1728;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;63;56.21131,-256.1639;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;22;212.2943,-56.92947;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-580.4396,1823.493;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;55;-1106.482,1088.915;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.93;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;29;-272.5844,1820.578;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-204.025,2051.673;Inherit;False;Property;_Disto;Disto;12;0;Create;True;0;0;0;False;0;False;0;1.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;31;-234.4877,1666.875;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;46;-734.4279,1082.248;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;410.5681,-255.4724;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-445.4158,980.2614;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;655.8312,-76.2672;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;176.3517,1666.692;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;426.9483,-54.84489;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;86;171.6103,56.70965;Inherit;False;Property;_DepthFadeColor;DepthFadeColor;15;0;Create;True;0;0;0;False;0;False;0.04060721,1,0,0;0,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-1854.153,770.8069;Inherit;False;Property;_DepthFade;DepthFade;11;0;Create;True;0;0;0;False;0;False;0;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;87;-728.8303,625.1729;Inherit;False;Property;_DepthFadeOpacity;DepthFadeOpacity;16;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;91;-766.9994,1283.486;Inherit;False;Step Antialiasing;-1;;5;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-1119.408,1306.199;Inherit;False;Property;_Dissolve;Dissolve;17;0;Create;True;0;0;0;False;0;False;0.73;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-756.8391,-839.8478;Inherit;False;Property;_Color;Color;2;1;[HDR];Create;True;0;0;0;False;0;False;1,0.5235949,0,0;2.996078,0.445736,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-755.4951,-656.6379;Inherit;False;Property;_Color2;Color2;3;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;5.992157,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;64;-355.3116,-322.7242;Inherit;False;Property;_Color3;Color3;4;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;5.992157,5.992157,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-755.8521,1002.142;Inherit;False;Property;_Opacity;Opacity;9;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;94;-4.098877,980.4158;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1347.773,483.4068;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;FireShield2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Overlay;;Overlay;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CameraDepthFade;99;-806.4601,1380.98;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-1084.198,1403.814;Inherit;False;Property;_CameraDepthFade_FallOff;CameraDepthFade_FallOff;18;0;Create;True;0;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-1114.198,1474.814;Inherit;False;Property;_CameraDepthFade_Distance;CameraDepthFade_Distance;19;0;Create;True;0;0;0;False;0;False;10;1;0;0;0;1;FLOAT;0
WireConnection;75;0;74;0
WireConnection;75;1;73;0
WireConnection;12;0;13;0
WireConnection;12;1;11;0
WireConnection;10;0;3;0
WireConnection;10;2;12;0
WireConnection;77;0;76;0
WireConnection;77;2;75;0
WireConnection;79;0;65;0
WireConnection;1;0;65;0
WireConnection;1;1;10;0
WireConnection;78;0;79;0
WireConnection;78;1;77;0
WireConnection;58;0;78;4
WireConnection;15;0;1;4
WireConnection;52;0;50;0
WireConnection;52;1;49;0
WireConnection;8;1;15;0
WireConnection;8;2;9;0
WireConnection;60;1;58;0
WireConnection;60;2;61;0
WireConnection;21;1;16;0
WireConnection;21;0;17;0
WireConnection;53;0;51;0
WireConnection;53;2;52;0
WireConnection;25;0;23;0
WireConnection;80;0;65;0
WireConnection;54;0;80;0
WireConnection;54;1;53;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;7;2;8;0
WireConnection;26;0;24;0
WireConnection;26;1;25;0
WireConnection;18;0;21;0
WireConnection;62;0;8;0
WireConnection;62;1;60;0
WireConnection;63;0;7;0
WireConnection;63;1;64;0
WireConnection;63;2;62;0
WireConnection;22;0;18;0
WireConnection;28;0;27;0
WireConnection;28;1;26;0
WireConnection;55;0;54;4
WireConnection;29;0;28;0
WireConnection;46;0;55;0
WireConnection;41;0;63;0
WireConnection;41;1;18;0
WireConnection;20;0;87;0
WireConnection;20;1;2;0
WireConnection;20;2;46;0
WireConnection;20;3;91;0
WireConnection;20;4;99;0
WireConnection;40;0;41;0
WireConnection;40;1;44;0
WireConnection;30;0;31;0
WireConnection;30;1;29;0
WireConnection;30;2;32;0
WireConnection;44;0;22;0
WireConnection;44;1;86;0
WireConnection;87;1;18;0
WireConnection;91;1;55;0
WireConnection;91;2;92;0
WireConnection;94;0;20;0
WireConnection;0;2;40;0
WireConnection;0;10;94;0
WireConnection;0;11;30;0
WireConnection;99;0;100;0
WireConnection;99;1;101;0
ASEEND*/
//CHKSM=F33EE705D11CED63100DBCEA36508EA1E11F4462