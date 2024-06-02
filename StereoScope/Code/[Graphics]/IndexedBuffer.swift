//
//  IndexedBuffer.swift
//  Yomama Ben Callen
//
//  Created by Nicky Taylor on 6/2/24.
//

import Foundation
import Metal
import simd

class IndexedBuffer<Node: PositionConforming2D,
                    VertexUniforms: UniformsVertex,
                    FragmentUniforms: UniformsFragment>: IndexedBufferable {
    
    typealias NodeType = Node
    typealias UniformsVertexType = VertexUniforms
    typealias UniformsFragmentType = FragmentUniforms
    
    func linkRender(renderEncoder: any MTLRenderCommandEncoder, pipelineState: Graphics.PipelineState) {
        
    }
    
    var graphics: Graphics?
    
    var vertices = [Node]()
    
    var vertexCount = 0
    var vertexCapacity = 0
    
    var indices = [UInt32]()
    
    var indexCount = 0
    var indexCapacity = 0
    
    var uniformsVertex = VertexUniforms()
    var uniformsFragment = FragmentUniforms()
    
    var vertexBufferLength = 0
    var indexBufferLength = 0
    
    var indexBuffer: (MTLBuffer)?
    var vertexBuffer: (MTLBuffer)?
    
    var uniformsVertexBuffer: (MTLBuffer)?
    var uniformsFragmentBuffer: (MTLBuffer)?
    
    var isVertexBufferDirty = false
    var isIndexBufferDirty = false
    var isUniformsVertexBufferDirty = false
    var isUniformsFragmentBufferDirty = false
    
    var primitiveType = MTLPrimitiveType.triangleStrip
    var cullMode = MTLCullMode.back
}
