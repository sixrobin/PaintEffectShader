Shader "Oil Painting"
{
    Properties
    {
        _PaintTexture ("Paint Texture", 2D) = "white" {}
        _TriplanarScale ("Triplanar Scale", Float) = 1
        _ColorRamp ("Color Ramp", 2D) = "white" {}
        _PaintSmoothing ("Paint Smoothing", Range(0, 1)) = 0.5
        _LightIntensity ("Light Intensity", Range(0, 1)) = 1
        _AmbientColorIntensity ("Ambient Color Intensity", Range(0, 1)) = 1
        _AmbientColorMinThreshold ("Ambient Color Min Threshold", Range(0, 1)) = 0
        _MinLightValue ("Min Light Value", Range(0, 1)) = 0
        _MaxLightValue ("Max Light Value", Range(0, 1)) = 1
        _SpecularIntensity ("Specular Intensity", Range(0, 1)) = 1
        _SpecularPower ("Specular Power", Range(1, 128)) = 64
        _SpecularSmoothing ("Specular Smoothing", Range(0, 1)) = 0.5
    }
    
    SubShader
    {
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "Triplanar.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex      : SV_POSITION;
                float2 uv          : TEXCOORD0;
                float3 normal      : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
                float3 localPos    : TEXCOORD3;
                float3 worldPos    : TEXCOORD4;
            };

            sampler2D _PaintTexture;
            float4 _PaintTexture_ST;
            sampler2D _ColorRamp;
            float _PaintSmoothing;
            
            float4 _LightColor0;
            float _LightIntensity;
            float _AmbientColorIntensity;
            float _AmbientColorMinThreshold;
            float _MinLightValue;
            float _MaxLightValue;

            float _SpecularIntensity;
            float _SpecularPower;
            float _SpecularSmoothing;
            
            v2f vert(appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _PaintTexture);
                
                o.localPos = v.vertex.xyz;
                o.worldPos = mul(unity_ObjectToWorld, o.localPos);
                
                o.normal = v.normal;
                o.worldNormal = normalize(mul(unity_ObjectToWorld, float4(o.normal, 0)));

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float paint = GetTriplanarMapping(_PaintTexture, i.localPos, i.normal).r;
                // paint = tex2D(_PaintTexture, i.uv); // Discard triplanar mapping.

                float3 normal = i.worldNormal * 0.5 + 0.5;
                float4 lightColor = _LightColor0;
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

                float spec = specular(_SpecularIntensity, i.worldNormal, lightDir, i.worldPos, _SpecularPower);
                spec = smoothstep(paint - _SpecularSmoothing, paint + _SpecularSmoothing, spec);

                float diffuse = lambert(lightColor.rgb, _LightIntensity, normal, lightDir).x;
                diffuse = smoothstep(paint - _PaintSmoothing, paint + _PaintSmoothing, diffuse);
                diffuse = clamp(diffuse, _MinLightValue, _MaxLightValue);
                diffuse += spec;

                // TODO: Add fresnel to see how it looks.
                // TODO: Add shadows.

                float4 paintColor = tex2D(_ColorRamp, float2(diffuse, 0)) * lightColor;

                float3 ambientColor = UNITY_LIGHTMODEL_AMBIENT * _AmbientColorIntensity;
                float ambientColorMask = saturate(smoothstep(_AmbientColorMinThreshold, 1, 1 - diffuse));
                paintColor.rgb = lerp(paintColor.rgb, paintColor.rgb + ambientColor, ambientColorMask);
                
                return paintColor;
            }
            
            ENDCG
        }
    }
}
