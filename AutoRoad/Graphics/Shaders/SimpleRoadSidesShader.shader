// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SimpleRoadSidesShader"
{
	Properties
	{
		_GradientDistance("GradientDistance", Float) = 1
		_GradientPower("GradientPower", Float) = 2
		_Multiply("Multiply", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Background"  "Queue" = "Background+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _GradientDistance;
		uniform float _Multiply;
		uniform float _GradientPower;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float temp_output_9_0 = pow( ( ( 1.0 - abs( ( ( i.uv_texcoord.x - 0.5 ) * 2.0 * _GradientDistance ) ) ) * _Multiply ) , _GradientPower );
			float3 temp_cast_0 = (temp_output_9_0).xxx;
			o.Emission = temp_cast_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
771;92;819;655;1035.776;338.5384;1.697504;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1766.191,330.9836;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-1558.485,431.404;Float;False;Property;_GradientDistance;GradientDistance;2;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;59;-1491.308,321.702;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1300.231,360.7968;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;64;-1170.892,361.8474;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;53;-1049.341,353.8356;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-981.5956,493.1162;Float;False;Property;_Multiply;Multiply;8;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-846.0908,563.0415;Float;False;Property;_GradientPower;GradientPower;4;0;Create;True;0;0;False;0;2;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-857.8057,353.8528;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;-660.0071,-1093.117;Float;False;Property;_GrassLayerColor2;GrassLayerColor2;3;0;Create;True;0;0;False;0;0.7924528,0.6174311,0.3027768,1;0.7948164,0.8490566,0.5486828,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;42;-310.8078,-150.68;Float;False;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;40;-92.48177,-477.4243;Float;False;Constant;_Int3;Int 3;5;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.ColorNode;39;-662.1674,-920.4938;Float;False;Property;_GrassLayerColor;GrassLayerColor;7;0;Create;True;0;0;False;0;0.5644689,0.7830189,0.4690726,1;0.627451,0.8078432,0.4392157,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-555.6685,-150.6671;Float;False;2;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;34;-719.6687,-149.7637;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;41;-82.92247,-557.9852;Float;False;Constant;_Int4;Int 4;5;0;Create;True;0;0;False;0;1;0;0;1;INT;0
Node;AmplifyShaderEditor.FloorOpNode;37;-425.2072,-151.0822;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;47;247.2036,-790.403;Float;False;Constant;_Int5;Int 5;4;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.ClampOpNode;46;-1279.169,6.93736;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;49;198.3351,-941.9313;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;43;70.62518,-626.8518;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;INT;0;False;3;INT;0;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;44;-367.2707,-940.8553;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;57;-107.4993,-141.6426;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;-471.7605,-1281.69;Float;False;Property;_GroundLayerColor;GroundLayerColor;5;0;Create;True;0;0;False;0;0.7924528,0.6174311,0.3027768,1;0.9339623,0.9115112,0.7004717,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;35;-486.7342,-46.92009;Float;False;Property;_BlendSteps;BlendSteps;6;0;Create;True;0;0;False;0;1;3;0;1;INT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;23;-1961.213,-218.6496;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;27;-1769.855,9.430341;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-1539.48,-211.885;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;22;-2161.431,-234.693;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;24;-1963.293,163.8427;Float;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;False;0;1,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;26;-1923.375,14.58653;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-2074.485,17.05205;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;500,-1000;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;28;-1761.66,-218.9457;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;9;-642.2745,350.6089;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;20;-2335.563,-241.3779;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-905.3774,-87.23021;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-1312.467,-113.8431;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;31;-1430.25,7.998273;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-1566.413,7.998273;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2167.64,-164.7336;Float;False;Property;_NoiseSize12;NoiseSize12;1;0;Create;True;0;0;False;0;20;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;32;-1403.318,-211.885;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;72;-359.7156,407.6295;Float;False;Constant;_Int0;Int 0;9;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;74;-194.2824,308.1176;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;SimpleRoadSidesShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Background;;Background;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;59;0;1;1
WireConnection;60;0;59;0
WireConnection;60;2;2;0
WireConnection;64;0;60;0
WireConnection;53;0;64;0
WireConnection;67;0;53;0
WireConnection;67;1;69;0
WireConnection;42;0;37;0
WireConnection;42;1;35;0
WireConnection;36;0;34;0
WireConnection;36;1;35;0
WireConnection;34;0;65;0
WireConnection;37;0;36;0
WireConnection;46;0;31;0
WireConnection;49;0;45;0
WireConnection;49;1;44;0
WireConnection;49;2;43;0
WireConnection;43;0;42;0
WireConnection;43;2;41;0
WireConnection;43;3;40;0
WireConnection;43;4;40;0
WireConnection;44;0;38;0
WireConnection;44;1;39;0
WireConnection;44;2;42;0
WireConnection;57;0;42;0
WireConnection;23;0;22;0
WireConnection;23;1;21;0
WireConnection;27;0;26;0
WireConnection;29;0;28;0
WireConnection;29;2;27;0
WireConnection;22;0;20;0
WireConnection;26;0;25;0
WireConnection;26;1;24;0
WireConnection;25;0;23;0
WireConnection;28;0;23;0
WireConnection;9;0;67;0
WireConnection;9;1;8;0
WireConnection;65;0;33;0
WireConnection;65;1;9;0
WireConnection;33;0;32;0
WireConnection;33;1;31;0
WireConnection;31;0;30;0
WireConnection;30;0;27;0
WireConnection;32;0;29;0
WireConnection;74;2;9;0
ASEEND*/
//CHKSM=F6AF52B908E698844D36C07E19A5FF65EFA1F4EA