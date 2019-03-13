struct Input {
    float2 uv_MainTex;
};

sampler2D _NormalTex;
sampler2D _S_AO_SSS_Tex;
fixed4 _SSSColor;
half _SSSPower;
half _SSSAmb;
half _SSSDist;
half _SSSRemapBlack;
half _SSSRemapWhite;
half _SSSEdgeValue;
half _SSSEdgePower;
int _DiffuseNormalLod;

half4 LightingSSS (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
{
    half NdotL = dot (s.Normal, lightDir);
    half3 reflectionVector = normalize(2.0 * s.Normal * NdotL - lightDir);
    half translucency = Translucency(s.Normal, lightDir, viewDir, atten, _SSSPower, _SSSAmb, _SSSDist, s.Alpha) * s.Gloss;
    half sss = _SSSEdgeValue * pow(saturate(1 - abs(NdotL) - 0.5f), _SSSEdgePower) * s.Gloss;
    half4 c;
    c.rgb = _LightColor0.rgb * (
         + sss * _SSSColor * atten
        + translucency * _SSSColor);
    c.a = 1;
    return c;
}

void surf (Input IN, inout SurfaceOutput o) {
    o.Albedo = 0;
    float4 mixTex = tex2D (_S_AO_SSS_Tex, IN.uv_MainTex);
    o.Alpha = saturate(lerp(_SSSRemapBlack, _SSSRemapWhite, mixTex.r));
    o.Gloss = mixTex.a; // Hiding this mask in here.
    //o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_MainTex));
    o.Normal = UnpackNormal(tex2Dlod(_NormalTex, half4(IN.uv_MainTex, 1, _DiffuseNormalLod)));

}