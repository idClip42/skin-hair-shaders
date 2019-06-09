Shader "Hair/Stubble" {
	Properties {
		_Noise ("Noise Map", 2D) = "white" {}
		_Normal ("Normal Map", 2D) = "bump" {}
		_Steps ("Steps", Float) = 20
		_Dim ("Image Width", Float) = 256
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		struct Input {
			float2 uv_Noise;
			float2 uv_Normal;
		};

		sampler2D _Noise;
		sampler2D _Normal;
		int _Steps;
		half _Dim;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float c = 1;
			fixed2 direction = UnpackNormal(tex2D(_Normal, IN.uv_Normal)).xy;
			for (int i = 0; i < _Steps; i++)
			{
				fixed2 os = direction * i / _Dim;
				os += IN.uv_Noise;
				fixed red = tex2D(_Noise, os).r;
				c *= red;
			}
			o.Albedo = c;
			o.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
