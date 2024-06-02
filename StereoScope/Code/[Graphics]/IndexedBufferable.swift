//
//  IndexedBufferable.swift
//  Yomama Ben Callen
//
//  Created by Nicky Taylor on 6/2/24.
//

import Foundation
import Metal
import simd

protocol IndexedBufferable<NodeType>: AnyObject {
    
    associatedtype NodeType
    associatedtype UniformsVertexType: UniformsVertex
    associatedtype UniformsFragmentType: UniformsFragment
    
    func linkRender(renderEncoder: MTLRenderCommandEncoder, pipelineState: Graphics.PipelineState)
    
    var graphics: Graphics? { get set }
    
    var vertices: [NodeType] { get set }
    var vertexCount: Int { get set }
    var vertexCapacity: Int { get set }
    
    var indices: [UInt32] { get set }
    var indexCount: Int { get set }
    var indexCapacity: Int { get set }
    
    var uniformsVertex: UniformsVertexType { get set }
    var uniformsFragment: UniformsFragmentType { get set }
    
    var vertexBufferLength: Int { get set }
    var indexBufferLength: Int { get set }
    
    var indexBuffer: MTLBuffer? { get set }
    var vertexBuffer: MTLBuffer? { get set }
    var uniformsVertexBuffer: MTLBuffer? { get set }
    var uniformsFragmentBuffer: MTLBuffer? { get set }
    
    var isVertexBufferDirty: Bool { get set }
    var isIndexBufferDirty: Bool { get set }
    var isUniformsVertexBufferDirty: Bool { get set }
    var isUniformsFragmentBufferDirty: Bool { get set }
    
    var primitiveType: MTLPrimitiveType { get set }
    var cullMode: MTLCullMode { get set }
}

extension IndexedBufferable {
    
    func load(graphics: Graphics) {
        
        self.graphics = graphics
        
        uniformsVertexBuffer = graphics.buffer(uniform: uniformsVertex)
        uniformsFragmentBuffer = graphics.buffer(uniform: uniformsFragment)
        
        isVertexBufferDirty = true
        isIndexBufferDirty = true
        isUniformsVertexBufferDirty = true
        isUniformsFragmentBufferDirty = true
    }
    
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
    
    func add(vertex: NodeType) {
        if vertexCount >= vertexCapacity {
            let newSize = vertexCount + (vertexCount / 2) + 1
            reserveCapacityVertices(minimumCapacity: newSize, placeholder: vertex)
        }
        vertices[vertexCount] = vertex
        vertexCount += 1
        isVertexBufferDirty = true
    }
    
    func add(index: UInt32) {
        if indexCount >= indexCapacity {
            let newSize = indexCount + (indexCount / 2) + 1
            reserveCapacityIndices(minimumCapacity: newSize)
        }
        indices[indexCount] = index
        indexCount += 1
        isIndexBufferDirty = true
    }
    
    func add(index1: UInt32, index2: UInt32, index3: UInt32) {
        if (indexCount + 2) >= indexCapacity {
            let newSize = (indexCount + 2) + ((indexCount + 2) / 2) + 1
            reserveCapacityIndices(minimumCapacity: newSize)
        }
        indices[indexCount + 0] = index1
        indices[indexCount + 1] = index2
        indices[indexCount + 2] = index3
        indexCount += 3
        isIndexBufferDirty = true
    }
    
    @discardableResult func addTriangleStripQuad(startingAt index: UInt32) -> UInt32 {
        if (indexCount + 5) >= indexCapacity {
            let newSize = (indexCount + 5) + ((indexCount + 5) / 2) + 1
            reserveCapacityIndices(minimumCapacity: newSize)
        }
        indices[indexCount + 0] = index + 0
        indices[indexCount + 1] = index + 1
        indices[indexCount + 2] = index + 2
        indices[indexCount + 3] = index + 1
        indices[indexCount + 4] = index + 3
        indices[indexCount + 5] = index + 2
        indexCount += 6
        isIndexBufferDirty = true
        return index + 4
    }
    
    @discardableResult func addTriangle(startingAt index: UInt32) -> UInt32 {
        if (indexCount + 2) >= indexCapacity {
            let newSize = (indexCount + 2) + ((indexCount + 2) / 2) + 1
            reserveCapacityIndices(minimumCapacity: newSize)
        }
        indices[indexCount + 0] = index + 0
        indices[indexCount + 1] = index + 1
        indices[indexCount + 2] = index + 2
        indexCount += 3
        isIndexBufferDirty = true
        return index + 3
    }
    
