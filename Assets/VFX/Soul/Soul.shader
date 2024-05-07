// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Soul"
{
	Properties
	{
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_Color0("Color 0", Color) = (0.6462264,0.8427672,1,0)
		_Color1("Color 1", Color) = (0.8066038,0.9140461,1,0)
		_RemapMax("RemapMax", Float) = 1
		_RemapMin("RemapMin", Float) = 0
		_NoiseScale("NoiseScale", Float) = 5
		_TimeSpeed("TimeSpeed", Float) = 0
		[Toggle]_isTransparent("isTransparent", Float) = 1
		_HDR_Intensity("HDR_Intensity", Float) = 1
		_Fresnel_Outline("Fresnel_Outline", Vector) = (0,-7,5,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _Color1;
		uniform float _HDR_Intensity;
		uniform float4 _Color0;
		uniform float _TimeSpeed;
		uniform float _NoiseScale;
		uniform float3 _Fresnel_Outline;
		uniform float _isTransparent;
		uniform float _Opacity;
		uniform float _RemapMin;
		uniform float _RemapMax;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult21 = (float2(ase_worldPos.y , ase_worldPos.z));
			float mulTime34 = _Time.y * ( _TimeSpeed * -1.0 );
			float simpleNoise22 = SimpleNoise( ( appendResult21 + mulTime34 )*_NoiseScale );
			float4 lerpResult53 = lerp( ( _Color1 * _HDR_Intensity ) , ( _Color0 * _HDR_Intensity ) , simpleNoise22);
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV56 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode56 = ( _Fresnel_Outline.x + _Fresnel_Outline.y * pow( 1.0 - fresnelNdotV56, _Fresnel_Outline.z ) );
			float4 lerpResult58 = lerp( lerpResult53 , float4( 0,0,0,0 ) , fresnelNode56);
			o.Emission = lerpResult58.rgb;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			o.Alpha = (( _isTransparent )?( saturate( ( (_RemapMin + (ase_vertex3Pos.z - 0.0) * (_RemapMax - _RemapMin) / (1.0 - 0.0)) * _Opacity ) ) ):( _Opacity ));
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Soul;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ToggleSwitchNode;46;-224,208;Inherit;False;Property;_isTransparent;isTransparent;7;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;5;-384,224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-544,224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;6;-768,128;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-976,176;Inherit;False;Property;_RemapMin;RemapMin;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-976,256;Inherit;False;Property;_RemapMax;RemapMax;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;1;-1008,16;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;22;-1360,-272;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;5.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-1568,-272;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1584,-176;Inherit;False;Property;_NoiseScale;NoiseScale;5;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-1824,-272;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;36;-2048,-320;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;34;-1856,-160;Inherit;False;1;0;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-2032,-160;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2240,-160;Inherit;False;Property;_TimeSpeed;TimeSpeed;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1344,-464;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0.6462264,0.8427672,1,0;0.6462264,0.8427672,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;39;-1344,-640;Inherit;False;Property;_Color1;Color 1;2;0;Create;True;0;0;0;False;0;False;0.8066038,0.9140461,1,0;0.8066038,0.9140461,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-848,-640;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-848,-464;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1088,-544;Inherit;False;Property;_HDR_Intensity;HDR_Intensity;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;53;-576,-320;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;58;-312.6411,-128.9343;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;56;-592,-80;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;59;-784,-64;Inherit;False;Property;_Fresnel_Outline;Fresnel_Outline;9;0;Create;True;0;0;0;False;0;False;0,-7,5;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;4;-912,336;Inherit;False;Property;_Opacity;Opacity;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
WireConnection;0;2;58;0
WireConnection;0;9;46;0
WireConnection;46;0;4;0
WireConnection;46;1;5;0
WireConnection;5;0;3;0
WireConnection;3;0;6;0
WireConnection;3;1;4;0
WireConnection;6;0;1;3
WireConnection;6;3;17;0
WireConnection;6;4;18;0
WireConnection;22;0;33;0
WireConnection;22;1;40;0
WireConnection;33;0;21;0
WireConnection;33;1;34;0
WireConnection;21;0;36;2
WireConnection;21;1;36;3
WireConnection;34;0;43;0
WireConnection;43;0;42;0
WireConnection;50;0;39;0
WireConnection;50;1;51;0
WireConnection;52;0;2;0
WireConnection;52;1;51;0
WireConnection;53;0;50;0
WireConnection;53;1;52;0
WireConnection;53;2;22;0
WireConnection;58;0;53;0
WireConnection;58;2;56;0
WireConnection;56;1;59;1
WireConnection;56;2;59;2
WireConnection;56;3;59;3
ASEEND*/
//CHKSM=A70616924E7E8E6F8D8593541ED37DFA7C8E51F4