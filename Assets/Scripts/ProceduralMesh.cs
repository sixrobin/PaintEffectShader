namespace ProceduralMeshes
{
    using UnityEngine;

    #if UNITY_EDITOR
    [ExecuteInEditMode]
    #endif
    public abstract class ProceduralMesh : MonoBehaviour
    {
        [SerializeField]
        protected MeshFilter _meshFilter;
        [SerializeField]
        private bool _generateEachFrame;

        protected virtual string GetMeshName() => this.GetType().Name;

        protected Mesh GetNewMesh()
        {
            Mesh mesh = new() { name = GetMeshName() };
            return mesh;
        }

        public abstract void Generate();
        
        #if UNITY_EDITOR
        private void Update()
        {
            if (_generateEachFrame)
                Generate();
        }

        private void Reset()
        {
            _meshFilter = GetComponent<MeshFilter>();
        }
        #endif
    }
}