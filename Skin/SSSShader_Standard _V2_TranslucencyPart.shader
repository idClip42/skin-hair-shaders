Shader "Skin/Skin Standard Shader V2 (Translucency Part)" {
	Properties {
		_Color ("Color", Color) = (0.8,0.8,0.8,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalTex ("Normal Map", 2D) = "bump" {}
        
        _SmoothnessRemapBlack ("Smoothness Remap Black", Range(-5,5)) = 0
        _SmoothnessRemapWhite ("Smoothness Remap White", Range(-5,5)) = 0.7
        
        _AOStrength ("Ambient Occlusion Strength", Range(0,1)) = 1
        
        _S_AO_SSS_Tex ("Thickness (R), Ambient Occlusion (G), Smoothness (B)", 2D) = "white" {}

        _DetailNormalTex ("Detail Normal Map", 2D) = "bump" {}
        _DetailNormalMapIntensity ("Detail Normal Map Intensity Diffuse", Range(0,2)) = 1
        _DetailNormalMapIntensitySpec ("Detail Normal Map Intensity Specular", Range(0,2)) = 1
        
        _DiffuseNormalLod ("LOD Bias for diffuse normals", Int) = 2

		_SSSColor ("Subsurface Color", Color) = (0.95,0.10,0.06,1)
		_SSSPower ("Translucency Power", Float) = 5
		_SSSAmb ("Translucency Ambient", Float) = 0.05
		_SSSDist ("Translucency Distortion", Float) = 0.5
        _SSSRemapBlack ("Translucency Remap Black", Range(-5,5)) = 0
        _SSSRemapWhite ("Translucency Remap White", Range(-5,5)) = 1
		_SSSEdgeValue("SSS Edge Value", Range(0,10)) = 5.0

        _SSSEdgePowerMin("SSS Edge Power Min", Float) = 0
        _SSSEdgePowerMax("SSS Edge Power Max", Float) = 8
	}
	SubShader {
        Blend One One
                
        CGPROGRAM
        #pragma surface surf SSS fullforwardshadows
        #pragma target 3.0
        #include "Translucency.cginc"
        #include "SSSShader_Standard_V2_SSSPass.cginc"
        ENDCG
        
        CGPROGRAM
        #pragma surface surf StandardSpecForward fullforwardshadows
        #pragma target 3.0
        #include "UnityPBSLighting.cginc"
        half4 LightingStandardSpecForward (SurfaceOutputStandard s, half3 viewDir, UnityGI gi) {
            fixed4 pbr = LightingStandard(s, viewDir, gi);
            return pbr;
        }
        void LightingStandardSpecForward_GI(SurfaceOutputStandard s, UnityGIInput data, inout UnityGI gi)
        {
            LightingStandard_GI(s, data, gi); 
        }
        #include "SSSShader_Standard_V2_SpecPass.cginc"
        ENDCG
	}
    CustomEditor "StandardSkinShaderGUI"
}