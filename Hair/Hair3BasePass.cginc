struct Input
{
    float2 uv_MainTex;
    float4 screenPos;
    float3 viewDir;
};

sampler2D _MainTex;
sampler2D _AnisoDir;
fixed4 _Color;
half _Cutoff;
half _Metallic;

#include "Dither.cginc"

void surf (Input IN, inout SurfaceOutputStandard o)
{
    fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
    o.Albedo = c.rgb;
    
    o.Alpha = saturate(c.a/_Cutoff);
    o.Alpha *= 4 * abs(dot(IN.viewDir, o.Normal));    // Edge Fade
    Dither((IN.screenPos.xy)/IN.screenPos.w, o.Alpha);
    
    o.Metallic = _Metallic;
}