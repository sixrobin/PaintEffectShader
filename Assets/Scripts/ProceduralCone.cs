namespace ProceduralMeshes
{
    using UnityEngine;

    public class ProceduralCone : ProceduralMesh
    {
        [SerializeField]
        private float _height = 2f;
        [SerializeField]
        private float _radius = 1f;
        [SerializeField, Min(3)]
        private int _resolution = 32;
        [SerializeField]
        private bool _cap = true;

        private void GenerateWithCap()
        {
            Mesh mesh = GetNewMesh();
            _meshFilter.mesh = mesh;

            Vector3[] vertices = new Vector3[_resolution * 2 + 2];
            Vector2[] uv = new Vector2[vertices.Length];
            int[] triangles = new int[_resolution * 6];

            Vector3 tipVertex = new Vector3(0f, _height);
            Vector3 capVertex = Vector3.zero;
            vertices[^2] = tipVertex;
            vertices[^1] = capVertex;
            uv[^2] = Vector2.up;
            uv[^1] = Vector2.one * 0.5f;

            for (int i = 0; i < _resolution; ++i)
            {
                float theta = (Mathf.PI * 2f * i) / _resolution;
                Vector3 pointDirection = new Vector3(Mathf.Sin(theta), 0f, Mathf.Cos(theta));
                    
                vertices[i * 2] = pointDirection * _radius;
                vertices[i * 2 + 1] = pointDirection * _radius;
                uv[i * 2] = new Vector2(i / (float)_resolution, 0f);
                uv[i * 2 + 1] = new Vector2(Mathf.InverseLerp(-1f, 1f, pointDirection.x), Mathf.InverseLerp(-1f, 1f, pointDirection.z));

                triangles[i * 6] = i * 2;
                triangles[i * 6 + 1] = (i * 2 + 2) % (vertices.Length - 2);
                triangles[i * 6 + 2] = vertices.Length - 2;
                
                triangles[i * 6 + 3] = i * 2 + 1;
                triangles[i * 6 + 4] = vertices.Length - 1;
                triangles[i * 6 + 5] = (i * 2 + 3) % (vertices.Length - 2);
            }
            
            mesh.vertices = vertices;
            mesh.triangles = triangles;
            mesh.uv = uv;
            mesh.RecalculateNormals();
            mesh.RecalculateTangents();
        }

        private void GenerateWithoutCap()
        {
            Mesh mesh = GetNewMesh();
            _meshFilter.mesh = mesh;

            Vector3[] vertices = new Vector3[_resolution + 1];
            Vector2[] uv = new Vector2[vertices.Length];
            int[] triangles = new int[_resolution * 3];

            Vector3 tipVertex = new Vector3(0f, _height);
            vertices[^1] = tipVertex;
            uv[^1] = Vector2.up;

            for (int i = 0; i < _resolution; ++i)
            {
                float theta = (Mathf.PI * 2f * i) / _resolution;
                Vector3 point = new Vector3(Mathf.Sin(theta), 0f, Mathf.Cos(theta)) * _radius;
                    
                vertices[i] = point;
                uv[i] = new Vector2(i / (float)_resolution, 0f);

                triangles[i * 3] = i;
                triangles[i * 3 + 1] = (i + 1) % (vertices.Length - 1);
                triangles[i * 3 + 2] = vertices.Length - 1;
            }
            
            mesh.vertices = vertices;
            mesh.triangles = triangles;
            mesh.uv = uv;
            mesh.RecalculateNormals();
            mesh.RecalculateTangents();
        }
        
        public override void Generate()
        {
            if (_cap)
                GenerateWithCap();
            else
                GenerateWithoutCap();
        }
    }
}