#include <UnityShaderVariables.cginc>

float3 computeLambert(float3 lightColor, float lightIntensity, float3 normal, float3 lightDir)
{
    return lightColor * lightIntensity * max(0, dot(normal, lightDir));
}

float computeSpecular(float intensity, float3 normal, float3 lightDir, float3 worldPos, float power)
{
    float3 viewDir = normalize(_WorldSpaceCameraPos - worldPos);
    float3 halfway = normalize(lightDir + viewDir);
    return intensity * pow(max(0, dot(normalize(normal), halfway)), power);
}

float3 computeSpecular(float3 lightColor, float intensity, float3 normal, float3 lightDir, float3 worldPos, float power)
{
    float3 viewDir = normalize(_WorldSpaceCameraPos - worldPos);
    float3 halfway = normalize(lightDir + viewDir);
    return lightColor * intensity * pow(max(0, dot(normalize(normal), halfway)), power);
}

float computeFresnel(float3 normal, float3 worldPos, float power)
{
    return pow(1 - saturate(dot(normalize(normal), normalize(_WorldSpaceCameraPos - worldPos))), power);
}