//
//  JiggleScene.swift
//  Jiggle3
//
//  Created by Nicky Taylor on 11/9/23.
//

import Foundation
import Metal
import MetalKit
import simd

class EarthScene: GraphicsDelegate {
    
    var graphics: Graphics!
    
    let width: Float
    let height: Float
    let centerX: Float
    let centerY: Float
    
    var earthTexture: MTLTexture?
    var lightsTexture: MTLTexture?
    var galaxyTexture: MTLTexture?
    
    
    
    private var galaxySprite = IndexedSpriteInstance<Sprite3DVertex,
                                                     UniformsSpriteVertex,
                                                     UniformsSpriteFragment>(sentinelNode: Sprite3DVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0))
   
    
    let testSprite = SpriteInstance2D()
    
    
    let earth: Earth
    
    init(width: Float,
         height: Float) {
        self.width = width
        self.height = height
        centerX = Float(Int(width * 0.5 + 0.5))
        centerY = Float(Int(height * 0.5 + 0.5))
        earth = Earth(width: width, height: height)
    }
    
    deinit {
        print("[--] JiggleScene")
    }
    
    func load() {
        let loader = MTKTextureLoader(device: graphics.metalDevice)
        if let image = UIImage(named: "earth_texture") {
            if let cgImage = image.cgImage {
                earthTexture = try? loader.newTexture(cgImage: cgImage)
            }
        }
        if let image = UIImage(named: "lights_texture") {
            if let cgImage = image.cgImage {
                lightsTexture = try? loader.newTexture(cgImage: cgImage)
            }
        }
        
        if let image = UIImage(named: "galaxy") {
            if let cgImage = image.cgImage {
                galaxyTexture = try? loader.newTexture(cgImage: cgImage)
            }
        }
        
        
        
        print("earthTexture = \(earthTexture)")
        print("lightsTexture = \(lightsTexture)")
        
        testSprite.load(graphics: graphics,
                        texture: earthTexture)
        
        earth.load(graphics: graphics,
                   texture: earthTexture,
                   textureLight: lightsTexture)
        
        galaxySprite.load(graphics: graphics,
                          texture: galaxyTexture)
        
    }
    
    func loadComplete() {
        //jiggleEngine.loadComplete()
        
    }
    
    var earthRotation = Float(0.0)
    var lightRotation = Float(0.0)
    
    func update(deltaTime: Float) {
        
        earthRotation += 0.0025
        //earthRotation += 0.00125 * 10.0
        
        if earthRotation >= (Float.pi * 2.0) {
            earthRotation -= (Float.pi * 2.0)
        }
        
        lightRotation -= 0.005
        if lightRotation < 0.0 {
            lightRotation += (Float.pi * 2.0)
        }
        
        earth.updateStereo(rotation: earthRotation)
        
    }
    
    func draw2D(renderEncoder: MTLRenderCommandEncoder) {
        
        var projectionMatrix = matrix_float4x4()
        projectionMatrix.ortho(width: width, height: height)
        
        let modelViewMatrix = matrix_identity_float4x4
        
        /*
         var projectionMatrix2D = matrix_float4x4()
         projectionMatrix2D.ortho(width: width,
         height: height)
         
         let modelViewMatrix2D = matrix_identity_float4x4
         
         
         testSprite.projectionMatrix = projectionMatrix2D
         testSprite.modelViewMatrix = modelViewMatrix2D
         
         testSprite.render(renderEncoder: renderEncoder)
         */
        
    }
    
    struct MatrixPack {
        let projectionMatrix: matrix_float4x4
        let modelViewMatrix: matrix_float4x4
        let normalMatrix: matrix_float4x4
    }
    
    func getMatrixPack() -> MatrixPack {
        /*
        let aspect = graphics.width / graphics.height
        var perspective = matrix_float4x4()
        perspective.perspective(fovy: Float.pi * 0.125, aspect: aspect, nearZ: 0.01, farZ: 255.0)
        
        var lookAt = matrix_float4x4()
        lookAt.lookAt(eyeX: 0.0, eyeY: 0.0, eyeZ: -10.0,
                      centerX: 0.0, centerY: 0.0, centerZ: 0.0,
                      upX: 0.0, upY: 1.0, upZ: 0.0)
        let projectionMatrix = simd_mul(perspective, lookAt)
        var modelViewMatrix = matrix_identity_float4x4
        modelViewMatrix.rotateY(radians: -earthRotation)
        */
        
        var projectionMatrix = matrix_float4x4()
        projectionMatrix.ortho(width: width, height: height)
        
        var modelViewMatrix = matrix_identity_float4x4
        //
        modelViewMatrix.translate(x: width / 2.0, y: height / 2.0, z: 0.0)
        modelViewMatrix.rotateY(radians: earthRotation)
        
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
        galaxySprite.setPositionFrame(x: 0.0, y: 0.0, width: width, height: height)
        galaxySprite.uniformsVertex.projectionMatrix = projectionMatrix
        galaxySprite.uniformsVertex.modelViewMatrix = modelViewMatrix
        galaxySprite.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed3DNoBlending)
    }
    
    func draw3DBloom(renderEncoder: MTLRenderCommandEncoder) {
        let matrixPack = getMatrixPack()
        graphics.set(depthState: .lessThan, renderEncoder: renderEncoder)
        earth.draw3DBloom(renderEncoder: renderEncoder,
                          projectionMatrix: matrixPack.projectionMatrix,
                          modelViewMatrix: matrixPack.modelViewMatrix)
    }
    
    func draw3D(renderEncoder: MTLRenderCommandEncoder) {
        
        
        let matrixPack = getMatrixPack()
        
        
        
        
        graphics.set(depthState: .lessThan, renderEncoder: renderEncoder)
        earth.draw3D(renderEncoder: renderEncoder,
                     projectionMatrix: matrixPack.projectionMatrix,
                     modelViewMatrix: matrixPack.modelViewMatrix,
                     normalMatrix: matrixPack.normalMatrix,
                     lightDirX: sin(lightRotation),
                     lightDirY: 0.0,
                     lightDirZ: -cosf(lightRotation),
                     lightAmbientIntensity: 0.0,
                     lightDiffuseIntensity: 1.0,
                     lightSpecularIntensity: 999_999_999.0,
                     lightNightIntensity: 1.0,
                     lightShininess: 24.0)
        
        
    }
    
    func draw3DStereoscopicLeft(renderEncoder: MTLRenderCommandEncoder) {
        
    }
    
    func draw3DStereoscopicRight(renderEncoder: MTLRenderCommandEncoder) {
        
    }
}
