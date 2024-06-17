//
//  IndexedInstanceable.swift
//  Yomama Ben Callen
//
//  Created by Nicky Taylor on 6/2/24.
//

import Foundation
import Metal
import simd

//
// Note: This is only for a single-quad triangle strip.
//
protocol IndexedInstanceable<NodeType>: IndexedDrawable {
    
    func linkRender(renderEncoder: MTLRenderCommandEncoder, pipelineState: Graphics.PipelineState)
    
    var vertices: [NodeType] { get set }
    
    var cullMode: MTLCullMode { get set }
}

extension IndexedInstanceable {
    
    func load(graphics: Graphics?) {
        
        self.graphics = graphics
        
        guard let graphics = graphics else {
            return
        }
        
        guard let metalDevice = graphics.metalDevice else {
            return
        }
        
        uniformsVertexBuffer = graphics.buffer(uniform: uniformsVertex)
        uniformsFragmentBuffer = graphics.buffer(uniform: uniformsFragment)
        
        let indices: [UInt32] = [0, 1, 2, 3]
        indexBuffer = metalDevice.makeBuffer(bytes: indices, length: MemoryLayout<UInt32>.size * 4)
        vertexBuffer = metalDevice.makeBuffer(bytes: vertices, length: MemoryLayout<NodeType>.size * 4)
        
        isVertexBufferDirty = false
        isUniformsVertexBufferDirty = true
        isUniformsFragmentBufferDirty = true
    }
    
    func render(renderEncoder: MTLRenderCommandEncoder, pipelineState: Graphics.PipelineState) {
        
        guard let graphics = graphics else {
            return
        }
        
        guard let uniformsVertexBuffer = uniformsVertexBuffer else {
            return
        }
        
        guard let uniformsFragmentBuffer = uniformsFragmentBuffer else {
            return
        }
        
        guard let vertexBuffer = vertexBuffer else {
            return
        }
        
        if isVertexBufferDirty {
            let length = MemoryLayout<NodeType>.size * 4
            vertexBuffer.contents().copyMemory(from: vertices, byteCount: length)
            isVertexBufferDirty = false
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
        renderEncoder.drawIndexedPrimitives(type: .triangleStrip,
                                            indexCount: 4,
                                            indexType: .uint32,
                                            indexBuffer: indexBuffer,
                                            indexBufferOffset: 0)
    }
}
