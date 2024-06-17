//
//  EarthScene.swift
//  Earth
//
//  Created by Nicky Taylor on 11/9/23.
//

import Foundation
import Metal
import MetalKit
import simd

enum LightType: CaseIterable {
    case none
    case diffuse
    case specular
    case night
}

enum ColorType: CaseIterable {
    case none
    case colored
}

var lightType = LightType.night
var colorType = ColorType.none

class EarthScene: GraphicsDelegate {
    
    
    
    var graphics: Graphics!
    
    let width: Float
    let height: Float
    let centerX: Float
    let centerY: Float
    
    var earthTexture: MTLTexture?
    var lightsTexture: MTLTexture?
    var galaxyTexture: MTLTexture?
    
    var skinMap = Sprite()
    var lightMap = Sprite()
    var galaxyMap = Sprite()
    
    private var galaxyInstance = IndexedSpriteInstance3D()
    
    let earth: Earth
    init(width: Float,
         height: Float) {
        self.width = width
        self.height = height
        centerX = Float(Int(width * 0.5 + 0.5))
        centerY = Float(Int(height * 0.5 + 0.5))
        earth = Earth(width: width, height: height)
    }
    
    func load() {
        let loader = MTKTextureLoader(device: graphics.metalDevice)
        
        if let image = UIImage(named: "earth_texture") {
            if let cgImage = image.cgImage {
                earthTexture = try? loader.newTexture(cgImage: cgImage)
            }
        }
        skinMap.load(graphics: graphics, texture: earthTexture, scaleFactor: graphics.scaleFactor)
        
        if let image = UIImage(named: "lights_texture") {
            if let cgImage = image.cgImage {
                lightsTexture = try? loader.newTexture(cgImage: cgImage)
            }
        }
        lightMap.load(graphics: graphics, texture: lightsTexture, scaleFactor: graphics.scaleFactor)
        
        if let image = UIImage(named: "galaxy") {
            if let cgImage = image.cgImage {
                galaxyTexture = try? loader.newTexture(cgImage: cgImage)
            }
        }
        galaxyMap.load(graphics: graphics, texture: galaxyTexture, scaleFactor: graphics.scaleFactor)

        earth.load(graphics: graphics,
                   skinMap: skinMap,
                   lightMap: lightMap)
        
        galaxyInstance.load(graphics: graphics,
                            sprite: galaxyMap)
    }
    
    func loadComplete() { 
        
    }
    
    var earthRotation = Math.pi
    var lightRotation = Math.pi_4
    
    func initialize() {
        
    }
    
    func update(deltaTime: Float, stereoSpreadBase: Float, stereoSpreadMax: Float) {
        
        earthRotation += deltaTime * 0.4
        if earthRotation >= (Float.pi * 2.0) {
            earthRotation -= (Float.pi * 2.0)
        }
        
        lightRotation -= deltaTime * 0.2
        if lightRotation < 0.0 {
            lightRotation += (Float.pi * 2.0)
        }
        
        earth.updateStereo(radians: earthRotation, stereoSpreadBase: stereoSpreadBase, stereoSpreadMax: stereoSpreadMax)
    }
    
    func predraw() {
        
    }
    
    struct MatrixPack {
        let projectionMatrix: matrix_float4x4
        let modelViewMatrix: matrix_float4x4
        let normalMatrix: matrix_float4x4
    }
    
    func getMatrixPack() -> MatrixPack {
        var projectionMatrix = matrix_float4x4()
        projectionMatrix.ortho(width: width, height: height)
        
        var modelViewMatrix = matrix_identity_float4x4
        modelViewMatrix.translate(x: width / 2.0, y: height / 2.0, z: 0.0)
        
        var normalMatrix = modelViewMatrix
        normalMatrix = simd_inverse(normalMatrix)
        normalMatrix = simd_transpose(normalMatrix)
        
        let result = MatrixPack(projectionMatrix: projectionMatrix,
                                modelViewMatrix: modelViewMatrix,
                                normalMatrix: normalMatrix)
        return result
    }
    
