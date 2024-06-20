struct TriplanarUV
{
    float2 x;
    float2 y;
    float2 z;
};

TriplanarUV GetTriplanarUV(float3 worldPos)
{
    TriplanarUV uv;
    uv.x = worldPos.zy;
    uv.y = worldPos.xz;
    uv.z = worldPos.xy;
    return uv;
}

float3 GetTriplanarWeights(float3 normal)
{
    float3 weight = abs(normal);
    return weight / (weight.x + weight.y + weight.z);
}

float GetTriplanarMapping(sampler2D textureSampler, float3 pos, float3 normal)
{
    TriplanarUV uv = GetTriplanarUV(pos);
    float3 weights = GetTriplanarWeights(normal);

    // TODO: Apply scaling.
    float3 x = tex2D(textureSampler, uv.x);
    float3 y = tex2D(textureSampler, uv.y);
    float3 z = tex2D(textureSampler, uv.z);
    
    return x * weights.x + y * weights.y + z * weights.z;
}