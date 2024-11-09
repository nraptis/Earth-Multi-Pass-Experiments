//
//  IndexedDrawable.swift
//  StereoScope
//
//  Created by Nicky Taylor on 6/2/24.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation
import Metal
import simd

protocol IndexedDrawable<NodeType>: AnyObject {
    
    associatedtype NodeType
    associatedtype UniformsVertexType: UniformsVertex
    associatedtype UniformsFragmentType: UniformsFragment
    
    func linkRender(renderEncoder: MTLRenderCommandEncoder, pipelineState: Graphics.PipelineState)
    
    var graphics: Graphics? { get set }
    
    var uniformsVertex: UniformsVertexType { get set }
    var uniformsFragment: UniformsFragmentType { get set }
    
    var indexBuffer: MTLBuffer? { get set }
    var vertexBuffer: MTLBuffer? { get set }
    var uniformsVertexBuffer: MTLBuffer? { get set }
    var uniformsFragmentBuffer: MTLBuffer? { get set }
    
    var isVertexBufferDirty: Bool { get set }
    var isIndexBufferDirty: Bool { get set }
    var isUniformsVertexBufferDirty: Bool { get set }
    var isUniformsFragmentBufferDirty: Bool { get set }
}

extension IndexedDrawable {
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
}

extension IndexedDrawable {
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
