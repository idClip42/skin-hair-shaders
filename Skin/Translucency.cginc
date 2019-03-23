#pragma target 3.0

// New SSS Code based off of
// https://www.slideshare.net/colinbb/colin-barrebrisebois-gdc-2011-approximating-translucency-for-a-fast-cheap-and-convincing-subsurfacescattering-look-7170855
// and
// http://farfarer.com/blog/2012/09/11/translucent-shader-unity3d/

half Translucency (fixed3 norm, half3 lightDir, half3 viewDir, half atten, half sssPow, half sssAmb, half sssDist, half thick){
	half3 vLTLight = lightDir + norm * sssDist;
//	half fLTDot = pow(saturate(dot(viewDir, -vLTLight)), sssPow);
	/// float transDot = pow ( max (0, dot ( viewDir, -transLightDir ) ), _Power ) * _Scale;
//	half fLTDot = pow(dot(viewDir, -vLTLight), sssPow);
	half fLTDot = pow (max (0, dot(viewDir, -vLTLight) ), sssPow);
//	return atten  * (fLTDot + sssAmb) * thick;
	return (atten * 2) * (fLTDot + sssAmb) * thick;
}