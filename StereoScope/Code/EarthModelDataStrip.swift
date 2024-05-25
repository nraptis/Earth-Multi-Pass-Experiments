//
//  EarthModelDataStrip.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

import Foundation
import Metal
import simd

class EarthModelDataStrip {
    
    weak var texture: MTLTexture?
    
    /*
     let texturedTriangleBuffer = IndexedTexturedTriangleBuffer<Sprite3DVertex,
                                                                UniformsSpriteNodeIndexedVertex,
                                                                UniformsSpriteNodeIndexedFragment>()
    */
    
    let texturedTriangleBuffer = IndexedTexturedTriangleBuffer<Sprite3DLightedColoredVertex,
                                                               UniformsSpriteNodeIndexedLightsVertex,
                                                               UniformsSpriteNodeIndexedDiffuseFragment>()
    
    let texturedTriangleBloomBuffer = IndexedTexturedTriangleBuffer<Shape3DVertex,
                                                                    UniformsShapeNodeIndexedVertex,
                                                                    UniformsShapeNodeIndexedFragment>()
    
    init(earthModelData: EarthModelData,
         indexV: Int) {
        
        for indexH in 0...EarthModelData.tileCountH {
            
            let x1 = earthModelData.points[indexH][indexV - 1].x
            let y1 = earthModelData.points[indexH][indexV - 1].y
            let z1 = earthModelData.points[indexH][indexV - 1].z
            let u1 = earthModelData.textureCoords[indexH][indexV - 1].x
            let v1 = earthModelData.textureCoords[indexH][indexV - 1].y
            
            let x2 = earthModelData.points[indexH][indexV].x
            let y2 = earthModelData.points[indexH][indexV].y
            let z2 = earthModelData.points[indexH][indexV].z
            let u2 = earthModelData.textureCoords[indexH][indexV].x
            let v2 = earthModelData.textureCoords[indexH][indexV].y
            
            texturedTriangleBuffer.add(index: UInt32(indexH * 2))
            texturedTriangleBuffer.add(index: UInt32(indexH * 2 + 1))
            
            /*
             
             */
            
            texturedTriangleBuffer.add(vertex: Sprite3DLightedColoredVertex(x: x1,
                                                                            y: y1,
                                                                            z: z1,
                                                                            u: u1,
                                                                            v: v1,
                                                                            normalX: x1,
                                                                            normalY: y1,
                                                                            normalZ: z1,
                                                                            r: Float.random(in: 0.0...1.0),
                                                                            g: Float.random(in: 0.0...1.0),
                                                                            b: Float.random(in: 0.0...1.0),
                                                                            a: Float.random(in: 0.5...1.0)))
            texturedTriangleBuffer.add(vertex: Sprite3DLightedColoredVertex(x: x2,
                                                                            y: y2,
                                                                            z: z2,
                                                                            u: u2,
                                                                            v: v2,
                                                                            normalX: x2,
                                                                            normalY: y2,
                                                                            normalZ: z2,
                                                                            r: Float.random(in: 0.0...1.0),
                                                                            g: Float.random(in: 0.0...1.0),
                                                                            b: Float.random(in: 0.0...1.0),
                                                                            a: Float.random(in: 0.5...1.0)))
            
            
            texturedTriangleBloomBuffer.add(index: UInt32(indexH * 2))
            texturedTriangleBloomBuffer.add(index: UInt32(indexH * 2 + 1))
            
            /*
             
             */
            
            texturedTriangleBloomBuffer.add(vertex: Shape3DVertex(x: x1,
                                                                   y: y1,
                                                                   z: z1))
            texturedTriangleBloomBuffer.add(vertex: Shape3DVertex(x: x2,
                                                                   y: y2,
                                                                   z: z2))
        }
    }
    
    func load(graphics: Graphics,
              texture: MTLTexture?) {
        self.texture = texture
        texturedTriangleBuffer.load(graphics: graphics,
                                    texture: texture)
        texturedTriangleBloomBuffer.load(graphics: graphics,
                                         texture: texture)
    }
    
    func draw3DBloom(renderEncoder: MTLRenderCommandEncoder,
                     projectionMatrix: matrix_float4x4,
                     modelViewMatrix: matrix_float4x4,
                     pipelineState: Graphics.PipelineState) {
        
        texturedTriangleBloomBuffer.uniformsVertex.projectionMatrix = projectionMatrix
        texturedTriangleBloomBuffer.uniformsVertex.modelViewMatrix = modelViewMatrix
        
        texturedTriangleBloomBuffer.uniformsFragment.red = 0.6
        texturedTriangleBloomBuffer.uniformsFragment.green = 0.75
        texturedTriangleBloomBuffer.uniformsFragment.blue = 1.0
        texturedTriangleBloomBuffer.uniformsFragment.alpha = 0.5
        
        texturedTriangleBloomBuffer.setDirty(isVertexBufferDirty: false,
                                        isIndexBufferDirty: false,
                                        isUniformsVertexBufferDirty: true,
                                        isUniformsFragmentBufferDirty: true)
        
        texturedTriangleBloomBuffer.render(renderEncoder: renderEncoder,
                                      pipelineState: pipelineState)
        
    }
    
    func draw3D(renderEncoder: MTLRenderCommandEncoder,
                projectionMatrix: matrix_float4x4,
                modelViewMatrix: matrix_float4x4,
                normalMatrix: matrix_float4x4,
                
                lightDirX: Float,
                lightDirY: Float,
                lightDirZ: Float,
                
                lightAmbientIntensity: Float,
                lightDiffuseIntensity: Float,
                lightSpecularIntensity: Float,
                
                lightShininess: Float,
                
                pipelineState: Graphics.PipelineState) {
        
        texturedTriangleBuffer.uniformsVertex.projectionMatrix = projectionMatrix
        texturedTriangleBuffer.uniformsVertex.modelViewMatrix = modelViewMatrix
        texturedTriangleBuffer.uniformsVertex.normalMatrix = normalMatrix
        
        //texturedTriangleBuffer.uniformsFragment.lightRed = Float.random(in: 0.0...1.0)
        //texturedTriangleBuffer.uniformsFragment.lightGreen = Float.random(in: 0.0...1.0)
        //texturedTriangleBuffer.uniformsFragment.lightBlue = Float.random(in: 0.0...1.0)
        
        texturedTriangleBuffer.uniformsFragment.lightDirX = lightDirX
        texturedTriangleBuffer.uniformsFragment.lightDirY = lightDirY
        texturedTriangleBuffer.uniformsFragment.lightDirZ = lightDirZ
        
        
        //mUniformEarth.mLight.mAmbientIntensity = 0.3f;
        //mUniformEarth.mLight.mDiffuseIntensity = 0.7f;
        //mUniformEarth.mLight.mDirX = f;
        //mUniformEarth.mLight.mDirY = f;
        //mUniformEarth.mLight.mDirZ = f;

        
        
        texturedTriangleBuffer.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
        texturedTriangleBuffer.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
        //texturedTriangleBuffer.uniformsFragment.lightSpecularIntensity = lightSpecularIntensity
        
        
        //texturedTriangleBuffer.uniformsFragment.lightShininess = lightShininess
        
        
        texturedTriangleBuffer.setDirty(isVertexBufferDirty: false,
                                        isIndexBufferDirty: false,
                                        isUniformsVertexBufferDirty: true,
                                        isUniformsFragmentBufferDirty: true)
        
        texturedTriangleBuffer.render(renderEncoder: renderEncoder,
                                      pipelineState: pipelineState)
        
    }
    
    
}
