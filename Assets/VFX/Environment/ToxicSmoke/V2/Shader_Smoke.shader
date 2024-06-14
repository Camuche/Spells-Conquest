// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shader_Smoke"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 15
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_CircleSize("CircleSize", Float) = 4
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_VertexOffset_Intensity("VertexOffset_Intensity", Float) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Opacity("Opacity", Range( 0 , 1)) = 0.5543478
		_Dissolve_Scale("Dissolve_Scale", Float) = 3.57
		_Noise_Scale("Noise_Scale", Float) = 4.88
		_TimeScale("TimeScale", Float) = 1
		_Color0("Color 0", Color) = (0,1,0,0)
		_Step("Step", Float) = 0.5
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _TimeScale;
		uniform float _Noise_Scale;
		uniform float _VertexOffset_Intensity;
		uniform float4 _Color0;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Step;
		uniform float4 positionsArray[20];
		uniform float _CircleSize;
		uniform float _Dissolve_Scale;
		uniform float _Opacity;
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


		float DistanceCheck43( float3 WorldPos, float3 objectPosition )
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
			float2 appendResult20 = (float2(ase_worldPos.x , ase_worldPos.z));
			float mulTime15 = _Time.y * _TimeScale;
			float2 temp_output_24_0 = ( appendResult20 + mulTime15 );
			float simplePerlin2D8 = snoise( temp_output_24_0*_Noise_Scale );
			simplePerlin2D8 = simplePerlin2D8*0.5 + 0.5;
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( simplePerlin2D8 * ase_vertexNormal * _VertexOffset_Intensity );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Color0.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			float3 ase_worldPos = i.worldPos;
			float3 WorldPos43 = ase_worldPos;
			float3 objectPosition43 = positionsArray[clamp(0,0,(20 - 1))].xyz;
			float localDistanceCheck43 = DistanceCheck43( WorldPos43 , objectPosition43 );
			float temp_output_3_0_g1 = ( _Step - ( localDistanceCheck43 / _CircleSize ) );
			float clampResult42 = clamp( saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) ) , 0.0 , 1.0 );
			float2 appendResult20 = (float2(ase_worldPos.x , ase_worldPos.z));
			float mulTime15 = _Time.y * _TimeScale;
			float2 temp_output_24_0 = ( appendResult20 + mulTime15 );
			float simplePerlin2D33 = snoise( temp_output_24_0*_Dissolve_Scale );
			simplePerlin2D33 = simplePerlin2D33*0.5 + 0.5;
			float clampResult29 = clamp( ( ( 1.0 - simplePerlin2D33 ) + (-1.0 + (_Opacity - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) , 0.0 , 1.0 );
			clip( ( ( 1.0 - clampResult42 ) * clampResult29 ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;54;-1002.352,1006.692;Inherit;False;774.0427;519.6707;VertexOffset;5;8;10;22;6;14;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;53;-1887.836,527.2322;Inherit;False;1231.001;379.7016;Dissolve;7;28;29;27;30;33;32;7;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-2007.89,77.83788;Inherit;False;1376.086;340.1487;MakeSmokeDissolveWithFire;8;40;42;44;43;41;37;38;39;MakeSmokeDissolveWithFire;1,1,1,1;0;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Shader_Smoke;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;0;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;9;-1;-1;0;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-174.9648,229.7506;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;12;-2508.415,1007.66;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;20;-2238.247,1058.475;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-2063.845,1058.34;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-2288.381,1168.25;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2451.141,1167.782;Inherit;False;Property;_TimeScale;TimeScale;13;0;Create;True;0;0;0;False;0;False;1;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;40;-1399.312,130.2404;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;42;-963.3841,136.6689;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;44;-809.8047,134.4365;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;43;-1663.91,127.8379;Float;False;float closest=10000@$float now=0@$for(int i=0@ i<positionsArray.Length@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;Create;2;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;DistanceCheck;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;41;-1190.352,131.1545;Inherit;False;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;37;-1957.89,153.3016;Inherit;False;positionsArray;0;20;2;True;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1572.462,226.4522;Float;False;Property;_CircleSize;CircleSize;5;0;Create;True;0;0;0;False;0;False;4;12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1575.543,304.9865;Inherit;False;Property;_Step;Step;15;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-1080.836,580.2325;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1.12;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;29;-834.8349,580.2325;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;27;-1285.836,579.2325;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;30;-1285.994,658.3358;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;33;-1571.834,577.2325;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1837.836,611.2326;Inherit;False;Property;_Dissolve_Scale;Dissolve_Scale;11;0;Create;True;0;0;0;False;0;False;3.57;0.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1615.598,793.9341;Inherit;False;Property;_Opacity;Opacity;10;0;Create;True;0;0;0;False;0;False;0.5543478;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;8;-741.7805,1056.81;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-952.3522,1139.362;Inherit;False;Property;_Noise_Scale;Noise_Scale;12;0;Create;True;0;0;0;False;0;False;4.88;0.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;22;-689.9202,1266.793;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-752.9724,1413.363;Inherit;False;Property;_VertexOffset_Intensity;VertexOffset_Intensity;8;0;Create;True;0;0;0;False;0;False;0;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-406.3095,1056.692;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;18;-757.3992,-510.5253;Inherit;False;Property;_Color0;Color 0;14;0;Create;True;0;0;0;False;0;False;0,1,0,0;0.1063613,0.6415094,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-387.9494,23.99615;Inherit;False;Property;_Metallic;Metallic;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-390.7895,94.59615;Inherit;False;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;0;False;0;False;0;0.222;0;1;0;1;FLOAT;0
WireConnection;0;0;18;0
WireConnection;0;3;4;0
WireConnection;0;4;5;0
WireConnection;0;10;26;0
WireConnection;0;11;14;0
WireConnection;26;0;44;0
WireConnection;26;1;29;0
WireConnection;20;0;12;1
WireConnection;20;1;12;3
WireConnection;24;0;20;0
WireConnection;24;1;15;0
WireConnection;15;0;17;0
WireConnection;40;0;43;0
WireConnection;40;1;38;0
WireConnection;42;0;41;0
WireConnection;44;0;42;0
WireConnection;43;0;12;0
WireConnection;43;1;37;0
WireConnection;41;1;40;0
WireConnection;41;2;39;0
WireConnection;28;0;27;0
WireConnection;28;1;30;0
WireConnection;29;0;28;0
WireConnection;27;0;33;0
WireConnection;30;0;7;0
WireConnection;33;0;24;0
WireConnection;33;1;32;0
WireConnection;8;0;24;0
WireConnection;8;1;10;0
WireConnection;14;0;8;0
WireConnection;14;1;22;0
WireConnection;14;2;6;0
ASEEND*/
//CHKSM=EA79E6466E37445CB51F83AF7F288E39C5488C69