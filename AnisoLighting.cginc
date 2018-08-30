#pragma target 3.0
#include "Translucency.cginc"

fixed4 LightingAnisotropic(SurfaceAnisoOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
{
	float NdotL = 1 - abs(dot(s.Normal, lightDir));
	fixed3 halfVector = normalize(normalize(lightDir) + normalize(viewDir));
	fixed spec = dot(s.Normal, halfVector);
	spec = 1 - abs(spec);
	spec = saturate(pow(spec, _SpecPower * 128) * _Specular);

	half specMult = 1;
	#ifdef _BASENORMALS_ON
		NdotL = saturate(dot (s.NormalOrig, lightDir));
		specMult = pow(NdotL, 2);
	#else
	#endif

	half translucency = 0;
	#ifdef _TRANSLUCENCY_ON
		translucency = saturate(Translucency(s.NormalOrig, lightDir, viewDir, atten, _TransPower, 0, _TransDist, 1));
	#else
	#endif

	fixed4 c;
	c.rgb = s.Albedo * _LightColor0.rgb * atten *
		NdotL +
		_SpecularColor.rgb * spec * atten * specMult +
		translucency * _SpecularColor.rgb * atten;
	c.a = s.Alpha;

	return c;
}