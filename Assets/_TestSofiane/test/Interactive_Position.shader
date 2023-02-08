// Made with Amplify Shader Editor v1.9.0.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Interactive Position"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_CircleSize("CircleSize", Range( 0 , 4)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TreeTransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 4.6
		#pragma exclude_renderers xbox360 xboxseries playstation psp2 n3ds wiiu switch nomrt 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows novertexlights nolightmap  nodynlightmap nodirlightmap 
		struct Input
		{
			float3 worldPos;
		};

		uniform float4 positionsArray[3];
		uniform float _CircleSize;
		uniform float _Cutoff = 0.5;


		float DistanceCheck219( float3 WorldPos, float3 objectPosition )
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 WorldPos219 = ase_worldPos;
			float3 objectPosition219 = positionsArray[clamp(0,0,(3 - 1))].xyz;
			float localDistanceCheck219 = DistanceCheck219( WorldPos219 , objectPosition219 );
			float clampResult224 = clamp( ( localDistanceCheck219 / _CircleSize ) , 0.0 , 1.0 );
			float temp_output_226_0 = ( 1.0 - clampResult224 );
			float3 temp_cast_1 = (temp_output_226_0).xxx;
			o.Emission = temp_cast_1;
			o.Alpha = 1;
			clip( temp_output_226_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19001
1920;0;1920;1019;7118.411;-139.2409;1.070972;True;False
Node;AmplifyShaderEditor.CommentaryNode;225;-6711.246,516.5844;Inherit;False;975.6604;317.2526;UseScript;6;220;219;222;224;218;217;Interactive by Position;1,1,1,1;0;0
Node;AmplifyShaderEditor.GlobalArrayNode;217;-6669.23,724.0018;Inherit;False;positionsArray;0;3;2;True;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;218;-6669.23,564.0018;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;220;-6384,670;Float;False;Property;_CircleSize;CircleSize;1;0;Create;True;0;0;0;False;0;False;0;4;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;219;-6379.23,566.0018;Float;False;float closest=10000@$float now=0@$for(int i=0@ i<positionsArray.Length@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;Create;2;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;DistanceCheck;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;222;-6062.23,567.0018;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;224;-5887.668,564.2119;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;226;-5774.803,703.6538;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-5633.929,566.4293;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Custom/Interactive Position;False;False;False;False;False;True;True;True;True;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;False;TreeTransparentCutout;;Geometry;All;10;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;2;10;25;True;0.92;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0.001;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;219;0;218;0
WireConnection;219;1;217;0
WireConnection;222;0;219;0
WireConnection;222;1;220;0
WireConnection;224;0;222;0
WireConnection;226;0;224;0
WireConnection;0;2;226;0
WireConnection;0;10;226;0
ASEEND*/
//CHKSM=0503A19C526DB7F1414C30934EAAA8D7A9FD3EEE