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
    weak var textureLight: MTLTexture?
    
    weak var earthModelData: EarthModelData?
    
    let indexV: Int
    
    let texturedTriangleBuffer = IndexedSpriteBuffer<Sprite3DLightedColoredVertex,
                                                               UniformsLightsVertex,
                                                               UniformsPhongFragment>()
    
    let stereoTriangleBuffer = IndexedSpriteBuffer<Sprite3DVertexStereoscopic,
                                                               UniformsShapeVertex,
                                                               UniformsShapeFragment>()
    
    
    
    
    let nightBuffer = IndexedNightBuffer<Sprite3DLightedVertex,
                                                               UniformsLightsVertex,
                                                               UniformsNightFragment>()
    
    
    
    
    let texturedTriangleBloomBuffer = IndexedSpriteBuffer<Shape3DVertex,
                                                                    UniformsShapeNodeIndexedVertex,
                                                                    UniformsShapeNodeIndexedFragment>()
    
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
            
            /*
             
             */
            
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
            
            /*
             
             */
            
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
    
    func updateStereo(rotation: Float) {
        
        let percentV1 = Float(indexV - 1) / Float(EarthModelData.tileCountV)
        let percentV2 = Float(indexV) / Float(EarthModelData.tileCountV)
        
        let factorV1 = sinf(percentV1 * Math.pi)
        let factorV2 = sinf(percentV2 * Math.pi)
        
        let startRotationH = Float(Float.pi)
        let endRotationH = startRotationH + Float.pi * 2.0
        let startRotationV = Float.pi
        let endRotationV = Float(0.0)
        var indexV = 0
        
        
        let _angleV1 = startRotationV + (endRotationV - startRotationV) * percentV1
        let _angleV2 = startRotationV + (endRotationV - startRotationV) * percentV2
        
        

        let radius = Float(200.0)
                
        
        if let earthModelData = earthModelData {
            
            
            for indexH in 0...EarthModelData.tileCountH {
                
                let percentH = (Float(indexH) / Float(EarthModelData.tileCountH))
                let _angleH = startRotationH + (endRotationH - startRotationH) * percentH
                
                let dirX1 = sinf(_angleH + rotation - Math.pi_2)
                let dirY1 = -cosf(_angleH - rotation)
                
                
                
                
                /*
                stereoTriangleBuffer.vertices[indexH * 2].x = point1.x * radius
                stereoTriangleBuffer.vertices[indexH * 2].y = point1.y * radius
                stereoTriangleBuffer.vertices[indexH * 2].z = point1.z * radius
                
                stereoTriangleBuffer.vertices[indexH * 2 + 1].x = point2.x * radius
                stereoTriangleBuffer.vertices[indexH * 2 + 1].y = point2.y * radius
                stereoTriangleBuffer.vertices[indexH * 2 + 1].z = point2.z * radius
                */
                
                let factorH1 = fabsf(dirX1)
                let factorH2 = fabsf(dirX1)
                
                
                stereoTriangleBuffer.vertices[indexH * 2].shiftRed = factorH1 * overshoot
                stereoTriangleBuffer.vertices[indexH * 2 + 1].shiftRed = factorH2 * overshoot
                
                
                /*
                let factorH = fabsf(point.z)
                
                if Bool.random() {
                    stereoTriangleBuffer.vertices[indexH * 2].shiftRed = factorH * 100.0
                    stereoTriangleBuffer.vertices[indexH * 2 + 1].shiftRed = factorH * 100.0
                } else {
                    stereoTriangleBuffer.vertices[indexH * 2].shiftRed = factorH * 0.0
                    stereoTriangleBuffer.vertices[indexH * 2 + 1].shiftRed = factorH * 0.0
                }
                */
                
                
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
    
    
}
