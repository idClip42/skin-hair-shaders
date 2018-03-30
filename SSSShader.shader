// Upgrade NOTE: upgraded instancing buffer 'Props' to new syntax.

Shader "Skin/Skin" {
	Properties {
		_Color ("Color", Color) = (0.8,0.8,0.8,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalTex ("Normal Map", 2D) = "bump" {}
		_SpecPower  ("Specular Power", Float) = 10
		_SpecularColor ("Specular Color", Color) = (0.3,0.3,0.3,1)
		[HDR] _SSSColor ("SSS Color", Color) = (1,0,0,1)
		//_SSSPower ("SSS Power", Float) = 2
		_SSSTex ("SSS Map", 2D) = "black" {}
		_DetailNormalTex ("Detail Normal Map", 2D) = "bump" {}
		_DetailNormalMapIntensity ("Detail Normal Map Intensity", Range(-10,10)) = 1
		_DetailNormalMapStrength ("Detail Normal Map Strength", Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf SSS fullforwardshadows
		#pragma target 3.0


		struct Input {
			float2 uv_MainTex;
			float2 uv_DetailNormalTex;
		};

		sampler2D _MainTex;
		sampler2D _NormalTex;
		sampler2D _SSSTex;
		sampler2D _DetailNormalTex;
		fixed4 _Color;
		fixed4 _SpecularColor;
		half _SpecPower;
		fixed4 _SSSColor;
		//half _SSSPower;
		half _DetailNormalMapIntensity;
		half _DetailNormalMapStrength;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		half4 LightingSSS (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
			half NdotL = dot (s.Normal, lightDir);

			half3 reflectionVector = normalize(2.0 * s.Normal * NdotL - lightDir);
			half spec = pow(max(0, dot(reflectionVector, viewDir)), _SpecPower);
			half3 finalSpec = _SpecularColor.rgb * spec;

			//half sss = pow((1 - abs(NdotL))/2, _SSSPower);
			//half sss = pow(saturate(1 - abs(NdotL) - 0.5f), _SSSPower);
			half sss = saturate(1 - abs(NdotL) - 0.5f);
			half translucency = s.Alpha * saturate(-NdotL)/2;

			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (
				finalSpec * atten + 
				saturate(NdotL) * atten * 1 +
				sss * _SSSColor * atten + 
				translucency * _SSSColor * atten);

			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Hiding translucency tex in alpha
			o.Alpha = tex2D (_SSSTex, IN.uv_MainTex);


			fixed3 n = UnpackNormal(tex2D(_NormalTex, IN.uv_MainTex));
			fixed3 nD = UnpackNormal(tex2D(_DetailNormalTex, IN.uv_DetailNormalTex));
			nD.x *= _DetailNormalMapIntensity;
			nD.y *= _DetailNormalMapIntensity;
			o.Normal = normalize(lerp(n, nD, _DetailNormalMapStrength));

		}
		ENDCG
	}
	FallBack "Diffuse"
}