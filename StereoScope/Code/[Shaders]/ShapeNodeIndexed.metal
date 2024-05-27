//
//  ShapeNodeIndexed.metal
//  RebuildEarth
//
//  Created by Nicky Taylor on 2/12/23.
//

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

#define SlotVertexData 0
#define SlotVertexUniforms 1

#define SlotFragmentUniforms 2

typedef struct {
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 modelViewMatrix;
} VertexUniforms;

typedef struct {
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 modelViewMatrix;
    matrix_float4x4 normalMatrix;
} VertexUniformsDiffuse;

typedef struct {
    float r;
    float g;
    float b;
    float a;
} FragmentUniforms;

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
    
} FragmentUniformsDiffuse;

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
    
} FragmentUniformsPhong;

typedef struct {
    float4 position [[position]];
} InOut;

typedef struct {
    float4 position [[position]];
    float4 color;
} InOutColors;

typedef struct {
    float4 position [[position]];
    float3 normal;
} InOutDiffuse;

typedef struct {
    float4 position [[position]];
    float3 normal;
    float3 eye;
} InOutPhong;

typedef struct {
    float4 position [[position]];
    float3 normal;
    float4 color;
} InOutDiffuseColors;

typedef struct {
    float4 position [[position]];
    float3 normal;
    float3 eye;
    float4 color;
} InOutPhongColors;

typedef struct {
    packed_float2 position [[]];
} Vertex2D;

typedef struct {
    packed_float2 position [[]];
    packed_float4 color [[]];
} Vertex2DColors;

typedef struct {
    packed_float3 position [[]];
} Vertex3D;

typedef struct {
    packed_float3 position [[]];
    packed_float4 color [[]];
} Vertex3DColors;

typedef struct {
    packed_float3 position [[]];
    packed_float3 normal [[]];
} Vertex3DDiffuse;

typedef struct {
    packed_float3 position [[]];
    packed_float3 normal [[]];
    packed_float4 color [[]];
} Vertex3DDiffuseColors;

typedef struct {
    packed_float3 position [[]];
    packed_float4 color [[]];
    float shift [[]];
} SpriteNodeStereoscopicColoredIndexedVertex3D;

vertex InOut shape_node_2d_vertex(constant Vertex2D *verts [[buffer(SlotVertexData)]],
                                                                uint vid [[vertex_id]],
                                                                constant VertexUniforms & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOut out;
    float4 position = float4(verts[vid].position, 0.0, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    return out;
}

fragment float4 shape_node_2d_fragment(InOut in [[stage_in]],
                                                constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]]) {
    float4 result = float4(uniforms.r,
                           uniforms.g,
                           uniforms.b,
                           uniforms.a);
    return result;
}

vertex InOutColors shape_node_colored_2d_vertex(constant Vertex2DColors *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniforms & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutColors out;
    float4 position = float4(verts[vid].position, 0.0, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.color = verts[vid].color;
    return out;
}

fragment float4 shape_node_colored_2d_fragment(InOutColors in [[stage_in]],
                                                constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]]) {
    float4 result = float4(uniforms.r * in.color[0],
                           uniforms.g * in.color[1],
                           uniforms.b * in.color[2],
                           uniforms.a * in.color[3]);
    return result;
}

vertex InOut shape_node_3d_vertex(constant Vertex3D *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniforms & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOut out;
    float4 position = float4(verts[vid].position, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    return out;
}

fragment float4 shape_node_3d_fragment(InOut in [[stage_in]],
                                       constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]]) {
    float4 result = float4(uniforms.r,
                           uniforms.g,
                           uniforms.b,
                           uniforms.a);
    return result;
}

vertex InOutDiffuse shape_node_diffuse_3d_vertex(constant Vertex3DDiffuse *verts [[buffer(SlotVertexData)]],
                                                 uint vid [[vertex_id]],
                                                 constant VertexUniformsDiffuse & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutDiffuse out;
    float4 position = float4(verts[vid].position, 1.0);
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.normal = float3(uniforms.normalMatrix * normal);
    return out;
}

fragment float4 shape_node_diffuse_3d_fragment(InOutDiffuse in [[stage_in]],
                                                constant FragmentUniformsDiffuse & uniforms [[buffer(SlotFragmentUniforms)]]) {
    float3 inNormal = normalize(in.normal);
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormal, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    float combinedLightIntensity = ambientIntensity + diffuseIntensity;
    float4 result = float4(uniforms.r * uniforms.lightR * combinedLightIntensity,
                           uniforms.g * uniforms.lightG * combinedLightIntensity,
                           uniforms.b * uniforms.lightB * combinedLightIntensity,
                           uniforms.a);
    return result;
}