    func reset() {
        vertexCount = 0
        indexCount = 0
        isVertexBufferDirty = true
        isIndexBufferDirty = true
    }
    
    func reserveCapacityVertices(minimumCapacity: Int, placeholder: NodeType) {
        if minimumCapacity > vertexCapacity {
            vertices.reserveCapacity(minimumCapacity)
            while vertices.count < minimumCapacity {
                vertices.append(placeholder)
            }
            vertexCapacity = minimumCapacity
        }
    }
    
    func reserveCapacityIndices(minimumCapacity: Int) {
        if minimumCapacity > indexCapacity {
            indices.reserveCapacity(minimumCapacity)
            while indices.count < minimumCapacity {
                indices.append(0)
            }
            indexCapacity = minimumCapacity
        }
    }
    
    func render(renderEncoder: MTLRenderCommandEncoder, pipelineState: Graphics.PipelineState) {
        
        guard let graphics = graphics else {
            return
        }
        
        guard indexCount > 0 else {
            return
        }
        
        guard vertexCount > 0 else {
            return
        }
        
        guard let uniformsVertexBuffer = uniformsVertexBuffer else {
            return
        }
        
        guard let uniformsFragmentBuffer = uniformsFragmentBuffer else {
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
            return
        }
        
        guard let indexBuffer = indexBuffer else {
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
        renderEncoder.setCullMode(cullMode)
        linkRender(renderEncoder: renderEncoder, pipelineState: pipelineState)
        renderEncoder.drawIndexedPrimitives(type: primitiveType,
                                            indexCount: indexCount,
                                            indexType: .uint32,
                                            indexBuffer: indexBuffer,
                                            indexBufferOffset: 0)
    }
    
    func writeVertexBuffer() {
        guard let graphics = graphics else { 
            return
        }
        
        let length = MemoryLayout<NodeType>.size * vertexCount
        guard length > 0 else {
            vertexBufferLength = 0
            return
        }
        
        guard let metalDevice = graphics.metalDevice else {
            return
        }
        
        if vertexBuffer !== nil {
            if length > vertexBufferLength {
                vertexBuffer = nil
                vertexBufferLength = MemoryLayout<NodeType>.size * vertexCapacity
                vertexBuffer = metalDevice.makeBuffer(bytes: vertices, length: vertexBufferLength)
            } else {
                if let vertexBuffer = vertexBuffer {
                    vertexBuffer.contents().copyMemory(from: vertices, byteCount: length)
                }
            }
        } else {
            vertexBufferLength = MemoryLayout<NodeType>.size * vertexCapacity
            vertexBuffer = metalDevice.makeBuffer(bytes: vertices, length: vertexBufferLength)
        }
    }
    
    func writeIndexBuffer() {
        guard let graphics = graphics else { return }
        
        let length = MemoryLayout<UInt32>.size * indexCount
        guard length > 0 else {
            indexBufferLength = 0
            return
        }
        
        guard let metalDevice = graphics.metalDevice else {
            return
        }
        
        if indexBuffer !== nil {
            if length > indexBufferLength {
                indexBuffer = nil
                indexBufferLength = MemoryLayout<UInt32>.size * indexCapacity
                indexBuffer = metalDevice.makeBuffer(bytes: indices, length: indexBufferLength)
            } else {
                if let indexBuffer = indexBuffer {
                    indexBuffer.contents().copyMemory(from: indices, byteCount: length)
                }
            }
        } else {
            indexBufferLength = MemoryLayout<UInt32>.size * indexCapacity
            indexBuffer = metalDevice.makeBuffer(bytes: indices, length: indexBufferLength)
        }
    }
}

extension IndexedBufferable {
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
    
    var red: Float {
        get {
            uniformsFragment.red
        }
        set {
            if uniformsFragment.red != newValue {
                uniformsFragment.red = newValue
                isUniformsFragmentBufferDirty = true
            }
        }
    }
    
    var green: Float {
        get {
            uniformsFragment.green
        }
        set {
            if uniformsFragment.green != newValue {
                uniformsFragment.green = newValue
                isUniformsFragmentBufferDirty = true
            }
        }
    }
    
    var blue: Float {
        get {
            uniformsFragment.blue
        }
        set {
            if uniformsFragment.blue != newValue {
                uniformsFragment.blue = newValue
                isUniformsFragmentBufferDirty = true
            }
        }
    }
    
    var alpha: Float {
        get {
            uniformsFragment.alpha
        }
        set {
            if uniformsFragment.alpha != newValue {
                uniformsFragment.alpha = newValue
                isUniformsFragmentBufferDirty = true
            }
        }
    }
}
