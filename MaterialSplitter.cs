using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialSplitter : MonoBehaviour 
{
    public ShaderSet[] shaderSets;

	void Start () 
    {
        for(int s = 0; s < shaderSets.Length; ++s)
            shaderSets[s].Init();
	}

    [System.Serializable]
    public class ShaderSet
    {
        public Shader baseShader;
        public Shader standardShader;
        public Shader overlayShader;

        // TODO: Add bools for skinned and non-skinned renderers

        public void Init()
        {
            if (baseShader == null || standardShader == null || overlayShader == null)
                return;

            FindAllMaterials();
        }

        void FindAllMaterials()
        {
            SkinnedMeshRenderer[] meshes = FindObjectsOfType<SkinnedMeshRenderer>();
            for (int m = 0; m < meshes.Length; ++m)
                CheckRenderer(meshes[m].sharedMesh, meshes[m].materials, meshes[m]);

        }

        void CheckRenderer(Mesh mesh, Material[] matList, Renderer renderer)
        {
            for (int m = 0; m < matList.Length; ++m)
            {
                Material mat = matList[m];
                if (mat.shader == baseShader)
                {
                    int index = mesh.subMeshCount;
                    mesh.subMeshCount++;
                    mesh.SetTriangles(mesh.GetTriangles(m), index);

                    Material standardMat = new Material(mat);
                    standardMat.shader = standardShader;
                    //standardMat.CopyPropertiesFromMaterial(mat);
                    Material overlayMat = new Material(mat);
                    overlayMat.shader = overlayShader;
                    //overlayMat.CopyPropertiesFromMaterial(mat);

                    matList[m] = standardMat;
                    Material[] newMatList = new Material[matList.Length + 1];
                    for (int m2 = 0; m2 < matList.Length; ++m2)
                        newMatList[m2] = matList[m2];
                    newMatList[matList.Length] = overlayMat;

                    renderer.materials = newMatList;
                }
            }
        }
    }
}
