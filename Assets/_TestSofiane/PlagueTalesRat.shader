// Made with Amplify Shader Editor v1.9.0.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/PlagueTalesRat"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_CircleSize("CircleSize", Float) = 4
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Disto("Disto", Range( 0 , 0.2)) = 0
		_Speed("Speed", Range( 0 , 0.2)) = 0.2
		_Float2("Float 2", Range( 0 , 1)) = 0
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_flowmap("flowmap", 2D) = "white" {}
		_Float0("Float 0", Range( -1 , 5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _TextureSample0;
		uniform sampler2D _flowmap;
		uniform float4 _flowmap_ST;
		uniform float _Disto;
		uniform float _Speed;
		uniform float _Float2;
		uniform sampler2D _TextureSample1;
		uniform float _Float0;
		uniform float4 positionsArray[3];
		uniform float _CircleSize;
		uniform float _Cutoff = 0.5;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;


		float DistanceCheck95( float3 WorldPos, float3 objectPosition )
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
			float2 uv_flowmap = v.texcoord * _flowmap_ST.xy + _flowmap_ST.zw;
			float4 lerpResult13 = lerp( float4( v.texcoord.xy, 0.0 , 0.0 ) , tex2Dlod( _flowmap, float4( uv_flowmap, 0, 0.0) ) , _Disto);
			float mulTime10 = _Time.y * _Speed;
			float4 temp_output_8_0 = ( lerpResult13 + mulTime10 );
			float4 tex2DNode2 = tex2Dlod( _TextureSample0, float4( temp_output_8_0.rg, 0, 0.0) );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			v.vertex.xyz += ( tex2DNode2.r * ase_worldNormal * _Float2 );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_flowmap = i.uv_texcoord * _flowmap_ST.xy + _flowmap_ST.zw;
			float4 lerpResult13 = lerp( float4( i.uv_texcoord, 0.0 , 0.0 ) , tex2D( _flowmap, uv_flowmap ) , _Disto);
			float mulTime10 = _Time.y * _Speed;
			float4 temp_output_8_0 = ( lerpResult13 + mulTime10 );
			o.Normal = UnpackNormal( tex2D( _TextureSample1, temp_output_8_0.rg ) );
			float4 tex2DNode2 = tex2D( _TextureSample0, temp_output_8_0.rg );
			float3 temp_cast_3 = (tex2DNode2.r).xxx;
			o.Albedo = temp_cast_3;
			float3 temp_cast_4 = (( _Float0 * tex2DNode2.r )).xxx;
			o.Emission = temp_cast_4;
			o.Alpha = 1;
			float3 ase_worldPos = i.worldPos;
			float3 WorldPos95 = ase_worldPos;
			float3 objectPosition95 = positionsArray[clamp(0,0,(3 - 1))].xyz;
			float localDistanceCheck95 = DistanceCheck95( WorldPos95 , objectPosition95 );
			float clampResult97 = clamp( ( localDistanceCheck95 / _CircleSize ) , 0.0 , 1.0 );
			clip( clampResult97 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19001
1920;0;1920;1019;22.25752;1255.37;2.456046;True;False
Node;AmplifyShaderEditor.CommentaryNode;108;485.2366,234.9695;Inherit;False;1927.85;470.0797;substractLava;12;93;71;101;106;107;105;92;100;95;94;96;97;substractLava;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-622.6161,-64.64378;Inherit;False;Property;_Speed;Speed;10;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-638.0986,-715.1688;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-708.9553,-174.7355;Inherit;False;Property;_Disto;Disto;8;0;Create;True;0;0;0;False;0;False;0;0.1527;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;-713.3216,-412.9977;Inherit;True;Property;_flowmap;flowmap;15;0;Create;True;0;0;0;False;0;False;-1;e5fc194be4ef2994a936322b74927473;e5fc194be4ef2994a936322b74927473;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;93;535.2366,288.0766;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GlobalArrayNode;92;1451.393,574.1833;Inherit;False;positionsArray;0;3;2;True;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;13;-259.5841,-452.5368;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-294.7989,76.41627;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;1745.756,511.048;Float;False;Property;_CircleSize;CircleSize;6;0;Create;True;0;0;0;False;0;False;4;5.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-23.55506,-419.3398;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;95;1725.155,383.7088;Float;False;float closest=10000@$float now=0@$for(int i=0@ i<positionsArray.Length@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;Create;2;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;DistanceCheck;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;54;355.0334,-113.7046;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;96;2067.525,408.0498;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;168.427,-502.6656;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;f87c01c63a01e86479cd8e93fe81fa69;f87c01c63a01e86479cd8e93fe81fa69;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;55;155.9958,22.1605;Inherit;False;Property;_Float2;Float 2;12;0;Create;True;0;0;0;False;0;False;0;0.705;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;180.6458,-608.8732;Inherit;False;Property;_Float0;Float 0;16;0;Create;True;0;0;0;False;0;False;0;0;-1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;-345.1644,310.7101;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;105;1140.861,284.9696;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;71;717.942,483.4551;Inherit;False;Property;_SpherePosition;Sphere Position;13;0;Create;True;0;0;0;False;0;False;0,0,0;-10,0,-11;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;26;170.2388,-299.0255;Inherit;True;Property;_TextureSample1;Texture Sample 1;14;0;Create;True;0;0;0;False;0;False;-1;668a18a1fe59e944286f64f88f9be2fd;668a18a1fe59e944286f64f88f9be2fd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;27;-906.4919,-126.1884;Inherit;True;0;4;1;0;4;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;30;-821.3286,505.899;Inherit;False;Property;_Float3;Float 3;9;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-591.0555,31.93046;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-120.299,384.0966;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;32;-414.4118,584.9998;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;100;1511.733,405.8158;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;97;2242.086,405.2599;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-740.4124,594.9998;Inherit;False;Property;_Float1;Float 1;11;0;Create;True;0;0;0;False;0;False;0.2352941;0.2352941;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;812.4667,-174.0522;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;107;1125.32,542.0829;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;106;1123.501,434.2228;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-924.9286,138.7996;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;701.8695,-636.5918;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;101;767.2625,288.0416;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3070.734,-600.5914;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Custom/PlagueTalesRat;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;18;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;0;32;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Spherical;False;True;Relative;0;;0;-1;-1;1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;7;0
WireConnection;13;1;45;0
WireConnection;13;2;14;0
WireConnection;10;0;9;0
WireConnection;8;0;13;0
WireConnection;8;1;10;0
WireConnection;95;0;93;0
WireConnection;95;1;92;0
WireConnection;96;0;95;0
WireConnection;96;1;94;0
WireConnection;2;1;8;0
WireConnection;33;0;28;0
WireConnection;33;1;29;0
WireConnection;33;2;30;0
WireConnection;105;0;101;0
WireConnection;105;1;71;1
WireConnection;26;1;8;0
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;34;0;33;0
WireConnection;34;1;32;0
WireConnection;32;0;31;0
WireConnection;100;0;105;0
WireConnection;100;1;106;0
WireConnection;100;2;107;0
WireConnection;97;0;96;0
WireConnection;52;0;2;1
WireConnection;52;1;54;0
WireConnection;52;2;55;0
WireConnection;107;0;101;2
WireConnection;107;1;71;3
WireConnection;106;0;101;1
WireConnection;106;1;71;2
WireConnection;50;0;46;0
WireConnection;50;1;2;1
WireConnection;101;0;93;0
WireConnection;0;0;2;1
WireConnection;0;1;26;0
WireConnection;0;2;50;0
WireConnection;0;10;97;0
WireConnection;0;11;52;0
ASEEND*/
//CHKSM=F22D26E7687940540076B995BA273651203BD6CB