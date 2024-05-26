//
//  IndexedSpriteInstance.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/25/24.
//

import Foundation
import Metal
import simd

class IndexedSpriteInstance<NodeType: PositionConforming2D & TextureCoordinateConforming,
                            UniformsVertexType: UniformsVertex,
                            UniformsFragmentType: UniformsFragment> {
    
    
    var vertices: [NodeType]
    
    let indices: [UInt32] = [0, 1, 2, 3]
    
    var uniformsVertex = UniformsVertexType()
    var uniformsFragment = UniformsFragmentType()
    
    private(set) var indexBuffer: MTLBuffer!
    private(set) var vertexBuffer: MTLBuffer!
    private(set) var uniformsVertexBuffer: MTLBuffer!
    private(set) var uniformsFragmentBuffer: MTLBuffer!
    
    var isVertexBufferDirty = true
    var isUniformsVertexBufferDirty = true
    var isUniformsFragmentBufferDirty = true
    
    var cullMode = MTLCullMode.none
    var samplerState = Graphics.SamplerState.linearClamp
    
    weak var texture: MTLTexture?
    private(set) unowned var graphics: Graphics?
    
    init(sentinelNode: NodeType) {
        vertices = [sentinelNode,
                    sentinelNode,
                    sentinelNode,
                    sentinelNode]
        vertices[0].u = 0.0
        vertices[0].v = 0.0
        vertices[1].u = 1.0
        vertices[1].v = 0.0
        vertices[2].u = 0.0
        vertices[2].v = 1.0
        vertices[3].u = 1.0
        vertices[3].v = 1.0
    }
    
    func setDirty(isVertexBufferDirty: Bool,
                  isUniformsVertexBufferDirty: Bool,
                  isUniformsFragmentBufferDirty: Bool) {
        if isVertexBufferDirty {
            self.isVertexBufferDirty = true
        }
        if isUniformsVertexBufferDirty {
            self.isUniformsVertexBufferDirty = true
        }
        if isUniformsFragmentBufferDirty {
            self.isUniformsFragmentBufferDirty = true
        }
    }
    
    func load(graphics: Graphics,
              texture: MTLTexture?) {
        
        self.graphics = graphics
        self.texture = texture
        
        uniformsVertexBuffer = graphics.buffer(uniform: uniformsVertex)
        uniformsFragmentBuffer = graphics.buffer(uniform: uniformsFragment)
        
        indexBuffer = graphics.metalDevice.makeBuffer(bytes: indices, length: MemoryLayout<UInt32>.size * 4)
        vertexBuffer = graphics.metalDevice.makeBuffer(bytes: vertices, length: MemoryLayout<NodeType>.size * 4)
        
        isVertexBufferDirty = true
        isUniformsVertexBufferDirty = true
        isUniformsFragmentBufferDirty = true
    }
    
    func setPositionFrame(x: Float, y: Float, width: Float, height: Float) {
        setPositionQuad(x1: x, y1: y,
                        x2: x + width, y2: y,
                        x3: x, y3: y + height,
                        x4: x + width, y4: y + height)
    }
    
    func setTextureCoordFrame(startU: Float, startV: Float, endU: Float, endV: Float) {
        setTextureCoordQuad(u1: startU, v1: startV,
                            u2: endU, v2: startV,
                            u3: startU, v3: endV,
                            u4: endU, v4: endV)
    }
    
    func setPositionQuad(x1: Float, y1: Float,
                         x2: Float, y2: Float,
                         x3: Float, y3: Float,
                         x4: Float, y4: Float) {
        if vertices[0].x != x1 {
            vertices[0].x = x1
            isVertexBufferDirty = true
        }
        if vertices[1].x != x2 {
            vertices[1].x = x2
            isVertexBufferDirty = true
        }
        if vertices[2].x != x3 {
            vertices[2].x = x3
            isVertexBufferDirty = true
        }
        if vertices[3].x != x4 {
            vertices[3].x = x4
            isVertexBufferDirty = true
        }
        if vertices[0].y != y1 {
            vertices[0].y = y1
            isVertexBufferDirty = true
        }
        if vertices[1].y != y2 {
            vertices[1].y = y2
            isVertexBufferDirty = true
        }
        if vertices[2].y != y3 {
            vertices[2].y = y3
            isVertexBufferDirty = true
        }
        if vertices[3].y != y4 {
            vertices[3].y = y4
            isVertexBufferDirty = true
        }
    }
    
    func setTextureCoordQuad(u1: Float, v1: Float,
                             u2: Float, v2: Float,
                             u3: Float, v3: Float,
                             u4: Float, v4: Float) {
        if vertices[0].u != u1 {
            vertices[0].u = u1
            isVertexBufferDirty = true
        }
        if vertices[1].u != u2 {
            vertices[1].u = u2
            isVertexBufferDirty = true
        }
        if vertices[2].u != u3 {
            vertices[2].u = u3
            isVertexBufferDirty = true
        }
        if vertices[3].u != u4 {
            vertices[3].u = u4
            isVertexBufferDirty = true
        }
        if vertices[0].v != v1 {
            vertices[0].v = v1
            isVertexBufferDirty = true
        }
        if vertices[1].v != v2 {
            vertices[1].v = v2
            isVertexBufferDirty = true
        }
        if vertices[2].v != v3 {
            vertices[2].v = v3
            isVertexBufferDirty = true
        }
        if vertices[3].v != v4 {
            vertices[3].v = v4
            isVertexBufferDirty = true
        }
    }
    
    func render(renderEncoder: MTLRenderCommandEncoder,
                pipelineState: Graphics.PipelineState) {
        
        guard let graphics = graphics else {
            return
        }
        
        guard let texture = texture else {
            print("IndexedTriangleTestDemoBufferShapeDemoColored2D => Render => Sprite Missing Texture")
            return
        }
        
        guard let uniformsVertexBuffer = uniformsVertexBuffer else {
            print("IndexedTriangleTestDemoBufferShapeDemoColored2D => Render => Sprite Missing Uniforms Vertex Buffer")
            return
        }
        
        guard let uniformsFragmentBuffer = uniformsFragmentBuffer else {
            print("IndexedTriangleTestDemoBufferShapeDemoColored2D => Render => Sprite Missing Uniforms Fragment Buffer")
            return
        }
        
        if isVertexBufferDirty {
            writeVertexBuffer()
            isVertexBufferDirty = false
        }

        guard let vertexBuffer = vertexBuffer else {
            print("IndexedTriangleTestDemoBufferShapeDemoColored2D => Render => Sprite Missing Vertex Buffer")
            return
        }
        
        guard let indexBuffer = indexBuffer else {
            print("IndexedTriangleTestDemoBufferShapeDemoColored2D => Render => Sprite Missing Index Buffer")
            return
        }
        
        if isUniformsVertexBufferDirty {
            graphics.write(buffer: uniformsVertexBuffer, uniform: uniformsVertex)
            isUniformsVertexBufferDirty = false
        }
        if isUniformsFragmentBufferDirty {
            graphics.write(buffer: uniformsFragmentBuffer, uniform: uniformsFragment)
            isUniformsFragmentBufferDirty = false
        }
        
        graphics.set(pipelineState: pipelineState, renderEncoder: renderEncoder)
        
        graphics.setVertexDataBuffer(vertexBuffer, renderEncoder: renderEncoder)
        
        graphics.setVertexUniformsBuffer(uniformsVertexBuffer, renderEncoder: renderEncoder)
        graphics.setFragmentUniformsBuffer(uniformsFragmentBuffer, renderEncoder: renderEncoder)
        
        graphics.setFragmentTexture(texture, renderEncoder: renderEncoder)
        
        graphics.set(samplerState: samplerState, renderEncoder: renderEncoder)
        
        renderEncoder.setCullMode(cullMode)
        
        renderEncoder.drawIndexedPrimitives(type: MTLPrimitiveType.triangleStrip,
                                            indexCount: 4,
                                            indexType: .uint32,
                                            indexBuffer: indexBuffer,
                                            indexBufferOffset: 0)
    }
    
    func writeVertexBuffer() {
        if let vertexBuffer = vertexBuffer {
            vertexBuffer.contents().copyMemory(from: vertices, byteCount: MemoryLayout<NodeType>.size * 4)
        }
    }
    
}
