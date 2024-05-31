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
            let earthModelDataStrip = EarthModelDataStrip(earthModelData: earthModelData, indexV: indexV)
            _earthModelDataStrips.append(earthModelDataStrip)
        }
        self.earthModelDataStrips = _earthModelDataStrips
    }
    
    func load(graphics: Graphics,
              texture: MTLTexture?,
              textureLight: MTLTexture?) {
        self.texture = texture
        
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.load(graphics: graphics, texture: texture, textureLight: textureLight)
        }
    }
    
    func update(deltaTime: Float, stereoSpreadBase: Float, stereoSpreadMax: Float) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.update(deltaTime: deltaTime)
        }
        
    }
    
    func updateStereo(radians: Float, stereoSpreadBase: Float, stereoSpreadMax: Float) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.updateStereo(radians: radians,
                                             width: width,
                                             height: height,
                                             stereoSpreadBase: stereoSpreadBase,
                                             stereoSpreadMax: stereoSpreadMax)
        }
    }
    
    func draw3DBloom_NotColored(renderEncoder: MTLRenderCommandEncoder,
                                projectionMatrix: matrix_float4x4,
                                modelViewMatrix: matrix_float4x4) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DBloom_NotColored(renderEncoder: renderEncoder,
                                                       projectionMatrix: projectionMatrix,
                                                       modelViewMatrix: modelViewMatrix)
        }
    }
    
    func draw3DBloom_YesColored(renderEncoder: MTLRenderCommandEncoder,
                                projectionMatrix: matrix_float4x4,
                                modelViewMatrix: matrix_float4x4) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DBloom_YesColored(renderEncoder: renderEncoder,
                                                       projectionMatrix: projectionMatrix,
                                                       modelViewMatrix: modelViewMatrix)
        }
    }
    
    func draw3D_NoLight_NotColored(renderEncoder: MTLRenderCommandEncoder,
                                   projectionMatrix: matrix_float4x4,
                                   modelViewMatrix: matrix_float4x4) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3D_NoLight_NotColored(renderEncoder: renderEncoder,
                                                          projectionMatrix: projectionMatrix,
                                                          modelViewMatrix: modelViewMatrix)
        }
    }
    
    func draw3D_NoLight_YesColored(renderEncoder: MTLRenderCommandEncoder,
                                   projectionMatrix: matrix_float4x4,
                                   modelViewMatrix: matrix_float4x4) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3D_NoLight_YesColored(renderEncoder: renderEncoder,
                                                          projectionMatrix: projectionMatrix,
                                                          modelViewMatrix: modelViewMatrix)
        }
    }
    
    func draw3DStereoscopicBlue_NoLight_NotColored(renderEncoder: MTLRenderCommandEncoder,
                                                   projectionMatrix: matrix_float4x4,
                                                   modelViewMatrix: matrix_float4x4) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DStereoscopic_NoLight_NoColors(renderEncoder: renderEncoder,
                                                                    projectionMatrix: projectionMatrix,
                                                                    modelViewMatrix: modelViewMatrix,
                                                                    pipelineState: .spriteNodeStereoscopicBlueIndexed3DNoBlending)
        }
    }
    
    func draw3DStereoscopicRed_NoLight_NotColored(renderEncoder: MTLRenderCommandEncoder,
                                                  projectionMatrix: matrix_float4x4,
                                                  modelViewMatrix: matrix_float4x4) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DStereoscopic_NoLight_NoColors(renderEncoder: renderEncoder,
                                                                    projectionMatrix: projectionMatrix,
                                                                    modelViewMatrix: modelViewMatrix,
                                                                    pipelineState: .spriteNodeStereoscopicRedIndexed3DNoBlending)
        }
    }
    
    func draw3DStereoscopicBlue_NoLight_YesColored(renderEncoder: MTLRenderCommandEncoder,
                                                   projectionMatrix: matrix_float4x4,
                                                   modelViewMatrix: matrix_float4x4) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DStereoscopic_NoLight_YesColors(renderEncoder: renderEncoder,
                                                                     projectionMatrix: projectionMatrix,
                                                                     modelViewMatrix: modelViewMatrix,
                                                                     pipelineState: .spriteNodeColoredStereoscopicBlueIndexed3DNoBlending)
        }
    }
    
    func draw3DStereoscopicRed_NoLight_YesColored(renderEncoder: MTLRenderCommandEncoder,
                                                  projectionMatrix: matrix_float4x4,
                                                  modelViewMatrix: matrix_float4x4) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DStereoscopic_NoLight_YesColors(renderEncoder: renderEncoder,
                                                                     projectionMatrix: projectionMatrix,
                                                                     modelViewMatrix: modelViewMatrix,
                                                                     pipelineState: .spriteNodeColoredStereoscopicRedIndexed3DNoBlending)
            
        }
    }
    
    func draw3D_Diffuse_NotColored(renderEncoder: MTLRenderCommandEncoder,
                                   projectionMatrix: matrix_float4x4,
                                   modelViewMatrix: matrix_float4x4,
                                   normalMatrix: matrix_float4x4,
                                   lightDirX: Float,
                                   lightDirY: Float,
                                   lightDirZ: Float,
                                   lightAmbientIntensity: Float,
                                   lightDiffuseIntensity: Float) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3D_Diffuse_NotColored(renderEncoder: renderEncoder,
                                                          projectionMatrix: projectionMatrix,
                                                          modelViewMatrix: modelViewMatrix,
                                                          normalMatrix: normalMatrix,
                                                          lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                          lightAmbientIntensity: lightAmbientIntensity,
                                                          lightDiffuseIntensity: lightDiffuseIntensity)
            
        }
        
    }
    
    func draw3D_Diffuse_YesColored(renderEncoder: MTLRenderCommandEncoder,
                                   projectionMatrix: matrix_float4x4,
                                   modelViewMatrix: matrix_float4x4,
                                   normalMatrix: matrix_float4x4,
                                   lightDirX: Float,
                                   lightDirY: Float,
                                   lightDirZ: Float,
                                   lightAmbientIntensity: Float,
                                   lightDiffuseIntensity: Float) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3D_Diffuse_YesColored(renderEncoder: renderEncoder,
                                                          projectionMatrix: projectionMatrix,
                                                          modelViewMatrix: modelViewMatrix,
                                                          normalMatrix: normalMatrix,
                                                          lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                          lightAmbientIntensity: lightAmbientIntensity,
                                                          lightDiffuseIntensity: lightDiffuseIntensity)
        }
    }
    
    
    func draw3DStereoscopicBlue_Diffuse_NotColored(renderEncoder: MTLRenderCommandEncoder,
                                                   projectionMatrix: matrix_float4x4,
                                                   modelViewMatrix: matrix_float4x4,
                                                   normalMatrix: matrix_float4x4,
                                                   lightDirX: Float,
                                                   lightDirY: Float,
                                                   lightDirZ: Float,
                                                   lightAmbientIntensity: Float,
                                                   lightDiffuseIntensity: Float) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DStereoscopic_Diffuse_NotColored(renderEncoder: renderEncoder,
                                                                      projectionMatrix: projectionMatrix,
                                                                      modelViewMatrix: modelViewMatrix,
                                                                      normalMatrix: normalMatrix,
                                                                      lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                                      lightAmbientIntensity: lightAmbientIntensity,
                                                                      lightDiffuseIntensity: lightDiffuseIntensity,
                                                                      pipelineState: .spriteNodeIndexedDiffuseStereoscopicBlue3DNoBlending)
            
        }
    }
    
    func draw3DStereoscopicRed_Diffuse_NotColored(renderEncoder: MTLRenderCommandEncoder,
                                                  projectionMatrix: matrix_float4x4,
                                                  modelViewMatrix: matrix_float4x4,
                                                  normalMatrix: matrix_float4x4,
                                                  lightDirX: Float,
                                                  lightDirY: Float,
                                                  lightDirZ: Float,
                                                  lightAmbientIntensity: Float,
                                                  lightDiffuseIntensity: Float) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DStereoscopic_Diffuse_NotColored(renderEncoder: renderEncoder,
                                                                      projectionMatrix: projectionMatrix,
                                                                      modelViewMatrix: modelViewMatrix,
                                                                      normalMatrix: normalMatrix,
                                                                      lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                                      lightAmbientIntensity: lightAmbientIntensity,
                                                                      lightDiffuseIntensity: lightDiffuseIntensity,
                                                                      pipelineState: .spriteNodeIndexedDiffuseStereoscopicRed3DNoBlending)
            
        }
    }
    
    func draw3DStereoscopicBlue_Diffuse_YesColored(renderEncoder: MTLRenderCommandEncoder,
                                                   projectionMatrix: matrix_float4x4,
                                                   modelViewMatrix: matrix_float4x4,
                                                   normalMatrix: matrix_float4x4,
                                                   lightDirX: Float,
                                                   lightDirY: Float,
                                                   lightDirZ: Float,
                                                   lightAmbientIntensity: Float,
                                                   lightDiffuseIntensity: Float) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DStereoscopic_Diffuse_YesColored(renderEncoder: renderEncoder,
                                                                      projectionMatrix: projectionMatrix,
                                                                      modelViewMatrix: modelViewMatrix,
                                                                      normalMatrix: normalMatrix,
                                                                      lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                                      lightAmbientIntensity: lightAmbientIntensity,
                                                                      lightDiffuseIntensity: lightDiffuseIntensity,
                                                                      pipelineState: .spriteNodeIndexedDiffuseColoredStereoscopicBlue3DNoBlending)
            
        }
    }
    
    func draw3DStereoscopicRed_Diffuse_YesColored(renderEncoder: MTLRenderCommandEncoder,
                                                  projectionMatrix: matrix_float4x4,
                                                  modelViewMatrix: matrix_float4x4,
                                                  normalMatrix: matrix_float4x4,
                                                  lightDirX: Float,
                                                  lightDirY: Float,
                                                  lightDirZ: Float,
                                                  lightAmbientIntensity: Float,
                                                  lightDiffuseIntensity: Float) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DStereoscopic_Diffuse_YesColored(renderEncoder: renderEncoder,
                                                                      projectionMatrix: projectionMatrix,
                                                                      modelViewMatrix: modelViewMatrix,
                                                                      normalMatrix: normalMatrix,
                                                                      lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                                      lightAmbientIntensity: lightAmbientIntensity,
                                                                      lightDiffuseIntensity: lightDiffuseIntensity,
                                                                      pipelineState: .spriteNodeIndexedDiffuseColoredStereoscopicRed3DNoBlending)
            
        }
    }
    
    
    
    func draw3D_Phong_NotColored(renderEncoder: MTLRenderCommandEncoder,
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
            earthModelDataStrip.draw3D_Phong_NotColored(renderEncoder: renderEncoder,
                                                        projectionMatrix: projectionMatrix,
                                                        modelViewMatrix: modelViewMatrix,
                                                        normalMatrix: normalMatrix,
                                                        lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                        lightAmbientIntensity: lightAmbientIntensity,
                                                        lightDiffuseIntensity: lightDiffuseIntensity,
                                                        lightSpecularIntensity: lightSpecularIntensity,
                                                        lightShininess: lightShininess)
            
        }
    }

    func draw3D_Phong_YesColored(renderEncoder: MTLRenderCommandEncoder,
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
            earthModelDataStrip.draw3D_Phong_YesColored(renderEncoder: renderEncoder,
                                                        projectionMatrix: projectionMatrix,
                                                        modelViewMatrix: modelViewMatrix,
                                                        normalMatrix: normalMatrix,
                                                        lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                        lightAmbientIntensity: lightAmbientIntensity,
                                                        lightDiffuseIntensity: lightDiffuseIntensity,
                                                        lightSpecularIntensity: lightSpecularIntensity,
                                                        lightShininess: lightShininess)
        }
    }
    
    func draw3DStereoscopicBlue_Phong_NotColored(renderEncoder: MTLRenderCommandEncoder,
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
            earthModelDataStrip.draw3DStereoscopic_Phong_NotColored(renderEncoder: renderEncoder,
                                                                    projectionMatrix: projectionMatrix,
                                                                    modelViewMatrix: modelViewMatrix,
                                                                    normalMatrix: normalMatrix,
                                                                    lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                                    lightAmbientIntensity: lightAmbientIntensity,
                                                                    lightDiffuseIntensity: lightDiffuseIntensity,
                                                                    lightSpecularIntensity: lightSpecularIntensity,
                                                                    lightShininess: lightShininess,
                                                                    pipelineState: .spriteNodeIndexedPhongStereoscopicBlue3DNoBlending)
            
        }
    }
    
    func draw3DStereoscopicRed_Phong_NotColored(renderEncoder: MTLRenderCommandEncoder,
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
            earthModelDataStrip.draw3DStereoscopic_Phong_NotColored(renderEncoder: renderEncoder,
                                                                    projectionMatrix: projectionMatrix,
                                                                    modelViewMatrix: modelViewMatrix,
                                                                    normalMatrix: normalMatrix,
                                                                    lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                                    lightAmbientIntensity: lightAmbientIntensity,
                                                                    lightDiffuseIntensity: lightDiffuseIntensity,
                                                                    lightSpecularIntensity: lightSpecularIntensity,
                                                                    lightShininess: lightShininess,
                                                                    pipelineState: .spriteNodeIndexedPhongStereoscopicRed3DNoBlending)
            
        }
    }

    func draw3DStereoscopicBlue_Phong_YesColored(renderEncoder: MTLRenderCommandEncoder,
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
            earthModelDataStrip.draw3DStereoscopic_Phong_YesColored(renderEncoder: renderEncoder,
                                                                    projectionMatrix: projectionMatrix,
                                                                    modelViewMatrix: modelViewMatrix,
                                                                    normalMatrix: normalMatrix,
                                                                    lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                                    lightAmbientIntensity: lightAmbientIntensity,
                                                                    lightDiffuseIntensity: lightDiffuseIntensity,
                                                                    lightSpecularIntensity: lightSpecularIntensity,
                                                                    lightShininess: lightShininess,
                                                                    pipelineState: .spriteNodeIndexedPhongColoredStereoscopicBlue3DNoBlending)
            
        }
    }

    func draw3DStereoscopicRed_Phong_YesColored(renderEncoder: MTLRenderCommandEncoder,
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
            earthModelDataStrip.draw3DStereoscopic_Phong_YesColored(renderEncoder: renderEncoder,
                                                                    projectionMatrix: projectionMatrix,
                                                                    modelViewMatrix: modelViewMatrix,
                                                                    normalMatrix: normalMatrix,
                                                                    lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                                    lightAmbientIntensity: lightAmbientIntensity,
                                                                    lightDiffuseIntensity: lightDiffuseIntensity,
                                                                    lightSpecularIntensity: lightSpecularIntensity,
                                                                    lightShininess: lightShininess,
                                                                    pipelineState: .spriteNodeIndexedPhongColoredStereoscopicRed3DNoBlending)
            
        }
    }
    
    func draw3D_Night(renderEncoder: MTLRenderCommandEncoder,
                      projectionMatrix: matrix_float4x4,
                      modelViewMatrix: matrix_float4x4,
                      normalMatrix: matrix_float4x4,
                      lightDirX: Float,
                      lightDirY: Float,
                      lightDirZ: Float,
                      lightAmbientIntensity: Float,
                      lightDiffuseIntensity: Float,
                      lightNightIntensity: Float,
                      overshoot: Float) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3D_Night(renderEncoder: renderEncoder,
                                             projectionMatrix: projectionMatrix,
                                             modelViewMatrix: modelViewMatrix,
                                             normalMatrix: normalMatrix,
                                             lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                             lightAmbientIntensity: lightAmbientIntensity,
                                             lightDiffuseIntensity: lightDiffuseIntensity,
                                             lightNightIntensity: lightNightIntensity,
                                             overshoot: overshoot)
            
        }
    }
    
    func draw3DStereoscopicBlue_Night(renderEncoder: MTLRenderCommandEncoder,
                                      projectionMatrix: matrix_float4x4,
                                      modelViewMatrix: matrix_float4x4,
                                      normalMatrix: matrix_float4x4,
                                      lightDirX: Float,
                                      lightDirY: Float,
                                      lightDirZ: Float,
                                      lightAmbientIntensity: Float,
                                      lightDiffuseIntensity: Float,
                                      lightNightIntensity: Float,
                                      overshoot: Float) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DStereoscopic_Night(renderEncoder: renderEncoder,
                                                         projectionMatrix: projectionMatrix,
                                                         modelViewMatrix: modelViewMatrix,
                                                         normalMatrix: normalMatrix,
                                                         lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                         lightAmbientIntensity: lightAmbientIntensity,
                                                         lightDiffuseIntensity: lightDiffuseIntensity,
                                                         lightNightIntensity: lightNightIntensity,
                                                         overshoot: overshoot,
                                                         pipelineState: .spriteNodeIndexedNightStereoscopicBlue3DNoBlending)
            
        }
    }

    func draw3DStereoscopicRed_Night(renderEncoder: MTLRenderCommandEncoder,
                                     projectionMatrix: matrix_float4x4,
                                     modelViewMatrix: matrix_float4x4,
                                     normalMatrix: matrix_float4x4,
                                     lightDirX: Float,
                                     lightDirY: Float,
                                     lightDirZ: Float,
                                     lightAmbientIntensity: Float,
                                     lightDiffuseIntensity: Float,
                                     lightNightIntensity: Float,
                                     overshoot: Float) {
        for earthModelDataStrip in earthModelDataStrips {
            earthModelDataStrip.draw3DStereoscopic_Night(renderEncoder: renderEncoder,
                                                         projectionMatrix: projectionMatrix,
                                                         modelViewMatrix: modelViewMatrix,
                                                         normalMatrix: normalMatrix,
                                                         lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                         lightAmbientIntensity: lightAmbientIntensity,
                                                         lightDiffuseIntensity: lightDiffuseIntensity,
                                                         lightNightIntensity: lightNightIntensity,
                                                         overshoot: overshoot,
                                                         pipelineState: .spriteNodeIndexedNightStereoscopicRed3DNoBlending)
        }
    }
}
