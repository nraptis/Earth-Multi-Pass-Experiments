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
    
    let earthModelData = EarthModelData()
    let earthModelDataStrips: [EarthModelDataStrip]
    weak var texture: MTLTexture?
    
    init() {
        var _earthModelDataStrips = [EarthModelDataStrip]()
        for indexV in 1...EarthModelData.tileCountV {
            let earthModelDataStrip = EarthModelDataStrip(earthModelData: earthModelData,
                                                          indexV: indexV)
            _earthModelDataStrips.append(earthModelDataStrip)
        }
        self.earthModelDataStrips = _earthModelDataStrips
        
    }
    
    func load(graphics: Graphics,
              texture: MTLTexture?) {
        self.texture = texture
        
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.load(graphics: graphics,
                                     texture: texture)
        }
    }
    
    func draw3DBloom(renderEncoder: MTLRenderCommandEncoder,
                     projectionMatrix: matrix_float4x4,
                     modelViewMatrix: matrix_float4x4) {
        
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DBloom(renderEncoder: renderEncoder,
                                            projectionMatrix: projectionMatrix,
                                            modelViewMatrix: modelViewMatrix, pipelineState: .spriteNodeIndexed3DNoBlending)
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
                                       
                                       lightShininess: lightShininess,
                                       
                                       pipelineState: .spriteNodeIndexedDiffuseColored3DNoBlending)
        }
    }
}
