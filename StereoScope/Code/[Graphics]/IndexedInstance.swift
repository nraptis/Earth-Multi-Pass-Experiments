//
//  IndexedInstance.swift
//  Yomama Ben Callen
//
//  Created by Nicky Taylor on 6/2/24.
//

import Foundation
import Metal
import simd

class IndexedInstance<Node: PositionConforming2D,
                        VertexUniforms: UniformsVertex,
                      FragmentUniforms: UniformsFragment>: IndexedInstanceable {
    
    typealias NodeType = Node
    typealias UniformsVertexType = VertexUniforms
    typealias UniformsFragmentType = FragmentUniforms
    
    init(node1: Node, node2: Node, node3: Node, node4: Node) {
        self.vertices = [node1, node2, node3, node4]
    }
    
    init(sentinelNode: Node) {
        self.vertices = [sentinelNode, sentinelNode, sentinelNode, sentinelNode]
    }
    
    func linkRender(renderEncoder: any MTLRenderCommandEncoder, pipelineState: Graphics.PipelineState) {
        
    }
    
    var graphics: Graphics?
    
    var vertices = [Node]()
    
    var uniformsVertex = VertexUniforms()
    var uniformsFragment = FragmentUniforms()
    
    var indexBuffer: (MTLBuffer)?
    var vertexBuffer: (MTLBuffer)?
    var uniformsVertexBuffer: (MTLBuffer)?
    var uniformsFragmentBuffer: (MTLBuffer)?
    
    var isVertexBufferDirty = false
    var isIndexBufferDirty = false
    var isUniformsVertexBufferDirty = false
    var isUniformsFragmentBufferDirty = false
    
    var cullMode = MTLCullMode.back
}

extension IndexedInstance where Node: PositionConforming2D {
    
    func setPositionFrame(x: Float, y: Float, width: Float, height: Float) {
        setPositionQuad(x1: x, y1: y,
                        x2: x + width, y2: y,
                        x3: x, y3: y + height,
                        x4: x + width, y4: y + height)
    }
    
    func setPositionQuad(x1: Float, y1: Float,
                         x2: Float, y2: Float) {
        setPositionQuad(x1: x1, y1: y1,
                        x2: x2, y2: y1,
                        x3: x1, y3: y2,
                        x4: x2, y4: y2)
    }
    
    func setPositionQuad(x1: Float, y1: Float, x2: Float, y2: Float,
                         x3: Float, y3: Float, x4: Float, y4: Float) {
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
}

extension IndexedInstance where Node: TextureCoordinateConforming {
    
    func setTextureCoordFrame(startU: Float, startV: Float, endU: Float, endV: Float) {
        setTextureCoordQuad(u1: startU, v1: startV,
                            u2: endU, v2: startV,
                            u3: startU, v3: endV,
                            u4: endU, v4: endV)
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
}
