// Upgrade NOTE: upgraded instancing buffer 'Props' to new syntax.

// Upgrade NOTE: upgraded instancing buffer 'Props' to new syntax.

Shader "Hair/Hair_Cutout" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Cutoff ("Cutoff", range(0,1)) = 0.5

		_TranslucencyColor ("Translucency Color", Color) = (1,1,1,1)
		_TranslucencyPower ("Translucency Power", Float) = 2

		_SpecularColor ("Specular Color", Color) = (1,1,1,1)
		_Specular ("Specular Amount", Range(0,1)) = 0.5
		_SpecPower ("Specular Power", Range(0,1)) = 0.5
		_AnisoDir ("Anisotropic Direction", 2D) = ""{}
		_AnisoOffset ("Anisotropic Offset", Range(-1,1)) = -0.2
	}
	SubShader {
		Tags { "Queue"="AlphaTest" "RenderType"="TransparentCutout" }
		LOD 200
		Cull Off
		
		CGPROGRAM
		#pragma surface surf Anisotropic alphatest:_Cutoff addshadow fullforwardshadows
		#pragma target 3.0
		#include "Translucency.cginc"


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

		fixed4 _TranslucencyColor;
		half _TranslucencyPower;

		float4 _SpecularColor;
		float _Specular;
		float _SpecPower;
		sampler2D _AnisoDir;
		float _AnisoOffset;

		fixed4 LightingAnisotropic(SurfaceAnisoOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float NdotL = abs(dot(s.Normal, lightDir));
			half trans = Translucency(s.Normal, lightDir, viewDir, atten, _TranslucencyPower, 0.25, 0.5, 1);

			fixed3 halfVector = normalize(normalize(lightDir) + normalize(viewDir));
			fixed HdotA = dot(normalize(s.Normal + s.AnisoDirection), halfVector);
			float aniso = max(0, sin(radians((HdotA + _AnisoOffset) * 180)));
			float spec = saturate(pow(aniso, _SpecPower * 128) * _Specular);

			fixed4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * atten * (
				NdotL +
				trans * _TranslucencyColor.rgb) +
				_SpecularColor.rgb * spec * atten;
			c.a = s.Alpha;

			return c;
		}
	
		void surf (Input IN, inout SurfaceAnisoOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;

			float3 anisoTex = UnpackNormal(tex2D(_AnisoDir, IN.uv_AnisoDir));
			o.AnisoDirection = anisoTex;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
