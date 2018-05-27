#pragma target 3.0

fixed4 LightingAnisotropic(SurfaceAnisoOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
{
	float NdotL = 1 - abs(dot(s.Normal, lightDir));
	fixed3 halfVector = normalize(normalize(lightDir) + normalize(viewDir));
	fixed spec = dot(s.Normal, halfVector);
	spec = 1 - abs(spec);
	spec = saturate(pow(spec, _SpecPower * 128) * _Specular);

	fixed4 c;
	c.rgb = s.Albedo * _LightColor0.rgb * atten *
		saturate(NdotL) +
		_SpecularColor.rgb * spec * atten;
	c.a = s.Alpha;

	return c;
}