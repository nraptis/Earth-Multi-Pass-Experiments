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
    
    let testSprite = SpriteInstance2D()
    
    let earth = Earth()
    
    
    let shapeInstance2D = [IndexedShapeInstance<Shape2DVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape2DVertex(x: 0.0, y: 0.0)),
                           IndexedShapeInstance<Shape2DVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape2DVertex(x: 0.0, y: 0.0)),
                           IndexedShapeInstance<Shape2DVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape2DVertex(x: 0.0, y: 0.0)),
                           IndexedShapeInstance<Shape2DVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape2DVertex(x: 0.0, y: 0.0))]
    
    let shapeInstance3D = [IndexedShapeInstance<Shape3DVertex,
                           UniformsShapeVertex,
                           UniformsShapeFragment>(sentinelNode: Shape3DVertex(x: 0.0, y: 0.0, z: 0.0)),
                           IndexedShapeInstance<Shape3DVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape3DVertex(x: 0.0, y: 0.0, z: 0.0)),
                           IndexedShapeInstance<Shape3DVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape3DVertex(x: 0.0, y: 0.0, z: 0.0)),
                           IndexedShapeInstance<Shape3DVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape3DVertex(x: 0.0, y: 0.0, z: 0.0))]
    
    let shapeInstance2DColored = [IndexedShapeInstance<Shape2DColoredVertex,
                           UniformsShapeVertex,
                                  UniformsShapeFragment>(sentinelNode: Shape2DColoredVertex(x: 0.0, y: 0.0
                                                                                            , r: Float.random(in: 0.0...1.0)
                                                                                            , g: Float.random(in: 0.0...1.0)
                                                                                            , b: Float.random(in: 0.0...1.0)
                                                                                            , a: Float.random(in: 0.5...1.0))),
                           IndexedShapeInstance<Shape2DColoredVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape2DColoredVertex(x: 0.0, y: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                         , g: Float.random(in: 0.0...1.0)
                                                                                                                         , b: Float.random(in: 0.0...1.0)
                                                                                                                         , a: Float.random(in: 0.5...1.0))),
                           IndexedShapeInstance<Shape2DColoredVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape2DColoredVertex(x: 0.0, y: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                         , g: Float.random(in: 0.0...1.0)
                                                                                                                         , b: Float.random(in: 0.0...1.0)
                                                                                                                         , a: Float.random(in: 0.5...1.0))),
                           IndexedShapeInstance<Shape2DColoredVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape2DColoredVertex(x: 0.0, y: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                         , g: Float.random(in: 0.0...1.0)
                                                                                                                         , b: Float.random(in: 0.0...1.0)
                                                                                                                         , a: Float.random(in: 0.5...1.0)))]
    
    let shapeInstance3DColored = [IndexedShapeInstance<Shape3DColoredVertex,
                               UniformsShapeVertex,
                                  UniformsShapeFragment>(sentinelNode: Shape3DColoredVertex(x: 0.0, y: 0.0, z: 0.0
                                                                                                , r: Float.random(in: 0.0...1.0)
                                                                                                , g: Float.random(in: 0.0...1.0)
                                                                                                , b: Float.random(in: 0.0...1.0)
                                                                                                , a: Float.random(in: 0.5...1.0))),
                               IndexedShapeInstance<Shape3DColoredVertex,
                               UniformsShapeVertex,
                                                                          UniformsShapeFragment>(sentinelNode: Shape3DColoredVertex(x: 0.0, y: 0.0, z: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                             , g: Float.random(in: 0.0...1.0)
                                                                                                                             , b: Float.random(in: 0.0...1.0)
                                                                                                                             , a: Float.random(in: 0.5...1.0))),
                               IndexedShapeInstance<Shape3DColoredVertex,
                               UniformsShapeVertex,
                                                                          UniformsShapeFragment>(sentinelNode: Shape3DColoredVertex(x: 0.0, y: 0.0, z: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                             , g: Float.random(in: 0.0...1.0)
                                                                                                                             , b: Float.random(in: 0.0...1.0)
                                                                                                                             , a: Float.random(in: 0.5...1.0))),
                               IndexedShapeInstance<Shape3DColoredVertex,
                               UniformsShapeVertex,
                                                                          UniformsShapeFragment>(sentinelNode: Shape3DColoredVertex(x: 0.0, y: 0.0, z: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                             , g: Float.random(in: 0.0...1.0)
                                                                                                                             , b: Float.random(in: 0.0...1.0)
                                                                                                                             , a: Float.random(in: 0.5...1.0)))]
    
    
    
    
    
    init(width: Float,
         height: Float) {
        self.width = width
        self.height = height
        centerX = Float(Int(width * 0.5 + 0.5))
        centerY = Float(Int(height * 0.5 + 0.5))
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
        
        print("earthTexture = \(earthTexture)")
        print("lightsTexture = \(lightsTexture)")
        
        testSprite.load(graphics: graphics,
                        texture: earthTexture)
        
        earth.load(graphics: graphics,
                   texture: earthTexture)
        
        shapeInstance2D[0].load(graphics: graphics)
        shapeInstance2D[1].load(graphics: graphics)
        shapeInstance2D[2].load(graphics: graphics)
        shapeInstance2D[3].load(graphics: graphics)
        
        shapeInstance3D[0].load(graphics: graphics)
        shapeInstance3D[1].load(graphics: graphics)
        shapeInstance3D[2].load(graphics: graphics)
        shapeInstance3D[3].load(graphics: graphics)
        
        shapeInstance2DColored[0].load(graphics: graphics)
        shapeInstance2DColored[1].load(graphics: graphics)
        shapeInstance2DColored[2].load(graphics: graphics)
        shapeInstance2DColored[3].load(graphics: graphics)
        
        shapeInstance3DColored[0].load(graphics: graphics)
        shapeInstance3DColored[1].load(graphics: graphics)
        shapeInstance3DColored[2].load(graphics: graphics)
        shapeInstance3DColored[3].load(graphics: graphics)
    }
    
    func loadComplete() {
        //jiggleEngine.loadComplete()
        
    }
    
    var earthRotation = Float(0.0)
    var lightRotation = Float(0.0)
    
    func update(deltaTime: Float) {
        
        earthRotation += 0.0075
        if earthRotation >= (Float.pi * 2.0) {
            earthRotation -= (Float.pi * 2.0)
        }
        
        lightRotation -= 0.01
        if lightRotation < 0.0 {
            lightRotation += (Float.pi * 2.0)
        }
        
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
        
        for i in 0..<4 {
            
            shapeInstance2D[i].setPositionFrame(x: 220.0 + Float(i) * 120.0, y: 200.0, width: 100.0, height: 160.0)
            shapeInstance2D[i].uniformsVertex.projectionMatrix = projectionMatrix
            shapeInstance2D[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            shapeInstance2D[i].uniformsFragment.red = 1.0
            shapeInstance2D[i].uniformsFragment.green = 1.0
            shapeInstance2D[i].uniformsFragment.blue = 0.5
            shapeInstance2D[i].uniformsFragment.alpha = 0.5
            shapeInstance2D[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            if i == 0 {
                shapeInstance2D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed2DNoBlending)
            }
            if i == 1 {
                shapeInstance2D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed2DAlphaBlending)
            }
            if i == 2 {
                shapeInstance2D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed2DAdditiveBlending)
            }
            if i == 3 {
                shapeInstance2D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed2DPremultipliedBlending)
            }
            
            
            
        }
        
        
        for i in 0..<4 {
            
            shapeInstance2DColored[i].setPositionFrame(x: 180.0 + Float(i) * 120.0, y: 260.0, width: 100.0, height: 160.0)
            shapeInstance2DColored[i].uniformsVertex.projectionMatrix = projectionMatrix
            shapeInstance2DColored[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            shapeInstance2DColored[i].uniformsFragment.red = 1.0
            shapeInstance2DColored[i].uniformsFragment.green = 1.0
            shapeInstance2DColored[i].uniformsFragment.blue = 0.5
            shapeInstance2DColored[i].uniformsFragment.alpha = 0.5
            shapeInstance2DColored[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            if i == 0 {
                shapeInstance2DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed2DNoBlending)
            }
            if i == 1 {
                shapeInstance2DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed2DAlphaBlending)
            }
            if i == 2 {
                shapeInstance2DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed2DAdditiveBlending)
            }
            if i == 3 {
                shapeInstance2DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed2DPremultipliedBlending)
            }
            
            
            
        }
    }
    
    struct MatrixPack {
        let projectionMatrix: matrix_float4x4
        let modelViewMatrix: matrix_float4x4
        let normalMatrix: matrix_float4x4
    }
    
    func getMatrixPack() -> MatrixPack {
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
        
        var normalMatrix = modelViewMatrix
        normalMatrix = simd_inverse(normalMatrix)
        normalMatrix = simd_transpose(normalMatrix)
        
        let result = MatrixPack(projectionMatrix: projectionMatrix,
                                modelViewMatrix: modelViewMatrix,
                                normalMatrix: normalMatrix)
        return result
    }
    
    func draw3DBloom(renderEncoder: MTLRenderCommandEncoder) {
        /*
        let matrixPack = getMatrixPack()
        graphics.set(depthState: .lessThan, renderEncoder: renderEncoder)
        earth.draw3DBloom(renderEncoder: renderEncoder,
                          projectionMatrix: matrixPack.projectionMatrix,
                          modelViewMatrix: matrixPack.modelViewMatrix)
        */
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
                     lightAmbientIntensity: 0.2,
                     lightDiffuseIntensity: 0.6,
                     lightSpecularIntensity: 1.0,
                     lightShininess: 24.0)
        
        
        
        graphics.set(depthState: .disabled, renderEncoder: renderEncoder)
        
        var projectionMatrix = matrix_float4x4()
        projectionMatrix.ortho(width: width, height: height)
        
        let modelViewMatrix = matrix_identity_float4x4
        for i in 0..<4 {
            
            shapeInstance3D[i].setPositionFrame(x: 220.0 + Float(i) * 120.0, y: 500.0, width: 100.0, height: 120.0)
            shapeInstance3D[i].uniformsVertex.projectionMatrix = projectionMatrix
            shapeInstance3D[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            shapeInstance3D[i].uniformsFragment.red = 0.5
            shapeInstance3D[i].uniformsFragment.green = 1.0
            shapeInstance3D[i].uniformsFragment.blue = 1.0
            shapeInstance3D[i].uniformsFragment.alpha = 0.6
            shapeInstance3D[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            if i == 0 {
                shapeInstance3D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed3DNoBlending)
            }
            if i == 1 {
                shapeInstance3D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed3DAlphaBlending)
            }
            if i == 2 {
                shapeInstance3D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed3DAdditiveBlending)
            }
            if i == 3 {
                shapeInstance3D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed3DPremultipliedBlending)
            }
            
            
            
        }
        
        for i in 0..<4 {
            
            shapeInstance3DColored[i].setPositionFrame(x: 120.0 + Float(i) * 120.0, y: 700.0, width: 100.0, height: 120.0)
            shapeInstance3DColored[i].uniformsVertex.projectionMatrix = projectionMatrix
            shapeInstance3DColored[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            shapeInstance3DColored[i].uniformsFragment.red = 0.5
            shapeInstance3DColored[i].uniformsFragment.green = 1.0
            shapeInstance3DColored[i].uniformsFragment.blue = 1.0
            shapeInstance3DColored[i].uniformsFragment.alpha = 0.6
            shapeInstance3DColored[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            if i == 0 {
                shapeInstance3DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed3DNoBlending)
            }
            if i == 1 {
                shapeInstance3DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed3DAlphaBlending)
            }
            if i == 2 {
                shapeInstance3DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed3DAdditiveBlending)
            }
            if i == 3 {
                shapeInstance3DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed3DPremultipliedBlending)
            }
            
            
            
        }
        
    }
    
    func draw3DStereoscopicLeft(renderEncoder: MTLRenderCommandEncoder) {
        
    }
    
    func draw3DStereoscopicRight(renderEncoder: MTLRenderCommandEncoder) {
        
    }
}
