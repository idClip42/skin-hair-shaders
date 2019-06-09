using System;
using UnityEngine;

namespace UnityEditor
{
    internal class StandardSkinShaderGUI : ShaderGUI
    {

        private static class Styles
        {
            public static GUIContent color = new GUIContent("Color");
            public static GUIContent tex = new GUIContent("Albedo (RGB)");
            public static GUIContent norm = new GUIContent("Normal Map");

            public static GUIContent smooth = new GUIContent("Smoothness Map");
            public static GUIContent ao = new GUIContent("Ambient Occlusion Map");
            public static GUIContent aoStr = new GUIContent("Ambient Occlusion Strength");
            public static GUIContent thickness = new GUIContent("Thickness Map");
            public static GUIContent s_ao_sss = new GUIContent("Thick(R), AO(G), Smooth(B), HairMask(A)");
            public static GUIContent singleMap = new GUIContent("Use Single S/AO/SSS Map");

            public static GUIContent smoothRemapBlack = new GUIContent("Smoothness Detail Remap Black");
            public static GUIContent smoothRemapWhite = new GUIContent("Smoothness Detail Remap White");
            public static GUIContent smoothRemapBlackBase = new GUIContent("Smoothness Base Remap Black");
            public static GUIContent smoothRemapWhiteBase = new GUIContent("Smoothness Base Remap White");

            public static GUIContent detailNorm = new GUIContent("Detail Normal Map");
            public static GUIContent detailNormIntensity = new GUIContent("Detail Normal Map Intensity Diffuse");
            public static GUIContent detailNormIntensitySpec = new GUIContent("Detail Normal Map Intensity Specular");
            public static GUIContent lodBiasDiff = new GUIContent("LOD Bias for diffuse normals");

            public static GUIContent sssColor = new GUIContent("Subsurface Color");
            public static GUIContent sssPower = new GUIContent("Translucency Power");
            public static GUIContent sssAmb = new GUIContent("Translucency Ambient");
            public static GUIContent sssDist = new GUIContent("Translucency Distortion");
            public static GUIContent sssTex = new GUIContent("Thickness Map");
            public static GUIContent sssRemapBlack = new GUIContent("Translucency Remap Black");
            public static GUIContent sssRemapWhite = new GUIContent("Translucency Remap White");
            public static GUIContent sssEdgeValue = new GUIContent("SSS Edge Value");

            //public static GUIContent sssEdgePower = new GUIContent("SSS Edge Power");
            public static GUIContent sssEdgePowerMin = new GUIContent("SSS Edge Power Min");
            public static GUIContent sssEdgePowerMax = new GUIContent("SSS Edge Power Max");
        }



        MaterialProperty color = null;
        MaterialProperty tex = null;
        MaterialProperty norm = null;

        MaterialProperty smooth = null;
        MaterialProperty ao = null;
        MaterialProperty aoStr = null;
        MaterialProperty thickness = null;
        MaterialProperty s_ao_sss = null;
        MaterialProperty singleMap = null;

        MaterialProperty smoothRemapBlack = null;
        MaterialProperty smoothRemapWhite = null;
        MaterialProperty smoothRemapBlackBase = null;
        MaterialProperty smoothRemapWhiteBase = null;

        MaterialProperty detailNorm = null;
        MaterialProperty detailNormIntensity = null;
        MaterialProperty detailNormIntensitySpec = null;
        MaterialProperty lodBiasDiff = null;

        MaterialProperty sssColor = null;
        MaterialProperty sssPower = null;
        MaterialProperty sssAmb = null;
        MaterialProperty sssDist = null;
        MaterialProperty sssRemapBlack = null;
        MaterialProperty sssRemapWhite = null;
        MaterialProperty sssEdgeValue = null;

        //MaterialProperty sssEdgePower = null;
        MaterialProperty sssEdgePowerMin = null;
        MaterialProperty sssEdgePowerMax = null;





        MaterialEditor m_MaterialEditor;


