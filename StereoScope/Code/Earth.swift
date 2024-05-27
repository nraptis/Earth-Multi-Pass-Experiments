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
    
    init(width: Float, height: Float) {
        
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
    
    func updateStereo(rotation: Float) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.updateStereo(rotation: rotation)
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
                                       //pipelineState: .spriteNodeStereoscopicLeftIndexed3DNoBlending
            
                                       
            
            )
            
        }
    }
}
