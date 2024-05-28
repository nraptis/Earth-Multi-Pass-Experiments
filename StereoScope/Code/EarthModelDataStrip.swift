//
//  EarthModelDataStrip.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

import Foundation
import Metal
import simd
import UIKit

class EarthModelDataStrip {
    
    
    weak var texture: MTLTexture?
    weak var textureLight: MTLTexture?
    
    weak var earthModelData: EarthModelData?
    
    let indexV: Int
    
    let texturedTriangleBuffer = IndexedSpriteBuffer<Sprite3DLightedColoredVertex,
                                                               UniformsLightsVertex,
                                                               UniformsPhongFragment>()
    
    let stereoTriangleBuffer = IndexedSpriteBuffer<Sprite3DVertexStereoscopic,
                                                               UniformsShapeVertex,
                                                               UniformsShapeFragment>()
    
    
    let nightBuffer = IndexedNightBuffer<Sprite3DLightedVertex, UniformsLightsVertex, UniformsNightFragment>()
    
    
    
    
    let texturedTriangleBloomBuffer = IndexedSpriteBuffer<Shape3DVertex, UniformsShapeNodeIndexedVertex, UniformsShapeNodeIndexedFragment>()
    
    
    let stereoSetupTestBuffer = IndexedShapeBuffer<Shape3DColoredVertex, UniformsShapeNodeIndexedVertex, UniformsShapeNodeIndexedFragment>()
    
    
    
    init(earthModelData: EarthModelData,
         indexV: Int) {
        
        self.indexV = indexV
        self.earthModelData = earthModelData
        
        for indexH in 0...EarthModelData.tileCountH {
            
            let x1 = earthModelData.points[indexH][indexV - 1].x
            let y1 = earthModelData.points[indexH][indexV - 1].y
            let z1 = earthModelData.points[indexH][indexV - 1].z
            
            let normalX1 = earthModelData.normals[indexH][indexV - 1].x
            let normalY1 = earthModelData.normals[indexH][indexV - 1].y
            let normalZ1 = earthModelData.normals[indexH][indexV - 1].z
            
            let u1 = earthModelData.textureCoords[indexH][indexV - 1].x
            let v1 = earthModelData.textureCoords[indexH][indexV - 1].y
            
            let x2 = earthModelData.points[indexH][indexV].x
            let y2 = earthModelData.points[indexH][indexV].y
            let z2 = earthModelData.points[indexH][indexV].z
            
            let normalX2 = earthModelData.normals[indexH][indexV].x
            let normalY2 = earthModelData.normals[indexH][indexV].y
            let normalZ2 = earthModelData.normals[indexH][indexV].z
            
            let u2 = earthModelData.textureCoords[indexH][indexV].x
            let v2 = earthModelData.textureCoords[indexH][indexV].y
            
            texturedTriangleBuffer.add(index: UInt32(indexH * 2))
            texturedTriangleBuffer.add(index: UInt32(indexH * 2 + 1))
            
            texturedTriangleBuffer.add(vertex: Sprite3DLightedColoredVertex(x: x1,
                                                                            y: y1,
                                                                            z: z1,
                                                                            u: u1,
                                                                            v: v1,
                                                                            normalX: normalX1,
                                                                            normalY: normalY1,
                                                                            normalZ: normalZ1,
                                                                            r: Float.random(in: 0.0...1.0),
                                                                            g: Float.random(in: 0.0...1.0),
                                                                            b: Float.random(in: 0.0...1.0),
                                                                            a: Float.random(in: 0.5...1.0)))
            texturedTriangleBuffer.add(vertex: Sprite3DLightedColoredVertex(x: x2,
                                                                            y: y2,
                                                                            z: z2,
                                                                            u: u2,
                                                                            v: v2,
                                                                            normalX: normalX2,
                                                                            normalY: normalY2,
                                                                            normalZ: normalZ2,
                                                                            r: Float.random(in: 0.0...1.0),
                                                                            g: Float.random(in: 0.0...1.0),
                                                                            b: Float.random(in: 0.0...1.0),
                                                                            a: Float.random(in: 0.5...1.0)))
            
            
            
            
            
            ///
            ///
            ///
            ///
            ///
            
            stereoTriangleBuffer.add(index: UInt32(indexH * 2))
            stereoTriangleBuffer.add(index: UInt32(indexH * 2 + 1))
            
            stereoTriangleBuffer.add(vertex: Sprite3DVertexStereoscopic(x: x1,
                                                                            y: y1,
                                                                            z: z1,
                                                                            u: u1,
                                                                            v: v1,
                                                                        shiftRed: 0.0,
                                                                        shiftBlue: 0.0))
            stereoTriangleBuffer.add(vertex: Sprite3DVertexStereoscopic(x: x2,
                                                                            y: y2,
                                                                            z: z2,
                                                                            u: u2,
                                                                            v: v2,
                                                                          shiftRed: 0.0,
                                                                          shiftBlue: 0.0))
            
            ///
            ///
            ///
            ///
            //
            //
            //
            //
            
            nightBuffer.add(index: UInt32(indexH * 2))
            nightBuffer.add(index: UInt32(indexH * 2 + 1))
            
            /*
             
             */
            
            nightBuffer.add(vertex: Sprite3DLightedVertex(x: x1,
                                                                            y: y1,
                                                                            z: z1,
                                                                            u: u1,
                                                                            v: v1,
                                                          normalX: normalX1,
                                                          normalY: normalY1,
                                                          normalZ: normalZ1))
            nightBuffer.add(vertex: Sprite3DLightedVertex(x: x2,
                                                                            y: y2,
                                                                            z: z2,
                                                                            u: u2,
                                                                            v: v2,
                                                          normalX: normalX2,
                                                          normalY: normalY2,
                                                          normalZ: normalZ2))
            
            //
            //
            //
            //
            
            
            
            
            
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
            
            
            stereoSetupTestBuffer.add(index: UInt32(indexH * 2))
            stereoSetupTestBuffer.add(index: UInt32(indexH * 2 + 1))
            stereoSetupTestBuffer.add(vertex: Shape3DColoredVertex(x: x1,
                                                                   y: y1,
                                                                   z: z1, r: 1.0, g: 1.0, b: 1.0, a: 1.0))
            stereoSetupTestBuffer.add(vertex: Shape3DColoredVertex(x: x2,
                                                                   y: y2,
                                                                   z: z2,
                                                                   r: 1.0,
                                                                   g: 1.0, b: 1.0, a: 1.0))
            
            
        }
    }
    
