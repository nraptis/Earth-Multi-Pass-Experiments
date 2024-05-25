//
//  GaussianBlur.metal
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

#define SpriteNodeIndexedVertexIndexData 0
#define SpriteNodeIndexedVertexIndexUniforms 1

#define SpriteNodeIndexedFragmentIndexTexture 0
#define SpriteNodeIndexedFragmentIndexSampler 1
#define SpriteNodeIndexedFragmentIndexUniforms 2

typedef struct {
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 modelViewMatrix;
} SpriteVertexUniforms;

typedef struct {
    float r;
    float g;
    float b;
    float a;
} SpriteFragmentUniforms;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
} SpriteNodeIndexedVertex3D;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
    packed_float4 color [[]];
} SpriteNodeColoredIndexedVertex3D;

typedef struct {
    float4 position [[position]];
    float2 textureCoord;
} SpriteNodeIndexedColorInOut;

typedef struct {
    float4 position [[position]];
    float2 textureCoord;
    float4 color;
} SpriteNodeColoredIndexedColorInOut;

vertex SpriteNodeIndexedColorInOut gaussian_blur_indexed_3d_vertex(constant SpriteNodeIndexedVertex3D *verts [[buffer(SpriteNodeIndexedVertexIndexData)]],
                                                uint vid [[vertex_id]],
                                                constant SpriteVertexUniforms & uniforms [[ buffer(SpriteNodeIndexedVertexIndexUniforms) ]]) {
    SpriteNodeIndexedColorInOut out;
    float4 position = float4(verts[vid].position, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    return out;
}

vertex SpriteNodeColoredIndexedColorInOut gaussian_blur_indexed_colored_3d_vertex(constant SpriteNodeColoredIndexedVertex3D *verts [[buffer(SpriteNodeIndexedVertexIndexData)]],
                                                uint vid [[vertex_id]],
                                                constant SpriteVertexUniforms & uniforms [[ buffer(SpriteNodeIndexedVertexIndexUniforms) ]]) {
    SpriteNodeColoredIndexedColorInOut out;
    float4 position = float4(verts[vid].position, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.color = verts[vid].color;
    return out;
}

fragment float4 gaussian_blur_indexed_3d_horizontal_fragment(SpriteNodeIndexedColorInOut in [[stage_in]],
                                                     constant SpriteFragmentUniforms & uniforms [[ buffer(SpriteNodeIndexedFragmentIndexUniforms) ]],
                                                     texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                     sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    float2 center = in.textureCoord;
    float width = colorMap.get_width();
    float stepX = (1.0 / width) * 3.0;
    half3 sum = half3(0.0, 0.0, 0.0);
    sum += colorMap.sample(colorSampler, float2(center.x - stepX * 2.0, center.y)).rgb * 0.133974596858;
    sum += colorMap.sample(colorSampler, float2(center.x - stepX, center.y)).rgb * 0.232050821185;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y)).rgb * 0.267949193716;
    sum += colorMap.sample(colorSampler, float2(center.x + stepX, center.y)).rgb * 0.232050821185;
    sum += colorMap.sample(colorSampler, float2(center.x + stepX * 2.0, center.y)).rgb * 0.133974596858;
    float r = clamp((float)sum[0], 0.0, 1.0);
    float g = clamp((float)sum[1], 0.0, 1.0);
    float b = clamp((float)sum[2], 0.0, 1.0);
    return float4(r, g, b, 1.0);
}

fragment float4 gaussian_blur_indexed_3d_vertical_fragment (SpriteNodeIndexedColorInOut in [[stage_in]],
                                                    constant SpriteFragmentUniforms & uniforms [[ buffer(SpriteNodeIndexedFragmentIndexUniforms) ]],
                                                    texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                    sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    float2 center = in.textureCoord;
    float aHeight = colorMap.get_height();
    float aStepY = (1.0 / aHeight) * 3.0;
    half3 sum = half3(0.0, 0.0, 0.0);
    sum += colorMap.sample(colorSampler, float2(center.x, center.y - aStepY * 2.0)).rgb * 0.133974596858;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y - aStepY)).rgb * 0.232050821185;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y)).rgb * 0.267949193716;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y + aStepY)).rgb * 0.232050821185;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y + aStepY * 2.0)).rgb * 0.133974596858;
    float r = clamp((float)sum[0], 0.0, 1.0);
    float g = clamp((float)sum[1], 0.0, 1.0);
    float b = clamp((float)sum[2], 0.0, 1.0);
    return float4(r, g, b, 1.0);
}

fragment float4 gaussian_blur_indexed_colored_indexed_3d_horizontal_fragment(SpriteNodeColoredIndexedColorInOut in [[stage_in]],
                                                     constant SpriteFragmentUniforms & uniforms [[ buffer(SpriteNodeIndexedFragmentIndexUniforms) ]],
                                                     texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                     sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    float2 center = in.textureCoord;
    float width = colorMap.get_width();
    float stepX = (1.0 / width) * 3.0;
    half3 sum = half3(0.0, 0.0, 0.0);
    sum += colorMap.sample(colorSampler, float2(center.x - stepX * 2.0, center.y)).rgb * 0.133974596858;
    sum += colorMap.sample(colorSampler, float2(center.x - stepX, center.y)).rgb * 0.232050821185;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y)).rgb * 0.267949193716;
    sum += colorMap.sample(colorSampler, float2(center.x + stepX, center.y)).rgb * 0.232050821185;
    sum += colorMap.sample(colorSampler, float2(center.x + stepX * 2.0, center.y)).rgb * 0.133974596858;
    float r = clamp((float)sum[0] * in.color[0], 0.0, 1.0);
    float g = clamp((float)sum[1] * in.color[1], 0.0, 1.0);
    float b = clamp((float)sum[2] * in.color[2], 0.0, 1.0);
    return float4(r, g, b, 1.0 * in.color[3]);
}

fragment float4 gaussian_blur_indexed_colored_indexed_3d_vertical_fragment (SpriteNodeColoredIndexedColorInOut in [[stage_in]],
                                                                    constant SpriteFragmentUniforms & uniforms [[ buffer(SpriteNodeIndexedFragmentIndexUniforms) ]],
                                                    texture2d<half> colorMap [[ texture(SpriteNodeIndexedFragmentIndexTexture) ]],
                                                    sampler colorSampler [[ sampler(SpriteNodeIndexedFragmentIndexSampler) ]]) {
    float2 center = in.textureCoord;
    float aHeight = colorMap.get_height();
    float aStepY = (1.0 / aHeight) * 3.0;
    half3 sum = half3(0.0, 0.0, 0.0);
    sum += colorMap.sample(colorSampler, float2(center.x, center.y - aStepY * 2.0)).rgb * 0.133974596858;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y - aStepY)).rgb * 0.232050821185;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y)).rgb * 0.267949193716;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y + aStepY)).rgb * 0.232050821185;
    sum += colorMap.sample(colorSampler, float2(center.x, center.y + aStepY * 2.0)).rgb * 0.133974596858;
    float r = clamp((float)sum[0] * in.color[0], 0.0, 1.0);
    float g = clamp((float)sum[1] * in.color[1], 0.0, 1.0);
    float b = clamp((float)sum[2] * in.color[2], 0.0, 1.0);
    return float4(r, g, b, 1.0 * in.color[3]);
}
