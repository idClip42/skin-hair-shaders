Shader "Hair/Hair" {
	Properties {
		[Header(Main Textures)]
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Cutoff ("Cutoff", range(0,1)) = 0.5
		[Toggle] _Dither("Dither", Float) = 0

		[Space]
		[Header(Specularity)]
		_SpecularColor ("Specular Color", Color) = (1,1,1,1)
		_Specular ("Specular Amount", Range(0,1)) = 0.5
		_SpecPower ("Specular Power", Range(0,1)) = 0.15

		[Space]
		[Header(Anisotropy)]
		_AnisoDir ("Anisotropic Direction", 2D) = ""{}
	}
	SubShader {
		Tags { "Queue"="AlphaTest" "RenderType"="TransparentCutout" }
		LOD 200
		Cull Off
		
		CGPROGRAM
		#pragma surface surf Anisotropic addshadow fullforwardshadows
		#pragma target 3.0
		#pragma shader_feature _DITHER_ON


		struct Input {
			float2 uv_MainTex;
			float2 uv_AnisoDir;
			float4 screenPos;
		};

		struct SurfaceAnisoOutput
		{
			fixed3 Albedo;
			fixed3 AnisoDirection;

			fixed3 Normal;
			fixed3 Emission;
			fixed Alpha;
		};

		sampler2D _MainTex;
		fixed4 _Color;
		fixed _Cutoff;

		float4 _SpecularColor;
		float _Specular;
		float _SpecPower;
		sampler2D _AnisoDir;
		float _AnisoOffset;

		fixed4 LightingAnisotropic(SurfaceAnisoOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float NdotL = 1 - abs(dot(s.Normal, lightDir));
			fixed3 halfVector = normalize(normalize(lightDir) + normalize(viewDir));
			fixed spec = dot(s.Normal, halfVector);
			spec = 1 - abs(spec);
			spec = saturate(pow(spec, _SpecPower * 128) * _Specular);

			fixed4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * atten *
				saturate(NdotL) +
				_SpecularColor.rgb * spec * atten;
			c.a = s.Alpha;

			return c;
		}
	
		void surf (Input IN, inout SurfaceAnisoOutput o) {
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

			float3 anisoTex = UnpackNormal(tex2D(_AnisoDir, IN.uv_AnisoDir));
			o.AnisoDirection = anisoTex;
			o.Normal = anisoTex;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
