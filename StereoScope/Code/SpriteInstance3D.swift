//
//  SpriteInstance3D.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

import Foundation
import Metal
import simd

class SpriteInstance3D {
    
    enum BlendMode {
        case none
        case additive
    }
    
    var blendMode = BlendMode.none
    
    private(set) weak var texture: MTLTexture?
    private(set) weak var graphics: Graphics?
    
    private var uniformsVertex = UniformsSpriteVertex()
    private var uniformsFragment = UniformsSpriteFragment()
    private var uniformsVertexBuffer: MTLBuffer?
    private var uniformsFragmentBuffer: MTLBuffer?
    
    private var vertexBuffer: MTLBuffer?
    private var indexBuffer: MTLBuffer?
    
    private var vertices = [Sprite3DVertex](repeating: Sprite3DVertex(x: 0.0,
                                                                      y: 0.0,
                                                                      z: 0.0,
                                                                      u: 0.0,
                                                                      v: 0.0), count: 4)
    
    private var indices: [UInt32] = [0, 1, 2, 3]
    
    var samplerState = Graphics.SamplerState.linearClamp
    
    var isVertexBufferDirty = true
    var isIndexBufferDirty = true
    
    var isUniformsVertexBufferDirty = true
    var isUniformsFragmentBufferDirty = true
    
    func setX1(_ value: Float) {
        if vertices[0].x != value {
            vertices[0].x = value
            isVertexBufferDirty = true
        }
    }
    func setY1(_ value: Float) {
        if vertices[0].y != value {
            vertices[0].y = value
            isVertexBufferDirty = true
        }
    }
    func setU1(_ value: Float) {
        if vertices[0].u != value {
            vertices[0].u = value
            isVertexBufferDirty = true
        }
    }
    func setV1(_ value: Float) {
        if vertices[0].v != value {
            vertices[0].v = value
            isVertexBufferDirty = true
        }
    }
    
    func setX2(_ value: Float) {
        if vertices[1].x != value {
            vertices[1].x = value
            isVertexBufferDirty = true
        }
    }
    func setY2(_ value: Float) {
        if vertices[1].y != value {
            vertices[1].y = value
            isVertexBufferDirty = true
        }
    }
    func setU2(_ value: Float) {
        if vertices[1].u != value {
            vertices[1].u = value
            isVertexBufferDirty = true
        }
    }
    func setV2(_ value: Float) {
        if vertices[1].v != value {
            vertices[1].v = value
            isVertexBufferDirty = true
        }
    }
    
    func setX3(_ value: Float) {
        if vertices[2].x != value {
            vertices[2].x = value
            isVertexBufferDirty = true
        }
    }
    func setY3(_ value: Float) {
        if vertices[2].y != value {
            vertices[2].y = value
            isVertexBufferDirty = true
        }
    }
    func setU3(_ value: Float) {
        if vertices[2].u != value {
            vertices[2].u = value
            isVertexBufferDirty = true
        }
    }
    func setV3(_ value: Float) {
        if vertices[2].v != value {
            vertices[2].v = value
            isVertexBufferDirty = true
        }
    }
    
    func setX4(_ value: Float) {
        if vertices[3].x != value {
            vertices[3].x = value
            isVertexBufferDirty = true
        }
    }
    func setY4(_ value: Float) {
        if vertices[3].y != value {
            vertices[3].y = value
            isVertexBufferDirty = true
        }
    }
    func setU4(_ value: Float) {
        if vertices[3].u != value {
            vertices[3].u = value
            isVertexBufferDirty = true
        }
    }
    func setV4(_ value: Float) {
        if vertices[3].v != value {
            vertices[3].v = value
            isVertexBufferDirty = true
        }
    }
    
    var projectionMatrix: matrix_float4x4 {
        get {
            uniformsVertex.projectionMatrix
        }
        set {
            if uniformsVertex.projectionMatrix != newValue {
                uniformsVertex.projectionMatrix = newValue
                isUniformsVertexBufferDirty = true
            }
        }
    }
    var modelViewMatrix: matrix_float4x4 {
        get {
            uniformsVertex.modelViewMatrix
        }
        set {
            if uniformsVertex.modelViewMatrix != newValue {
                uniformsVertex.modelViewMatrix = newValue
                isUniformsVertexBufferDirty = true
            }
        }
    }
    
    func load(graphics: Graphics) {
        self.graphics = graphics
        uniformsVertexBuffer = graphics.buffer(uniform: uniformsVertex)
        uniformsFragmentBuffer = graphics.buffer(uniform: uniformsFragment)
        vertexBuffer = graphics.buffer(array: vertices)
        indexBuffer = graphics.buffer(array: indices)
    }
    
    func load(graphics: Graphics,
              texture: MTLTexture?) {
        load(graphics: graphics)
        self.texture = texture
        if let texture = texture {
            setX1(0.0)
            setY1(0.0)
            setU1(0.0)
            setV1(0.0)
            setX2(Float(texture.width))
            setY2(0.0)
            setU2(1.0)
            setV2(0.0)
            setX3(0.0)
            setY3(Float(texture.height))
            setU3(0.0)
            setV3(1.0)
            setX4(Float(texture.width))
            setY4(Float(texture.height))
            setU4(1.0)
            setV4(1.0)
        }
    }
    
    func render(renderEncoder: MTLRenderCommandEncoder) {
        guard let graphics = graphics else { return }
        guard let texture = texture else { return }
        guard let vertexBuffer = vertexBuffer else { return }
        guard let indexBuffer = indexBuffer else { return }
        guard let uniformsVertexBuffer = uniformsVertexBuffer else { return }
        guard let uniformsFragmentBuffer = uniformsFragmentBuffer else { return }
        switch blendMode {
        case .none:
            graphics.set(pipelineState: .spriteNodeIndexed2DNoBlending, renderEncoder: renderEncoder)
        case .additive:
            graphics.set(pipelineState: .spriteNodeIndexed2DAdditiveBlending, renderEncoder: renderEncoder)
        }
        
        if isVertexBufferDirty {
            graphics.write(buffer: vertexBuffer, array: vertices)
            isVertexBufferDirty = false
        }
        if isIndexBufferDirty {
            graphics.write(buffer: indexBuffer, array: indices)
            isIndexBufferDirty = false
        }
        if isUniformsVertexBufferDirty {
            graphics.write(buffer: uniformsVertexBuffer, uniform: uniformsVertex)
            isUniformsVertexBufferDirty = false
        }
        if isUniformsFragmentBufferDirty {
            graphics.write(buffer: uniformsFragmentBuffer, uniform: uniformsFragment)
            isUniformsFragmentBufferDirty = false
        }
        graphics.setFragmentTexture(texture, renderEncoder: renderEncoder)
        graphics.setVertexUniformsBuffer(uniformsVertexBuffer, renderEncoder: renderEncoder)
        graphics.setFragmentUniformsBuffer(uniformsFragmentBuffer, renderEncoder: renderEncoder)
        graphics.setVertexDataBuffer(vertexBuffer, renderEncoder: renderEncoder)
        graphics.set(samplerState: samplerState, renderEncoder: renderEncoder)
        renderEncoder.setCullMode(MTLCullMode.back)
        renderEncoder.drawIndexedPrimitives(type: .triangleStrip,
                                            indexCount: 4,
                                            indexType: .uint32,
                                            indexBuffer: indexBuffer, indexBufferOffset: 0)
    }
}
