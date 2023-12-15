// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Interactive by Position"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,0)
		[Header(Interactive parameters (Play mode only))]_Distance("Distance", Range( 0 , 1)) = 0
		_Proximity("Proximity", Range( 0 , 4)) = 0
		[Toggle]_Visualize("Visualize", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
		};

		uniform float4 positionsArray[3];
		uniform float _Proximity;
		uniform float _Distance;
		uniform float4 _Color;
		uniform float _Visualize;


		float DistanceCheck61( float3 WorldPos, float3 objectPosition )
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


		float DistanceCheck76( float3 WorldPos, float3 objectPosition )
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


		float DistanceCheck84( float3 WorldPos, float3 objectPosition )
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


		float DistanceCheck87( float3 WorldPos, float3 objectPosition )
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 WorldPosition103 = ase_worldPos;
			float3 WorldPos61 = WorldPosition103;
			float4 GlobalArray107 = positionsArray[clamp(0,0,(3 - 1))];
			float3 objectPosition61 = GlobalArray107.xyz;
			float localDistanceCheck61 = DistanceCheck61( WorldPos61 , objectPosition61 );
			float DistanceCheck115 = localDistanceCheck61;
			float clampResult64 = clamp( ( DistanceCheck115 / _Proximity ) , 0.0 , 1.0 );
			float temp_output_65_0 = ( 1.0 - clampResult64 );
			float3 appendResult79 = (float3(0.1 , 0.0 , 0.0));
			float3 WorldPos76 = ( WorldPosition103 + appendResult79 );
			float3 objectPosition76 = GlobalArray107.xyz;
			float localDistanceCheck76 = DistanceCheck76( WorldPos76 , objectPosition76 );
			float3 appendResult80 = (float3(0.0 , 0.1 , 0.0));
			float3 WorldPos84 = ( WorldPosition103 + appendResult80 );
			float3 objectPosition84 = GlobalArray107.xyz;
			float localDistanceCheck84 = DistanceCheck84( WorldPos84 , objectPosition84 );
			float3 appendResult81 = (float3(0.0 , 0.0 , 0.1));
			float3 WorldPos87 = ( WorldPosition103 + appendResult81 );
			float3 objectPosition87 = GlobalArray107.xyz;
			float localDistanceCheck87 = DistanceCheck87( WorldPos87 , objectPosition87 );
			float3 appendResult90 = (float3(( localDistanceCheck76 - DistanceCheck115 ) , ( localDistanceCheck84 - DistanceCheck115 ) , ( localDistanceCheck87 - DistanceCheck115 )));
			v.vertex.xyz += ( ( temp_output_65_0 * appendResult90 * _Distance ) * 100 );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Color.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 WorldPosition103 = ase_worldPos;
			float3 WorldPos61 = WorldPosition103;
			float4 GlobalArray107 = positionsArray[clamp(0,0,(3 - 1))];
			float3 objectPosition61 = GlobalArray107.xyz;
			float localDistanceCheck61 = DistanceCheck61( WorldPos61 , objectPosition61 );
			float DistanceCheck115 = localDistanceCheck61;
			float clampResult64 = clamp( ( DistanceCheck115 / _Proximity ) , 0.0 , 1.0 );
			float temp_output_65_0 = ( 1.0 - clampResult64 );
			float3 temp_cast_2 = ((( _Visualize )?( temp_output_65_0 ):( 0.0 ))).xxx;
			o.Emission = temp_cast_2;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