        public void FindProperties(MaterialProperty[] props)
        {
            color = FindProperty("_Color", props);
            tex = FindProperty("_MainTex", props);
            norm = FindProperty("_NormalTex", props);

            aoStr = FindProperty("_AOStrength", props);
            s_ao_sss = FindProperty("_S_AO_SSS_Tex", props);

            smoothRemapBlack = FindProperty("_SmoothnessRemapBlack", props);
            smoothRemapWhite = FindProperty("_SmoothnessRemapWhite", props);
            smoothRemapBlackBase = FindProperty("_SmoothnessRemapBlackBase", props);
            smoothRemapWhiteBase = FindProperty("_SmoothnessRemapWhiteBase", props);

            detailNorm = FindProperty("_DetailNormalTex", props);
            detailNormIntensity = FindProperty("_DetailNormalMapIntensity", props);

            detailNormIntensitySpec = FindProperty("_DetailNormalMapIntensitySpec", props);
            lodBiasDiff = FindProperty("_DiffuseNormalLod", props);

            sssColor = FindProperty("_SSSColor", props);
            sssPower = FindProperty("_SSSPower", props);
            sssAmb = FindProperty("_SSSAmb", props);
            sssDist = FindProperty("_SSSDist", props);
            sssRemapBlack = FindProperty("_SSSRemapBlack", props);
            sssRemapWhite = FindProperty("_SSSRemapWhite", props);
            sssEdgeValue = FindProperty("_SSSEdgeValue", props);

            sssEdgePowerMin = FindProperty("_SSSEdgePowerMin", props);
            sssEdgePowerMax = FindProperty("_SSSEdgePowerMax", props);
        }


        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
        {
            FindProperties(props);
            m_MaterialEditor = materialEditor;
            Material material = materialEditor.target as Material;

            ShaderPropertiesGUI(material);
        }

        public void ShaderPropertiesGUI(Material material)
        {
            EditorGUIUtility.labelWidth = 0f;

            GUILayout.Label("Primary Textures", EditorStyles.boldLabel);
            m_MaterialEditor.TexturePropertySingleLine(Styles.tex, tex, color);

            m_MaterialEditor.TexturePropertySingleLine(Styles.norm, norm);

            m_MaterialEditor.TexturePropertySingleLine(Styles.detailNorm, detailNorm, detailNormIntensity);
            m_MaterialEditor.TextureScaleOffsetProperty(detailNorm);

            m_MaterialEditor.ShaderProperty(lodBiasDiff, Styles.lodBiasDiff);
            m_MaterialEditor.ShaderProperty(detailNormIntensitySpec, Styles.detailNormIntensitySpec);

            GUILayout.Label("Material Properties", EditorStyles.boldLabel);

            m_MaterialEditor.TexturePropertySingleLine(Styles.s_ao_sss, s_ao_sss); 

            m_MaterialEditor.ShaderProperty(aoStr, Styles.aoStr);
            m_MaterialEditor.ShaderProperty(smoothRemapBlackBase, Styles.smoothRemapBlackBase);
            m_MaterialEditor.ShaderProperty(smoothRemapWhiteBase, Styles.smoothRemapWhiteBase);
            m_MaterialEditor.ShaderProperty(smoothRemapBlack, Styles.smoothRemapBlack);
            m_MaterialEditor.ShaderProperty(smoothRemapWhite, Styles.smoothRemapWhite);
            m_MaterialEditor.ShaderProperty(sssRemapBlack, Styles.sssRemapBlack);
            m_MaterialEditor.ShaderProperty(sssRemapWhite, Styles.sssRemapWhite);

            GUILayout.Label("Subsurface Scattering", EditorStyles.boldLabel);
            m_MaterialEditor.ShaderProperty(sssColor, Styles.sssColor);
            m_MaterialEditor.ShaderProperty(sssPower, Styles.sssPower);
            m_MaterialEditor.ShaderProperty(sssAmb, Styles.sssAmb);
            m_MaterialEditor.ShaderProperty(sssDist, Styles.sssDist);
            m_MaterialEditor.ShaderProperty(sssEdgeValue, Styles.sssEdgeValue);

            m_MaterialEditor.ShaderProperty(sssEdgePowerMin, Styles.sssEdgePowerMin);
            m_MaterialEditor.ShaderProperty(sssEdgePowerMax, Styles.sssEdgePowerMax);
        }

    }

}