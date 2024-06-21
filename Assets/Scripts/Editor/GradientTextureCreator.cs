namespace RSLib.Editor
{
    using UnityEditor;
    using UnityEngine;

    public class GradientTextureCreator : EditorWindow
    {
        private Gradient _gradient = new Gradient();
        private int _width = 128;
        private int _height = 8;
        private Orientation _orientation;
        private bool _inverted;
        
        private enum Orientation
        {
	        [InspectorName("Horizontal")] HORIZONTAL,
	        [InspectorName("Vertical")]   VERTICAL
        }

        [MenuItem("RSLib/Gradient Texture Creator")]
        public static void Open()
        {
			GetWindow<GradientTextureCreator>("Gradient Texture Creator").Show();
		}

        private void CreateGradientTexture()
        {
	        Color[] colors = new Color[_width * _height];

	        for (int x = 0; x < _width; ++x)
	        {
		        for (int y = 0; y < _height; ++y)
		        {
			        float t = _orientation == Orientation.HORIZONTAL
						      ? x / (float)(_width - 1)
						      : y / (float)(_height - 1);
			        
			        Color color = _gradient.Evaluate(_inverted ? 1 - t : t);
			        colors[x + y * _width] = color;
		        }
	        }
	        
	        Texture2D gradientTexture = new Texture2D(_width, _height, TextureFormat.ARGB32, false);
	        gradientTexture.SetPixels(colors);
	        byte[] encodedTexture = gradientTexture.EncodeToPNG();

	        try
	        {
		        int fileIndex = 1;
		        string fileName = $"NewGradient{fileIndex}";
		        string path = $@"{Application.dataPath}/{fileName}.png";

		        while (System.IO.File.Exists(path))
		        {
			        fileIndex++;
			        fileName = $"NewGradient{fileIndex}";
			        path = $@"{Application.dataPath}/{fileName}.png";
		        }

		        System.IO.File.WriteAllBytes(path, encodedTexture);
		        AssetDatabase.ImportAsset($"Assets/{fileName}.png", ImportAssetOptions.Default);
		        Texture asset = AssetDatabase.LoadAssetAtPath<Texture>($"Assets/{fileName}.png");
		        Debug.Log($"Gradient texture created at path Assets/{fileName}.png.", asset);
	        }
	        catch (System.Exception e)
	        {
		        Debug.LogError(e);
	        }
        }
        
        private void OnGUI()
        {
	        EditorGUILayout.BeginHorizontal();
	        GUILayout.Space(10f);
	        EditorGUILayout.BeginVertical();
	        GUILayout.Space(10f);

	        GUILayout.Space(10f);
	        EditorGUILayout.BeginVertical(EditorStyles.helpBox);
	        GUILayout.Space(5f);

	        _gradient = EditorGUILayout.GradientField("Gradient: ", _gradient, GUILayout.ExpandWidth(true));
	        _width = EditorGUILayout.IntField("Width: ", _width, GUILayout.ExpandWidth(true));
	        _height = EditorGUILayout.IntField("Height: ", _height, GUILayout.ExpandWidth(true));
	        _orientation = (Orientation)EditorGUILayout.EnumPopup("Orientation: ", _orientation, GUILayout.ExpandWidth(true));
	        _inverted = EditorGUILayout.Toggle("Inverted: ", _inverted, GUILayout.ExpandWidth(true));
		        
	        GUILayout.Space(5);
	        EditorGUILayout.EndVertical();
	        GUILayout.Space(10);

	        if (GUILayout.Button("Create Texture", GUILayout.Height(45f), GUILayout.ExpandWidth(true)))
		        CreateGradientTexture();

	        EditorGUILayout.EndVertical();
	        GUILayout.Space(10f);
	        EditorGUILayout.EndHorizontal();

	        Repaint();
        }
    }
}
