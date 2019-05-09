// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SimpleGroundShader"
{
	Properties
	{
		_GrassLayerColor2("GrassLayerColor2", Color) = (0.7924528,0.6174311,0.3027768,1)
		_GroundLayerColor("GroundLayerColor", Color) = (0.7924528,0.6174311,0.3027768,1)
		_GroundLayerInnerColor("GroundLayerInnerColor", Color) = (0.7735849,0.5726988,0.3028658,1)
		_Noise2_Size("Noise2_Size", Vector) = (1,2,0,0)
		_Noise_Size("Noise_Size", Vector) = (1,2,0,0)
		_BlendSteps("BlendSteps", Int) = 1
		_GrassLayerColor("GrassLayerColor", Color) = (0.5644689,0.7830189,0.4690726,1)
		_GrassOpacity("GrassOpacity", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Background"  "Queue" = "Geometry-2" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		ZTest Always
		GrabPass{ }
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
		};

		uniform float4 _GroundLayerColor;
		uniform float4 _GroundLayerInnerColor;
		uniform float2 _Noise_Size;
		uniform float2 _Noise2_Size;
		uniform sampler2D _GrabTexture;
		uniform float4 _GrassLayerColor2;
		uniform float4 _GrassLayerColor;
		uniform int _BlendSteps;
		uniform float _GrassOpacity;


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


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_9_0 = (ase_worldPos).xy;
			float simplePerlin2D11 = snoise( ( temp_output_9_0 / _Noise_Size ) );
			float simplePerlin2D26 = snoise( ( ( temp_output_9_0 + float2( 500,-1000 ) ) / _Noise2_Size ) );
			float temp_output_75_0 = ( 1.0 - ( simplePerlin2D11 + simplePerlin2D26 ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor46 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float temp_output_47_0 = ( 1.0 - screenColor46.r );
			float clampResult83 = clamp( ( temp_output_75_0 * temp_output_47_0 ) , 0.0 , 1.0 );
			float4 lerpResult67 = lerp( _GroundLayerColor , _GroundLayerInnerColor , clampResult83);
			float clampResult12 = clamp( ( temp_output_75_0 * temp_output_47_0 ) , 0.0 , 1.0 );
			float temp_output_14_0 = ( floor( ( clampResult12 * _BlendSteps ) ) / _BlendSteps );
			float4 lerpResult7 = lerp( _GrassLayerColor2 , _GrassLayerColor , temp_output_14_0);
			float ifLocalVar35 = 0;
			if( temp_output_14_0 <= ( temp_output_14_0 * _GrassOpacity ) )
				ifLocalVar35 = (float)0;
			else
				ifLocalVar35 = (float)1;
			float4 lerpResult37 = lerp( lerpResult67 , lerpResult7 , ifLocalVar35);
			o.Albedo = lerpResult37.rgb;
			o.Emission = lerpResult37.rgb;
			int temp_output_25_0 = 0;
			o.Metallic = (float)temp_output_25_0;
			o.Smoothness = (float)temp_output_25_0;
			o.Occlusion = (float)temp_output_25_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
768;92;822;655;1181.454;1226.351;1.984984;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;8;-2740.102,475.4587;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ComponentMaskNode;9;-2543.686,478.0419;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;33;-2131.156,826.6601;Float;False;Property;_Noise2_Size;Noise2_Size;4;0;Create;True;0;0;False;0;1,2;1,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-2080.223,713.9612;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;500,-1000;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;77;-2106.446,564.4123;Float;False;Property;_Noise_Size;Noise_Size;5;0;Create;True;0;0;False;0;1,2;1,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;81;-1922.952,504.7608;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;82;-1920.279,741.4122;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GrabScreenPosition;45;-1623.137,1218.771;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;11;-1751.521,493.7892;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;26;-1757.965,739.6696;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;46;-1395.318,1219.858;Float;False;Global;_GrabScreen0;Grab Screen 0;5;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-1512.912,622.1973;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;75;-1389.818,623.9445;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;47;-1226.409,1251.792;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-851.15,839.2932;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;12;-766.3143,484.3443;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;22;-788.431,611.6718;Float;False;Property;_BlendSteps;BlendSteps;6;0;Create;True;0;0;False;0;1;4;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-578.2194,503.597;Float;False;2;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;34;-452.3999,489.3009;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1144.904,504.1286;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-332.9791,497.6793;Float;False;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-348.8096,613.9146;Float;False;Property;_GrassOpacity;GrassOpacity;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-545.2488,-1049.263;Float;False;Property;_GroundLayerColor;GroundLayerColor;2;0;Create;True;0;0;False;0;0.7924528,0.6174311,0.3027768,1;0.7921569,0.711583,0.4745098,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;40;-41.78325,170.7496;Float;False;Constant;_Int2;Int 2;5;0;Create;True;0;0;False;0;1;0;0;1;INT;0
Node;AmplifyShaderEditor.ClampOpNode;83;-1015.496,499.0291;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;39;-32.34255,250.3107;Float;False;Constant;_Int1;Int 1;5;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.ColorNode;68;-563.1078,-784.9834;Float;False;Property;_GroundLayerInnerColor;GroundLayerInnerColor;3;0;Create;True;0;0;False;0;0.7735849,0.5726988,0.3028658,1;0.7921569,0.711583,0.4745098,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;18;-652.0282,-207.7589;Float;False;Property;_GrassLayerColor;GrassLayerColor;7;0;Create;True;0;0;False;0;0.5644689,0.7830189,0.4690726,1;0.3965379,0.6320754,0.4580747,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-141.2177,518.3529;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;-649.868,-380.3814;Float;False;Property;_GrassLayerColor2;GrassLayerColor2;1;0;Create;True;0;0;False;0;0.7924528,0.6174311,0.3027768,1;0.5002038,0.735849,0.4199893,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;35;182.7644,129.8831;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;INT;0;False;3;INT;0;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;7;-357.1316,-228.1204;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;67;-141.6066,-669.1204;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;48;-1069.758,1249.734;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;25;703.6887,-110.4172;Float;False;Constant;_Int0;Int 0;4;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.LerpOp;37;208.4744,-229.1964;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;44;931.48,-204.8574;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;SimpleGroundShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;-2;True;Background;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;8;0
WireConnection;27;0;9;0
WireConnection;81;0;9;0
WireConnection;81;1;77;0
WireConnection;82;0;27;0
WireConnection;82;1;33;0
WireConnection;11;0;81;0
WireConnection;26;0;82;0
WireConnection;46;0;45;0
WireConnection;20;0;11;0
WireConnection;20;1;26;0
WireConnection;75;0;20;0
WireConnection;47;0;46;1
WireConnection;61;0;75;0
WireConnection;61;1;47;0
WireConnection;12;0;61;0
WireConnection;13;0;12;0
WireConnection;13;1;22;0
WireConnection;34;0;13;0
WireConnection;84;0;75;0
WireConnection;84;1;47;0
WireConnection;14;0;34;0
WireConnection;14;1;22;0
WireConnection;83;0;84;0
WireConnection;71;0;14;0
WireConnection;71;1;72;0
WireConnection;35;0;14;0
WireConnection;35;1;71;0
WireConnection;35;2;40;0
WireConnection;35;3;39;0
WireConnection;35;4;39;0
WireConnection;7;0;38;0
WireConnection;7;1;18;0
WireConnection;7;2;14;0
WireConnection;67;0;19;0
WireConnection;67;1;68;0
WireConnection;67;2;83;0
WireConnection;48;0;47;0
WireConnection;37;0;67;0
WireConnection;37;1;7;0
WireConnection;37;2;35;0
WireConnection;44;0;37;0
WireConnection;44;2;37;0
WireConnection;44;3;25;0
WireConnection;44;4;25;0
WireConnection;44;5;25;0
ASEEND*/
//CHKSM=0B9AC157B7C7E7871428A6A52E52E16849DBEE0C