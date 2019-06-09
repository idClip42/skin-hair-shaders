Shader "Hair/Hair 3"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Cutoff ("Cutoff", range(0,1)) = 0.5
        _Metallic("Metalness", range(0,1)) = 0
        _AO("Ambient Occlusion", range(0,1)) = 0.25
        _AnisoDir ("Anisotropic Direction", 2D) = ""{}
        _SpecularColor ("Specular Color", Color) = (1,1,1,1)
        _SpecPower ("Specular Power", Range(0,1)) = 0.1
        _SpecMult ("Specular Multiplier", Float) = 1
        _DitherMotion("Dither Motion", Float) = 10
        
        _Translucency("Translucency", 2D) = "black" {}
        _TMin("Translucency Min", range(-1,1)) = -0.015
        _TMax("Translucency Max", range(0,2)) = 0.2
        _TPower ("Translucency Power", Float) = 30
        _TAmb ("Translucency Ambient", Range(0,1)) = 0.1
        _TDist ("Translucency Distortion", Float) = 0.2
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Cull Off

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows addshadow
        #pragma target 3.0
        #include "Hair3BasePass.cginc"
        ENDCG
        
        Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
        LOD 200
        Cull Off
        Blend One One
        ZWrite Off
        CGPROGRAM
        #pragma surface surf Anisotropic fullforwardshadows
        #pragma target 3.0
        #include "../Utilities/Translucency.cginc"
        #include "Hair3SpecPass.cginc"
        ENDCG
    }
    FallBack "Diffuse"
}