vertex InOutDiffuseColors shape_node_diffuse_colored_3d_vertex(constant Vertex3DDiffuseColors *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniformsDiffuse & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutDiffuseColors out;
    float4 position = float4(verts[vid].position, 1.0);
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.normal = float3(uniforms.normalMatrix * normal);
    out.color = verts[vid].color;
    return out;
}

fragment float4 shape_node_diffuse_colored_3d_fragment(InOutDiffuseColors in [[stage_in]],
                                                       constant FragmentUniformsDiffuse & uniforms [[buffer(SlotFragmentUniforms)]]) {
    float3 inNormal = normalize(in.normal);
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormal, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    float combinedLightIntensity = ambientIntensity + diffuseIntensity;
    float4 result = float4(uniforms.r * uniforms.lightR * combinedLightIntensity * in.color[0],
                           uniforms.g * uniforms.lightG * combinedLightIntensity * in.color[1],
                           uniforms.b * uniforms.lightB * combinedLightIntensity * in.color[2],
                           uniforms.a * in.color[3]);
    return result;
}

vertex InOutPhong shape_node_phong_3d_vertex(constant Vertex3DDiffuse *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniformsDiffuse & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutPhong out;
    float4 position = float4(verts[vid].position, 1.0);
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.normal = float3(uniforms.normalMatrix * normal);
    out.eye = float3(uniforms.normalMatrix * position);
    return out;
}

fragment float4 shape_node_phong_3d_fragment(InOutPhong in [[stage_in]],
                                             constant FragmentUniformsPhong & uniforms [[buffer(SlotFragmentUniforms)]]) {
    float3 inNormal = normalize(in.normal);
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float3 eye = normalize(in.eye);
    float3 reflectedNormalized = normalize(-reflect(antiDirection, inNormal));
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormal, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    float specularIntensity = pow(max(dot(reflectedNormalized, eye), 0.0), uniforms.lightShininess) * uniforms.lightSpecularIntensity;
    specularIntensity = clamp(specularIntensity, 0.0, 1.0);
    float combinedLightIntensity = ambientIntensity + diffuseIntensity + specularIntensity;
    float4 result = float4(uniforms.r * uniforms.lightR * combinedLightIntensity,
                           uniforms.g * uniforms.lightG * combinedLightIntensity,
                           uniforms.b * uniforms.lightB * combinedLightIntensity,
                           uniforms.a);
    return result;
}

vertex InOutPhongColors shape_node_phong_colored_3d_vertex(constant Vertex3DDiffuseColors *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniformsDiffuse & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutPhongColors out;
    float4 position = float4(verts[vid].position, 1.0);
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.normal = float3(uniforms.normalMatrix * normal);
    out.eye = float3(uniforms.normalMatrix * position);
    out.color = verts[vid].color;
    return out;
}

fragment float4 shape_node_phong_colored_3d_fragment(InOutPhongColors in [[stage_in]],
                                                constant FragmentUniformsPhong & uniforms [[buffer(SlotFragmentUniforms)]]) {
    float3 inNormal = normalize(in.normal);
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float3 eye = normalize(in.eye);
    float3 reflectedNormalized = normalize(-reflect(antiDirection, inNormal));
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormal, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    float specularIntensity = pow(max(dot(reflectedNormalized, eye), 0.0), uniforms.lightShininess) * uniforms.lightSpecularIntensity;
    specularIntensity = clamp(specularIntensity, 0.0, 10.0);
    float combinedLightIntensity = ambientIntensity + diffuseIntensity + specularIntensity;
    float4 result = float4(uniforms.r * uniforms.lightR * combinedLightIntensity * in.color[0],
                           uniforms.g * uniforms.lightG * combinedLightIntensity * in.color[1],
                           uniforms.b * uniforms.lightB * combinedLightIntensity * in.color[2],
                           uniforms.a * in.color[3]);
    return result;
}

vertex InOutColors shape_node_colored_3d_vertex(constant Vertex3DColors *verts [[buffer(SlotVertexData)]],
                                                                    uint vid [[vertex_id]],
                                                                   constant VertexUniforms & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutColors out;
    float4 position = float4(verts[vid].position, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.color = verts[vid].color;
    return out;
}

fragment float4 shape_node_colored_3d_fragment(InOutColors in [[stage_in]],
                                                constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]]) {
    float4 result = float4(uniforms.r * in.color[0],
                           uniforms.g * in.color[1],
                           uniforms.b * in.color[2],
                           uniforms.a * in.color[3]);
    return result;
}
