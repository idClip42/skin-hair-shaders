struct Input {
    float2 uv_MainTex;
    float2 uv_DetailNormalTex;
};

sampler2D _MainTex;
sampler2D _NormalTex;
sampler2D _S_AO_SSS_Tex;
sampler2D _DetailNormalTex;
fixed4 _Color;
half _DetailNormalMapIntensitySpec;
half _SmoothnessRemapBlack;
half _SmoothnessRemapWhite;

void surf (Input IN, inout SurfaceOutputStandard o) {
    o.Albedo = half3(0,0,0);
    o.Alpha = 1;
    fixed3 n = UnpackNormal(tex2D(_NormalTex, IN.uv_MainTex));
    fixed3 nD = UnpackNormal(tex2D(_DetailNormalTex, IN.uv_DetailNormalTex));
    nD.x *= _DetailNormalMapIntensitySpec;
    nD.y *= _DetailNormalMapIntensitySpec;
    o.Normal = normalize(n + nD);
    o.Smoothness = saturate(lerp(_SmoothnessRemapBlack, _SmoothnessRemapWhite, tex2D (_S_AO_SSS_Tex, IN.uv_MainTex).b));
}