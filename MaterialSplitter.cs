using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialSplitter : MonoBehaviour 
{
    public ShaderSet[] shaderSets;

	void Start () 
    {
        foreach (ShaderSet set in shaderSets)
            set.Init();
	}

    [System.Serializable]
    public class ShaderSet
    {
        public Shader baseShader;
        public Shader standardShader;
        public Shader overlayShader;

        public void Init()
        {
            FindAllMaterials();
        }

        void FindAllMaterials()
        {
            foreach(SkinnedMeshRenderer mesh in FindObjectsOfType<SkinnedMeshRenderer>())
                CheckRenderer(mesh.sharedMesh, mesh.materials, mesh);
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
                    standardMat.CopyPropertiesFromMaterial(mat);
                    Material overlayMat = new Material(mat);
                    overlayMat.shader = overlayShader;
                    overlayMat.CopyPropertiesFromMaterial(mat);

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
