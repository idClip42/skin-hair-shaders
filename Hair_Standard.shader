Shader "Hair/HairStandard" {
	Properties {
		[Header(Main Textures)]
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Cutoff ("Cutoff", range(0,1)) = 0.5
		[Toggle] _Dither("Dither", Float) = 0
		_AnisoDir ("Anisotropic Normal Map", 2D) = "bump"{}
		_AnisoStr ("Anisotropic Strength", range(0,1)) = 0.75
		_Smoothness ("Smoothness", Range(0,1)) = 0.75
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "Queue"="AlphaTest" "RenderType"="TransparentCutout" }
		LOD 200
		Cull Off
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0
		#pragma shader_feature _DITHER_ON


		struct Input {
			float2 uv_MainTex;
			float4 screenPos;
		};

		sampler2D _MainTex;
		fixed4 _Color;
		fixed _Cutoff;
		sampler2D _AnisoDir;
		half _AnisoStr;
		half _Smoothness;
		half _Metallic;

	
		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;

			#ifdef _DITHER_ON
				half alpha = saturate(c.a/_Cutoff);

				float4x4 thresholdMatrix =
	   			{  1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
	   			  13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
	   			   4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
	   			  16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
	   			};

	   			float4x4 _RowAccess = { 1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1 };

	   			float2 pos = IN.screenPos.xy / IN.screenPos.w;

	   			pos *= _ScreenParams.xy;

	   			clip(alpha - thresholdMatrix[fmod(pos.x, 4)] * _RowAccess[fmod(pos.y, 4)]);
					
			#else
				clip(o.Alpha - _Cutoff);
			#endif


			o.Normal = lerp(o.Normal, UnpackNormal(tex2D(_AnisoDir, IN.uv_MainTex)), _AnisoStr);

			o.Smoothness = _Smoothness;
			o.Metallic = _Metallic;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
