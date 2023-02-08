// Made with Amplify Shader Editor v1.9.0.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Lave"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_CircleSize("CircleSize", Float) = 4
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Disto("Disto", Range( 0 , 0.1)) = 0
		_Speed("Speed", Range( 0 , 0.2)) = 0.2
		_Float2("Float 2", Range( 0 , 1)) = 0
		_SpherePosition("Sphere Position", Vector) = (0,0,0,0)
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
		uniform float3 _SpherePosition;
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
			o.Albedo = tex2DNode2.rgb;
			o.Emission = ( _Float0 * tex2DNode2 ).rgb;
			o.Alpha = 1;
			float3 ase_worldPos = i.worldPos;
			float3 break101 = ase_worldPos;
			float4 appendResult100 = (float4(( break101.x - _SpherePosition.x ) , ( break101.y - _SpherePosition.y ) , ( break101.z - _SpherePosition.z ) , 0.0));
			float3 WorldPos95 = appendResult100.xyz;
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
1920;0;1920;1019;2473.187;2628.714;4.306087;True;False
Node;AmplifyShaderEditor.CommentaryNode;108;-269.1658,-1231.031;Inherit;False;1927.85;470.0797;substractLava;12;93;71;101;106;107;105;92;100;95;94;96;97;substractLava;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;93;-219.1658,-1177.924;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;71;-36.46061,-982.5458;Inherit;False;Property;_SpherePosition;Sphere Position;14;0;Create;True;0;0;0;False;0;False;0,0,0;-0.4,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;101;12.85999,-1177.959;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-638.0986,-715.1688;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-708.9553,-174.7355;Inherit;False;Property;_Disto;Disto;8;0;Create;True;0;0;0;False;0;False;0;0.1;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-622.6161,-64.64378;Inherit;False;Property;_Speed;Speed;10;0;Create;True;0;0;0;False;0;False;0.2;0.008;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;-713.3216,-412.9977;Inherit;True;Property;_flowmap;flowmap;16;0;Create;True;0;0;0;False;0;False;-1;e5fc194be4ef2994a936322b74927473;e5fc194be4ef2994a936322b74927473;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;105;386.4577,-1181.031;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;107;370.9161,-923.918;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;106;369.0974,-1031.778;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-294.7989,76.41627;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;-259.5841,-452.5368;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GlobalArrayNode;92;706.1225,-900.951;Inherit;False;positionsArray;0;3;2;True;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;100;757.3293,-1060.185;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-23.55506,-419.3398;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;94;991.3524,-954.9528;Float;False;Property;_CircleSize;CircleSize;6;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;95;996.1224,-1058.951;Float;False;float closest=10000@$float now=0@$for(int i=0@ i<positionsArray.Length@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;Create;2;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;DistanceCheck;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;96;1313.122,-1057.951;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;155.9958,22.1605;Inherit;False;Property;_Float2;Float 2;12;0;Create;True;0;0;0;False;0;False;0;0.14;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;168.427,-502.6656;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;f87c01c63a01e86479cd8e93fe81fa69;f87c01c63a01e86479cd8e93fe81fa69;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;46;180.6458,-608.8732;Inherit;False;Property;_Float0;Float 0;17;0;Create;True;0;0;0;False;0;False;0;1.16;-1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;54;355.0334,-113.7046;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-871.7529,-2189.313;Inherit;False;2;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-871.4622,-2288.7;Inherit;False;2;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;57;-1169.943,-2091.043;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;68;1458.221,-1800.309;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;592.21,-2141.982;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;941.2483,-2214.882;Inherit;False;Property;_Size;Size;13;0;Create;True;0;0;0;False;0;False;0;81.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;61;-419.4283,-2027.526;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;69;1327.33,-2122.707;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-1074.564,-2233.278;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-679.4622,-2033.7;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-687.4622,-2154.7;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;62;-412.5435,-1895.481;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;66;134.5526,-1894.206;Inherit;True;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;3360.968,-2113.709;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;86;2815.007,-2296.141;Inherit;True;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;80;2412.863,-2563.793;Inherit;True;Polar Coordinates;-1;;7;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendOpsNode;78;3295.765,-2434.418;Inherit;True;LinearBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;84;2427.508,-2320.109;Inherit;True;Polar Coordinates;-1;;6;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;2186.487,-2523.846;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-0.03,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-685.4622,-2288.7;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;59;-419.4282,-2222.263;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-591.0555,31.93046;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;1789.877,-2504.715;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-120.299,384.0966;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;26;170.2388,-299.0255;Inherit;True;Property;_TextureSample1;Texture Sample 1;15;0;Create;True;0;0;0;False;0;False;-1;668a18a1fe59e944286f64f88f9be2fd;668a18a1fe59e944286f64f88f9be2fd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;812.4667,-174.0522;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;33;-345.1644,310.7101;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-821.3286,505.899;Inherit;False;Property;_Float3;Float 3;9;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-740.4124,594.9998;Inherit;False;Property;_Float1;Float 1;11;0;Create;True;0;0;0;False;0;False;0.2352941;0.2352941;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;27;-906.4919,-126.1884;Inherit;True;0;4;1;0;4;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-924.9286,138.7996;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;32;-414.4118,584.9998;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;701.8695,-636.5918;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;85;2849.629,-2559.798;Inherit;True;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;97;1487.684,-1060.741;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;89;-964.5643,-2486.279;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;58;-226.1363,-2223.706;Inherit;False;Polar Coordinates;-1;;3;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;60;108.5905,-2349.61;Inherit;True;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;64;-230.4636,-1857.313;Inherit;False;Polar Coordinates;-1;;5;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;65;92.65163,-2109.748;Inherit;True;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;63;-231.9058,-2043.394;Inherit;False;Polar Coordinates;-1;;4;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-806.4623,-2408.7;Inherit;False;2;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;2205.129,-2396.013;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.2,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3070.734,-600.5914;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Custom/Lave;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;18;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;0;32;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Spherical;False;True;Relative;0;;0;-1;-1;1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;101;0;93;0
WireConnection;105;0;101;0
WireConnection;105;1;71;1
WireConnection;107;0;101;2
WireConnection;107;1;71;3
WireConnection;106;0;101;1
WireConnection;106;1;71;2
WireConnection;10;0;9;0
WireConnection;13;0;7;0
WireConnection;13;1;45;0
WireConnection;13;2;14;0
WireConnection;100;0;105;0
WireConnection;100;1;106;0
WireConnection;100;2;107;0
WireConnection;8;0;13;0
WireConnection;8;1;10;0
WireConnection;95;0;100;0
WireConnection;95;1;92;0
WireConnection;96;0;95;0
WireConnection;96;1;94;0
WireConnection;2;1;8;0
WireConnection;77;1;90;0
WireConnection;68;0;69;0
WireConnection;67;0;60;0
WireConnection;67;1;65;0
WireConnection;67;2;66;0
WireConnection;61;0;72;0
WireConnection;61;1;74;0
WireConnection;69;0;70;0
WireConnection;69;1;67;0
WireConnection;74;0;77;0
WireConnection;74;1;57;3
WireConnection;73;0;76;0
WireConnection;73;1;57;2
WireConnection;62;0;73;0
WireConnection;62;1;74;0
WireConnection;66;0;64;0
WireConnection;87;0;85;0
WireConnection;87;1;86;0
WireConnection;86;0;84;0
WireConnection;80;1;82;0
WireConnection;78;0;85;0
WireConnection;78;1;86;0
WireConnection;84;1;83;0
WireConnection;82;0;79;0
WireConnection;72;0;75;0
WireConnection;72;1;57;1
WireConnection;59;0;72;0
WireConnection;59;1;73;0
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;34;0;33;0
WireConnection;34;1;32;0
WireConnection;26;1;8;0
WireConnection;52;0;2;1
WireConnection;52;1;54;0
WireConnection;52;2;55;0
WireConnection;33;0;28;0
WireConnection;33;1;29;0
WireConnection;33;2;30;0
WireConnection;32;0;31;0
WireConnection;50;0;46;0
WireConnection;50;1;2;0
WireConnection;85;0;80;0
WireConnection;97;0;96;0
WireConnection;58;1;59;0
WireConnection;60;0;58;0
WireConnection;64;1;62;0
WireConnection;65;0;63;0
WireConnection;63;1;61;0
WireConnection;75;1;89;0
WireConnection;83;0;79;0
WireConnection;0;0;2;0
WireConnection;0;1;26;0
WireConnection;0;2;50;0
WireConnection;0;10;97;0
WireConnection;0;11;52;0
ASEEND*/
//CHKSM=3ADC6D90FE60B5C733F620E3FEE082D83EB25FF6