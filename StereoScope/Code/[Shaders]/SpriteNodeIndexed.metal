//
//  SpriteNodeIndexed.metal
//  RebuildEarth
//
//  Created by Nicky Taylor on 2/12/23.
//

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

#define SpriteNodeIndexedVertexIndexData 0
#define SpriteNodeIndexedVertexIndexUniforms 1

#define SpriteNodeIndexedFragmentIndexTexture 0
#define SpriteNodeIndexedFragmentIndexSampler 1
#define SpriteNodeIndexedFragmentIndexUniforms 2
#define SpriteNodeIndexedFragmentIndexNightTexture 3

typedef struct {
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 modelViewMatrix;
} SpriteNodeIndexedVertexUniforms;

typedef struct {
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 modelViewMatrix;
    matrix_float4x4 normalMatrix;
} SpriteNodeIndexedLightsVertexUniforms;

typedef struct {
    float r;
    float g;
    float b;
    float a;
} SpriteNodeIndexedFragmentUniforms;

typedef struct {
    float r;
    float g;
    float b;
    float a;
    
    float lightR;
    float lightG;
    float lightB;
    
    float lightAmbientIntensity;
    float lightDiffuseIntensity;
    
    float lightDirX;
    float lightDirY;
    float lightDirZ;
    
} SpriteNodeIndexedDiffuseFragmentUniforms;

typedef struct {
    float r;
    float g;
    float b;
    float a;
    
    float lightR;
    float lightG;
    float lightB;
    
    float lightAmbientIntensity;
    float lightDiffuseIntensity;
    float lightSpecularIntensity;
    
    float lightDirX;
    float lightDirY;
    float lightDirZ;
    
    float lightShininess;
    
} SpriteNodeIndexedPhongFragmentUniforms;


typedef struct {
    float4 position [[position]];
    float2 textureCoord;
} SpriteNodeIndexedColorInOut;

typedef struct {
    float4 position [[position]];
    float2 textureCoord;
    float4 color;
} SpriteNodeColoredIndexedColorInOut;

typedef struct {
    float4 position [[position]];
    float2 textureCoord;
    float3 normal;
} SpriteNodeDiffuseIndexedColorInOut;

typedef struct {
    float4 position [[position]];
    float2 textureCoord;
    float3 normal;
    float3 eye;
} SpriteNodePhongIndexedColorInOut;

typedef struct {
    float4 position [[position]];
    float2 textureCoord;
    float3 normal;
    float4 color;
} SpriteNodeDiffuseColoredIndexedColorInOut;

typedef struct {
    float4 position [[position]];
    float2 textureCoord;
    float3 normal;
    float3 eye;
    float4 color;
} SpriteNodePhongColoredIndexedColorInOut;

typedef struct {
    packed_float2 position [[]];
    packed_float2 textureCoord [[]];
} SpriteNodeIndexedVertex2D;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
} SpriteNodeIndexedVertex3D;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
    packed_float3 normal [[]];
} SpriteNodeLightsIndexedVertex3D;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
    packed_float3 normal [[]];
    packed_float4 color [[]];
} SpriteNodeLightsColoredIndexedVertex3D;

typedef struct {
    packed_float2 position [[]];
    packed_float2 textureCoord [[]];
    packed_float4 color [[]];
} SpriteNodeColoredIndexedVertex2D;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
    packed_float4 color [[]];
} SpriteNodeColoredIndexedVertex3D;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
    packed_float4 color [[]];
    float shift [[]];
} SpriteNodeStereoscopicColoredIndexedVertex3D;

