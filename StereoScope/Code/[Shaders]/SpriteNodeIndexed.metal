//
//  SpriteNodeIndexed.metal
//  RebuildEarth
//
//  Created by Nicky Taylor on 2/12/23.
//

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

#define SlotVertexData 0
#define SlotVertexUniforms 1

#define SlotFragmentTexture 0
#define SlotFragmentSampler 1
#define SlotFragmentUniforms 2
#define SlotFragmentLightTexture 3
#define SlotFragmentBumpTexture 4
#define SlotFragmentDisplacementTexture 5

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
    float r;
    float g;
    float b;
    float a;
    float lightR;
    float lightG;
    float lightB;
    float lightAmbientIntensity;
    float lightDiffuseIntensity;
    float lightNightIntensity;
    float lightDirX;
    float lightDirY;
    float lightDirZ;
    float overshoot;
    
} FragmentUniformsNight;

typedef struct {
    float4 position [[position]];
    float2 textureCoord;
} InOut;

typedef struct {
    float4 position [[position]];
    float2 textureCoord;
    float4 color;
} InOutColors;


typedef struct {
    float4 position [[position]];
    float2 textureCoord;
    float3 normal;
} InOutDiffuse;

typedef struct {
    float4 position [[position]];
    float2 textureCoord;
    float3 normal;
    float3 eye;
} InOutPhong;

typedef struct {
    float4 position [[position]];
    float2 textureCoord;
    float3 normal;
    float3 normalInverse;
} InOutNight;

typedef struct {
    float4 position [[position]];
    float2 textureCoord;
    float3 normal;
    float4 color;
} InOutDiffuseColors;

typedef struct {
    float4 position [[position]];
    float2 textureCoord;
    float3 normal;
    float3 eye;
    float4 color;
} InOutPhongColors;

typedef struct {
    packed_float2 position [[]];
    packed_float2 textureCoord [[]];
} Vertex2D;

typedef struct {
    packed_float2 position [[]];
    packed_float2 textureCoord [[]];
    packed_float4 color [[]];
} Vertex2DColors;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
} Vertex3D;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
    packed_float2 shift [[]];
} Vertex3DStereoscopic;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
    packed_float4 color [[]];
} Vertex3DColors;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
    packed_float4 color [[]];
    packed_float2 shift [[]];
} Vertex3DColorsStereoscopic;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
    packed_float3 normal [[]];
} Vertex3DDiffuse;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
    packed_float3 normal [[]];
    packed_float2 shift [[]];
} Vertex3DDiffuseStereoscopic;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
    packed_float3 normal [[]];
    packed_float4 color [[]];
} Vertex3DDiffuseColors;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
    packed_float3 normal [[]];
    packed_float4 color [[]];
    packed_float2 shift [[]];
} Vertex3DDiffuseColorsStereoscopic;

typedef struct {
    packed_float3 position [[]];
    packed_float2 textureCoord [[]];
    packed_float4 color [[]];
    float shift [[]];
} SpriteNodeStereoscopicColoredIndexedVertex3D;

vertex InOut sprite_node_2d_vertex(constant Vertex2D *verts [[buffer(SlotVertexData)]],
                                                                uint vid [[vertex_id]],
                                                                constant VertexUniforms & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOut out;
    float4 position = float4(verts[vid].position, 0.0, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    return out;
}

fragment float4 sprite_node_2d_fragment(InOut in [[stage_in]],
                                                constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r,
                           colorSample.g * uniforms.g,
                           colorSample.b * uniforms.b,
                           colorSample.a * uniforms.a);
    return result;
}

fragment float4 sprite_node_white_2d_fragment(InOut in [[stage_in]],
                                                constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.a * uniforms.r,
                           colorSample.a * uniforms.g,
                           colorSample.a * uniforms.b,
                           colorSample.a * uniforms.a);
    return result;
}

