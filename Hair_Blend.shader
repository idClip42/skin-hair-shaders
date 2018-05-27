Shader "Hair/Hair_Blend" {
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
		#pragma surface surf Anisotropic alphatest:_Cutoff addshadow fullforwardshadows
		#pragma target 3.0


		struct Input {
			float2 uv_MainTex;
			float2 uv_AnisoDir;
		};

		struct SurfaceAnisoOutput
		{
			fixed3 Albedo;
//			fixed3 AnisoDirection;
			fixed3 Normal;
			fixed3 Emission;
			fixed Alpha;
		};

		sampler2D _MainTex;
		fixed4 _Color;

		float4 _SpecularColor;
		float _Specular;
		float _SpecPower;
		sampler2D _AnisoDir;
		float _AnisoOffset;

		#include "AnisoLighting.cginc"
	
		void surf (Input IN, inout SurfaceAnisoOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;

			float3 anisoTex = tex2D(_AnisoDir, IN.uv_AnisoDir);
			o.Normal = anisoTex;
			o.Normal -= 0.5f;
			o.Normal *= 2;
//			o.Normal = anisoTex;
		}
		ENDCG

		CGPROGRAM
		#pragma surface surf Anisotropic alpha:blend fullforwardshadows
		#pragma target 3.0


		struct Input {
			float2 uv_MainTex;
			float2 uv_AnisoDir;
		};

		struct SurfaceAnisoOutput
		{
			fixed3 Albedo;
//			fixed3 AnisoDirection;
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

		#include "AnisoLighting.cginc"

		void surf (Input IN, inout SurfaceAnisoOutput o) {

			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;

			float3 anisoTex = tex2D(_AnisoDir, IN.uv_AnisoDir);
			o.Normal = anisoTex;
			o.Normal -= 0.5f;
			o.Normal *= 2;
//			o.Normal = anisoTex;

			c.a = c.a / _Cutoff;
			clip(-c.a + 1);
			o.Alpha = c.a;
		}
		ENDCG


	}
	FallBack "Diffuse"
}