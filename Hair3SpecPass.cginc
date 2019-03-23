struct Input
{
    float2 uv_MainTex;
    float3 worldNormal; INTERNAL_DATA
};
struct SurfaceAnisoOutput
{
    fixed3 Albedo;
    fixed3 Normal;
    fixed3 NormalOrig;
    fixed3 Emission;
    fixed Alpha;
};
sampler2D _MainTex;
sampler2D _AnisoDir;
float4 _SpecularColor;
float _SpecPower;
float _SpecMult;

fixed4 LightingAnisotropic(SurfaceAnisoOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
{
    float NdotL = 1 - abs(dot(s.Normal, lightDir));
    fixed3 halfVector = normalize(normalize(lightDir) + normalize(viewDir));
    fixed spec = dot(s.Normal, halfVector);
    spec = 1 - abs(spec);
    spec = saturate(pow(spec, _SpecPower * 128));

    half diffuse = 1;
    NdotL = saturate(dot (s.NormalOrig, lightDir));
    diffuse = pow(NdotL, 2);

    fixed4 c;
    c.rgb = _SpecularColor.rgb * spec * atten * diffuse * _SpecMult * s.Alpha;
    c.a = 1;
    
    return c;
}

void surf (Input IN, inout SurfaceAnisoOutput o)
{
    o.Alpha = tex2D (_MainTex, IN.uv_MainTex).a;
    o.Albedo = (0.5,0,0);
    
    o.NormalOrig = WorldNormalVector (IN, o.Normal);
    float3 anisoTex = tex2D(_AnisoDir, IN.uv_MainTex);
    o.Normal = anisoTex;
    o.Normal -= 0.5f;
    o.Normal *= 2;
}