vertex InOutColors sprite_node_colored_2d_vertex(constant Vertex2DColors *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniforms & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutColors out;
    float4 position = float4(verts[vid].position, 0.0, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.color = verts[vid].color;
    return out;
}

fragment float4 sprite_node_colored_2d_fragment(InOutColors in [[stage_in]],
                                                constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * in.color[0],
                           colorSample.g * uniforms.g * in.color[1],
                           colorSample.b * uniforms.b * in.color[2],
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}


fragment float4 sprite_node_colored_white_2d_fragment(InOutColors in [[stage_in]],
                                                constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.a * uniforms.r * in.color[0],
                           colorSample.a * uniforms.g * in.color[1],
                           colorSample.a * uniforms.b * in.color[2],
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}

vertex InOut sprite_node_3d_vertex(constant Vertex3D *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniforms & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOut out;
    float4 position = float4(verts[vid].position, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    return out;
}

fragment float4 sprite_node_3d_fragment(InOut in [[stage_in]],
                                                constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r,
                           colorSample.g * uniforms.g,
                           colorSample.b * uniforms.b,
                           colorSample.a * uniforms.a);
    return result;
}

vertex InOut sprite_node_stereoscopic_blue_3d_vertex(constant Vertex3DStereoscopic *verts [[buffer(SlotVertexData)]],
                                                     uint vid [[vertex_id]],
                                                     constant VertexUniforms & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    
    InOut out;
    float4 position = float4(verts[vid].position, 1.0);
    position[0] += verts[vid].shift[0];
    
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    return out;
}

fragment float4 sprite_node_stereoscopic_blue_3d_fragment(InOut in [[stage_in]],
                                                constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(0.0,
                           colorSample.g * uniforms.g,
                           colorSample.b * uniforms.b,
                           colorSample.a * uniforms.a);
    
    return result;
}

vertex InOut sprite_node_stereoscopic_red_3d_vertex(constant Vertex3DStereoscopic *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniforms & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOut out;
    float4 position = float4(verts[vid].position, 1.0);
    position[0] -= verts[vid].shift[1];
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    return out;
}

fragment float4 sprite_node_stereoscopic_red_3d_fragment(InOut in [[stage_in]],
                                                           constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]],
                                                           texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                           sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r,
                           0.0,
                           0.0,
                           colorSample.a * uniforms.a);
    return result;
}




vertex InOutDiffuseColors sprite_node_diffuse_colored_3d_vertex(constant Vertex3DDiffuseColors *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniformsDiffuse & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutDiffuseColors out;
    float4 position = float4(verts[vid].position, 1.0);
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.normal = float3(uniforms.normalMatrix * normal);
    out.color = verts[vid].color;
    return out;
}

fragment float4 sprite_node_diffuse_colored_3d_fragment(InOutDiffuseColors in [[stage_in]],
                                                constant FragmentUniformsDiffuse & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    float3 inNormal = normalize(in.normal);
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormal, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    float combinedLightIntensity = ambientIntensity + diffuseIntensity;
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * uniforms.lightR * combinedLightIntensity * in.color[0],
                           colorSample.g * uniforms.g * uniforms.lightG * combinedLightIntensity * in.color[1],
                           colorSample.b * uniforms.b * uniforms.lightB * combinedLightIntensity * in.color[2],
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}


