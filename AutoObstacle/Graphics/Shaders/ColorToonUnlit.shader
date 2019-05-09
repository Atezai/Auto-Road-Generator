// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ColorToonUnlit"
{
	Properties
	{
		_Color1("Color 1", Color) = (0,0,0,0)
		_Color0("Color 0", Color) = (0,0,0,0)
		_SunDir("SunDir", Vector) = (0,0,0,0)
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		

		Pass
		{
			Name "Unlit"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float3 ase_normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			uniform float4 _Color0;
			uniform float4 _Color1;
			uniform float3 _SunDir;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord.xyz = ase_worldNormal;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				fixed4 finalColor;
				float3 ase_worldNormal = i.ase_texcoord.xyz;
				float dotResult4 = dot( ase_worldNormal , _SunDir );
				float clampResult11 = clamp( ( floor( dotResult4 ) / 3.0 ) , 0.0 , 1.0 );
				float4 lerpResult3 = lerp( _Color0 , _Color1 , clampResult11);
				
				
				finalColor = lerpResult3;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16100
902;92;688;655;863.2953;393.7579;1.9;True;False
Node;AmplifyShaderEditor.WorldNormalVector;5;-451.9195,380.0311;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;6;-492.8259,563.7231;Float;False;Property;_SunDir;SunDir;2;0;Create;True;0;0;False;0;0,0,0;0,1,-3.2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;4;-228.1195,429.7309;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;8;-77.64534,436.5419;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;12;67.70473,438.4421;Float;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-283.7,-82.29998;Float;False;Property;_Color0;Color 0;1;0;Create;True;0;0;False;0;0,0,0,0;0.5284036,0.5660378,0.4672482,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;11;200.7048,438.4422;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-286.7196,100.531;Float;False;Property;_Color1;Color 1;0;0;Create;True;0;0;False;0;0,0,0,0;0.4783463,0.7075472,0.4572357,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-181.195,575.2419;Float;False;Constant;_ShadowStrength;ShadowStrength;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;30.65474,611.342;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;3;-33.21948,6.931;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;228.5999,3.4;Float;False;True;2;Float;ASEMaterialInspector;0;1;ColorToonUnlit;0770190933193b94aaa3065e307002fa;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;4;0;5;0
WireConnection;4;1;6;0
WireConnection;8;0;4;0
WireConnection;12;0;8;0
WireConnection;11;0;12;0
WireConnection;9;0;4;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;3;2;11;0
WireConnection;0;0;3;0
ASEEND*/
//CHKSM=3D4564D316B15D371F196A7887D122ACCF836035