    func load(graphics: Graphics,
              texture: MTLTexture?,
              textureLight: MTLTexture?) {
        self.texture = texture
        self.textureLight = textureLight
        texturedTriangleBuffer.load(graphics: graphics,
                                    texture: texture)
        texturedTriangleBloomBuffer.load(graphics: graphics,
                                         texture: texture)
        nightBuffer.load(graphics: graphics, texture: texture, textureLight: textureLight)
        
        stereoTriangleBuffer.load(graphics: graphics,
                                  texture: texture)
        
        stereoSetupTestBuffer.load(graphics: graphics)
        
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
    
    func updateStereo(radians: Float) {
        
        let stereoAmount = Float(UIDevice.current.userInterfaceIdiom == .pad ? 18.0 : 8.0)
        
        if let earthModelData = earthModelData {
            
            for indexH in 0...EarthModelData.tileCountH {
                
                let normalX1 = earthModelData.normals[indexH][indexV - 1].x
                let normalY1 = earthModelData.normals[indexH][indexV - 1].y
                let normalZ1 = earthModelData.normals[indexH][indexV - 1].z
                
                let normalX2 = earthModelData.normals[indexH][indexV].x
                let normalY2 = earthModelData.normals[indexH][indexV].y
                let normalZ2 = earthModelData.normals[indexH][indexV].z
                
                let factorY1 = sinf(fabsf(1.0 - normalY1) * Math.pi_2)
                let factorY2 = sinf(fabsf(1.0 - normalY2) * Math.pi_2)
                
                let baseRotation1 = -atan2f(-normalX1, -normalZ1)
                let rotation1 = baseRotation1 - radians
                let stereoShift1 = fabsf(cosf(rotation1) * factorY1)
                
                let baseRotation2 = -atan2f(-normalX2, -normalZ2)
                let rotation2 = baseRotation2 - radians
                let stereoShift2 = fabsf(cosf(rotation2) * factorY2)
                
                let vertexIndex1 = (indexH << 1)
                let vertexIndex2 = vertexIndex1 + 1
                
                stereoSetupTestBuffer.vertices[vertexIndex1].r = stereoShift1
                stereoSetupTestBuffer.vertices[vertexIndex1].g = stereoShift1
                stereoSetupTestBuffer.vertices[vertexIndex1].b = stereoShift1
                
                stereoSetupTestBuffer.vertices[vertexIndex2].r = stereoShift2
                stereoSetupTestBuffer.vertices[vertexIndex2].g = stereoShift2
                stereoSetupTestBuffer.vertices[vertexIndex2].b = stereoShift2
                
                stereoTriangleBuffer.vertices[vertexIndex1].shiftRed = 2.0 + stereoShift1 * stereoAmount
                stereoTriangleBuffer.vertices[vertexIndex1].shiftBlue = 2.0 + stereoShift1 * stereoAmount
                
                stereoTriangleBuffer.vertices[vertexIndex2].shiftRed = 2.0 + stereoShift1 * stereoAmount
                stereoTriangleBuffer.vertices[vertexIndex2].shiftBlue = 2.0 + stereoShift1 * stereoAmount
            }
        }
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
                lightNightIntensity: Float,
                
                lightShininess: Float,
                
                pipelineState: Graphics.PipelineState) {
        
        
        
         nightBuffer.uniformsVertex.projectionMatrix = projectionMatrix
         nightBuffer.uniformsVertex.modelViewMatrix = modelViewMatrix
         nightBuffer.uniformsVertex.normalMatrix = normalMatrix
         
         //texturedTriangleBuffer.uniformsFragment.lightRed = Float.random(in: 0.0...1.0)
         //texturedTriangleBuffer.uniformsFragment.lightGreen = Float.random(in: 0.0...1.0)
         //texturedTriangleBuffer.uniformsFragment.lightBlue = Float.random(in: 0.0...1.0)
         
         nightBuffer.uniformsFragment.lightDirX = lightDirX
         nightBuffer.uniformsFragment.lightDirY = lightDirY
         nightBuffer.uniformsFragment.lightDirZ = lightDirZ
         
         
         //mUniformEarth.mLight.mAmbientIntensity = 0.3f;
         //mUniformEarth.mLight.mDiffuseIntensity = 0.7f;
         //mUniformEarth.mLight.mDirX = f;
         //mUniformEarth.mLight.mDirY = f;
         //mUniformEarth.mLight.mDirZ = f;

         
         
         nightBuffer.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
         nightBuffer.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
         //nightBuffer.uniformsFragment.lightSpecularIntensity = lightSpecularIntensity
         nightBuffer.uniformsFragment.lightNightIntensity = lightNightIntensity
         
         
         
         
         
         nightBuffer.uniformsFragment.overshoot = overshoot
         
         
         nightBuffer.setDirty(isVertexBufferDirty: false,
                                         isIndexBufferDirty: false,
                                         isUniformsVertexBufferDirty: true,
                                         isUniformsFragmentBufferDirty: true)
         
         nightBuffer.render(renderEncoder: renderEncoder,
                                       pipelineState: pipelineState)
        
        
        
        /*
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
         texturedTriangleBuffer.uniformsFragment.lightSpecularIntensity = lightSpecularIntensity
         
         
         texturedTriangleBuffer.uniformsFragment.lightShininess = lightShininess
         
         
         texturedTriangleBuffer.setDirty(isVertexBufferDirty: false,
                                         isIndexBufferDirty: false,
                                         isUniformsVertexBufferDirty: true,
                                         isUniformsFragmentBufferDirty: true)
         
         texturedTriangleBuffer.render(renderEncoder: renderEncoder,
                                       pipelineState: pipelineState)
         */
        
        
    }
    
    func draw3DStereoscopic(renderEncoder: MTLRenderCommandEncoder,
                            projectionMatrix: matrix_float4x4,
                            modelViewMatrix: matrix_float4x4,
                            normalMatrix: matrix_float4x4,
                
                            lightDirX: Float,
                            lightDirY: Float,
                            lightDirZ: Float,
                
                            lightAmbientIntensity: Float,
                            lightDiffuseIntensity: Float,
                            lightSpecularIntensity: Float,
                            lightNightIntensity: Float,
                
                            lightShininess: Float,
                
                            pipelineState: Graphics.PipelineState) {

        
        stereoTriangleBuffer.uniformsVertex.projectionMatrix = projectionMatrix
        stereoTriangleBuffer.uniformsVertex.modelViewMatrix = modelViewMatrix

        stereoTriangleBuffer.setDirty(isVertexBufferDirty: true,
                                        isIndexBufferDirty: false,
                                        isUniformsVertexBufferDirty: true,
                                        isUniformsFragmentBufferDirty: true)
        
        stereoTriangleBuffer.render(renderEncoder: renderEncoder,
                                      pipelineState: pipelineState)
        
    }
    
}
