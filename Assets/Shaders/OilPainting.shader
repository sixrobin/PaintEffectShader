Shader "Oil Painting"
{
    Properties
    {
        [Header(PAINT EFFECT)]
        [Space(5)]
        _PaintTexture ("Paint Texture", 2D) = "white" {}
        [Toggle] _UseTriplanarMapping ("Use Triplanar Mapping", Float) = 1
        _TriplanarScale ("Triplanar Scale", Vector) = (1, 1, 1, 1)
        _ColorRamp ("Color Ramp", 2D) = "white" {}
        _PaintSmoothing ("Paint Smoothing", Range(0, 1)) = 0.5

        [Space(30)]
        
        [Header(LIGHTING)]
        [Space(5)]
        _LightIntensity ("Light Intensity", Range(0, 1)) = 1
        _LightColorIntensity ("Light Color Intensity", Range(0, 1)) = 1
        _MinLightValue ("Min Light Value", Range(0, 1)) = 0
        _MaxLightValue ("Max Light Value", Range(0, 1)) = 1
        _ShadowIntensity ("Shadow Intensity", Range(0, 1)) = 0.9

        [Space(30)]
        
        [Header(AMBIENT COLOR)]
        [Space(5)]
        _AmbientColorIntensity ("Ambient Color Intensity", Range(0, 1)) = 1
        _AmbientColorMinThreshold ("Ambient Color Min Threshold", Range(0, 1)) = 0

        [Space(30)]

        [Header(SPECULAR)]
        [Space(5)]
        _SpecularIntensity ("Specular Intensity", Range(0, 1)) = 1
        _SpecularPower ("Specular Power", Range(1, 128)) = 64
        _SpecularSmoothing ("Specular Smoothing", Range(0, 1)) = 0.5

        [Space(30)]

        [Header(FRESNEL)]
        [Space(5)]
        _FresnelPower ("Fresnel Power", Range(1, 10)) = 1
        _FresnelIntensity ("Fresnel Intensity", Range(0, 10)) = 1
        _FresnelSmoothing ("Fresnel Smoothing", Range(0, 1)) = 0.5
    }
    
    SubShader
    {
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
        
        Pass
        {
            Tags
            {
                "RenderType"="Opaque"
                "LightMode"="ForwardBase"
            }
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd_fullshadows nolightmap nodirlightmap nodynlightmap novertexlight

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
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
                float4 pos         : SV_POSITION;
                float2 uv          : TEXCOORD0;
                SHADOW_COORDS(1)
                float3 normal      : TEXCOORD2;
                float3 worldNormal : TEXCOORD3;
                float3 localPos    : TEXCOORD4;
                float3 worldPos    : TEXCOORD5;
            };

            sampler2D _PaintTexture;
            float4 _PaintTexture_ST;
            float _UseTriplanarMapping;
            
            sampler2D _ColorRamp;
            float4 _ColorRamp_ST;
            float _PaintSmoothing;
            
            float4 _LightColor0;
            float _LightIntensity;
            float _LightColorIntensity;
            float _AmbientColorIntensity;
            float _AmbientColorMinThreshold;
            float _MinLightValue;
            float _MaxLightValue;

            float _SpecularIntensity;
            float _SpecularPower;
            float _SpecularSmoothing;

            float _FresnelPower;
            float _FresnelIntensity;
            float _FresnelSmoothing;

            float _ShadowIntensity;
            
            v2f vert(appdata v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _PaintTexture);

                o.normal = v.normal;
                o.worldNormal = normalize(mul(unity_ObjectToWorld, float4(v.normal, 0))).xyz;
                
                o.localPos = v.vertex.xyz;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                TRANSFER_SHADOW(o)
                
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 normal = i.worldNormal * 0.5 + 0.5;
                float4 lightColor = _LightColor0;
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                
                // Paint brush texture.
                float paint = _UseTriplanarMapping
                              ? GetTriplanarMapping(_PaintTexture, i.localPos, i.normal).r
                              : tex2D(_PaintTexture, i.uv);

                // Diffuse base.
                float diffuse = computeLambert(lightColor.rgb, _LightIntensity, normal, lightDir).x;
                diffuse = smoothstep(paint - _PaintSmoothing, paint + _PaintSmoothing, diffuse);
                diffuse = clamp(diffuse, _MinLightValue, _MaxLightValue);

                // Specular.
                float specular = computeSpecular(_SpecularIntensity, i.worldNormal, lightDir, i.worldPos, _SpecularPower);
                specular = smoothstep(paint - _SpecularSmoothing, paint + _SpecularSmoothing, specular);
                diffuse += specular;

                // Fresnel.
                float fresnel = computeFresnel(i.worldNormal, i.worldPos, _FresnelPower) * _FresnelIntensity;
                fresnel = smoothstep(paint - _FresnelSmoothing, paint + _FresnelSmoothing, fresnel);
                diffuse += fresnel;

                // Cast shadow.
                float shadow = SHADOW_ATTENUATION(i);
                shadow = smoothstep(paint - _FresnelSmoothing, paint + _FresnelSmoothing, shadow);
                diffuse = lerp(diffuse, diffuse * shadow, _ShadowIntensity);

                // Coloring.
                float4 paintColor = tex2D(_ColorRamp, float2(diffuse, 0) * _ColorRamp_ST.xy + _ColorRamp_ST.zw);
                paintColor = lerp(paintColor, paintColor * lightColor, _LightColorIntensity);
                float3 ambientColor = UNITY_LIGHTMODEL_AMBIENT * _AmbientColorIntensity;
                float ambientColorMask = saturate(smoothstep(_AmbientColorMinThreshold, 1, 1 - diffuse));
                paintColor.rgb = lerp(paintColor.rgb, paintColor.rgb + ambientColor, ambientColorMask);
                
                return paintColor;
            }
            
            ENDCG
        }
        
    }
}
