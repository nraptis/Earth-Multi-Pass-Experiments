//
//  IndexedBuffer.swift
//  Yomama Ben Callen
//
//  Created by Nicky Taylor on 6/2/24.
//
//  Verified on 11/9/2024 by Nick Raptis
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
    
    var _cornerX: [Float] = [0.0, 0.0, 0.0, 0.0]
    var _cornerY: [Float] = [0.0, 0.0, 0.0, 0.0]
    func transformCorners(cornerX1: Float, cornerY1: Float,
                          cornerX2: Float, cornerY2: Float,
                          cornerX3: Float, cornerY3: Float,
                          cornerX4: Float, cornerY4: Float,
                          translation: Math.Point, scale: Float, rotation: Float) {
        _cornerX[0] = cornerX1; _cornerY[0] = cornerY1
        _cornerX[1] = cornerX2; _cornerY[1] = cornerY2
        _cornerX[2] = cornerX3; _cornerY[2] = cornerY3
        _cornerX[3] = cornerX4; _cornerY[3] = cornerY4
        if rotation != 0.0 {
            var cornerIndex = 0
            while cornerIndex < 4 {
                
                var x = _cornerX[cornerIndex]
                var y = _cornerY[cornerIndex]
                
                var dist = x * x + y * y
                if dist > Math.epsilon {
                    dist = sqrtf(Float(dist))
                    x /= dist
                    y /= dist
                }
                
                if scale != 1.0 {
                    dist *= scale
                }
                
                let pivotRotation = rotation - atan2f(-x, -y)
                x = sinf(Float(pivotRotation)) * dist
                y = -cosf(Float(pivotRotation)) * dist
                
                _cornerX[cornerIndex] = x
                _cornerY[cornerIndex] = y
                
                cornerIndex += 1
            }
        } else if scale != 1.0 {
            var cornerIndex = 0
            while cornerIndex < 4 {
                _cornerX[cornerIndex] *= scale
                _cornerY[cornerIndex] *= scale
                cornerIndex += 1
            }
        }
        //
        if translation.x != 0 || translation.y != 0 {
            var cornerIndex = 0
            while cornerIndex < 4 {
                _cornerX[cornerIndex] += translation.x
                _cornerY[cornerIndex] += translation.y
                cornerIndex += 1
            }
        }
    }
}
