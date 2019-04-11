struct Input {
    float2 uv_MainTex;
    float2 uv_DetailNormalTex;
    //float3 viewDir;
};

//sampler2D _MainTex;
sampler2D _NormalTex;
sampler2D _S_AO_SSS_Tex;
sampler2D _DetailNormalTex;
half _AOStrength;
//fixed4 _Color;
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
    float4 mixTex = tex2D (_S_AO_SSS_Tex, IN.uv_MainTex);
    o.Smoothness = saturate(lerp(_SmoothnessRemapBlack, _SmoothnessRemapWhite, mixTex.b)) * mixTex.a;
    
    o.Occlusion = lerp(1, mixTex.g, _AOStrength) * mixTex.a;
    
    //o.Smoothness *= saturate(3 * abs(dot(IN.viewDir, o.Normal)));
}