//
//  Earth.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

import Foundation
import Metal
import simd

class Earth {
    
    let earthModelData: EarthModelData
    let earthModelDataStrips: [EarthModelDataStrip]
    weak var texture: MTLTexture?
    
    let width: Float
    let height: Float
    
    init(width: Float, height: Float) {
        
        self.width = width
        self.height = height
        
        earthModelData = EarthModelData(width: width, height: height)
        
        var _earthModelDataStrips = [EarthModelDataStrip]()
        for indexV in 1...EarthModelData.tileCountV {
            let earthModelDataStrip = EarthModelDataStrip(earthModelData: earthModelData,
                                                          indexV: indexV)
            _earthModelDataStrips.append(earthModelDataStrip)
        }
        self.earthModelDataStrips = _earthModelDataStrips
        
    }
    
    func load(graphics: Graphics,
              texture: MTLTexture?,
              textureLight: MTLTexture?) {
        self.texture = texture
        
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.load(graphics: graphics,
                                     texture: texture,
                                     textureLight: textureLight)
        }
    }
    
    func update(deltaTime: Float) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.update(deltaTime: deltaTime)
        }
        
    }
    
    func updateStereo(radians: Float) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.updateStereo(radians: radians, width: width, height: height)
        }
    }
    
    func draw3DBloom(renderEncoder: MTLRenderCommandEncoder,
                     projectionMatrix: matrix_float4x4,
                     modelViewMatrix: matrix_float4x4) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DBloom(renderEncoder: renderEncoder,
                                            projectionMatrix: projectionMatrix,
                                            modelViewMatrix: modelViewMatrix, pipelineState: .shapeNodeIndexed3DNoBlending)
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
                lightShininess: Float) {
        
        
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3D(renderEncoder: renderEncoder,
                                       projectionMatrix: projectionMatrix,
                                       modelViewMatrix: modelViewMatrix,
                                       normalMatrix: normalMatrix,
                                       
                                       lightDirX: lightDirX,
                                       lightDirY: lightDirY,
                                       lightDirZ: lightDirZ,
                                       
                                       lightAmbientIntensity: lightAmbientIntensity,
                                       lightDiffuseIntensity: lightDiffuseIntensity,
                                       lightSpecularIntensity: lightSpecularIntensity,
                                       lightNightIntensity: lightNightIntensity,
                                       
                                       lightShininess: lightShininess,
                                       
                                       pipelineState: .spriteNodeIndexedNight3DNoBlending
                                       
                                       //pipelineState: .shapeNodeColoredIndexed3DNoBlending
                                       
                                       //pipelineState: .spriteNodeStereoscopicBlueIndexed3DNoBlending
                                       
                                      // pipelineState: .spriteNodeStereoscopicBlueIndexed3DNoBlending
                                       
                                       
            
            
            )
            
        }
    }
    
    func draw3DStereoscopicBlue(renderEncoder: MTLRenderCommandEncoder,
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
                                lightShininess: Float) {
        
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DStereoscopic(renderEncoder: renderEncoder,
                                       projectionMatrix: projectionMatrix,
                                       modelViewMatrix: modelViewMatrix,
                                       normalMatrix: normalMatrix,
                                       
                                       lightDirX: lightDirX,
                                       lightDirY: lightDirY,
                                       lightDirZ: lightDirZ,
                                       
                                       lightAmbientIntensity: lightAmbientIntensity,
                                       lightDiffuseIntensity: lightDiffuseIntensity,
                                       lightSpecularIntensity: lightSpecularIntensity,
                                       lightNightIntensity: lightNightIntensity,
                                       
                                       lightShininess: lightShininess,
                                       
                                       //pipelineState: .spriteNodeIndexedNight3DNoBlending
                                       //pipelineState: .shapeNodeColoredIndexed3DNoBlending
                                       
                                       //pipelineState: .spriteNodeStereoscopicBlueIndexed3DNoBlending
                                                   
                                        pipelineState: .spriteNodeIndexedNightStereoscopicBlue3DNoBlending
                                          
                                        //           pipelineState: .spriteNodeIndexedPhongColoredStereoscopicBlue3DNoBlending
                                                   
            
            )
            
        }
    }
    
    func draw3DStereoscopicRed(renderEncoder: MTLRenderCommandEncoder,
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
                                lightShininess: Float) {
        
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DStereoscopic(renderEncoder: renderEncoder,
                                                   projectionMatrix: projectionMatrix,
                                                   modelViewMatrix: modelViewMatrix,
                                                   normalMatrix: normalMatrix,
                                                   
                                                   lightDirX: lightDirX,
                                                   lightDirY: lightDirY,
                                                   lightDirZ: lightDirZ,
                                                   
                                                   lightAmbientIntensity: lightAmbientIntensity,
                                                   lightDiffuseIntensity: lightDiffuseIntensity,
                                                   lightSpecularIntensity: lightSpecularIntensity,
                                                   lightNightIntensity: lightNightIntensity,
                                                   
                                                   lightShininess: lightShininess,
                                                   
                                                   //pipelineState: .spriteNodeIndexedNight3DNoBlending
                                                   //pipelineState: .shapeNodeColoredIndexed3DNoBlending
                                                   
                                                   //pipelineState: .spriteNodeStereoscopicRedIndexed3DNoBlending
                                                   
                                                   pipelineState: .spriteNodeIndexedNightStereoscopicRed3DNoBlending
                                                   
                                                   //pipelineState: .spriteNodeIndexedPhongColoredStereoscopicRed3DNoBlending
                                                   
            
            
            )
        
            
        }
         
    }
    
}