vertex SpriteNodeIndexedColorInOut sprite_node_indexed_2d_vertex(constant SpriteNodeIndexedVertex2D *verts [[buffer(SpriteNodeIndexedVertexIndexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant SpriteNodeIndexedVertexUniforms & uniforms [[ buffer(SpriteNodeIndexedVertexIndexUniforms) ]]) {
    SpriteNodeIndexedColorInOut out;
    float4 position = float4(verts[vid].position, 0.0, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    return out;
}

fragment float4 sprite_node_indexed_2d_fragment(SpriteNodeIndexedColorInOut in [[stage_in]],
                                                constant SpriteNodeIndexedFragmentUniforms & uniforms [[buffer(SpriteNodeIndexedFragmentIndexUniforms)]],
                                                texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r,
                           colorSample.g * uniforms.g,
                           colorSample.b * uniforms.b,
                           colorSample.a * uniforms.a);
    return result;
}

fragment float4 sprite_node_white_indexed_2d_fragment(SpriteNodeIndexedColorInOut in [[stage_in]],
                                                constant SpriteNodeIndexedFragmentUniforms & uniforms [[buffer(SpriteNodeIndexedFragmentIndexUniforms)]],
                                                texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.a * uniforms.r,
                           colorSample.a * uniforms.g,
                           colorSample.a * uniforms.b,
                           colorSample.a * uniforms.a);
    return result;
}

vertex SpriteNodeColoredIndexedColorInOut sprite_node_colored_indexed_2d_vertex(constant SpriteNodeColoredIndexedVertex2D *verts [[buffer(SpriteNodeIndexedVertexIndexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant SpriteNodeIndexedVertexUniforms & uniforms [[ buffer(SpriteNodeIndexedVertexIndexUniforms) ]]) {
    SpriteNodeColoredIndexedColorInOut out;
    float4 position = float4(verts[vid].position, 0.0, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.color = verts[vid].color;
    return out;
}


fragment float4 sprite_node_colored_indexed_2d_fragment(SpriteNodeColoredIndexedColorInOut in [[stage_in]],
                                                constant SpriteNodeIndexedFragmentUniforms & uniforms [[buffer(SpriteNodeIndexedFragmentIndexUniforms)]],
                                                texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * in.color[0],
                           colorSample.g * uniforms.g * in.color[1],
                           colorSample.b * uniforms.b * in.color[2],
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}


fragment float4 sprite_node_colored_white_indexed_2d_fragment(SpriteNodeColoredIndexedColorInOut in [[stage_in]],
                                                constant SpriteNodeIndexedFragmentUniforms & uniforms [[buffer(SpriteNodeIndexedFragmentIndexUniforms)]],
                                                texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.a * uniforms.r * in.color[0],
                           colorSample.a * uniforms.g * in.color[1],
                           colorSample.a * uniforms.b * in.color[2],
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}


vertex SpriteNodeIndexedColorInOut sprite_node_indexed_3d_vertex(constant SpriteNodeIndexedVertex3D *verts [[buffer(SpriteNodeIndexedVertexIndexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant SpriteNodeIndexedVertexUniforms & uniforms [[ buffer(SpriteNodeIndexedVertexIndexUniforms) ]]) {
    SpriteNodeIndexedColorInOut out;
    float4 position = float4(verts[vid].position, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    return out;
}

fragment float4 sprite_node_indexed_3d_fragment(SpriteNodeIndexedColorInOut in [[stage_in]],
                                                constant SpriteNodeIndexedFragmentUniforms & uniforms [[buffer(SpriteNodeIndexedFragmentIndexUniforms)]],
                                                texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r,
                           colorSample.g * uniforms.g,
                           colorSample.b * uniforms.b,
                           colorSample.a * uniforms.a);
    return result;
}

vertex SpriteNodeDiffuseIndexedColorInOut sprite_node_indexed_diffuse_3d_vertex(constant SpriteNodeLightsIndexedVertex3D *verts [[buffer(SpriteNodeIndexedVertexIndexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant SpriteNodeIndexedLightsVertexUniforms & uniforms [[ buffer(SpriteNodeIndexedVertexIndexUniforms) ]]) {
    SpriteNodeDiffuseIndexedColorInOut out;
    float4 position = float4(verts[vid].position, 1.0);
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.normal = float3(uniforms.normalMatrix * normal);
    return out;
}

fragment float4 sprite_node_indexed_diffuse_3d_fragment(SpriteNodeDiffuseIndexedColorInOut in [[stage_in]],
                                                constant SpriteNodeIndexedDiffuseFragmentUniforms & uniforms [[buffer(SpriteNodeIndexedFragmentIndexUniforms)]],
                                                texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    float3 inNormalized = normalize(in.normal);
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormalized, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    float combinedLightIntensity = ambientIntensity + diffuseIntensity;
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * uniforms.lightR * combinedLightIntensity,
                           colorSample.g * uniforms.g * uniforms.lightG * combinedLightIntensity,
                           colorSample.b * uniforms.b * uniforms.lightB * combinedLightIntensity,
                           colorSample.a * uniforms.a);
    return result;
}

vertex SpriteNodeDiffuseColoredIndexedColorInOut sprite_node_indexed_diffuse_colored_3d_vertex(constant SpriteNodeLightsColoredIndexedVertex3D *verts [[buffer(SpriteNodeIndexedVertexIndexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant SpriteNodeIndexedLightsVertexUniforms & uniforms [[ buffer(SpriteNodeIndexedVertexIndexUniforms) ]]) {
    SpriteNodeDiffuseColoredIndexedColorInOut out;
    float4 position = float4(verts[vid].position, 1.0);
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.normal = float3(uniforms.normalMatrix * normal);
    out.color = verts[vid].color;
    return out;
}

fragment float4 sprite_node_indexed_diffuse_colored_3d_fragment(SpriteNodeDiffuseColoredIndexedColorInOut in [[stage_in]],
                                                constant SpriteNodeIndexedDiffuseFragmentUniforms & uniforms [[buffer(SpriteNodeIndexedFragmentIndexUniforms)]],
                                                texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    float3 inNormalized = normalize(in.normal);
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormalized, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    float combinedLightIntensity = ambientIntensity + diffuseIntensity;
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * uniforms.lightR * combinedLightIntensity * in.color[0],
                           colorSample.g * uniforms.g * uniforms.lightG * combinedLightIntensity * in.color[1],
                           colorSample.b * uniforms.b * uniforms.lightB * combinedLightIntensity * in.color[2],
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}

vertex SpriteNodePhongIndexedColorInOut sprite_node_indexed_phong_3d_vertex(constant SpriteNodeLightsIndexedVertex3D *verts [[buffer(SpriteNodeIndexedVertexIndexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant SpriteNodeIndexedLightsVertexUniforms & uniforms [[ buffer(SpriteNodeIndexedVertexIndexUniforms) ]]) {
    SpriteNodePhongIndexedColorInOut out;
    float4 position = float4(verts[vid].position, 1.0);
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.normal = float3(uniforms.normalMatrix * normal);
    out.eye = float3(uniforms.normalMatrix * position);
    return out;
}


fragment float4 sprite_node_indexed_phong_3d_fragment(SpriteNodePhongIndexedColorInOut in [[stage_in]],
                                                constant SpriteNodeIndexedPhongFragmentUniforms & uniforms [[buffer(SpriteNodeIndexedFragmentIndexUniforms)]],
                                                texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    float3 inNormalized = normalize(in.normal);
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float3 eye = normalize(in.eye);
    float3 reflectedNormalized = normalize(-reflect(antiDirection, inNormalized));
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormalized, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    float specularIntensity = pow(max(dot(reflectedNormalized, eye), 0.0), uniforms.lightShininess) * uniforms.lightSpecularIntensity;
    specularIntensity = clamp(specularIntensity, 0.0, 10.0);
    float combinedLightIntensity = ambientIntensity + diffuseIntensity + specularIntensity;
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * uniforms.lightR * combinedLightIntensity,
                           colorSample.g * uniforms.g * uniforms.lightG * combinedLightIntensity,
                           colorSample.b * uniforms.b * uniforms.lightB * combinedLightIntensity,
                           colorSample.a * uniforms.a);
    return result;
}

vertex SpriteNodePhongColoredIndexedColorInOut sprite_node_indexed_phong_colored_3d_vertex(constant SpriteNodeLightsColoredIndexedVertex3D *verts [[buffer(SpriteNodeIndexedVertexIndexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant SpriteNodeIndexedLightsVertexUniforms & uniforms [[ buffer(SpriteNodeIndexedVertexIndexUniforms) ]]) {
    SpriteNodePhongColoredIndexedColorInOut out;
    float4 position = float4(verts[vid].position, 1.0);
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.normal = float3(uniforms.normalMatrix * normal);
    out.eye = float3(uniforms.normalMatrix * position);
    out.color = verts[vid].color;
    return out;
}

fragment float4 sprite_node_indexed_phong_colored_3d_fragment(SpriteNodePhongColoredIndexedColorInOut in [[stage_in]],
                                                constant SpriteNodeIndexedPhongFragmentUniforms & uniforms [[buffer(SpriteNodeIndexedFragmentIndexUniforms)]],
                                                texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    float3 inNormalized = normalize(in.normal);
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float3 eye = normalize(in.eye);
    float3 reflectedNormalized = normalize(-reflect(antiDirection, inNormalized));
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormalized, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    float specularIntensity = pow(max(dot(reflectedNormalized, eye), 0.0), uniforms.lightShininess) * uniforms.lightSpecularIntensity;
    specularIntensity = clamp(specularIntensity, 0.0, 10.0);
    float combinedLightIntensity = ambientIntensity + diffuseIntensity + specularIntensity;
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * uniforms.lightR * combinedLightIntensity * in.color[0],
                           colorSample.g * uniforms.g * uniforms.lightG * combinedLightIntensity * in.color[1],
                           colorSample.b * uniforms.b * uniforms.lightB * combinedLightIntensity * in.color[2],
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}

fragment float4 sprite_node_white_indexed_3d_fragment(SpriteNodeIndexedColorInOut in [[stage_in]],
                                                constant SpriteNodeIndexedFragmentUniforms & uniforms [[buffer(SpriteNodeIndexedFragmentIndexUniforms)]],
                                                texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.a * uniforms.r,
                           colorSample.a * uniforms.g,
                           colorSample.a * uniforms.b,
                           colorSample.a * uniforms.a);
    return result;
}

vertex SpriteNodeColoredIndexedColorInOut sprite_node_colored_indexed_3d_vertex(constant SpriteNodeColoredIndexedVertex3D *verts [[buffer(SpriteNodeIndexedVertexIndexData)]],
                                                                    uint vid [[vertex_id]],
                                                                   constant SpriteNodeIndexedVertexUniforms & uniforms [[ buffer(SpriteNodeIndexedVertexIndexUniforms) ]]) {
    SpriteNodeColoredIndexedColorInOut out;
    float4 position = float4(verts[vid].position, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.color = verts[vid].color;
    return out;
}

fragment float4 sprite_node_colored_indexed_3d_fragment(SpriteNodeColoredIndexedColorInOut in [[stage_in]],
                                                constant SpriteNodeIndexedFragmentUniforms & uniforms [[buffer(SpriteNodeIndexedFragmentIndexUniforms)]],
                                                texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * in.color[0],
                           colorSample.g * uniforms.g * in.color[1],
                           colorSample.b * uniforms.b * in.color[2],
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}


fragment float4 sprite_node_colored_white_indexed_3d_fragment(SpriteNodeColoredIndexedColorInOut in [[stage_in]],
                                                constant SpriteNodeIndexedFragmentUniforms & uniforms [[buffer(SpriteNodeIndexedFragmentIndexUniforms)]],
                                                texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.a * uniforms.r * in.color[0],
                           colorSample.a * uniforms.g * in.color[1],
                           colorSample.a * uniforms.b * in.color[2],
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}

vertex SpriteNodeColoredIndexedColorInOut sprite_node_stereoscopic_left_colored_indexed_3d_vertex(constant SpriteNodeStereoscopicColoredIndexedVertex3D *verts [[buffer(SpriteNodeIndexedVertexIndexData)]],
                                                                    uint vid [[vertex_id]],
                                                                   constant SpriteNodeIndexedVertexUniforms & uniforms [[ buffer(SpriteNodeIndexedVertexIndexUniforms) ]]) {
    SpriteNodeColoredIndexedColorInOut out;
    float4 position = float4(verts[vid].position, 1.0);
    float shift = verts[vid].shift;
    position[0] -= shift;
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.color = verts[vid].color;
    return out;
}

vertex SpriteNodeColoredIndexedColorInOut sprite_node_stereoscopic_right_colored_indexed_3d_vertex(constant SpriteNodeStereoscopicColoredIndexedVertex3D *verts [[buffer(SpriteNodeIndexedVertexIndexData)]],
                                                                    uint vid [[vertex_id]],
                                                                   constant SpriteNodeIndexedVertexUniforms & uniforms [[ buffer(SpriteNodeIndexedVertexIndexUniforms) ]]) {
    SpriteNodeColoredIndexedColorInOut out;
    float4 position = float4(verts[vid].position, 1.0);
    float shift = verts[vid].shift;
    position[0] += shift;
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.color = verts[vid].color;
    return out;
}

fragment float4 sprite_node_stereo_left_colored_indexed_3d_fragment(SpriteNodeColoredIndexedColorInOut in [[stage_in]],
                                                                    constant SpriteNodeIndexedFragmentUniforms & uniforms [[buffer(SpriteNodeIndexedFragmentIndexUniforms)]],
                                                texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(0.0,
                           colorSample.g * uniforms.g * in.color[1],
                           colorSample.b * uniforms.b * in.color[2],
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}

fragment float4 sprite_node_stereo_right_colored_indexed_3d_fragment(SpriteNodeColoredIndexedColorInOut in [[stage_in]],
                                                                    constant SpriteNodeIndexedFragmentUniforms & uniforms [[buffer(SpriteNodeIndexedFragmentIndexUniforms)]],
                                                texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * in.color[0],
                           0.0,
                           0.0,
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}