vertex InOutNight sprite_node_night_3d_vertex(constant Vertex3DDiffuse *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniformsDiffuse & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutNight out;
    float4 position = float4(verts[vid].position, 1.0);
    float4 normal = float4(verts[vid].normal, 1.0);
    float4 normalInverse = float4(-verts[vid].normal[0],
                                  -verts[vid].normal[1],
                                  -verts[vid].normal[2],
                                  1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.normal = float3(uniforms.normalMatrix * normal);
    out.normalInverse = float3(uniforms.normalMatrix * normalInverse);
    return out;
}

fragment float4 sprite_node_night_3d_fragment(InOutNight in [[stage_in]],
                                                constant FragmentUniformsNight & uniforms [[buffer(SlotFragmentUniforms)]],
                                              texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                              texture2d<half> lightMap [[ texture(SlotFragmentLightTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    float3 inNormal = normalize(in.normal);
    float3 inNormalInverse = normalize(in.normalInverse);
    
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormal, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    
    float combinedLightIntensity = ambientIntensity + diffuseIntensity;
    
    float nightIntensity = max(dot(inNormalInverse, antiDirection), 0.0) * uniforms.lightNightIntensity;
    nightIntensity = clamp(nightIntensity, 0.0, 1.0);
    
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    half4 lightSample = lightMap.sample(colorSampler, in.textureCoord.xy);
    
    float redBase = uniforms.r * uniforms.lightR;
    float greenBase = uniforms.g * uniforms.lightG;
    float blueBase = uniforms.b * uniforms.lightB;
    
    float redLeft = redBase * colorSample.r * combinedLightIntensity;
    float greenLeft = greenBase * colorSample.g * combinedLightIntensity;
    float blueLeft = blueBase * colorSample.b * combinedLightIntensity;
    
    float redRight = redBase * lightSample.r * nightIntensity;
    float greenRight = greenBase * lightSample.g * nightIntensity;
    float blueRight = blueBase * lightSample.b * nightIntensity;
    
    float red = clamp(redLeft + redRight, 0.0, 1.0);
    float green = clamp(greenLeft + greenRight, 0.0, 1.0);
    float blue = clamp(blueLeft + blueRight, 0.0, 1.0);
    
    
    float4 result = float4(red,
                           green,
                           blue,
                           1.0);
    return result;
}

//FragmentUniformsNight
//

vertex InOutPhong sprite_node_phong_3d_vertex(constant Vertex3DDiffuse *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniformsDiffuse & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutPhong out;
    float4 position = float4(verts[vid].position, 1.0);
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.normal = float3(uniforms.normalMatrix * normal);
    out.eye = float3(uniforms.normalMatrix * position);
    return out;
}

fragment float4 sprite_node_phong_3d_fragment(InOutPhong in [[stage_in]],
                                                constant FragmentUniformsPhong & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
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
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * uniforms.lightR * combinedLightIntensity,
                           colorSample.g * uniforms.g * uniforms.lightG * combinedLightIntensity,
                           colorSample.b * uniforms.b * uniforms.lightB * combinedLightIntensity,
                           colorSample.a * uniforms.a);
    return result;
}

vertex InOutPhongColors sprite_node_phong_colored_3d_vertex(constant Vertex3DDiffuseColors *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniformsDiffuse & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutPhongColors out;
    float4 position = float4(verts[vid].position, 1.0);
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.normal = float3(uniforms.normalMatrix * normal);
    out.eye = float3(uniforms.normalMatrix * position);
    out.color = verts[vid].color;
    return out;
}

fragment float4 sprite_node_phong_colored_3d_fragment(InOutPhongColors in [[stage_in]],
                                                constant FragmentUniformsPhong & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
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
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * uniforms.lightR * combinedLightIntensity * in.color[0],
                           colorSample.g * uniforms.g * uniforms.lightG * combinedLightIntensity * in.color[1],
                           colorSample.b * uniforms.b * uniforms.lightB * combinedLightIntensity * in.color[2],
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}

fragment float4 sprite_node_white_3d_fragment(InOut in [[stage_in]],
                                                constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.a * uniforms.r,
                           colorSample.a * uniforms.g,
                           colorSample.a * uniforms.b,
                           colorSample.a * uniforms.a);
    return result;
}

vertex InOutColors sprite_node_colored_3d_vertex(constant Vertex3DColors *verts [[buffer(SlotVertexData)]],
                                                                    uint vid [[vertex_id]],
                                                                   constant VertexUniforms & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutColors out;
    float4 position = float4(verts[vid].position, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.color = verts[vid].color;
    return out;
}

fragment float4 sprite_node_colored_3d_fragment(InOutColors in [[stage_in]],
                                                constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * in.color[0],
                           colorSample.g * uniforms.g * in.color[1],
                           colorSample.b * uniforms.b * in.color[2],
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}

vertex InOutColors sprite_node_colored_stereoscopic_blue_3d_vertex(constant Vertex3DColorsStereoscopic *verts [[buffer(SlotVertexData)]],
                                                                    uint vid [[vertex_id]],
                                                                   constant VertexUniforms & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutColors out;
    float4 position = float4(verts[vid].position, 1.0);
    position[0] += verts[vid].shift[0];
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.color = verts[vid].color;
    return out;
}

fragment float4 sprite_node_colored_stereoscopic_blue_3d_fragment(InOutColors in [[stage_in]],
                                                constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(0.0,
                           colorSample.g * uniforms.g * in.color[1],
                           colorSample.b * uniforms.b * in.color[2],
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}

vertex InOutColors sprite_node_colored_stereoscopic_red_3d_vertex(constant Vertex3DColorsStereoscopic *verts [[buffer(SlotVertexData)]],
                                                                    uint vid [[vertex_id]],
                                                                   constant VertexUniforms & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutColors out;
    float4 position = float4(verts[vid].position, 1.0);
    position[0] -= verts[vid].shift[1];
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.color = verts[vid].color;
    return out;
}

fragment float4 sprite_node_colored_stereoscopic_red_3d_fragment(InOutColors in [[stage_in]],
                                                constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * in.color[0],
                           0.0,
                           0.0,
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}



fragment float4 sprite_node_colored_white_3d_fragment(InOutColors in [[stage_in]],
                                                constant FragmentUniforms & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.a * uniforms.r * in.color[0],
                           colorSample.a * uniforms.g * in.color[1],
                           colorSample.a * uniforms.b * in.color[2],
                           colorSample.a * uniforms.a * in.color[3]);
    return result;
}



vertex InOutDiffuse sprite_node_diffuse_3d_vertex(constant Vertex3DDiffuse *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniformsDiffuse & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutDiffuse out;
    float4 position = float4(verts[vid].position, 1.0);
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.normal = float3(uniforms.normalMatrix * normal);
    return out;
}

fragment float4 sprite_node_diffuse_3d_fragment(InOutDiffuse in [[stage_in]],
                                                constant FragmentUniformsDiffuse & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    float3 inNormal = normalize(in.normal);
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormal, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    float combinedLightIntensity = ambientIntensity + diffuseIntensity;
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * uniforms.lightR * combinedLightIntensity,
                           colorSample.g * uniforms.g * uniforms.lightG * combinedLightIntensity,
                           colorSample.b * uniforms.b * uniforms.lightB * combinedLightIntensity,
                           colorSample.a * uniforms.a);
    return result;
}




vertex InOutDiffuse sprite_node_diffuse_stereoscopic_blue_3d_vertex(constant Vertex3DDiffuseStereoscopic *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniformsDiffuse & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutDiffuse out;
    float4 position = float4(verts[vid].position, 1.0);
    position[0] += verts[vid].shift[0];
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.normal = float3(uniforms.normalMatrix * normal);
    return out;
}


fragment float4 sprite_node_diffuse_stereoscopic_blue_3d_fragment(InOutDiffuse in [[stage_in]],
                                                constant FragmentUniformsDiffuse & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    float3 inNormal = normalize(in.normal);
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormal, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    float combinedLightIntensity = ambientIntensity + diffuseIntensity;
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(0.0,
                           colorSample.g * uniforms.g * uniforms.lightG * combinedLightIntensity,
                           colorSample.b * uniforms.b * uniforms.lightB * combinedLightIntensity,
                           colorSample.a * uniforms.a);
    return result;
}

vertex InOutDiffuse sprite_node_diffuse_stereoscopic_red_3d_vertex(constant Vertex3DDiffuseStereoscopic *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniformsDiffuse & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutDiffuse out;
    float4 position = float4(verts[vid].position, 1.0);
    position[0] -= verts[vid].shift[1];
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.normal = float3(uniforms.normalMatrix * normal);
    return out;
}

fragment float4 sprite_node_diffuse_stereoscopic_red_3d_fragment(InOutDiffuse in [[stage_in]],
                                                constant FragmentUniformsDiffuse & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    float3 inNormal = normalize(in.normal);
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormal, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    float combinedLightIntensity = ambientIntensity + diffuseIntensity;
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * uniforms.lightR * combinedLightIntensity,
                           0.0,
                           0.0,
                           colorSample.a * uniforms.a);
    return result;
}



vertex InOutDiffuseColors sprite_node_diffuse_colored_stereoscopic_blue_3d_vertex(constant Vertex3DDiffuseColorsStereoscopic *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniformsDiffuse & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutDiffuseColors out;
    float4 position = float4(verts[vid].position, 1.0);
    position[0] += verts[vid].shift[0];
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.normal = float3(uniforms.normalMatrix * normal);
    out.color = verts[vid].color;
    return out;
}


fragment float4 sprite_node_diffuse_colored_stereoscopic_blue_3d_fragment(InOutDiffuseColors in [[stage_in]],
                                                constant FragmentUniformsDiffuse & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    float3 inNormal = normalize(in.normal);
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormal, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    float combinedLightIntensity = ambientIntensity + diffuseIntensity;
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(0.0,
                           colorSample.g * uniforms.g * uniforms.lightG * combinedLightIntensity * in.color[1],
                           colorSample.b * uniforms.b * uniforms.lightB * combinedLightIntensity * in.color[2],
                           colorSample.a * uniforms.a);
    return result;
}

vertex InOutDiffuseColors sprite_node_diffuse_colored_stereoscopic_red_3d_vertex(constant Vertex3DDiffuseColorsStereoscopic *verts [[buffer(SlotVertexData)]],
                                                                   uint vid [[vertex_id]],
                                                                   constant VertexUniformsDiffuse & uniforms [[ buffer(SlotVertexUniforms) ]]) {
    InOutDiffuseColors out;
    float4 position = float4(verts[vid].position, 1.0);
    position[0] -= verts[vid].shift[1];
    float4 normal = float4(verts[vid].normal, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.textureCoord = verts[vid].textureCoord;
    out.normal = float3(uniforms.normalMatrix * normal);
    out.color = verts[vid].color;
    return out;
}

fragment float4 sprite_node_diffuse_colored_stereoscopic_red_3d_fragment(InOutDiffuseColors in [[stage_in]],
                                                constant FragmentUniformsDiffuse & uniforms [[buffer(SlotFragmentUniforms)]],
                                                texture2d<half> colorMap [[ texture(SlotFragmentTexture) ]],
                                                sampler colorSampler [[ sampler(SlotFragmentSampler) ]]) {
    float3 inNormal = normalize(in.normal);
    float3 antiDirection = float3(-uniforms.lightDirX, -uniforms.lightDirY, -uniforms.lightDirZ);
    float ambientIntensity = uniforms.lightAmbientIntensity;
    ambientIntensity = clamp(ambientIntensity, 0.0, 1.0);
    float diffuseIntensity = max(dot(inNormal, antiDirection), 0.0) * uniforms.lightDiffuseIntensity;
    diffuseIntensity = clamp(diffuseIntensity, 0.0, 1.0);
    float combinedLightIntensity = ambientIntensity + diffuseIntensity;
    half4 colorSample = colorMap.sample(colorSampler, in.textureCoord.xy);
    float4 result = float4(colorSample.r * uniforms.r * uniforms.lightR * combinedLightIntensity * in.color[0],
                           0.0,
                           0.0,
                           colorSample.a * uniforms.a);
    return result;
}
