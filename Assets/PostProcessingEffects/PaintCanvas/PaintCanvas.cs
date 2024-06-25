namespace RSPostProcessing
{
    using UnityEngine;

    [ExecuteInEditMode]
    [AddComponentMenu("RSPostProcessing/Paint Canvas")]
    public class PaintCanvas : CameraPostEffect
    {
        private static readonly int CANVAS_GRAIN_ID = Shader.PropertyToID("_CanvasGrain");
        private static readonly int CANVAS_MASK_ID = Shader.PropertyToID("_CanvasMask");
        private static readonly int CANVAS_GRAIN_INTENSITY_ID = Shader.PropertyToID("_CanvasGrainIntensity");
        private static readonly int CANVAS_SCALE_X_ID = Shader.PropertyToID("_CanvasScaleX");
        private static readonly int CANVAS_SCALE_Y_ID = Shader.PropertyToID("_CanvasScaleY");
        private static readonly int SHARPEN_SIZE_ID = Shader.PropertyToID("_SharpenSize");
        private static readonly int SHARPEN_INTENSITY_ID = Shader.PropertyToID("_SharpenIntensity");
        
        [SerializeField]
        private Texture2D _canvasGrain;
        [SerializeField]
        private Texture2D _canvasMask;
        [SerializeField, Range(0f, 1f)]
        private float _canvasGrainIntensity = 1f;
        [SerializeField, Min(0.01f)]
        private float _canvasScaleX = 1f;
        [SerializeField, Min(0.01f)]
        private float _canvasScaleY = 1f;
        
        [SerializeField, Range(0.00005f, 0.0008f)]
        private float _sharpenSize = 0.0001f;
        [SerializeField, Range(0f, 4f)]
        private float _sharpenIntensity = 2f;
        
        protected override string ShaderName => "RSPostProcessing/Paint Canvas";

        protected override void OnBeforeRenderImage(RenderTexture source, RenderTexture destination, Material material)
        {
            material.SetTexture(CANVAS_GRAIN_ID, _canvasGrain);
            material.SetTexture(CANVAS_MASK_ID, _canvasMask);
            material.SetFloat(CANVAS_GRAIN_INTENSITY_ID, _canvasGrainIntensity);
            material.SetFloat(CANVAS_SCALE_X_ID, _canvasScaleX);
            material.SetFloat(CANVAS_SCALE_Y_ID, _canvasScaleY);
            this.Material.SetFloat(SHARPEN_SIZE_ID, _sharpenSize);
            this.Material.SetFloat(SHARPEN_INTENSITY_ID, _sharpenIntensity);
        }
    }
}