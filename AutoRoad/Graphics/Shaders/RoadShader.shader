// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RoadShader"
{
	Properties
	{
		_RoadTexture("RoadTexture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry-1" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		ZTest Always
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _RoadTexture;
		uniform float4 _RoadTexture_ST;
		uniform float4 _Color;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_RoadTexture = i.uv_texcoord * _RoadTexture_ST.xy + _RoadTexture_ST.zw;
			float4 temp_output_4_0 = ( tex2D( _RoadTexture, uv_RoadTexture ) * _Color * 2 );
			o.Albedo = temp_output_4_0.rgb;
			o.Emission = temp_output_4_0.rgb;
			int temp_output_45_0 = 0;
			o.Metallic = (float)temp_output_45_0;
			o.Smoothness = (float)temp_output_45_0;
			o.Occlusion = (float)temp_output_45_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
771;98.62717;819;655;1075.2;294.6691;1.656794;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;2;-812,-18;Float;True;Property;_RoadTexture;RoadTexture;0;0;Create;True;0;0;False;0;7223e977a60d13b47ab26716534ad54e;a5c6bbeb37677f64e96a89f022bd1243;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.IntNode;43;-548.1693,419.4789;Float;False;Constant;_Int1;Int 1;7;0;Create;True;0;0;False;0;2;0;0;1;INT;0
Node;AmplifyShaderEditor.SamplerNode;1;-590,-15;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-748.2839,189.326;Float;False;Property;_Color;Color;1;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;25;-1089.355,671.2465;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1295.585,1017.799;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1398.515,663.5845;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;2;False;2;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1695.035,637.6295;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-1697.2,549.5103;Float;False;Property;_GradientDistance;GradientDistance;2;0;Create;True;0;0;False;0;1;1.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-1226.212,669.8515;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-279,55;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;33;-1495.105,1014.233;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-997.773,561.0317;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;32;-1640.592,1019.231;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;29;-2014.944,996.5027;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;27;-947.0518,670.9854;Float;False;Property;_GradientPower;GradientPower;3;0;Create;True;0;0;False;0;2;-1.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-404.9158,955.8952;Float;False;Property;_Blend;Blend;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;26;-827.0703,560.7698;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;38;-786.019,1022.593;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1847.02,1073.147;Float;False;Property;_LayerBlend_noiseSize;LayerBlend_noiseSize;4;0;Create;True;0;0;False;0;20;13.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;36;-1005.193,1020.848;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;35;-1159.826,1020.885;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-906.3441,1161.43;Float;False;Property;_NoisePower;NoisePower;5;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;23;-1556.375,748.6005;Float;False;Constant;_Int0;Int 0;3;0;Create;True;0;0;False;0;2;0;0;1;INT;0
Node;AmplifyShaderEditor.ComponentMaskNode;31;-1840.811,1003.188;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.IntNode;45;-166.8616,153.3184;Float;False;Constant;_Int2;Int 2;7;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.ClampOpNode;13;-659.8386,560.0375;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.HeightMapBlendNode;37;-369.4194,795.1594;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;51;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;RoadShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;2;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;-1;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;28;-2064.943,946.5027;Float;False;1221.998;325.7307;Noise;0;;1,1,1,1;0;0
WireConnection;1;0;2;0
WireConnection;25;0;24;0
WireConnection;34;0;33;0
WireConnection;22;0;5;1
WireConnection;22;1;19;0
WireConnection;22;2;23;0
WireConnection;24;0;22;0
WireConnection;24;1;19;0
WireConnection;4;0;1;0
WireConnection;4;1;3;0
WireConnection;4;2;43;0
WireConnection;33;0;32;0
WireConnection;21;0;19;0
WireConnection;21;1;25;0
WireConnection;32;0;31;0
WireConnection;32;1;30;0
WireConnection;26;0;21;0
WireConnection;26;1;27;0
WireConnection;38;0;36;0
WireConnection;38;1;39;0
WireConnection;36;0;35;0
WireConnection;35;0;34;0
WireConnection;31;0;29;0
WireConnection;13;0;26;0
WireConnection;37;0;38;0
WireConnection;37;1;13;0
WireConnection;37;2;40;0
WireConnection;51;0;4;0
WireConnection;51;2;4;0
WireConnection;51;3;45;0
WireConnection;51;4;45;0
WireConnection;51;5;45;0
ASEEND*/
//CHKSM=018264C481D8E54FB244CD01A35AA02439090E2A