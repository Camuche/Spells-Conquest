// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lava"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 15
		_TessMin( "Tess Min Distance", Float ) = 5
		_TessMax( "Tess Max Distance", Float ) = 50
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_SpherePosition("Sphere Position", Vector) = (0,0,0,0)
		_CircleSize("CircleSize", Float) = 4
		_FlowMap1("FlowMap", 2D) = "white" {}
		_Disto1("Disto", Range( 0 , 1)) = 0
		_SpeedDisto1("SpeedDisto", Float) = 0
		_OffsetStrength1("OffsetStrength", Float) = 0
		[HDR]_Color5("Color 5", Color) = (4,0.345098,0,0)
		_Noise_Scale("Noise_Scale", Float) = 0
		_Vector2("Vector 2", Vector) = (0,0,0,0)
		_Remap2("Remap2", Float) = 0
		_Albedo("Albedo", 2D) = "white" {}
		[HDR]_Color6("Color 6", Color) = (0,0,0,0)
		_normal("normal", 2D) = "white" {}
		_Roughness("Roughness", 2D) = "white" {}
		_Rock_Size("Rock_Size", Float) = 0
		_Float3("Float 3", Float) = 0
		_FlowMapSize("FlowMapSize", Float) = 1
		[HDR]_Color4("Color 4", Color) = (0,0,0,0)
		_Rock_Color("Rock_Color", Color) = (0,0,0,0)
		_Rock_Roughness_Intensity("Rock_Roughness_Intensity", Float) = 0
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

		uniform float _Float3;
		uniform sampler2D _FlowMap1;
		uniform float _FlowMapSize;
		uniform float _Disto1;
		uniform float _SpeedDisto1;
		uniform float _OffsetStrength1;
		uniform sampler2D _normal;
		uniform float _Rock_Size;
		uniform float _Noise_Scale;
		uniform float2 _Vector2;
		uniform sampler2D _Albedo;
		uniform float4 _Rock_Color;
		uniform float4 _Color4;
		uniform float4 _Color5;
		uniform float4 _Color6;
		uniform float _Remap2;
		uniform sampler2D _Roughness;
		uniform float _Rock_Roughness_Intensity;
		uniform float3 _SpherePosition;
		uniform float4 positionsArray[3];
		uniform float _CircleSize;
		uniform float _Cutoff = 0.5;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;


		float2 voronoihash302( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi302( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash302( n + g );
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


		float2 voronoihash317( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi317( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash317( n + g );
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


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
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
			float time302 = 0.0;
			float2 voronoiSmoothId302 = 0;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult167 = (float2(ase_worldPos.x , ase_worldPos.z));
			float4 lerpResult308 = lerp( float4( ( appendResult167 * _Float3 ), 0.0 , 0.0 ) , tex2Dlod( _FlowMap1, float4( ( appendResult167 * _FlowMapSize ), 0, 0.0) ) , _Disto1);
			float mulTime309 = _Time.y * _SpeedDisto1;
			float4 temp_output_310_0 = ( lerpResult308 + mulTime309 );
			float2 coords302 = temp_output_310_0.rg * _Float3;
			float2 id302 = 0;
			float2 uv302 = 0;
			float voroi302 = voronoi302( coords302, time302, id302, uv302, 0, voronoiSmoothId302 );
			float simplePerlin2D303 = snoise( temp_output_310_0.rg*_Float3 );
			simplePerlin2D303 = simplePerlin2D303*0.5 + 0.5;
			float time317 = 0.0;
			float2 voronoiSmoothId317 = 0;
			float mulTime323 = _Time.y * ( _SpeedDisto1 / -1.0 );
			float4 temp_output_324_0 = ( lerpResult308 + mulTime323 );
			float2 coords317 = temp_output_324_0.rg * _Float3;
			float2 id317 = 0;
			float2 uv317 = 0;
			float voroi317 = voronoi317( coords317, time317, id317, uv317, 0, voronoiSmoothId317 );
			float simplePerlin2D318 = snoise( temp_output_324_0.rg*_Float3 );
			simplePerlin2D318 = simplePerlin2D318*0.5 + 0.5;
			float temp_output_329_0 = ( ( voroi302 * simplePerlin2D303 ) + ( voroi317 * simplePerlin2D318 ) );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 temp_output_297_0 = ( temp_output_329_0 * _OffsetStrength1 * ase_vertexNormal );
			v.vertex.xyz += temp_output_297_0;
			v.vertex.w = 1;
			v.normal = temp_output_297_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult167 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_245_0 = ( appendResult167 * _Rock_Size );
			float simpleNoise177 = SimpleNoise( appendResult167*_Noise_Scale );
			float clampResult190 = clamp( (_Vector2.x + (simpleNoise177 - 0.0) * (_Vector2.y - _Vector2.x) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float temp_output_243_0 = ( 1.0 - clampResult190 );
			float4 lerpResult241 = lerp( float4( 0,0,0,0 ) , tex2D( _normal, temp_output_245_0 ) , temp_output_243_0);
			o.Normal = lerpResult241.rgb;
			float4 tex2DNode237 = tex2D( _Albedo, temp_output_245_0 );
			float4 lerpResult240 = lerp( float4( 0,0,0,0 ) , ( tex2DNode237 * _Rock_Color ) , temp_output_243_0);
			o.Albedo = lerpResult240.rgb;
			float4 lerpResult266 = lerp( float4( 0,0,0,0 ) , ( step( ( tex2DNode237.r * 0.85 ) , 0.3 ) * _Color4 ) , ( 1.0 - step( temp_output_243_0 , 0.936 ) ));
			float time302 = 0.0;
			float2 voronoiSmoothId302 = 0;
			float4 lerpResult308 = lerp( float4( ( appendResult167 * _Float3 ), 0.0 , 0.0 ) , tex2D( _FlowMap1, ( appendResult167 * _FlowMapSize ) ) , _Disto1);
			float mulTime309 = _Time.y * _SpeedDisto1;
			float4 temp_output_310_0 = ( lerpResult308 + mulTime309 );
			float2 coords302 = temp_output_310_0.rg * _Float3;
			float2 id302 = 0;
			float2 uv302 = 0;
			float voroi302 = voronoi302( coords302, time302, id302, uv302, 0, voronoiSmoothId302 );
			float simplePerlin2D303 = snoise( temp_output_310_0.rg*_Float3 );
			simplePerlin2D303 = simplePerlin2D303*0.5 + 0.5;
			float time317 = 0.0;
			float2 voronoiSmoothId317 = 0;
			float mulTime323 = _Time.y * ( _SpeedDisto1 / -1.0 );
			float4 temp_output_324_0 = ( lerpResult308 + mulTime323 );
			float2 coords317 = temp_output_324_0.rg * _Float3;
			float2 id317 = 0;
			float2 uv317 = 0;
			float voroi317 = voronoi317( coords317, time317, id317, uv317, 0, voronoiSmoothId317 );
			float simplePerlin2D318 = snoise( temp_output_324_0.rg*_Float3 );
			simplePerlin2D318 = simplePerlin2D318*0.5 + 0.5;
			float temp_output_329_0 = ( ( voroi302 * simplePerlin2D303 ) + ( voroi317 * simplePerlin2D318 ) );
			float temp_output_342_0 = (0.0 + (temp_output_329_0 - 0.0) * (1.5 - 0.0) / (1.0 - 0.0));
			float4 lerpResult183 = lerp( lerpResult266 , ( temp_output_342_0 * _Color5 ) , clampResult190);
			float clampResult212 = clamp( (_Remap2 + (clampResult190 - 0.0) * (1.0 - _Remap2) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float4 lerpResult210 = lerp( lerpResult183 , ( temp_output_342_0 * _Color6 ) , clampResult212);
			o.Emission = lerpResult210.rgb;
			o.Metallic = 0.0;
			float4 lerpResult242 = lerp( float4( 0,0,0,0 ) , tex2D( _Roughness, temp_output_245_0 ) , temp_output_243_0);
			o.Smoothness = ( lerpResult242 * _Rock_Roughness_Intensity ).r;
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
Node;AmplifyShaderEditor.CommentaryNode;358;7162.447,-534.311;Inherit;False;842.5449;333.7129;DepthFade;5;333;346;352;353;347;DepthFade;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;354;4030,702;Inherit;False;2587;1072;Distortion;22;329;301;316;317;303;302;318;324;323;328;310;308;309;311;307;305;306;338;312;331;339;355;Distortion;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;234;2896,-816;Inherit;False;2965.765;972.3643;Emissive;27;183;243;266;269;267;268;210;216;211;185;177;189;187;196;209;190;208;197;195;198;184;213;212;274;275;342;357;Emissive;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;89;4710.197,1883.551;Inherit;False;1927.85;470.0797;substractLava;12;101;100;99;98;97;96;95;94;93;92;91;90;substractLava;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;90;4760.197,1936.659;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;92;4992.222,1936.623;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleSubtractOpNode;93;5365.82,1933.551;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;95;5348.461,2082.806;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;94;5350.28,2190.665;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;97;5736.693,2054.399;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;98;5970.717,2159.631;Float;False;Property;_CircleSize;CircleSize;7;0;Create;True;0;0;0;False;0;False;4;6.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;100;6292.485,2056.633;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;101;6467.046,2053.843;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;96;5685.486,2213.632;Inherit;False;positionsArray;0;3;2;True;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;99;5975.486,2055.633;Float;False;float closest=10000@$float now=0@$for(int i=0@ i<positionsArray.Length@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;Create;2;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;DistanceCheck;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;91;4942.902,2132.038;Inherit;False;Property;_SpherePosition;Sphere Position;6;0;Create;True;0;0;0;False;0;False;0,0,0;0,1E+13,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;68;-1530.488,15.40344;Inherit;False;Property;_Step0;Step0;16;0;Create;True;0;0;0;False;0;False;0;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1442.686,349.0594;Inherit;False;Property;_Step1;Step1;18;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;67;-1275.679,-42.30443;Inherit;False;Step Antialiasing;-1;;26;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;42;-1274.533,266.8735;Inherit;False;Step Antialiasing;-1;;27;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1523.788,567.5851;Inherit;False;Property;_Step2;Step2;20;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;70;-1004.469,-84.88849;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1520.286,647.8993;Inherit;False;Property;_Step3;Step3;22;0;Create;True;0;0;0;False;0;False;0;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;-825.5718,226.5073;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;48;-1264.994,474.7452;Inherit;False;Step Antialiasing;-1;;28;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;57;-469.3532,452.3481;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;49;-1252.755,621.7141;Inherit;False;Step Antialiasing;-1;;29;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;58;-132.0311,769.0897;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;60;-852.9786,349.5027;Inherit;False;Property;_Color2;Color 2;27;0;Create;True;0;0;0;False;0;False;0,0,1,0;1,0.1709029,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;61;-512.5867,593.0876;Inherit;False;Property;_Color3;Color 3;28;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;69;-1493.981,-234.2767;Inherit;False;Property;_Color05;Color 0.5;25;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;4.867144,1.04478,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;59;-1284.542,61.16684;Inherit;False;Property;_Color1;Color 1;26;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;1,0.2778975,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;55;-1499.226,-418.0536;Inherit;False;Property;_Color0;Color 0;24;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;1.844303,1.264941,0.6083302,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-1539.204,-1733.116;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;106;-1893.246,-1608.606;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;138;-214.4805,-1196.674;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;140;-35.58334,-885.2773;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;142;320.6352,-659.4366;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;144;657.9575,-342.6949;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-740.4995,-1096.382;Inherit;False;Property;_Step0bis;Step0bis;17;0;Create;True;0;0;0;False;0;False;0;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-652.6974,-762.7254;Inherit;False;Property;_Step1bis;Step1bis;19;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-733.7994,-544.1996;Inherit;False;Property;_Step2bis;Step2bis;21;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-730.2975,-463.8854;Inherit;False;Property;_Step3bis;Step3bis;23;0;Create;True;0;0;0;False;0;False;0;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;150;-469.5325,-1180.317;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;151;-381.5325,-831.5167;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;152;-367.1324,-636.3168;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;153;-402.3325,-474.7168;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;104;-1857.516,-1736.364;Inherit;False;Constant;_Vector1;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.VoronoiNode;107;-1074.525,-1667.245;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;7.52;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;103;-1347.517,-1666.317;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3.36,0.19;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;157;-1457.686,-1415.51;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-2062.146,-1608.606;Inherit;False;Property;_LavafallSpeed;LavafallSpeed;8;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-1632.686,-1485.51;Inherit;False;Property;_LavafallTilingX;LavafallTilingX;34;0;Create;True;0;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-1633.686,-1405.51;Inherit;False;Property;_LavafallTilingY;LavafallTilingY;35;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;109;950.0657,542.2985;Inherit;False;Property;_Lavafall;Lavafall;32;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;158;740.1299,917.9675;Inherit;False;Property;_Lavafall2;Lavafall2;33;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;424.6514,478.7385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;164;457.449,378.6434;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;160.5732,511.0333;Inherit;False;Property;_OffsetStrengthbis;OffsetStrengthbis;31;0;Create;True;0;0;0;False;0;False;0;0.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;223;2704,-336;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;224;2480,-304;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;212;4800,-64;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;213;4464,-576;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;184;4016,-544;Inherit;False;Property;_Color5;Color 5;36;1;[HDR];Create;True;0;0;0;False;0;False;4,0.345098,0,0;47.93726,9.537255,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;198;4240,-672;Inherit;False;Property;_Remap;Remap;40;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;197;4432,-768;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;208;4576,-64;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;190;4096,-192;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;209;4400,16;Inherit;False;Property;_Remap2;Remap2;41;0;Create;True;0;0;0;False;0;False;0;-0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;3776,-704;Inherit;False;Property;_ScaleNoiseTexture;ScaleNoiseTexture;39;0;Create;True;0;0;0;False;0;False;0;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;2288.788,-324.5535;Inherit;False;Property;_TimeSpeed;TimeSpeed;42;0;Create;True;0;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;249;6377.891,143.9949;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;242;6041.891,143.9949;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;253;5993.891,351.9951;Inherit;False;Property;_Rock_Roughness_Intensity;Rock_Roughness_Intensity;53;0;Create;True;0;0;0;False;0;False;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;7472,464;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Lava;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;0;15;5;50;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;5;-1;-1;0;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;245;2944,-1408;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;246;2640,-1376;Inherit;False;Property;_Rock_Size;Rock_Size;47;0;Create;True;0;0;0;False;0;False;0;0.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;237;3488,-1632;Inherit;True;Property;_Albedo;Albedo;43;0;Create;True;0;0;0;False;0;False;-1;None;75328d36bbc1c4f48861f277c2b3b0c1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;238;3488,-1440;Inherit;True;Property;_normal;normal;45;0;Create;True;0;0;0;False;0;False;-1;None;1b8245471349dea4780491afef1d08b6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;239;3488,-1248;Inherit;True;Property;_Roughness;Roughness;46;0;Create;True;0;0;0;False;0;False;-1;None;fe43f7517b642074386a0fe966bf0195;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;247;4016,-1632;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;240;6176,-1632;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;211;4464,-288;Inherit;False;Property;_Color6;Color 6;44;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;47.93726,0.5019608,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;216;4816,-352;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;210;5600,-368;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;268;4640,-704;Inherit;False;Constant;_Float2;Float 2;50;0;Create;True;0;0;0;False;0;False;0.936;0.936;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;267;4848,-736;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;269;4976,-736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;266;5184,-784;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;183;5328,-560;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;241;6176,-880;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;273;5185.454,-1205.098;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleNode;270;4368,-1216;Inherit;False;0.85;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;261;4624,-1216;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;263;4336,-1136;Inherit;False;Constant;_Float1;Float 1;47;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;4896,-1008;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;243;4640,-464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;274;5025.421,-360.9934;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;275;5423.032,-748.4172;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;265;4608,-992;Inherit;False;Property;_Color4;Color 4;51;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;11.98431,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;250;3552,-1808;Inherit;False;Property;_Rock_Color;Rock_Color;52;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.6037736,0.2135992,0.2135992,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;185;2976,-176;Inherit;False;Property;_Noise_Scale;Noise_Scale;37;0;Create;True;0;0;0;False;0;False;0;2.99;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;187;3600,-208;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;189;3440,-144;Inherit;False;Property;_Vector2;Vector 2;38;0;Create;True;0;0;0;False;0;False;0,0;-0.38,0.86;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;276;3589.015,-725.8406;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;195;4000,-768;Inherit;True;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;177;3200,-208;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;6.81;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;167;2432,-768;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;173;2240,-800;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;307.5886,976.8096;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-33.21582,1086.189;Inherit;False;Property;_OffsetStrength;OffsetStrength;29;0;Create;True;0;0;0;False;0;False;0;0.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;78;6.7677,1247.337;Inherit;False;Constant;_Vector0;Vector 0;15;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;18;-3995.775,-115.4346;Inherit;False;Property;_Tiling;Tiling;11;0;Create;True;0;0;0;False;0;False;1;4.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1788.633,325.5395;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;1;-2194.643,245.5152;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;17;-2259.946,556.5942;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-3499.835,225.4973;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-3565.1,679.1956;Inherit;False;Property;_Disto;Disto;12;0;Create;True;0;0;0;False;0;False;0;0.761;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-3468.232,761.4728;Inherit;False;Property;_SpeedDisto;SpeedDisto;15;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-3584.304,487.708;Inherit;True;Property;_FlowMap;FlowMap;10;0;Create;True;0;0;0;False;0;False;-1;e5fc194be4ef2994a936322b74927473;e5fc194be4ef2994a936322b74927473;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;30;-3107.13,470.4836;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;26;-3088.532,606.1944;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-2873.692,470.6956;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;342;4272,-352;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;297;7136,768;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;330;6816,816;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;298;6816,736;Inherit;False;Property;_OffsetStrength1;OffsetStrength;30;0;Create;True;0;0;0;False;0;False;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;255;7088,528;Inherit;False;Constant;_Float0;Float 0;47;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;329;6384,1024;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;6096,1024;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;316;6096,1248;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;317;5792,1248;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;303;5744,1024;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;302;5792,752;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;318;5744,1520;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;324;5504,1248;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;323;5248,1280;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;328;5120,1280;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;310;5504,752;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;308;5216,752;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;309;5184,864;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;311;4784,752;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;307;4656,848;Inherit;True;Property;_FlowMap1;FlowMap;9;0;Create;True;0;0;0;False;0;False;-1;e5fc194be4ef2994a936322b74927473;e5fc194be4ef2994a936322b74927473;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;305;4656,1040;Inherit;False;Property;_Disto1;Disto;13;0;Create;True;0;0;0;False;0;False;0;0.761;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;306;4752,1120;Inherit;False;Property;_SpeedDisto1;SpeedDisto;14;0;Create;True;0;0;0;False;0;False;0;0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;338;4304,864;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;312;4208,1424;Inherit;False;Property;_Float3;Float 3;48;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;331;4464,944;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;339;4080,880;Inherit;False;Property;_FlowMapSize;FlowMapSize;50;0;Create;True;0;0;0;False;0;False;1;0.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;355;6551.329,906.9301;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;357;3995.452,-76.81384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;333;7237.172,-331.0507;Inherit;False;Property;_DepthFade;DepthFade;49;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;346;7669.225,-361.5981;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;352;7405.447,-362.3109;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;353;7212.447,-484.3109;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;347;7826.992,-446.292;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
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
WireConnection;223;0;167;0
WireConnection;223;1;224;0
WireConnection;224;0;236;0
WireConnection;212;0;208;0
WireConnection;213;0;342;0
WireConnection;213;1;184;0
WireConnection;197;0;195;0
WireConnection;197;4;198;0
WireConnection;208;0;190;0
WireConnection;208;3;209;0
WireConnection;190;0;187;0
WireConnection;249;0;242;0
WireConnection;249;1;253;0
WireConnection;242;1;239;0
WireConnection;242;2;274;0
WireConnection;0;0;240;0
WireConnection;0;1;241;0
WireConnection;0;2;210;0
WireConnection;0;3;255;0
WireConnection;0;4;249;0
WireConnection;0;10;101;0
WireConnection;0;11;297;0
WireConnection;0;12;297;0
WireConnection;245;0;167;0
WireConnection;245;1;246;0
WireConnection;237;1;245;0
WireConnection;238;1;245;0
WireConnection;239;1;245;0
WireConnection;247;0;237;0
WireConnection;247;1;250;0
WireConnection;240;1;247;0
WireConnection;240;2;275;0
WireConnection;216;0;342;0
WireConnection;216;1;211;0
WireConnection;210;0;183;0
WireConnection;210;1;216;0
WireConnection;210;2;212;0
WireConnection;267;0;243;0
WireConnection;267;1;268;0
WireConnection;269;0;267;0
WireConnection;266;1;264;0
WireConnection;266;2;269;0
WireConnection;183;0;266;0
WireConnection;183;1;213;0
WireConnection;183;2;190;0
WireConnection;241;1;273;0
WireConnection;241;2;243;0
WireConnection;273;0;238;0
WireConnection;270;0;237;1
WireConnection;261;0;270;0
WireConnection;261;1;263;0
WireConnection;264;0;261;0
WireConnection;264;1;265;0
WireConnection;243;0;190;0
WireConnection;274;0;243;0
WireConnection;275;0;243;0
WireConnection;187;0;177;0
WireConnection;187;3;189;1
WireConnection;187;4;189;2
WireConnection;195;0;223;0
WireConnection;195;1;196;0
WireConnection;177;0;167;0
WireConnection;177;1;185;0
WireConnection;167;0;173;1
WireConnection;167;1;173;3
WireConnection;75;0;20;0
WireConnection;75;1;76;0
WireConnection;75;2;78;0
WireConnection;20;0;1;0
WireConnection;20;1;17;0
WireConnection;1;0;27;0
WireConnection;1;2;18;0
WireConnection;17;0;27;0
WireConnection;17;1;18;0
WireConnection;19;0;18;0
WireConnection;30;0;19;0
WireConnection;30;1;24;0
WireConnection;30;2;31;0
WireConnection;26;0;28;0
WireConnection;27;0;30;0
WireConnection;27;1;26;0
WireConnection;342;0;357;0
WireConnection;297;0;329;0
WireConnection;297;1;298;0
WireConnection;297;2;330;0
WireConnection;329;0;301;0
WireConnection;329;1;316;0
WireConnection;301;0;302;0
WireConnection;301;1;303;0
WireConnection;316;0;317;0
WireConnection;316;1;318;0
WireConnection;317;0;324;0
WireConnection;317;2;312;0
WireConnection;303;0;310;0
WireConnection;303;1;312;0
WireConnection;302;0;310;0
WireConnection;302;2;312;0
WireConnection;318;0;324;0
WireConnection;318;1;312;0
WireConnection;324;0;308;0
WireConnection;324;1;323;0
WireConnection;323;0;328;0
WireConnection;328;0;306;0
WireConnection;310;0;308;0
WireConnection;310;1;309;0
WireConnection;308;0;311;0
WireConnection;308;1;307;0
WireConnection;308;2;305;0
WireConnection;309;0;306;0
WireConnection;311;0;167;0
WireConnection;311;1;331;0
WireConnection;307;1;338;0
WireConnection;338;0;167;0
WireConnection;338;1;339;0
WireConnection;331;0;312;0
WireConnection;355;0;329;0
WireConnection;357;0;355;0
WireConnection;346;0;352;0
WireConnection;352;1;353;0
WireConnection;352;0;333;0
WireConnection;347;0;210;0
WireConnection;347;1;346;0
ASEEND*/
//CHKSM=DB573163C0F396E974258E43BC823F7D4E400842