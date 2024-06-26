using UnityEngine;

public class MeshSimplifier : MonoBehaviour
{
    [SerializeField]
    private float _quality = 0.1f;
    
    [ContextMenu("Simplify Mesh")]
    public void SimplifyMesh()
    {
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        
        Mesh originalMesh = meshFilter.sharedMesh;
        
        UnityMeshSimplifier.MeshSimplifier meshSimplifier = new();
        meshSimplifier.Initialize(originalMesh);
        meshSimplifier.SimplifyMesh(_quality);
        
        Mesh simplifiedMesh = meshSimplifier.ToMesh();
        
        meshFilter.sharedMesh = simplifiedMesh;
    }
}
