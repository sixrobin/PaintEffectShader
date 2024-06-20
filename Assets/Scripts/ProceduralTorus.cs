namespace ProceduralMeshes
{
    using UnityEngine;

    public class ProceduralTorus : ProceduralMesh
    {
        [SerializeField]
        private float _largeCircleRadius = 1f;
        [SerializeField]
        private float _smallCircleRadius = 0.2f;
        [SerializeField, Min(3)]
        private int _largeCircleResolution = 16;
        [SerializeField, Min(3)]
        private int _smallCircleResolution = 16;
        [SerializeField]
        private Vector2Int _uvOffset;

        [ContextMenu("Generate")]
        public override void Generate()
        {
            Mesh mesh = GetNewMesh();
            _meshFilter.mesh = mesh;

            Vector3[] vertices = new Vector3[_smallCircleResolution * _largeCircleResolution];
            Vector2[] uv = new Vector2[vertices.Length];
            int[] triangles = new int[_smallCircleResolution * _largeCircleResolution * 6];

            for (int i = 0, v = 0; i < _largeCircleResolution; ++i)
            {
                float largeTheta = (Mathf.PI * 2f * i) / _largeCircleResolution;
                Vector3 smallCircleCenter = new Vector3(Mathf.Sin(largeTheta) * _largeCircleRadius, 0f, Mathf.Cos(largeTheta) * _largeCircleRadius);

                for (int j = 0; j < _smallCircleResolution; ++j, ++v)
                {
                    float smallTheta = (Mathf.PI * 2f * j) / _smallCircleResolution;
                    Vector3 pointLocalSpace = new Vector3(Mathf.Sin(smallTheta) * _smallCircleRadius, Mathf.Cos(smallTheta) * _smallCircleRadius, 0f);
                    pointLocalSpace = Quaternion.Euler(0f, largeTheta * Mathf.Rad2Deg + 90f, 0f) * pointLocalSpace;
                    
                    vertices[v] = smallCircleCenter + pointLocalSpace;
                    uv[v] = new Vector2((i + _uvOffset.x) / (float)_largeCircleResolution % 1, (j + (_smallCircleResolution * 0.5f) + _uvOffset.y) / (float)_smallCircleResolution % 1);
                }
            }
            
            for (int t = 0; t < _largeCircleResolution * _smallCircleResolution; ++t)
            {
                if ((t + 1) % _smallCircleResolution > 0)
                {
                    triangles[t * 6] = t;
                    triangles[t * 6 + 1] = (t + 1 + _smallCircleResolution) % vertices.Length;
                    triangles[t * 6 + 2] = (t + 1) % vertices.Length;
                    triangles[t * 6 + 3] = t;
                    triangles[t * 6 + 4] = (t + _smallCircleResolution) % vertices.Length;
                    triangles[t * 6 + 5] = (t + 1 + _smallCircleResolution) % vertices.Length;
                }
                else
                {
                    triangles[t * 6] = t;
                    triangles[t * 6 + 1] = (t + 1) % vertices.Length;
                    triangles[t * 6 + 2] = (t + 1 - _smallCircleResolution) % vertices.Length;
                    triangles[t * 6 + 3] = t;
                    triangles[t * 6 + 4] = (t + _smallCircleResolution) % vertices.Length;
                    triangles[t * 6 + 5] = (t + 1) % vertices.Length;
                }
            }

            mesh.vertices = vertices;
            mesh.triangles = triangles;
            mesh.uv = uv;
            mesh.RecalculateNormals();
            mesh.RecalculateTangents();
        }
    }
}