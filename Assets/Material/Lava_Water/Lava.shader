// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lava"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 15
		_TessMin( "Tess Min Distance", Float ) = 5
		_TessMax( "Tess Max Distance", Float ) = 30
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_SpherePosition("Sphere Position", Vector) = (0,0,0,0)
		_CircleSize("CircleSize", Float) = 4
		[HDR]_Color5("Color 5", Color) = (4,0.345098,0,0)
		_Noise_Scale("Noise_Scale", Float) = 0
		_Vector2("Vector 2", Vector) = (0,0,0,0)
		_ScaleNoiseTexture("ScaleNoiseTexture", Float) = 0
		_Remap("Remap", Float) = 0
		_Offset_Intensity("Offset_Intensity", Float) = 0
		_Remap2("Remap2", Float) = 0
		_TimeSpeed("TimeSpeed", Float) = 0
		[HDR]_Color6("Color 6", Color) = (0,0,0,0)
		_ScaleOrangeNoise("ScaleOrangeNoise", Float) = 0
		_Offset_Intensity2("Offset_Intensity2", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _Noise_Scale;
		uniform float2 _Vector2;
		uniform float _Offset_Intensity;
		uniform float _TimeSpeed;
		uniform float _Offset_Intensity2;
		uniform float _ScaleNoiseTexture;
		uniform float _Remap;
		uniform float _ScaleOrangeNoise;
		uniform float4 _Color5;
		uniform float4 _Color6;
		uniform float _Remap2;
		uniform float3 _SpherePosition;
		uniform float4 positionsArray[3];
		uniform float _CircleSize;
		uniform float _Cutoff = 0.5;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;


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


		float DistanceCheck99( float3 WorldPos, float3 objectPosition )
		{
			float closest=10000;
			float now=0;
			for(int i=0; i<positionsArray.Length;i++){
				now = distance(WorldPos,positionsArray[i]);
				if(now < closest){
				closest = now;
				}
			}
			return closest;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult167 = (float2(ase_worldPos.x , ase_worldPos.z));
			float simplePerlin2D177 = snoise( appendResult167*_Noise_Scale );
			simplePerlin2D177 = simplePerlin2D177*0.5 + 0.5;
			float temp_output_187_0 = (_Vector2.x + (simplePerlin2D177 - 0.0) * (_Vector2.y - _Vector2.x) / (1.0 - 0.0));
			float3 ase_vertexNormal = v.normal.xyz;
			float mulTime224 = _Time.y * _TimeSpeed;
			float2 temp_output_223_0 = ( appendResult167 + mulTime224 );
			float simplePerlin2D225 = snoise( temp_output_223_0 );
			simplePerlin2D225 = simplePerlin2D225*0.5 + 0.5;
			float3 temp_output_228_0 = ( ( ( 1.0 - temp_output_187_0 ) * _Offset_Intensity * ase_vertexNormal ) + ( simplePerlin2D225 * _Offset_Intensity2 * ase_vertexNormal ) );
			v.vertex.xyz += temp_output_228_0;
			v.vertex.w = 1;
			v.normal = temp_output_228_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult167 = (float2(ase_worldPos.x , ase_worldPos.z));
			float simplePerlin2D195 = snoise( appendResult167*_ScaleNoiseTexture );
			simplePerlin2D195 = simplePerlin2D195*0.5 + 0.5;
			float4 temp_cast_0 = ((0.0 + (simplePerlin2D195 - 0.0) * (_Remap - 0.0) / (1.0 - 0.0))).xxxx;
			float mulTime224 = _Time.y * _TimeSpeed;
			float2 temp_output_223_0 = ( appendResult167 + mulTime224 );
			float simplePerlin2D217 = snoise( temp_output_223_0*_ScaleOrangeNoise );
			simplePerlin2D217 = simplePerlin2D217*0.5 + 0.5;
			float simplePerlin2D177 = snoise( appendResult167*_Noise_Scale );
			simplePerlin2D177 = simplePerlin2D177*0.5 + 0.5;
			float temp_output_187_0 = (_Vector2.x + (simplePerlin2D177 - 0.0) * (_Vector2.y - _Vector2.x) / (1.0 - 0.0));
			float clampResult190 = clamp( temp_output_187_0 , 0.0 , 1.0 );
			float4 lerpResult183 = lerp( temp_cast_0 , ( simplePerlin2D217 * _Color5 ) , clampResult190);
			float clampResult212 = clamp( (_Remap2 + (clampResult190 - 0.0) * (1.0 - _Remap2) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float4 lerpResult210 = lerp( lerpResult183 , ( simplePerlin2D217 * _Color6 ) , clampResult212);
			o.Emission = lerpResult210.rgb;
			o.Alpha = 1;
			float3 break92 = ase_worldPos;
			float4 appendResult97 = (float4(( break92.x - _SpherePosition.x ) , ( break92.y - _SpherePosition.y ) , ( break92.z - _SpherePosition.z ) , 0.0));
			float3 WorldPos99 = appendResult97.xyz;
			float3 objectPosition99 = positionsArray[clamp(0,0,(3 - 1))].xyz;
			float localDistanceCheck99 = DistanceCheck99( WorldPos99 , objectPosition99 );
			float clampResult101 = clamp( ( localDistanceCheck99 / _CircleSize ) , 0.0 , 1.0 );
			clip( clampResult101 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;234;3358,-818;Inherit;False;2423;963;Emissive;20;210;183;212;213;184;198;195;197;217;216;211;208;190;209;218;196;187;189;177;185;Emissive;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;233;4661.236,686;Inherit;False;1260.764;483;Vertex Offset;9;205;199;201;227;231;225;226;200;228;Vertex Offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;89;2070.086,1330.765;Inherit;False;1927.85;470.0797;substractLava;12;101;100;99;98;97;96;95;94;93;92;91;90;substractLava;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;83;1128.672,-181.9883;Inherit;False;Property;_DeapthFade;DeapthFade;28;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;82;1357.672,-170.9883;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;307.5886,976.8096;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;85;1094.672,-338.9883;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;90;2120.086,1383.873;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;92;2352.111,1383.837;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleSubtractOpNode;93;2725.709,1380.765;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;95;2708.35,1530.019;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;94;2710.169,1637.879;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;97;3096.582,1501.612;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;98;3330.606,1606.844;Float;False;Property;_CircleSize;CircleSize;7;0;Create;True;0;0;0;False;0;False;4;6.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;100;3652.374,1503.846;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;101;3826.935,1501.056;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;96;3045.375,1660.846;Inherit;False;positionsArray;0;3;2;True;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;99;3335.375,1502.846;Float;False;float closest=10000@$float now=0@$for(int i=0@ i<positionsArray.Length@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;Create;2;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;DistanceCheck;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;91;2302.791,1579.251;Inherit;False;Property;_SpherePosition;Sphere Position;6;0;Create;True;0;0;0;False;0;False;0,0,0;0,1E+13,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;110;680.3025,-1102.558;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;111;885.533,-1079.537;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-3995.775,-115.4346;Inherit;False;Property;_Tiling;Tiling;10;0;Create;True;0;0;0;False;0;False;1;4.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;1;-2194.643,245.5152;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;17;-2259.946,556.5942;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1788.633,325.5395;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-3499.835,225.4973;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-3565.1,679.1956;Inherit;False;Property;_Disto;Disto;11;0;Create;True;0;0;0;False;0;False;0;0.761;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-3468.232,761.4728;Inherit;False;Property;_SpeedDisto;SpeedDisto;12;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-3584.304,487.708;Inherit;True;Property;_FlowMap;FlowMap;9;0;Create;True;0;0;0;False;0;False;-1;e5fc194be4ef2994a936322b74927473;e5fc194be4ef2994a936322b74927473;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;30;-3107.13,470.4836;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;26;-3088.532,606.1944;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-2873.692,470.6956;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-1530.488,15.40344;Inherit;False;Property;_Step0;Step0;13;0;Create;True;0;0;0;False;0;False;0;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1442.686,349.0594;Inherit;False;Property;_Step1;Step1;15;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;67;-1275.679,-42.30443;Inherit;False;Step Antialiasing;-1;;26;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;42;-1274.533,266.8735;Inherit;False;Step Antialiasing;-1;;27;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1523.788,567.5851;Inherit;False;Property;_Step2;Step2;17;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;70;-1004.469,-84.88849;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1520.286,647.8993;Inherit;False;Property;_Step3;Step3;19;0;Create;True;0;0;0;False;0;False;0;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;-825.5718,226.5073;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;48;-1264.994,474.7452;Inherit;False;Step Antialiasing;-1;;28;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;57;-469.3532,452.3481;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;49;-1252.755,621.7141;Inherit;False;Step Antialiasing;-1;;29;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;58;-132.0311,769.0897;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;60;-852.9786,349.5027;Inherit;False;Property;_Color2;Color 2;24;0;Create;True;0;0;0;False;0;False;0,0,1,0;1,0.1709029,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;61;-512.5867,593.0876;Inherit;False;Property;_Color3;Color 3;25;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;69;-1493.981,-234.2767;Inherit;False;Property;_Color05;Color 0.5;22;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;4.867144,1.04478,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;59;-1284.542,61.16684;Inherit;False;Property;_Color1;Color 1;23;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;1,0.2778975,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;55;-1499.226,-418.0536;Inherit;False;Property;_Color0;Color 0;21;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;1.844303,1.264941,0.6083302,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-1539.204,-1733.116;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;106;-1893.246,-1608.606;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;138;-214.4805,-1196.674;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;140;-35.58334,-885.2773;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;142;320.6352,-659.4366;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;144;657.9575,-342.6949;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-740.4995,-1096.382;Inherit;False;Property;_Step0bis;Step0bis;14;0;Create;True;0;0;0;False;0;False;0;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-652.6974,-762.7254;Inherit;False;Property;_Step1bis;Step1bis;16;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-733.7994,-544.1996;Inherit;False;Property;_Step2bis;Step2bis;18;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-730.2975,-463.8854;Inherit;False;Property;_Step3bis;Step3bis;20;0;Create;True;0;0;0;False;0;False;0;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;150;-469.5325,-1180.317;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;151;-381.5325,-831.5167;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;152;-367.1324,-636.3168;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;153;-402.3325,-474.7168;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;104;-1857.516,-1736.364;Inherit;False;Constant;_Vector1;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.VoronoiNode;107;-1074.525,-1667.245;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;7.52;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;103;-1347.517,-1666.317;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3.36,0.19;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;157;-1457.686,-1415.51;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-2062.146,-1608.606;Inherit;False;Property;_LavafallSpeed;LavafallSpeed;8;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-1632.686,-1485.51;Inherit;False;Property;_LavafallTilingX;LavafallTilingX;31;0;Create;True;0;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-1633.686,-1405.51;Inherit;False;Property;_LavafallTilingY;LavafallTilingY;32;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;109;950.0657,542.2985;Inherit;False;Property;_Lavafall;Lavafall;29;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;158;740.1299,917.9675;Inherit;False;Property;_Lavafall2;Lavafall2;30;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;424.6514,478.7385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-33.21582,1086.189;Inherit;False;Property;_OffsetStrength;OffsetStrength;26;0;Create;True;0;0;0;False;0;False;0;0.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;164;457.449,378.6434;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;160.5732,511.0333;Inherit;False;Property;_OffsetStrengthbis;OffsetStrengthbis;27;0;Create;True;0;0;0;False;0;False;0;0.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;166;1231.779,367.1611;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;168;1426.779,147.1611;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;169;2336,784;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;170;2288,976;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;78;6.7677,1247.337;Inherit;False;Constant;_Vector0;Vector 0;15;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;223;2704,-336;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;224;2480,-304;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;6672,416;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Lava;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;0;15;5;30;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;5;-1;-1;0;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;228;5776,800;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;5568,800;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;5568,928;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;225;5136,928;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;231;5088,1008;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;227;5136,1056;Inherit;False;Property;_Offset_Intensity2;Offset_Intensity2;43;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;201;5168,816;Inherit;False;Property;_Offset_Intensity;Offset_Intensity;38;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;199;5200,736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;210;5520,-384;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;183;5168,-592;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;212;5232,-64;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;213;4896,-576;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;184;4448,-544;Inherit;False;Property;_Color5;Color 5;33;1;[HDR];Create;True;0;0;0;False;0;False;4,0.345098,0,0;16.94838,3.371929,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;198;4672,-672;Inherit;False;Property;_Remap;Remap;37;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;195;4432,-768;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;197;4864,-768;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;217;4544,-352;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;216;5248,-352;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;211;4928,-288;Inherit;False;Property;_Color6;Color 6;41;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;47.93726,0.5019608,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;208;5008,-64;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;190;4528,-192;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;209;4832,16;Inherit;False;Property;_Remap2;Remap2;39;0;Create;True;0;0;0;False;0;False;0;-0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;218;4320,-288;Inherit;False;Property;_ScaleOrangeNoise;ScaleOrangeNoise;42;0;Create;True;0;0;0;False;0;False;0;0.96;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;4208,-704;Inherit;False;Property;_ScaleNoiseTexture;ScaleNoiseTexture;36;0;Create;True;0;0;0;False;0;False;0;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;187;4032,-208;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;189;3872,-144;Inherit;False;Property;_Vector2;Vector 2;35;0;Create;True;0;0;0;False;0;False;0,0;-0.84,0.86;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;177;3632,-208;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;6.81;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;3408,-176;Inherit;False;Property;_Noise_Scale;Noise_Scale;34;0;Create;True;0;0;0;False;0;False;0;0.84;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;205;4688,848;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;232;5814.078,1206.884;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;2288.788,-324.5535;Inherit;False;Property;_TimeSpeed;TimeSpeed;40;0;Create;True;0;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;167;2432,-768;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;173;2240,-800;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
WireConnection;82;1;85;0
WireConnection;82;0;83;0
WireConnection;75;0;20;0
WireConnection;75;1;76;0
WireConnection;75;2;78;0
WireConnection;92;0;90;0
WireConnection;93;0;92;0
WireConnection;93;1;91;1
WireConnection;95;0;92;1
WireConnection;95;1;91;2
WireConnection;94;0;92;2
WireConnection;94;1;91;3
WireConnection;97;0;93;0
WireConnection;97;1;95;0
WireConnection;97;2;94;0
WireConnection;100;0;99;0
WireConnection;100;1;98;0
WireConnection;101;0;100;0
WireConnection;99;0;97;0
WireConnection;99;1;96;0
WireConnection;111;0;110;1
WireConnection;111;1;110;3
WireConnection;1;0;27;0
WireConnection;1;2;18;0
WireConnection;17;0;27;0
WireConnection;17;1;18;0
WireConnection;20;0;1;0
WireConnection;20;1;17;0
WireConnection;19;0;18;0
WireConnection;30;0;19;0
WireConnection;30;1;24;0
WireConnection;30;2;31;0
WireConnection;26;0;28;0
WireConnection;27;0;30;0
WireConnection;27;1;26;0
WireConnection;67;1;20;0
WireConnection;67;2;68;0
WireConnection;42;1;20;0
WireConnection;42;2;43;0
WireConnection;70;0;55;0
WireConnection;70;1;69;0
WireConnection;70;2;67;0
WireConnection;52;0;70;0
WireConnection;52;1;59;0
WireConnection;52;2;42;0
WireConnection;48;1;20;0
WireConnection;48;2;50;0
WireConnection;57;0;60;0
WireConnection;57;1;52;0
WireConnection;57;2;48;0
WireConnection;49;1;20;0
WireConnection;49;2;51;0
WireConnection;58;0;61;0
WireConnection;58;1;57;0
WireConnection;58;2;49;0
WireConnection;102;0;104;0
WireConnection;102;1;106;0
WireConnection;106;0;105;0
WireConnection;138;0;55;0
WireConnection;138;1;69;0
WireConnection;138;2;150;0
WireConnection;140;0;138;0
WireConnection;140;1;59;0
WireConnection;140;2;151;0
WireConnection;142;0;60;0
WireConnection;142;1;140;0
WireConnection;142;2;152;0
WireConnection;144;0;61;0
WireConnection;144;1;142;0
WireConnection;144;2;153;0
WireConnection;150;0;107;0
WireConnection;150;1;133;0
WireConnection;151;0;107;0
WireConnection;151;1;134;0
WireConnection;152;0;107;0
WireConnection;152;1;137;0
WireConnection;153;0;107;0
WireConnection;153;1;139;0
WireConnection;107;0;103;0
WireConnection;103;0;157;0
WireConnection;103;1;102;0
WireConnection;157;0;155;0
WireConnection;157;1;156;0
WireConnection;109;0;58;0
WireConnection;109;1;144;0
WireConnection;158;0;75;0
WireConnection;158;1;159;0
WireConnection;159;0;107;0
WireConnection;159;1;163;0
WireConnection;169;0;109;0
WireConnection;170;2;158;0
WireConnection;170;3;158;0
WireConnection;223;0;167;0
WireConnection;223;1;224;0
WireConnection;224;0;236;0
WireConnection;0;2;210;0
WireConnection;0;10;232;0
WireConnection;0;11;228;0
WireConnection;0;12;228;0
WireConnection;228;0;200;0
WireConnection;228;1;226;0
WireConnection;200;0;199;0
WireConnection;200;1;201;0
WireConnection;200;2;205;0
WireConnection;226;0;225;0
WireConnection;226;1;227;0
WireConnection;226;2;231;0
WireConnection;225;0;223;0
WireConnection;231;0;205;0
WireConnection;199;0;187;0
WireConnection;210;0;183;0
WireConnection;210;1;216;0
WireConnection;210;2;212;0
WireConnection;183;0;197;0
WireConnection;183;1;213;0
WireConnection;183;2;190;0
WireConnection;212;0;208;0
WireConnection;213;0;217;0
WireConnection;213;1;184;0
WireConnection;195;0;167;0
WireConnection;195;1;196;0
WireConnection;197;0;195;0
WireConnection;197;4;198;0
WireConnection;217;0;223;0
WireConnection;217;1;218;0
WireConnection;216;0;217;0
WireConnection;216;1;211;0
WireConnection;208;0;190;0
WireConnection;208;3;209;0
WireConnection;190;0;187;0
WireConnection;187;0;177;0
WireConnection;187;3;189;1
WireConnection;187;4;189;2
WireConnection;177;0;167;0
WireConnection;177;1;185;0
WireConnection;232;0;101;0
WireConnection;167;0;173;1
WireConnection;167;1;173;3
ASEEND*/
//CHKSM=6A48A204FC53340FDCDA9BD92C6B7C7D42C9F71A