    func draw3DPrebloom(renderEncoder: MTLRenderCommandEncoder) {
        var projectionMatrix = matrix_float4x4()
        projectionMatrix.ortho(width: width, height: height)
        let modelViewMatrix = matrix_identity_float4x4
        galaxyInstance.setPositionFrame(x: 0.0, y: 0.0, width: width, height: height)
        galaxyInstance.uniformsVertex.projectionMatrix = projectionMatrix
        galaxyInstance.uniformsVertex.modelViewMatrix = modelViewMatrix
        galaxyInstance.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed3DNoBlending)
    }
    
    func draw3DBloom(renderEncoder: MTLRenderCommandEncoder) {
        let matrixPack = getMatrixPack()
        graphics.set(depthState: .lessThan, renderEncoder: renderEncoder)
        switch colorType {
        case .none:
            earth.draw3DBloom_NotColored(renderEncoder: renderEncoder,
                                         projectionMatrix: matrixPack.projectionMatrix,
                                         modelViewMatrix: matrixPack.modelViewMatrix)
        case .colored:
            earth.draw3DBloom_YesColored(renderEncoder: renderEncoder,
                                         projectionMatrix: matrixPack.projectionMatrix,
                                         modelViewMatrix: matrixPack.modelViewMatrix)
        }
        graphics.set(depthState: .disabled, renderEncoder: renderEncoder)
    }
    
    func draw3D(renderEncoder: MTLRenderCommandEncoder) {
        
        var lightDirX = sinf(lightRotation)
        var lightDirY = Float(0.20)
        var lightDirZ = -cosf(lightRotation)
        let lightLength = sqrtf(lightDirX * lightDirX + lightDirY * lightDirY + lightDirZ * lightDirZ)
        lightDirX /= lightLength
        lightDirY /= lightLength
        lightDirZ /= lightLength
        let matrixPack = getMatrixPack()
        graphics.set(depthState: .lessThan, renderEncoder: renderEncoder)
        
        switch lightType {
        case .none:
            switch colorType {
            case .none:
                earth.draw3D_NoLight_NotColored(renderEncoder: renderEncoder,
                                                projectionMatrix: matrixPack.projectionMatrix,
                                                modelViewMatrix: matrixPack.modelViewMatrix)
            case .colored:
                earth.draw3D_NoLight_YesColored(renderEncoder: renderEncoder,
                                                projectionMatrix: matrixPack.projectionMatrix,
                                                modelViewMatrix: matrixPack.modelViewMatrix)
            }
        case .diffuse:
            switch colorType {
            case .none:
                earth.draw3D_Diffuse_NotColored(renderEncoder: renderEncoder,
                                                projectionMatrix: matrixPack.projectionMatrix,
                                                modelViewMatrix: matrixPack.modelViewMatrix,
                                                normalMatrix: matrixPack.normalMatrix,
                                                lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                lightAmbientIntensity: 0.25, lightDiffuseIntensity: 0.75)
            case .colored:
                earth.draw3D_Diffuse_YesColored(renderEncoder: renderEncoder,
                                                projectionMatrix: matrixPack.projectionMatrix,
                                                modelViewMatrix: matrixPack.modelViewMatrix,
                                                normalMatrix: matrixPack.normalMatrix,
                                                lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                lightAmbientIntensity: 0.25, lightDiffuseIntensity: 0.75)
            }
            
            break
        case .specular:
            switch colorType {
            case .none:
                earth.draw3D_Phong_NotColored(renderEncoder: renderEncoder,
                                              projectionMatrix: matrixPack.projectionMatrix,
                                              modelViewMatrix: matrixPack.modelViewMatrix,
                                              normalMatrix: matrixPack.normalMatrix,
                                              lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                              lightAmbientIntensity: 0.25, lightDiffuseIntensity: 0.5, lightSpecularIntensity: 0.25, lightShininess: 32.0)
            case .colored:
                earth.draw3D_Phong_YesColored(renderEncoder: renderEncoder,
                                              projectionMatrix: matrixPack.projectionMatrix,
                                              modelViewMatrix: matrixPack.modelViewMatrix,
                                              normalMatrix: matrixPack.normalMatrix,
                                              lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                              lightAmbientIntensity: 0.25, lightDiffuseIntensity: 0.5, lightSpecularIntensity: 0.25, lightShininess: 32.0)
            }
            
        case .night:
            earth.draw3D_Night(renderEncoder: renderEncoder,
                               projectionMatrix: matrixPack.projectionMatrix,
                               modelViewMatrix: matrixPack.modelViewMatrix,
                               normalMatrix: matrixPack.normalMatrix,
                               lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                               lightAmbientIntensity: 0.0, lightDiffuseIntensity: 1.0,
                               lightNightIntensity: 1.0, overshoot: overshoot)
        }
        
        graphics.set(depthState: .disabled, renderEncoder: renderEncoder)
    }
    
    func draw3DStereoscopicBlue(renderEncoder: MTLRenderCommandEncoder, stereoSpreadBase: Float, stereoSpreadMax: Float) {
        
        var lightDirX = sinf(lightRotation)
        var lightDirY = Float(0.20)
        var lightDirZ = -cosf(lightRotation)
        let lightLength = sqrtf(lightDirX * lightDirX + lightDirY * lightDirY + lightDirZ * lightDirZ)
        lightDirX /= lightLength
        lightDirY /= lightLength
        lightDirZ /= lightLength
        let matrixPack = getMatrixPack()
        graphics.set(depthState: .lessThan, renderEncoder: renderEncoder)
        
        switch lightType {
        case .none:
            switch colorType {
            case .none:
                earth.draw3DStereoscopicBlue_NoLight_NotColored(renderEncoder: renderEncoder,
                                                                projectionMatrix: matrixPack.projectionMatrix,
                                                                modelViewMatrix: matrixPack.modelViewMatrix)
            case .colored:
                earth.draw3DStereoscopicBlue_NoLight_YesColored(renderEncoder: renderEncoder,
                                                                projectionMatrix: matrixPack.projectionMatrix,
                                                                modelViewMatrix: matrixPack.modelViewMatrix)
            }
        case .diffuse:
            switch colorType {
            case .none:
                earth.draw3DStereoscopicBlue_Diffuse_NotColored(renderEncoder: renderEncoder,
                                                                projectionMatrix: matrixPack.projectionMatrix,
                                                                modelViewMatrix: matrixPack.modelViewMatrix,
                                                                normalMatrix: matrixPack.normalMatrix,
                                                                lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                                lightAmbientIntensity: 0.25, lightDiffuseIntensity: 0.75)
            case .colored:
                earth.draw3DStereoscopicBlue_Diffuse_YesColored(renderEncoder: renderEncoder,
                                                                projectionMatrix: matrixPack.projectionMatrix,
                                                                modelViewMatrix: matrixPack.modelViewMatrix,
                                                                normalMatrix: matrixPack.normalMatrix,
                                                                lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                                lightAmbientIntensity: 0.25, lightDiffuseIntensity: 0.75)
            }
        case .specular:
            
            switch colorType {
            case .none:
                earth.draw3DStereoscopicBlue_Phong_NotColored(renderEncoder: renderEncoder,
                                                              projectionMatrix: matrixPack.projectionMatrix,
                                                              modelViewMatrix: matrixPack.modelViewMatrix,
                                                              normalMatrix: matrixPack.normalMatrix,
                                                              lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                              lightAmbientIntensity: 0.25, lightDiffuseIntensity: 0.5,
                                                              lightSpecularIntensity: 0.25, lightShininess: 32.0)
            case .colored:
                earth.draw3DStereoscopicBlue_Phong_YesColored(renderEncoder: renderEncoder,
                                                              projectionMatrix: matrixPack.projectionMatrix,
                                                              modelViewMatrix: matrixPack.modelViewMatrix,
                                                              normalMatrix: matrixPack.normalMatrix,
                                                              lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                              lightAmbientIntensity: 0.25, lightDiffuseIntensity: 0.5,
                                                              lightSpecularIntensity: 0.25, lightShininess: 32.0)
            }
            
        case .night:
            earth.draw3DStereoscopicBlue_Night(renderEncoder: renderEncoder,
                                               projectionMatrix: matrixPack.projectionMatrix,
                                               modelViewMatrix: matrixPack.modelViewMatrix,
                                               normalMatrix: matrixPack.normalMatrix,
                                               lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                               lightAmbientIntensity: 0.0, lightDiffuseIntensity: 1.0,
                                               lightNightIntensity: 1.0, overshoot: overshoot)
            
        }
        graphics.set(depthState: .disabled, renderEncoder: renderEncoder)
    }
    
    func draw3DStereoscopicRed(renderEncoder: MTLRenderCommandEncoder, stereoSpreadBase: Float, stereoSpreadMax: Float) {
        
        var lightDirX = sinf(lightRotation)
        var lightDirY = Float(0.20)
        var lightDirZ = -cosf(lightRotation)
        let lightLength = sqrtf(lightDirX * lightDirX + lightDirY * lightDirY + lightDirZ * lightDirZ)
        lightDirX /= lightLength
        lightDirY /= lightLength
        lightDirZ /= lightLength
        let matrixPack = getMatrixPack()
        graphics.set(depthState: .lessThan, renderEncoder: renderEncoder)
        
        switch lightType {
        case .none:
            switch colorType {
            case .none:
                earth.draw3DStereoscopicRed_NoLight_NotColored(renderEncoder: renderEncoder,
                                                               projectionMatrix: matrixPack.projectionMatrix,
                                                               modelViewMatrix: matrixPack.modelViewMatrix)
            case .colored:
                earth.draw3DStereoscopicRed_NoLight_YesColored(renderEncoder: renderEncoder,
                                                               projectionMatrix: matrixPack.projectionMatrix,
                                                               modelViewMatrix: matrixPack.modelViewMatrix)
            }
        case .diffuse:
            switch colorType {
            case .none:
                earth.draw3DStereoscopicRed_Diffuse_NotColored(renderEncoder: renderEncoder,
                                                               projectionMatrix: matrixPack.projectionMatrix,
                                                               modelViewMatrix: matrixPack.modelViewMatrix,
                                                               normalMatrix: matrixPack.normalMatrix,
                                                               lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                               lightAmbientIntensity: 0.25, lightDiffuseIntensity: 0.75)
            case .colored:
                earth.draw3DStereoscopicRed_Diffuse_YesColored(renderEncoder: renderEncoder,
                                                               projectionMatrix: matrixPack.projectionMatrix,
                                                               modelViewMatrix: matrixPack.modelViewMatrix,
                                                               normalMatrix: matrixPack.normalMatrix,
                                                               lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                               lightAmbientIntensity: 0.25, lightDiffuseIntensity: 0.75)
            }
        case .specular:
            switch colorType {
            case .none:
                earth.draw3DStereoscopicRed_Phong_NotColored(renderEncoder: renderEncoder,
                                                             projectionMatrix: matrixPack.projectionMatrix,
                                                             modelViewMatrix: matrixPack.modelViewMatrix,
                                                             normalMatrix: matrixPack.normalMatrix,
                                                             lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                             lightAmbientIntensity: 0.25, lightDiffuseIntensity: 0.5,
                                                             lightSpecularIntensity: 0.25, lightShininess: 32.0)
            case .colored:
                earth.draw3DStereoscopicRed_Phong_YesColored(renderEncoder: renderEncoder,
                                                             projectionMatrix: matrixPack.projectionMatrix,
                                                             modelViewMatrix: matrixPack.modelViewMatrix,
                                                             normalMatrix: matrixPack.normalMatrix,
                                                             lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                                             lightAmbientIntensity: 0.25, lightDiffuseIntensity: 0.5,
                                                             lightSpecularIntensity: 0.25, lightShininess: 32.0)
            }
        case .night:
            earth.draw3DStereoscopicRed_Night(renderEncoder: renderEncoder,
                                              projectionMatrix: matrixPack.projectionMatrix,
                                              modelViewMatrix: matrixPack.modelViewMatrix,
                                              normalMatrix: matrixPack.normalMatrix,
                                              lightDirX: lightDirX, lightDirY: lightDirY, lightDirZ: lightDirZ,
                                              lightAmbientIntensity: 0.0, lightDiffuseIntensity: 1.0,
                                              lightNightIntensity: 1.0, overshoot: overshoot)
        }
        
        graphics.set(depthState: .disabled, renderEncoder: renderEncoder)
    }
    
    func draw2D(renderEncoder: MTLRenderCommandEncoder) {
        
    }
    
}
