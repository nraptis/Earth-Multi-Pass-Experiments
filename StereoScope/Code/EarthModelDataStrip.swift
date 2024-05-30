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
    
    let stereoLightedColoredTriangleBuffer = IndexedSpriteBuffer<Sprite3DLightedColoredStereoscopicVertex,
                                                               UniformsLightsVertex,
                                                          UniformsPhongFragment>()
    
    let nightBuffer = IndexedNightBuffer<Sprite3DLightedVertex, UniformsLightsVertex, UniformsNightFragment>()
    
    let stereoNightBuffer = IndexedNightBuffer<Sprite3DLightedStereoscopicVertex, UniformsLightsVertex, UniformsNightFragment>()
    
    
    
    
    let texturedTriangleBloomBuffer = IndexedSpriteBuffer<Shape3DVertex, UniformsShapeNodeIndexedVertex, UniformsShapeNodeIndexedFragment>()
    
    
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
            
            
            
            ////
            ///
            ///
            ///
            
            
            
            stereoLightedColoredTriangleBuffer.add(index: UInt32(indexH * 2))
            stereoLightedColoredTriangleBuffer.add(index: UInt32(indexH * 2 + 1))
            
            stereoLightedColoredTriangleBuffer.add(vertex: Sprite3DLightedColoredStereoscopicVertex(x: x1,
                                                                            y: y1,
                                                                            z: z1,
                                                                            u: u1,
                                                                            v: v1,
                                                                                      normalX: normalX1,
                                                                                      normalY: normalY1,
                                                                                      normalZ: normalZ1,
                                                                                                    r: 1.0, g: 1.0, b: Float.random(in: 0.5...1.0), a: 1.0,
                                                                        shiftRed: 0.0,
                                                                        shiftBlue: 0.0))
            stereoLightedColoredTriangleBuffer.add(vertex: Sprite3DLightedColoredStereoscopicVertex(x: x2,
                                                                            y: y2,
                                                                            z: z2,
                                                                            u: u2,
                                                                            v: v2,
                                                                                      normalX: normalX2,
                                                                                      normalY: normalY2,
                                                                                      normalZ: normalZ2,
                                                                                                    r: 1.0, g: 1.0, b: Float.random(in: 0.5...1.0), a: 1.0,
                                                                          shiftRed: 0.0,
                                                                          shiftBlue: 0.0))
            
            ///
            ///
            ///
            ///
            ///
            
            
            
            
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
            
            
            stereoNightBuffer.add(index: UInt32(indexH * 2))
            stereoNightBuffer.add(index: UInt32(indexH * 2 + 1))
            
            /*
             
             */
            
            stereoNightBuffer.add(vertex: Sprite3DLightedStereoscopicVertex(x: x1,
                                                                            y: y1,
                                                                            z: z1,
                                                                            u: u1,
                                                                            v: v1,
                                                          normalX: normalX1,
                                                          normalY: normalY1,
                                                                            normalZ: normalZ1,
                                                                            shiftRed: 0.0,
                                                                            shiftBlue: 0.0))
            stereoNightBuffer.add(vertex: Sprite3DLightedStereoscopicVertex(x: x2,
                                                                            y: y2,
                                                                            z: z2,
                                                                            u: u2,
                                                                            v: v2,
                                                          normalX: normalX2,
                                                          normalY: normalY2,
                                                          normalZ: normalZ2,
                                                                      shiftRed: 0.0,
                                                                      shiftBlue: 0.0))
            
            
            
            
            
            
            
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
              texture: MTLTexture?,
              textureLight: MTLTexture?) {
        self.texture = texture
        self.textureLight = textureLight
        
        texturedTriangleBloomBuffer.load(graphics: graphics,
                                         texture: texture)
        nightBuffer.load(graphics: graphics, 
                         texture: texture,
                         textureLight: textureLight)
        
        stereoNightBuffer.load(graphics: graphics, 
                               texture: texture,
                               textureLight: textureLight)
        
        stereoLightedColoredTriangleBuffer.load(graphics: graphics,
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
        texturedTriangleBloomBuffer.uniformsFragment.alpha = 1.0
        
        texturedTriangleBloomBuffer.setDirty(isVertexBufferDirty: false,
                                        isIndexBufferDirty: false,
                                        isUniformsVertexBufferDirty: true,
                                        isUniformsFragmentBufferDirty: true)
        
        texturedTriangleBloomBuffer.render(renderEncoder: renderEncoder,
                                           pipelineState: pipelineState)
        
    }
    
    func update(deltaTime: Float) {
        
        
    }
    
    func updateStereo(radians: Float, width: Float, height: Float) {
        
        //let stereoAmount = Float(UIDevice.current.userInterfaceIdiom == .pad ? 18.0 : 8.0)
        
        let radius: Float
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            radius = min(width, height) * (0.5 * 0.75)
        } else {
            radius = min(width, height) * (0.5 * 0.85)
        }
        
        
        let startRotationH = Float(Float.pi)
        let endRotationH = startRotationH + Float.pi * 2.0
        let startRotationV = Float.pi
        let endRotationV = Float(0.0)
        
        
            let percentV1 = (Float(indexV - 1) / Float(EarthModelData.tileCountV))
            let percentV2 = (Float(indexV) / Float(EarthModelData.tileCountV))
            let _angleV1 = startRotationV + (endRotationV - startRotationV) * percentV1
            let _angleV2 = startRotationV + (endRotationV - startRotationV) * percentV2
            var indexH = 0
            while indexH <= EarthModelData.tileCountH {
                let percentH = (Float(indexH) / Float(EarthModelData.tileCountH))
                let _angleH = startRotationH + (endRotationH - startRotationH) * percentH - radians
                var point1 = simd_float3(0.0, 1.0, 0.0)
                point1 = Math.rotateX(float3: point1, radians: _angleV1)
                point1 = Math.rotateY(float3: point1, radians: _angleH)
                
                var point2 = simd_float3(0.0, 1.0, 0.0)
                point2 = Math.rotateX(float3: point2, radians: _angleV2)
                point2 = Math.rotateY(float3: point2, radians: _angleH)
                
                
                let vertexIndex1 = (indexH << 1)
                let vertexIndex2 = vertexIndex1 + 1
                
                let shift1 = stereoSpreadBase + fabsf(point1.z) * stereoSpreadMax
                let shift2 = stereoSpreadBase + fabsf(point2.z) * stereoSpreadMax
                
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].x = point1.x * radius
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].y = point1.y * radius
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].z = point1.z * radius
                
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].normalX = point1.x
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].normalY = point1.y
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].normalZ = point1.z
                
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].x = point2.x * radius
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].y = point2.y * radius
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].z = point2.z * radius
                
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].normalX = point2.x
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].normalY = point2.y
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].normalZ = point2.z
                
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].shiftRed = shift1
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].shiftBlue = shift1
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].shiftRed = shift2
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].shiftBlue = shift2

                /*
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].r = point1.z
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].g = 0.0
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].b = 0.0
                
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].r = point2.z
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].g = 0.0
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].b = 0.0
                */
                
                
                
                
                stereoNightBuffer.vertices[vertexIndex1].x = point1.x * radius
                stereoNightBuffer.vertices[vertexIndex1].y = point1.y * radius
                stereoNightBuffer.vertices[vertexIndex1].z = point1.z * radius
                
                stereoNightBuffer.vertices[vertexIndex1].normalX = point1.x
                stereoNightBuffer.vertices[vertexIndex1].normalY = point1.y
                stereoNightBuffer.vertices[vertexIndex1].normalZ = point1.z
                
                stereoNightBuffer.vertices[vertexIndex2].x = point2.x * radius
                stereoNightBuffer.vertices[vertexIndex2].y = point2.y * radius
                stereoNightBuffer.vertices[vertexIndex2].z = point2.z * radius
                
                stereoNightBuffer.vertices[vertexIndex2].normalX = point2.x
                stereoNightBuffer.vertices[vertexIndex2].normalY = point2.y
                stereoNightBuffer.vertices[vertexIndex2].normalZ = point2.z
                
                stereoNightBuffer.vertices[vertexIndex1].shiftRed = shift1
                stereoNightBuffer.vertices[vertexIndex1].shiftBlue = shift1
                stereoNightBuffer.vertices[vertexIndex2].shiftRed = shift2
                stereoNightBuffer.vertices[vertexIndex2].shiftBlue = shift2
                
                
                
                nightBuffer.vertices[vertexIndex1].x = point1.x * radius
                nightBuffer.vertices[vertexIndex1].y = point1.y * radius
                nightBuffer.vertices[vertexIndex1].z = point1.z * radius
                
                nightBuffer.vertices[vertexIndex1].normalX = point1.x
                nightBuffer.vertices[vertexIndex1].normalY = point1.y
                nightBuffer.vertices[vertexIndex1].normalZ = point1.z
                
                nightBuffer.vertices[vertexIndex2].x = point2.x * radius
                nightBuffer.vertices[vertexIndex2].y = point2.y * radius
                nightBuffer.vertices[vertexIndex2].z = point2.z * radius
                
                nightBuffer.vertices[vertexIndex2].normalX = point2.x
                nightBuffer.vertices[vertexIndex2].normalY = point2.y
                nightBuffer.vertices[vertexIndex2].normalZ = point2.z
                
                indexH += 1
            }
         
        
        
        if let earthModelData = earthModelData {
            
            for indexH in 0...EarthModelData.tileCountH {
                
                /*
                let normalX1 = earthModelData.normals[indexH][indexV - 1].x
                let normalY1 = earthModelData.normals[indexH][indexV - 1].y
                let normalZ1 = earthModelData.normals[indexH][indexV - 1].z
                
                let normalX2 = earthModelData.normals[indexH][indexV].x
                let normalY2 = earthModelData.normals[indexH][indexV].y
                let normalZ2 = earthModelData.normals[indexH][indexV].z
                
                let factorY1 = fabsf(sinf(fabsf(1.0 - normalY1) * Math.pi_2))
                let factorY2 = fabsf(sinf(fabsf(1.0 - normalY2) * Math.pi_2))
                
                let baseRotation1 = -atan2f(-normalX1, -normalZ1)
                let rotation1 = baseRotation1 - radians
                let stereoShift1 = fabsf(cosf(rotation1)) * factorY1
                
                let baseRotation2 = -atan2f(-normalX2, -normalZ2)
                let rotation2 = baseRotation2 - radians
                let stereoShift2 = fabsf(cosf(rotation2)) * factorY2
                
                let vertexIndex1 = (indexH << 1)
                let vertexIndex2 = vertexIndex1 + 1
                
                stereoTriangleBuffer.vertices[vertexIndex1].shiftRed = stereoSpreadBase + stereoShift1 * stereoSpreadMax
                stereoTriangleBuffer.vertices[vertexIndex1].shiftBlue = stereoSpreadBase + stereoShift1 * stereoSpreadMax
                stereoTriangleBuffer.vertices[vertexIndex2].shiftRed = stereoSpreadBase + stereoShift2 * stereoSpreadMax
                stereoTriangleBuffer.vertices[vertexIndex2].shiftBlue = stereoSpreadBase + stereoShift2 * stereoSpreadMax
                
                stereoLightedTriangleBuffer.vertices[vertexIndex1].shiftRed = stereoSpreadBase + stereoShift1 * stereoSpreadMax
                stereoLightedTriangleBuffer.vertices[vertexIndex1].shiftBlue = stereoSpreadBase + stereoShift1 * stereoSpreadMax
                stereoLightedTriangleBuffer.vertices[vertexIndex2].shiftRed = stereoSpreadBase + stereoShift2 * stereoSpreadMax
                stereoLightedTriangleBuffer.vertices[vertexIndex2].shiftBlue = stereoSpreadBase + stereoShift2 * stereoSpreadMax
                
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].shiftRed = stereoSpreadBase + stereoShift1 * stereoSpreadMax
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].shiftBlue = stereoSpreadBase + stereoShift1 * stereoSpreadMax
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].shiftRed = stereoSpreadBase + stereoShift2 * stereoSpreadMax
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].shiftBlue = stereoSpreadBase + stereoShift2 * stereoSpreadMax
                
                stereoNightBuffer.vertices[vertexIndex1].shiftRed = stereoSpreadBase + stereoShift1 * stereoSpreadMax
                stereoNightBuffer.vertices[vertexIndex1].shiftBlue = stereoSpreadBase + stereoShift1 * stereoSpreadMax
                stereoNightBuffer.vertices[vertexIndex2].shiftRed = stereoSpreadBase + stereoShift2 * stereoSpreadMax
                stereoNightBuffer.vertices[vertexIndex2].shiftBlue = stereoSpreadBase + stereoShift2 * stereoSpreadMax
                */
                
                /*
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].r = stereoShift1
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].g = stereoShift1
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].b = stereoShift1
                
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].r = stereoShift2
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].g = stereoShift2
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].b = stereoShift2
                */
                
                /*
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].r = stereoShift1
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].g = 0.0
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex1].b = 0.0
                
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].r = stereoShift2
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].g = 0.0
                stereoLightedColoredTriangleBuffer.vertices[vertexIndex2].b = 0.0
                */
                
                //stereoLightedColoredTriangleBuffer
                
                
            }
        }
        
        /*
        stereoTriangleBuffer.setDirty(isVertexBufferDirty: true, isIndexBufferDirty: false, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
        stereoLightedTriangleBuffer.setDirty(isVertexBufferDirty: true, isIndexBufferDirty: false, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
        stereoLightedColoredTriangleBuffer.setDirty(isVertexBufferDirty: true, isIndexBufferDirty: false, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
        stereoNightBuffer.setDirty(isVertexBufferDirty: true, isIndexBufferDirty: false, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
        */
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
         
         nightBuffer.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
         nightBuffer.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
         nightBuffer.uniformsFragment.lightNightIntensity = lightNightIntensity
         nightBuffer.uniformsFragment.overshoot = overshoot
         
         
         nightBuffer.setDirty(isVertexBufferDirty: true,
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
        
        
        
        stereoNightBuffer.uniformsVertex.projectionMatrix = projectionMatrix
        stereoNightBuffer.uniformsVertex.modelViewMatrix = modelViewMatrix
        stereoNightBuffer.uniformsVertex.normalMatrix = normalMatrix
        stereoNightBuffer.uniformsFragment.lightDirX = lightDirX
        stereoNightBuffer.uniformsFragment.lightDirY = lightDirY
        stereoNightBuffer.uniformsFragment.lightDirZ = lightDirZ
        stereoNightBuffer.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
        stereoNightBuffer.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
        stereoNightBuffer.uniformsFragment.lightNightIntensity = lightNightIntensity
        stereoNightBuffer.uniformsFragment.overshoot = overshoot
        
        stereoNightBuffer.setDirty(isVertexBufferDirty: true,
                                        isIndexBufferDirty: false,
                                        isUniformsVertexBufferDirty: true,
                                        isUniformsFragmentBufferDirty: true)
        
        stereoNightBuffer.render(renderEncoder: renderEncoder,
                                      pipelineState: pipelineState)
        
        
        
        /*
        stereoLightedColoredTriangleBuffer.uniformsVertex.projectionMatrix = projectionMatrix
        stereoLightedColoredTriangleBuffer.uniformsVertex.modelViewMatrix = modelViewMatrix
        stereoLightedColoredTriangleBuffer.uniformsVertex.normalMatrix = normalMatrix
        stereoLightedColoredTriangleBuffer.uniformsFragment.lightDirX = lightDirX
        stereoLightedColoredTriangleBuffer.uniformsFragment.lightDirY = lightDirY
        stereoLightedColoredTriangleBuffer.uniformsFragment.lightDirZ = lightDirZ
        stereoLightedColoredTriangleBuffer.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
        stereoLightedColoredTriangleBuffer.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
        stereoLightedColoredTriangleBuffer.uniformsFragment.lightSpecularIntensity = lightSpecularIntensity
        stereoLightedColoredTriangleBuffer.uniformsFragment.lightShininess = lightShininess
        
        stereoLightedColoredTriangleBuffer.setDirty(isVertexBufferDirty: true,
                                                    isIndexBufferDirty: false,
                                                    isUniformsVertexBufferDirty: true,
                                                    isUniformsFragmentBufferDirty: true)
        
        stereoLightedColoredTriangleBuffer.render(renderEncoder: renderEncoder,
                                                  pipelineState: pipelineState)
        */
        
        /*
        stereoLightedTriangleBuffer.uniformsVertex.projectionMatrix = projectionMatrix
        stereoLightedTriangleBuffer.uniformsVertex.modelViewMatrix = modelViewMatrix
        stereoLightedTriangleBuffer.uniformsVertex.normalMatrix = normalMatrix
        stereoLightedTriangleBuffer.uniformsFragment.lightDirX = lightDirX
        stereoLightedTriangleBuffer.uniformsFragment.lightDirY = lightDirY
        stereoLightedTriangleBuffer.uniformsFragment.lightDirZ = lightDirZ
        stereoLightedTriangleBuffer.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
        stereoLightedTriangleBuffer.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
        stereoLightedTriangleBuffer.uniformsFragment.lightNightIntensity = lightNightIntensity
        
        stereoLightedTriangleBuffer.setDirty(isVertexBufferDirty: true,
                                        isIndexBufferDirty: false,
                                        isUniformsVertexBufferDirty: true,
                                        isUniformsFragmentBufferDirty: true)
        
        stereoLightedTriangleBuffer.render(renderEncoder: renderEncoder,
                                      pipelineState: pipelineState)
         */
        
        
        
/*
        
        stereoTriangleBuffer.uniformsVertex.projectionMatrix = projectionMatrix
        stereoTriangleBuffer.uniformsVertex.modelViewMatrix = modelViewMatrix

        stereoTriangleBuffer.setDirty(isVertexBufferDirty: true,
                                        isIndexBufferDirty: false,
                                        isUniformsVertexBufferDirty: true,
                                        isUniformsFragmentBufferDirty: true)
        
        stereoTriangleBuffer.render(renderEncoder: renderEncoder,
                                      pipelineState: pipelineState)
 */
        
        
        
        /*
        stereoColoredTriangleBuffer.uniformsVertex.projectionMatrix = projectionMatrix
        stereoColoredTriangleBuffer.uniformsVertex.modelViewMatrix = modelViewMatrix

        stereoColoredTriangleBuffer.setDirty(isVertexBufferDirty: true,
                                        isIndexBufferDirty: false,
                                        isUniformsVertexBufferDirty: true,
                                        isUniformsFragmentBufferDirty: true)
        
        stereoColoredTriangleBuffer.render(renderEncoder: renderEncoder,
                                      pipelineState: pipelineState)
        
        */
        
        
        
        
    }
    
}
