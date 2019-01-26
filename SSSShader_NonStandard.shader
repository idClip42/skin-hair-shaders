Shader "Skin/Skin Shader" {
	Properties {
		[Header(Main Textures)]
		_Color ("Color", Color) = (0.8,0.8,0.8,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalTex ("Normal Map", 2D) = "bump" {}

		[Space]
		[Header(Specularity)]
		_SpecPower  ("Specular Power", Float) = 10
		_SpecularValue("Specular Value", Range(0,20)) = 1.0

        [Space]
        [Header(Details)]
        _DetailNormalTex ("Detail Normal Map", 2D) = "bump" {}
        _DetailNormalMapIntensity ("Detail Normal Map Intensity", Range(-2,2)) = 1
//      _DetailNormalMapStrength ("Detail Normal Map Strength", Range(0,1)) = 0.5

		[Space]
		[Header(Subsurface Scattering)]
		[HDR] _SSSColor ("Subsurface Color", Color) = (1,0,0,1)
		_SSSPower ("Translucency Power", Float) = 1
		_SSSAmb ("Translucency Ambient", Float) = 0.25
		_SSSDist ("Translucency Distortion", Float) = 0.5
		_SSSTex ("Translucency Map", 2D) = "white" {}
        _SSSRemapBlack ("Translucency Remap Black", Range(-1,1)) = 0
        _SSSRemapWhite ("Translucency Remap White", Range(0,2)) = 1
		_SSSEdgeValue("SSS Edge Value", Range(0,1)) = 1.0
		_SSSEdgePower("SSS Edge Power", Float) = 2.0
		//_SSSProfile ("SSS Profile", 2D) = "black" {}
		//_SSSProfileStrength("SSS Profile Strength", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf SSS fullforwardshadows
		#pragma target 3.0
		#include "Translucency.cginc"


		struct Input {
			float2 uv_MainTex;
			float2 uv_DetailNormalTex;
		};

		sampler2D _MainTex;
		sampler2D _NormalTex;
		sampler2D _SSSTex;
		//sampler2D _SSSProfile;
		sampler2D _DetailNormalTex;
		fixed4 _Color;
//		fixed4 _SpecularColor;
		half _SpecularValue;
		half _SpecPower;
		fixed4 _SSSColor;
		half _SSSPower;
		half _SSSAmb;
		half _SSSDist;
        half _SSSRemapBlack;
        half _SSSRemapWhite;
		half _SSSEdgeValue;
		half _SSSEdgePower;
		//half _SSSProfileStrength;
		half _DetailNormalMapIntensity;
//		half _DetailNormalMapStrength;

		half4 LightingSSS (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
			half NdotL = dot (s.Normal, lightDir);

			half3 reflectionVector = normalize(2.0 * s.Normal * NdotL - lightDir);
			half spec = pow(max(0, dot(reflectionVector, viewDir)), _SpecPower);
			half3 finalSpec = _SpecularValue * spec;

			//half3 profileSpec = tex2D (_SSSProfile, half2(spec/2, 0.5));//     (theDot/2 + .5);
			//finalSpec = lerp(finalSpec, profileSpec, _SSSProfileStrength);
			// return half4(finalSpec, 1);


			half translucency = Translucency(s.Normal, lightDir, viewDir, atten, _SSSPower, _SSSAmb, _SSSDist, s.Alpha);
			half sss = _SSSEdgeValue * pow(saturate(1 - abs(NdotL) - 0.5f), _SSSEdgePower);

			// NdotL = 1 - (pow(1-NdotL, 2))

		 	half4 c;
		 	c.rgb = s.Albedo * _LightColor0.rgb * (
		 		finalSpec * atten + 
				saturate(NdotL) * atten 
				 + sss * _SSSColor * atten// * s.Alpha
				+ translucency * _SSSColor
				);
			c.a = 1;
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Hiding translucency tex in alpha
			//o.Alpha = tex2D (_SSSTex, IN.uv_MainTex);
            
            //o.Alpha *= _SSSRemapWhite;
            
            o.Alpha = saturate(lerp(_SSSRemapBlack, _SSSRemapWhite, tex2D (_SSSTex, IN.uv_MainTex).r));
            
            
            //o.Alpha = (o.Alpha - _SSSRemapBlack) * (1 + _SSSRemapBlack);
            
            //o.Alpha = saturate(o.Alpha);


			fixed3 n = UnpackNormal(tex2D(_NormalTex, IN.uv_MainTex));
			fixed3 nD = UnpackNormal(tex2D(_DetailNormalTex, IN.uv_DetailNormalTex));
			nD.x *= _DetailNormalMapIntensity;
			nD.y *= _DetailNormalMapIntensity;
//			o.Normal = normalize(lerp(n, nD, _DetailNormalMapStrength));
			o.Normal = normalize(n + nD);

		}
		ENDCG
	}
	FallBack "Diffuse"
}
