// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Aura"
{
	Properties
	{
		_DepthFade_Distance("DepthFade_Distance", Float) = 2
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		_Fresnel_Parameters("Fresnel_Parameters", Vector) = (0,1,5,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPosition1;
			float3 worldPos;
			float3 viewDir;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float4 _Color0;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFade_Distance;
		uniform float3 _Fresnel_Parameters;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos1 = ase_vertex3Pos;
			float4 ase_screenPos1 = ComputeScreenPos( UnityObjectToClipPos( vertexPos1 ) );
			o.screenPosition1 = ase_screenPos1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 temp_output_9_0 = _Color0;
			o.Emission = temp_output_9_0.rgb;
			float4 ase_screenPos1 = i.screenPosition1;
			float4 ase_screenPosNorm1 = ase_screenPos1 / ase_screenPos1.w;
			ase_screenPosNorm1.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm1.z : ase_screenPosNorm1.z * 0.5 + 0.5;
			float screenDepth1 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm1.xy ));
			float distanceDepth1 = saturate( abs( ( screenDepth1 - LinearEyeDepth( ase_screenPosNorm1.z ) ) / ( _DepthFade_Distance ) ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV10 = dot( ase_worldNormal, i.viewDir );
			float fresnelNode10 = ( _Fresnel_Parameters.x + _Fresnel_Parameters.y * pow( 1.0 - fresnelNdotV10, _Fresnel_Parameters.z ) );
			float temp_output_17_0 = saturate( ( ( 1.0 - distanceDepth1 ) + saturate( fresnelNode10 ) ) );
			float lerpResult20 = lerp( 0.075 , 1.0 , temp_output_17_0);
			o.Alpha = lerpResult20;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.ColorNode;9;-655.8245,-109.8589;Inherit;False;Property;_Color0;Color 0;1;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-688,208;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;2;-1392,80;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;1;-1168,80;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1424,224;Inherit;False;Property;_DepthFade_Distance;DepthFade_Distance;0;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;4;-912,80;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;12;-912,320;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;14;-1504,320;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;15;-1504,464;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;19;-1504,608;Inherit;False;Property;_Fresnel_Parameters;Fresnel_Parameters;2;0;Create;True;0;0;0;False;0;False;0,1,5;0,1,5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;10;-1200,320;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,-16;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Aura;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-224,32;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;17;-560,208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;-400,160;Inherit;False;3;0;FLOAT;0.075;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
WireConnection;16;0;4;0
WireConnection;16;1;12;0
WireConnection;1;1;2;0
WireConnection;1;0;3;0
WireConnection;4;0;1;0
WireConnection;12;0;10;0
WireConnection;10;0;14;0
WireConnection;10;4;15;0
WireConnection;10;1;19;1
WireConnection;10;2;19;2
WireConnection;10;3;19;3
WireConnection;0;2;9;0
WireConnection;0;9;20;0
WireConnection;8;0;9;0
WireConnection;8;1;17;0
WireConnection;17;0;16;0
WireConnection;20;2;17;0
ASEEND*/
//CHKSM=B44EAE305D67AE1B40CEECB92706EB435F7D3AEB