0;5.5;1920;1022;3971.24;74.59631;1.991375;True;False
Node;AmplifyShaderEditor.CommentaryNode;119;-2896,192;Inherit;False;1541;357;Comment;10;60;59;107;103;61;63;62;64;65;115;Base Distance Check;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;60;-2848,240;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GlobalArrayNode;59;-2848,400;Inherit;False;positionsArray;0;3;2;True;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;111;-2688,1280;Inherit;False;1119.05;255.4766;Comment;7;110;96;118;87;89;106;81;Z;0,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;102;-2688,960;Inherit;False;1117.837;255.9221;Comment;7;109;95;117;84;88;105;80;Y;0,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;101;-2688,640;Inherit;False;1119.902;255.2793;Comment;7;108;94;116;104;76;74;79;X;1,0,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;-2592,240;Inherit;False;WorldPosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-2592,400;Inherit;False;GlobalArray;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-2528,1312;Inherit;False;103;WorldPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;80;-2640,1056;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-2528,672;Inherit;False;103;WorldPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;79;-2640,736;Inherit;False;FLOAT3;4;0;FLOAT;0.1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;61;-2336,320;Float;False;float closest=10000@$float now=0@$for(int i=0@ i<positionsArray.Length@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;Create;2;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;DistanceCheck;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-2528,992;Inherit;False;103;WorldPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;81;-2640,1376;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-2336,1024;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;-2080,320;Inherit;False;DistanceCheck;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-2368,1440;Inherit;False;107;GlobalArray;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-2336,704;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-2368,800;Inherit;False;107;GlobalArray;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-2368,1120;Inherit;False;107;GlobalArray;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2336,432;Float;False;Property;_Proximity;Proximity;2;0;Create;True;0;0;0;False;0;False;0;0.97;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;89;-2336,1344;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-1952,1440;Inherit;False;115;DistanceCheck;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;87;-2176,1344;Float;False;float closest=10000@$float now=0@$for(int i=0@ i<positionsArray.Length@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;Create;2;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;DistanceCheck;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-1952,1120;Inherit;False;115;DistanceCheck;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;63;-1856,320;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-1952,800;Inherit;False;115;DistanceCheck;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;76;-2176,704;Float;False;float closest=10000@$float now=0@$for(int i=0@ i<positionsArray.Length@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;Create;2;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;DistanceCheck;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;84;-2176,1024;Float;False;float closest=10000@$float now=0@$for(int i=0@ i<positionsArray.Length@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;Create;2;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;DistanceCheck;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;94;-1728,704;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;95;-1728,1024;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;64;-1696,320;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;96;-1728,1344;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;65;-1536,320;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;90;-1408,1008;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-1424,1264;Inherit;False;Property;_Distance;Distance;1;1;[Header];Create;True;1;Interactive parameters (Play mode only);0;0;False;0;False;0;0.118;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-1120,1008;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleNode;113;-960,1008;Inherit;False;100;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;100;-1056,768;Inherit;False;Property;_Visualize;Visualize;3;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;57;-1072,560;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.6132076,0.6132076,0.6132076,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-768,736;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/Interactive by Position;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;103;0;60;0
WireConnection;107;0;59;0
WireConnection;61;0;103;0
WireConnection;61;1;107;0
WireConnection;88;0;105;0
WireConnection;88;1;80;0
WireConnection;115;0;61;0
WireConnection;74;0;104;0
WireConnection;74;1;79;0
WireConnection;89;0;106;0
WireConnection;89;1;81;0
WireConnection;87;0;89;0
WireConnection;87;1;110;0
WireConnection;63;0;115;0
WireConnection;63;1;62;0
WireConnection;76;0;74;0
WireConnection;76;1;108;0
WireConnection;84;0;88;0
WireConnection;84;1;109;0
WireConnection;94;0;76;0
WireConnection;94;1;116;0
WireConnection;95;0;84;0
WireConnection;95;1;117;0
WireConnection;64;0;63;0
WireConnection;96;0;87;0
WireConnection;96;1;118;0
WireConnection;65;0;64;0
WireConnection;90;0;94;0
WireConnection;90;1;95;0
WireConnection;90;2;96;0
WireConnection;91;0;65;0
WireConnection;91;1;90;0
WireConnection;91;2;97;0
WireConnection;113;0;91;0
WireConnection;100;1;65;0
WireConnection;0;0;57;0
WireConnection;0;2;100;0
WireConnection;0;11;113;0
ASEEND*/
//CHKSM=CCFF4ED10BAA35CAE2F9A540469E0BEBA678CA9D