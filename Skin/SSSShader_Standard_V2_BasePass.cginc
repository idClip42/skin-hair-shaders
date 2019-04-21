struct Input {
    float2 uv_MainTex;
    float2 uv_DetailNormalTex;
};

sampler2D _MainTex;
sampler2D _NormalTex;
sampler2D _S_AO_SSS_Tex;
sampler2D _DetailNormalTex;
fixed4 _Color;
half _DetailNormalMapIntensity;
half _AOStrength;
int _DiffuseNormalLod;

void surf (Input IN, inout SurfaceOutputStandard o) {
    fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
    o.Albedo = c.rgb;
    o.Alpha = 1;
    fixed3 n = UnpackNormal(tex2Dlod(_NormalTex, half4(IN.uv_MainTex, 1, _DiffuseNormalLod)));
    fixed3 nD = UnpackNormal(tex2D(_DetailNormalTex, IN.uv_DetailNormalTex));
    nD.x *= _DetailNormalMapIntensity;
    nD.y *= _DetailNormalMapIntensity;
    o.Normal = normalize(n + nD);
    fixed4 mixTex = tex2D (_S_AO_SSS_Tex, IN.uv_MainTex);
    o.Occlusion = lerp(1, mixTex.g, _AOStrength) * mixTex.a;
    o.Metallic = 1 - mixTex.a;
}