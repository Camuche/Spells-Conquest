// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lava"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_SpherePosition("Sphere Position", Vector) = (0,0,0,0)
		_CircleSize("CircleSize", Float) = 4
		_LavafallSpeed("LavafallSpeed", Float) = 0.3
		_FlowMap("FlowMap", 2D) = "white" {}
		_Tiling("Tiling", Float) = 1
		_Disto("Disto", Range( 0 , 1)) = 0
		_SpeedDisto("SpeedDisto", Float) = 0
		_Step0("Step0", Float) = 0
		_Step0bis("Step0bis", Float) = 0
		_Step1("Step1", Float) = 0
		_Step1bis("Step1bis", Float) = 0
		_Step2("Step2", Float) = 0
		_Step2bis("Step2bis", Float) = 0
		_Step3("Step3", Float) = 0
		_Step3bis("Step3bis", Float) = 0
		[HDR]_Color0("Color 0", Color) = (1,0,0,0)
		[HDR]_Color05("Color 0.5", Color) = (0,0,0,0)
		[HDR]_Color1("Color 1", Color) = (1,1,1,0)
		_Color2("Color 2", Color) = (0,0,1,0)
		_Color3("Color 3", Color) = (0,0,0,0)
		_Tess("Tess", Float) = 0
		_OffsetStrength("OffsetStrength", Float) = 0
		_OffsetStrengthbis("OffsetStrengthbis", Float) = 0
		[Toggle]_Lavafall("Lavafall", Float) = 0
		[Toggle]_Lavafall2("Lavafall2", Float) = 0
		_LavafallTilingX("LavafallTilingX", Float) = 0
		_LavafallTilingY("LavafallTilingY", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float _Lavafall2;
		uniform float _Tiling;
		uniform sampler2D _FlowMap;
		uniform float4 _FlowMap_ST;
		uniform float _Disto;
		uniform float _SpeedDisto;
		uniform float _OffsetStrength;
		uniform float _LavafallTilingX;
		uniform float _LavafallTilingY;
		uniform float _LavafallSpeed;
		uniform float _OffsetStrengthbis;
		uniform float _Lavafall;
		uniform float4 _Color3;
		uniform float4 _Color2;
		uniform float4 _Color0;
		uniform float4 _Color05;
		uniform float _Step0;
		uniform float4 _Color1;
		uniform float _Step1;
		uniform float _Step2;
		uniform float _Step3;
		uniform float _Step0bis;
		uniform float _Step1bis;
		uniform float _Step2bis;
		uniform float _Step3bis;
		uniform float3 _SpherePosition;
		uniform float4 positionsArray[3];
		uniform float _CircleSize;
		uniform float _Tess;
		uniform float _Cutoff = 0.5;


		float2 voronoihash1( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi1( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash1( n + g );
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


		float2 voronoihash107( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi107( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash107( n + g );
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
			float4 temp_cast_5 = (_Tess).xxxx;
			return temp_cast_5;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float time1 = 0.0;
			float2 voronoiSmoothId1 = 0;
			float2 temp_cast_0 = (_Tiling).xx;
			float2 uv_TexCoord19 = v.texcoord.xy * temp_cast_0;
			float2 uv_FlowMap = v.texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float4 lerpResult30 = lerp( float4( uv_TexCoord19, 0.0 , 0.0 ) , tex2Dlod( _FlowMap, float4( uv_FlowMap, 0, 0.0) ) , _Disto);
			float mulTime26 = _Time.y * _SpeedDisto;
			float4 temp_output_27_0 = ( lerpResult30 + mulTime26 );
			float2 coords1 = temp_output_27_0.rg * _Tiling;
			float2 id1 = 0;
			float2 uv1 = 0;
			float voroi1 = voronoi1( coords1, time1, id1, uv1, 0, voronoiSmoothId1 );
			float simplePerlin2D17 = snoise( temp_output_27_0.rg*_Tiling );
			simplePerlin2D17 = simplePerlin2D17*0.5 + 0.5;
			float temp_output_20_0 = ( voroi1 * simplePerlin2D17 );
			float time107 = 0.0;
			float2 voronoiSmoothId107 = 0;
			float2 appendResult157 = (float2(_LavafallTilingX , _LavafallTilingY));
			float mulTime106 = _Time.y * _LavafallSpeed;
			float2 uv_TexCoord103 = v.texcoord.xy * appendResult157 + ( float2( 0,1 ) * mulTime106 );
			float2 coords107 = uv_TexCoord103 * 7.52;
			float2 id107 = 0;
			float2 uv107 = 0;
			float voroi107 = voronoi107( coords107, time107, id107, uv107, 0, voronoiSmoothId107 );
			float3 temp_cast_4 = (( voroi107 * _OffsetStrengthbis )).xxx;
			float3 temp_output_158_0 = (( _Lavafall2 )?( temp_cast_4 ):( ( temp_output_20_0 * _OffsetStrength * float3(0,1,0) ) ));
			v.vertex.xyz += temp_output_158_0;
			v.vertex.w = 1;
			v.normal = temp_output_158_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time1 = 0.0;
			float2 voronoiSmoothId1 = 0;
			float2 temp_cast_0 = (_Tiling).xx;
			float2 uv_TexCoord19 = i.uv_texcoord * temp_cast_0;
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float4 lerpResult30 = lerp( float4( uv_TexCoord19, 0.0 , 0.0 ) , tex2D( _FlowMap, uv_FlowMap ) , _Disto);
			float mulTime26 = _Time.y * _SpeedDisto;
			float4 temp_output_27_0 = ( lerpResult30 + mulTime26 );
			float2 coords1 = temp_output_27_0.rg * _Tiling;
			float2 id1 = 0;
			float2 uv1 = 0;
			float voroi1 = voronoi1( coords1, time1, id1, uv1, 0, voronoiSmoothId1 );
			float simplePerlin2D17 = snoise( temp_output_27_0.rg*_Tiling );
			simplePerlin2D17 = simplePerlin2D17*0.5 + 0.5;
			float temp_output_20_0 = ( voroi1 * simplePerlin2D17 );
			float temp_output_3_0_g26 = ( _Step0 - temp_output_20_0 );
			float4 lerpResult70 = lerp( _Color0 , _Color05 , saturate( ( temp_output_3_0_g26 / fwidth( temp_output_3_0_g26 ) ) ));
			float temp_output_3_0_g27 = ( _Step1 - temp_output_20_0 );
			float4 lerpResult52 = lerp( lerpResult70 , _Color1 , saturate( ( temp_output_3_0_g27 / fwidth( temp_output_3_0_g27 ) ) ));
			float temp_output_3_0_g28 = ( _Step2 - temp_output_20_0 );
			float4 lerpResult57 = lerp( _Color2 , lerpResult52 , saturate( ( temp_output_3_0_g28 / fwidth( temp_output_3_0_g28 ) ) ));
			float temp_output_3_0_g29 = ( _Step3 - temp_output_20_0 );
			float4 lerpResult58 = lerp( _Color3 , lerpResult57 , saturate( ( temp_output_3_0_g29 / fwidth( temp_output_3_0_g29 ) ) ));
			float time107 = 0.0;
			float2 voronoiSmoothId107 = 0;
			float2 appendResult157 = (float2(_LavafallTilingX , _LavafallTilingY));
			float mulTime106 = _Time.y * _LavafallSpeed;
			float2 uv_TexCoord103 = i.uv_texcoord * appendResult157 + ( float2( 0,1 ) * mulTime106 );
			float2 coords107 = uv_TexCoord103 * 7.52;
			float2 id107 = 0;
			float2 uv107 = 0;
			float voroi107 = voronoi107( coords107, time107, id107, uv107, 0, voronoiSmoothId107 );
			float4 lerpResult138 = lerp( _Color0 , _Color05 , step( voroi107 , _Step0bis ));
			float4 lerpResult140 = lerp( lerpResult138 , _Color1 , step( voroi107 , _Step1bis ));
			float4 lerpResult142 = lerp( _Color2 , lerpResult140 , step( voroi107 , _Step2bis ));
			float4 lerpResult144 = lerp( _Color3 , lerpResult142 , step( voroi107 , _Step3bis ));
			o.Emission = (( _Lavafall )?( lerpResult144 ):( lerpResult58 )).rgb;
			o.Alpha = 1;
			float3 ase_worldPos = i.worldPos;
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
Node;AmplifyShaderEditor.CommentaryNode;89;-837.1667,1396.725;Inherit;False;1927.85;470.0797;substractLava;12;101;100;99;98;97;96;95;94;93;92;91;90;substractLava;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;83;1128.672,-181.9883;Inherit;False;Property;_DeapthFade;DeapthFade;24;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;82;1357.672,-170.9883;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;307.5886,976.8096;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;85;1094.672,-338.9883;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1478.03,657.4004;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Lava;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.WorldPosInputsNode;90;-787.1668,1449.833;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;92;-555.1411,1449.797;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleSubtractOpNode;93;-181.5426,1446.725;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;95;-198.9026,1595.979;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;94;-197.0836,1703.839;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;97;189.3298,1567.572;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;98;423.3534,1672.804;Float;False;Property;_CircleSize;CircleSize;2;0;Create;True;0;0;0;False;0;False;4;6.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;100;745.1226,1569.806;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;101;919.6837,1567.016;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;96;138.1227,1726.806;Inherit;False;positionsArray;0;3;2;True;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;99;428.1224,1568.806;Float;False;float closest=10000@$float now=0@$for(int i=0@ i<positionsArray.Length@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;Create;2;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;DistanceCheck;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;1122.163,1041.499;Inherit;False;Property;_Tess;Tess;21;0;Create;True;0;0;0;False;0;False;0;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;91;-604.4615,1645.211;Inherit;False;Property;_SpherePosition;Sphere Position;1;0;Create;True;0;0;0;False;0;False;0,0,0;0,1E+13,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;110;680.3025,-1102.558;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;111;885.533,-1079.537;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-3995.775,-115.4346;Inherit;False;Property;_Tiling;Tiling;5;0;Create;True;0;0;0;False;0;False;1;4.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;1;-2194.643,245.5152;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;17;-2259.946,556.5942;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1788.633,325.5395;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-3499.835,225.4973;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-3565.1,679.1956;Inherit;False;Property;_Disto;Disto;6;0;Create;True;0;0;0;False;0;False;0;0.761;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-3468.232,761.4728;Inherit;False;Property;_SpeedDisto;SpeedDisto;7;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-3584.304,487.708;Inherit;True;Property;_FlowMap;FlowMap;4;0;Create;True;0;0;0;False;0;False;-1;e5fc194be4ef2994a936322b74927473;e5fc194be4ef2994a936322b74927473;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;30;-3107.13,470.4836;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;26;-3088.532,606.1944;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-2873.692,470.6956;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-1530.488,15.40344;Inherit;False;Property;_Step0;Step0;8;0;Create;True;0;0;0;False;0;False;0;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1442.686,349.0594;Inherit;False;Property;_Step1;Step1;10;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;67;-1275.679,-42.30443;Inherit;False;Step Antialiasing;-1;;26;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;42;-1274.533,266.8735;Inherit;False;Step Antialiasing;-1;;27;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1523.788,567.5851;Inherit;False;Property;_Step2;Step2;12;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;70;-1004.469,-84.88849;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1520.286,647.8993;Inherit;False;Property;_Step3;Step3;14;0;Create;True;0;0;0;False;0;False;0;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;-825.5718,226.5073;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;48;-1264.994,474.7452;Inherit;False;Step Antialiasing;-1;;28;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;57;-469.3532,452.3481;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;49;-1252.755,621.7141;Inherit;False;Step Antialiasing;-1;;29;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;58;-132.0311,769.0897;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;60;-852.9786,349.5027;Inherit;False;Property;_Color2;Color 2;19;0;Create;True;0;0;0;False;0;False;0,0,1,0;1,0.1709029,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;61;-512.5867,593.0876;Inherit;False;Property;_Color3;Color 3;20;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;69;-1493.981,-234.2767;Inherit;False;Property;_Color05;Color 0.5;17;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;4.867144,1.04478,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;59;-1284.542,61.16684;Inherit;False;Property;_Color1;Color 1;18;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;1,0.2778975,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;55;-1499.226,-418.0536;Inherit;False;Property;_Color0;Color 0;16;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;1.844303,1.264941,0.6083302,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-1539.204,-1733.116;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;106;-1893.246,-1608.606;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;138;-214.4805,-1196.674;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;140;-35.58334,-885.2773;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;142;320.6352,-659.4366;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;144;657.9575,-342.6949;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-740.4995,-1096.382;Inherit;False;Property;_Step0bis;Step0bis;9;0;Create;True;0;0;0;False;0;False;0;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-652.6974,-762.7254;Inherit;False;Property;_Step1bis;Step1bis;11;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-733.7994,-544.1996;Inherit;False;Property;_Step2bis;Step2bis;13;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-730.2975,-463.8854;Inherit;False;Property;_Step3bis;Step3bis;15;0;Create;True;0;0;0;False;0;False;0;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;150;-469.5325,-1180.317;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;151;-381.5325,-831.5167;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;152;-367.1324,-636.3168;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;153;-402.3325,-474.7168;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;104;-1857.516,-1736.364;Inherit;False;Constant;_Vector1;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.VoronoiNode;107;-1074.525,-1667.245;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;7.52;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;103;-1347.517,-1666.317;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3.36,0.19;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;157;-1457.686,-1415.51;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-2062.146,-1608.606;Inherit;False;Property;_LavafallSpeed;LavafallSpeed;3;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-1632.686,-1485.51;Inherit;False;Property;_LavafallTilingX;LavafallTilingX;27;0;Create;True;0;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-1633.686,-1405.51;Inherit;False;Property;_LavafallTilingY;LavafallTilingY;28;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;109;950.0657,542.2985;Inherit;False;Property;_Lavafall;Lavafall;25;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;158;740.1299,917.9675;Inherit;False;Property;_Lavafall2;Lavafall2;26;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;424.6514,478.7385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;78;6.7677,1247.337;Inherit;False;Constant;_Vector0;Vector 0;15;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;76;-33.21582,1086.189;Inherit;False;Property;_OffsetStrength;OffsetStrength;22;0;Create;True;0;0;0;False;0;False;0;0.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;164;457.449,378.6434;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;160.5732,511.0333;Inherit;False;Property;_OffsetStrengthbis;OffsetStrengthbis;23;0;Create;True;0;0;0;False;0;False;0;0.64;0;0;0;1;FLOAT;0
WireConnection;82;1;85;0
WireConnection;82;0;83;0
WireConnection;75;0;20;0
WireConnection;75;1;76;0
WireConnection;75;2;78;0
WireConnection;0;2;109;0
WireConnection;0;10;101;0
WireConnection;0;11;158;0
WireConnection;0;12;158;0
WireConnection;0;14;77;0
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
ASEEND*/
//CHKSM=9F3183CC082DCE2D73A8FE39549A8100ED37526A