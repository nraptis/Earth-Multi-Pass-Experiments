//
//  IndexedTriangleBufferSprite3D.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

import Foundation
import Metal
import simd

class IndexedTexturedTriangleBuffer<NodeType,
                                    UniformsVertexType: UniformsVertex,
                                    UniformsFragmentType: UniformsFragment> {
    
    private(set) var vertices = [NodeType]()
    private(set) var vertexCount = 0
    private(set) var vertexCapacity = 0
    
    private(set) var indices = [UInt32]()
    private(set) var indexCount = 0
    private(set) var indexCapacity = 0
    
    private var vertexBufferLength = 0
    private var indexBufferLength = 0
    
    var uniformsVertex = UniformsVertexType()
    var uniformsFragment = UniformsFragmentType()
    
    private(set) var indexBuffer: MTLBuffer!
    private(set) var vertexBuffer: MTLBuffer!
    private(set) var uniformsVertexBuffer: MTLBuffer!
    private(set) var uniformsFragmentBuffer: MTLBuffer!
    
    var isVertexBufferDirty = true
    var isIndexBufferDirty = true
    var isUniformsVertexBufferDirty = true
    var isUniformsFragmentBufferDirty = true
    
    var primitiveType = MTLPrimitiveType.triangleStrip
    var cullMode = MTLCullMode.none
    var samplerState = Graphics.SamplerState.linearClamp
    
    private(set) weak var texture: MTLTexture?
    private(set) unowned var graphics: Graphics?
    
    func setDirty(isVertexBufferDirty: Bool,
                  isIndexBufferDirty: Bool,
                  isUniformsVertexBufferDirty: Bool,
                  isUniformsFragmentBufferDirty: Bool) {
        if isVertexBufferDirty {
            self.isVertexBufferDirty = true
        }
        if isIndexBufferDirty {
            self.isIndexBufferDirty = true
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
        
        isVertexBufferDirty = true
        isIndexBufferDirty = true
        isUniformsVertexBufferDirty = true
        isUniformsFragmentBufferDirty = true
    }
    
    func add(vertex: NodeType) {
        if vertexCount >= vertexCapacity {
            let newSize = vertexCount + (vertexCount / 2) + 1
            reserveCapacityVertices(minimumCapacity: newSize, placeholder: vertex)
        }
        vertices[vertexCount] = vertex
        vertexCount += 1
    }
    
    func add(index: UInt32) {
        if indexCount >= indexCapacity {
            let newSize = indexCount + (indexCount / 2) + 1
            reserveCapacityIndices(minimumCapacity: newSize)
        }
        indices[indexCount] = index
        indexCount += 1
    }
    
    func reset() {
        vertexCount = 0
        indexCount = 0
        isVertexBufferDirty = true
        isIndexBufferDirty = true
    }
    
    private func reserveCapacityVertices(minimumCapacity: Int,
                                         placeholder: NodeType) {
        if minimumCapacity > vertexCapacity {
            vertices.reserveCapacity(minimumCapacity)
            while vertices.count < minimumCapacity {
                vertices.append(placeholder)
            }
            vertexCapacity = minimumCapacity
        }
    }
    
    private func reserveCapacityIndices(minimumCapacity: Int) {
        if minimumCapacity > indexCapacity {
            indices.reserveCapacity(minimumCapacity)
            while indices.count < minimumCapacity {
                indices.append(0)
            }
            indexCapacity = minimumCapacity
        }
    }
    
    func render(renderEncoder: MTLRenderCommandEncoder,
                pipelineState: Graphics.PipelineState) {
        
        guard let graphics = graphics else {
            return
        }
        
        guard indexCount > 0 else {
            return
        }
        
        guard vertexCount > 0 else {
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
        
        if isIndexBufferDirty {
            writeIndexBuffer()
            isIndexBufferDirty = false
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
        
        renderEncoder.drawIndexedPrimitives(type: primitiveType,
                                            indexCount: indexCount,
                                            indexType: .uint32,
                                            indexBuffer: indexBuffer,
                                            indexBufferOffset: 0)
    }
    
    func writeVertexBuffer() {
        guard let graphics = graphics else { return }
        
        let length = MemoryLayout<NodeType>.size * vertexCount
        guard length > 0 else {
            vertexBufferLength = 0
            return
        }
        
        if vertexBuffer !== nil {
            if length > vertexBufferLength {
                vertexBuffer = nil
                vertexBufferLength = MemoryLayout<NodeType>.size * vertexCapacity
                vertexBuffer = graphics.metalDevice.makeBuffer(bytes: vertices, length: vertexBufferLength)
            } else {
                vertexBuffer.contents().copyMemory(from: vertices, byteCount: length)
            }
        } else {
            vertexBufferLength = MemoryLayout<NodeType>.size * vertexCapacity
            vertexBuffer = graphics.metalDevice.makeBuffer(bytes: vertices, length: vertexBufferLength)
        }
    }
    
    func writeIndexBuffer() {
        guard let graphics = graphics else { return }
        
        let length = MemoryLayout<UInt32>.size * indexCount
        guard length > 0 else {
            indexBufferLength = 0
            return
        }
        
        if indexBuffer !== nil {
            if length > indexBufferLength {
                indexBuffer = nil
                indexBufferLength = MemoryLayout<UInt32>.size * indexCapacity
                indexBuffer = graphics.metalDevice.makeBuffer(bytes: indices, length: indexBufferLength)
            } else {
                indexBuffer.contents().copyMemory(from: indices, byteCount: length)
            }
        } else {
            indexBufferLength = MemoryLayout<UInt32>.size * indexCapacity
            indexBuffer = graphics.metalDevice.makeBuffer(bytes: indices, length: indexBufferLength)
        }
    }
    
    
}
