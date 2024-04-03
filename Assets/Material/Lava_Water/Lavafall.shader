// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lavafall"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_SpherePosition("Sphere Position", Vector) = (0,10000000000000,0,0)
		_CircleSize("CircleSize", Float) = 6.2
		_Step0("Step0", Float) = 0.03
		_Step1("Step1", Float) = 0.01
		_Step2("Step2", Float) = 0.05
		_Step3("Step3", Float) = 0.13
		[HDR]_Color0("Color 0", Color) = (1,0,0,0)
		[HDR]_Color05("Color 0.5", Color) = (0,0,0,0)
		[HDR]_Color1("Color 1", Color) = (1,1,1,0)
		_Color2("Color 2", Color) = (0,0,1,0)
		_Color3("Color 3", Color) = (0,0,0,0)
		_Tess("Tess", Float) = 15
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
		#pragma surface surf Standard keepalpha vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float4 _Color3;
		uniform float4 _Color2;
		uniform float4 _Color0;
		uniform float4 _Color05;
		uniform float _Step0;
		uniform float4 _Color1;
		uniform float _Step1;
		uniform float _Step2;
		uniform float _Step3;
		uniform float3 _SpherePosition;
		uniform float4 positionsArray[3];
		uniform float _CircleSize;
		uniform float _Tess;
		uniform float _Cutoff = 0.5;


		float2 voronoihash19( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi19( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash19( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		float DistanceCheck11( float3 WorldPos, float3 objectPosition )
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
			float4 temp_cast_0 = (_Tess).xxxx;
			return temp_cast_0;
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time19 = 0.0;
			float2 voronoiSmoothId19 = 0;
			float mulTime21 = _Time.y * 0.4;
			float2 uv_TexCoord20 = i.uv_texcoord * float2( 3.36,0.19 ) + ( float2( 0,1 ) * mulTime21 );
			float2 coords19 = uv_TexCoord20 * 7.52;
			float2 id19 = 0;
			float2 uv19 = 0;
			float voroi19 = voronoi19( coords19, time19, id19, uv19, 0, voronoiSmoothId19 );
			float temp_output_3_0_g26 = ( _Step0 - voroi19 );
			float4 lerpResult33 = lerp( _Color0 , _Color05 , saturate( ( temp_output_3_0_g26 / fwidth( temp_output_3_0_g26 ) ) ));
			float temp_output_3_0_g27 = ( _Step1 - voroi19 );
			float4 lerpResult35 = lerp( lerpResult33 , _Color1 , saturate( ( temp_output_3_0_g27 / fwidth( temp_output_3_0_g27 ) ) ));
			float temp_output_3_0_g28 = ( _Step2 - voroi19 );
			float4 lerpResult37 = lerp( _Color2 , lerpResult35 , saturate( ( temp_output_3_0_g28 / fwidth( temp_output_3_0_g28 ) ) ));
			float temp_output_3_0_g29 = ( _Step3 - voroi19 );
			float4 lerpResult39 = lerp( _Color3 , lerpResult37 , saturate( ( temp_output_3_0_g29 / fwidth( temp_output_3_0_g29 ) ) ));
			o.Emission = lerpResult39.rgb;
			o.Alpha = 1;
			float3 ase_worldPos = i.worldPos;
			float3 break5 = ase_worldPos;
			float4 appendResult9 = (float4(( break5.x - _SpherePosition.x ) , ( break5.y - _SpherePosition.y ) , ( break5.z - _SpherePosition.z ) , 0.0));
			float3 WorldPos11 = appendResult9.xyz;
			float3 objectPosition11 = positionsArray[clamp(0,0,(3 - 1))].xyz;
			float localDistanceCheck11 = DistanceCheck11( WorldPos11 , objectPosition11 );
			float clampResult14 = clamp( ( localDistanceCheck11 / _CircleSize ) , 0.0 , 1.0 );
			clip( clampResult14 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;2;-2144.995,329.9431;Inherit;False;1927.85;470.0797;substractLava;12;14;13;12;11;10;9;8;7;6;5;4;3;substractLava;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;3;-2094.995,383.0511;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;5;-1862.969,383.0151;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleSubtractOpNode;6;-1489.37,379.9431;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;7;-1506.73,529.1971;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-1504.911,637.0571;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-1118.497,500.7902;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-884.473,606.0221;Float;False;Property;_CircleSize;CircleSize;2;0;Create;True;0;0;0;False;0;False;6.2;6.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;13;-562.7037,503.0242;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;14;-388.1426,500.2341;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;17;-902.0888,77.43753;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;15;-1531.87,-208.3599;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1650.716,-469.0147;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-1459.029,-402.216;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3.36,0.19;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;23;-1969.028,-472.2629;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;24;-2173.658,-344.5047;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;21;-2004.758,-344.5045;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-1566.205,-5.055097;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;18;-1957.002,-35.65704;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VoronoiNode;19;-1197.605,-363.8147;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;7.52;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;28;-693.7542,-887.8305;Inherit;False;Property;_Step0;Step0;3;0;Create;True;0;0;0;False;0;False;0.03;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;30;-438.9442,-945.5384;Inherit;False;Step Antialiasing;-1;;26;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;31;-437.798,-636.3605;Inherit;False;Step Antialiasing;-1;;27;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-687.0535,-335.6488;Inherit;False;Property;_Step2;Step2;5;0;Create;True;0;0;0;False;0;False;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;-167.7337,-988.1224;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-683.5516,-255.3345;Inherit;False;Property;_Step3;Step3;6;0;Create;True;0;0;0;False;0;False;0.13;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;35;11.16292,-676.7267;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;36;-428.2587,-428.4887;Inherit;False;Step Antialiasing;-1;;28;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;37;367.3816,-450.8858;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;38;-416.0197,-281.5198;Inherit;False;Step Antialiasing;-1;;29;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;39;704.7036,-134.1441;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;40;-16.24384,-553.7313;Inherit;False;Property;_Color2;Color 2;10;0;Create;True;0;0;0;False;0;False;0,0,1,0;1,0.1709029,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;41;324.1481,-310.1463;Inherit;False;Property;_Color3;Color 3;11;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;43;-657.2464,-1137.51;Inherit;False;Property;_Color05;Color 0.5;8;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;4.867144,1.04478,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;44;-447.8073,-842.0671;Inherit;False;Property;_Color1;Color 1;9;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;1,0.2778975,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1400.985,131.8575;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Lavafall;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;False;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-605.9517,-554.1746;Inherit;False;Property;_Step1;Step1;4;0;Create;True;0;0;0;False;0;False;0.01;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;42;-489.3861,-1350.842;Inherit;False;Property;_Color0;Color 0;7;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;1.844303,1.264941,0.6083302,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;4;-1912.289,578.4292;Inherit;False;Property;_SpherePosition;Sphere Position;1;0;Create;True;0;0;0;False;0;False;0,1E+13,0;0,1E+13,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GlobalArrayNode;10;-1169.704,660.0242;Inherit;False;positionsArray;0;3;2;True;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;11;-879.704,502.0242;Float;False;float closest=10000@$float now=0@$for(int i=0@ i<positionsArray.Length@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;Create;2;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;DistanceCheck;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;942.1404,659.7485;Inherit;False;Property;_Tess;Tess;12;0;Create;True;0;0;0;False;0;False;15;15;0;0;0;1;FLOAT;0
WireConnection;5;0;3;0
WireConnection;6;0;5;0
WireConnection;6;1;4;1
WireConnection;7;0;5;1
WireConnection;7;1;4;2
WireConnection;8;0;5;2
WireConnection;8;1;4;3
WireConnection;9;0;6;0
WireConnection;9;1;7;0
WireConnection;9;2;8;0
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;14;0;13;0
WireConnection;17;0;16;0
WireConnection;22;0;23;0
WireConnection;22;1;21;0
WireConnection;20;1;22;0
WireConnection;21;0;24;0
WireConnection;16;0;18;1
WireConnection;16;1;18;3
WireConnection;19;0;20;0
WireConnection;30;1;19;0
WireConnection;30;2;28;0
WireConnection;31;1;19;0
WireConnection;31;2;29;0
WireConnection;33;0;42;0
WireConnection;33;1;43;0
WireConnection;33;2;30;0
WireConnection;35;0;33;0
WireConnection;35;1;44;0
WireConnection;35;2;31;0
WireConnection;36;1;19;0
WireConnection;36;2;32;0
WireConnection;37;0;40;0
WireConnection;37;1;35;0
WireConnection;37;2;36;0
WireConnection;38;1;19;0
WireConnection;38;2;34;0
WireConnection;39;0;41;0
WireConnection;39;1;37;0
WireConnection;39;2;38;0
WireConnection;0;2;39;0
WireConnection;0;10;14;0
WireConnection;0;14;47;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
ASEEND*/
//CHKSM=670D3005A127BA6342561EF29320F6F9083C86DC