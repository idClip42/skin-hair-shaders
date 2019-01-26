Shader "Skin/Skin Standard Shader" {
	Properties {
		[Header(Main Textures)]
		_Color ("Color", Color) = (0.8,0.8,0.8,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalTex ("Normal Map", 2D) = "bump" {}
        _Smoothness("Smoothness", Range(0,1)) = 0.6
        _AOTex ("Ambient Occlusion", 2D) = "white" {}

        [Space]
        [Header(Details)]
        _DetailNormalTex ("Detail Normal Map", 2D) = "bump" {}
        _DetailNormalMapIntensity ("Detail Normal Map Intensity", Range(-2,2)) = 1

		[Space]
		[Header(Subsurface Scattering)]
		_SSSColor ("Subsurface Color", Color) = (0.95,0.10,0.06,1)
		_SSSPower ("Translucency Power", Float) = 5
		_SSSAmb ("Translucency Ambient", Float) = 0.05
		_SSSDist ("Translucency Distortion", Float) = 0.5
		_SSSTex ("Translucency Map", 2D) = "white" {}
        _SSSRemapBlack ("Translucency Remap Black", Range(-1,1)) = 0
        _SSSRemapWhite ("Translucency Remap White", Range(0,2)) = 1
		//_SSSEdgeValue("SSS Value", Range(0,1)) = 1.0
		//_SSSEdgePower("SSS Power", Float) = 2.0
	}
	SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        
        
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input {
            float2 uv_MainTex;
            float2 uv_DetailNormalTex;
        };

        sampler2D _MainTex;
        sampler2D _NormalTex;
        sampler2D _AOTex;
        sampler2D _DetailNormalTex;
        fixed4 _Color;
        half _Smoothness;
        half _DetailNormalMapIntensity;
        void surf (Input IN, inout SurfaceOutputStandard o) {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = 1;

            fixed3 n = UnpackNormal(tex2D(_NormalTex, IN.uv_MainTex));
            fixed3 nD = UnpackNormal(tex2D(_DetailNormalTex, IN.uv_DetailNormalTex));
            nD.x *= _DetailNormalMapIntensity;
            nD.y *= _DetailNormalMapIntensity;
            o.Normal = normalize(n + nD);
            
            o.Smoothness = _Smoothness;
            o.Metallic = 0;
            o.Occlusion = tex2D (_AOTex, IN.uv_MainTex);

        }
        ENDCG
        
        
        
        Tags { "Queue" = "Transparent-100" "RenderType"="Transparent" }
        
        //ZWrite Off
        Blend One One // Additive
        
        CGPROGRAM
        #pragma surface surf SSS fullforwardshadows
        #pragma target 3.0
        #include "Translucency.cginc"


        struct Input {
            float2 uv_MainTex;
            float2 uv_DetailNormalTex;
        };

        sampler2D _NormalTex;
        sampler2D _SSSTex;
        sampler2D _DetailNormalTex;
        half _SpecularValue;
        fixed4 _SSSColor;
        half _SSSPower;
        half _SSSAmb;
        half _SSSDist;
        half _SSSRemapBlack;
        half _SSSRemapWhite;
        //half _SSSEdgeValue;
        //half _SSSEdgePower;
        half _DetailNormalMapIntensity;

        half4 LightingSSS (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
        {
            half NdotL = dot (s.Normal, lightDir);
            half3 reflectionVector = normalize(2.0 * s.Normal * NdotL - lightDir);
            half translucency = Translucency(s.Normal, lightDir, viewDir, atten, _SSSPower, _SSSAmb, _SSSDist, s.Alpha);
            //half sss = _SSSEdgeValue * pow(saturate(1 - abs(NdotL) - 0.5f), _SSSEdgePower);
            half4 c;
            c.rgb = _LightColor0.rgb * (
                 //+ sss * _SSSColor * atten
                //+ 
                translucency * _SSSColor
                );
            c.a = 1;
            return c;
        }

        void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = 0;
            //o.Alpha = tex2D (_SSSTex, IN.uv_MainTex);
            o.Alpha = saturate(lerp(_SSSRemapBlack, _SSSRemapWhite, tex2D (_SSSTex, IN.uv_MainTex).r));

            fixed3 n = UnpackNormal(tex2D(_NormalTex, IN.uv_MainTex));
            fixed3 nD = UnpackNormal(tex2D(_DetailNormalTex, IN.uv_DetailNormalTex));
            nD.x *= _DetailNormalMapIntensity;
            nD.y *= _DetailNormalMapIntensity;
            o.Normal = normalize(n + nD);
        }
        ENDCG
	}
	FallBack "Diffuse"
}
