Shader "RSPostProcessing/Paint Canvas"
{
    Properties
    {
        _CanvasGrain ("Canvas Grain", 2D) = "black" {}
        _CanvasMask ("Canvas Mask", 2D) = "white" {}
        _CanvasGrainIntensity ("Canvas Grain Intensity", Range(0, 1)) = 1
        _CanvasScaleX ("Canvas Scale X", Float) = 1
        _CanvasScaleY ("Canvas Scale Y", Float) = 1
        
        [HideInInspector] _MainTex ("Texture", 2D) = "white" {}
    }
    
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv     : TEXCOORD0;
            };

            sampler2D _MainTex;
            sampler2D _CanvasGrain;
            sampler2D _CanvasMask;
            float _CanvasGrainIntensity;
            float _CanvasScaleX;
            float _CanvasScaleY;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float4 color = tex2D(_MainTex, i.uv);
                float3 canvasGrain = tex2D(_CanvasGrain, i.uv * float2(_CanvasScaleX, _CanvasScaleY)).rgb;
                float canvasMask = tex2D(_CanvasMask, i.uv).r;
                
                float3 paintColor = lerp(color.rgb, color.rgb * canvasGrain, _CanvasGrainIntensity); // TODO: Make grain blend mode dynamic.
                
                return fixed4(lerp(canvasGrain, paintColor, canvasMask), color.a);
            }
            
            ENDCG
        }
    }
}