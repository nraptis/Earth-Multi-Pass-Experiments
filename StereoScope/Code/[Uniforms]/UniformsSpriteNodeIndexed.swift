//
//  UniformsSpriteNodeIndexed.swift
//  RebuildEarth
//
//  Created by Nicky Taylor on 2/21/23.
//

import Foundation
import simd

typealias UniformsSpriteNodeIndexedVertex = UniformsShapeVertex
typealias UniformsSpriteNodeIndexedFragment = UniformsShapeFragment

struct UniformsSpriteNodeIndexedDiffuseFragment: UniformsFragment {
    
    var red: Float
    var green: Float
    var blue: Float
    var alpha: Float
    
    var lightRed: Float
    var lightGreen: Float
    var lightBlue: Float
    
    var lightAmbientIntensity: Float
    var lightDiffuseIntensity: Float
    
    var lightDirX: Float
    var lightDirY: Float
    var lightDirZ: Float
    
    init() {
        red = 1.0
        green = 1.0
        blue = 1.0
        alpha = 1.0
        
        lightRed = 1.0
        lightGreen = 1.0
        lightBlue = 1.0
        
        lightAmbientIntensity = 0.0
        lightDiffuseIntensity = 1.0
        
        lightDirX = 0.0
        lightDirY = 0.0
        lightDirZ = -1.0
    }
    
    mutating func set(red: Float, green: Float, blue: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = 1.0
    }
    
    mutating func set(red: Float, green: Float, blue: Float, alpha: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    var size: Int {
        var result = 0
        result += (MemoryLayout<Float>.size * 12)
        return result
    }
    
    var data: [Float] {
        var result = [Float]()
        result.reserveCapacity(size)
        result.append(red)
        result.append(green)
        result.append(blue)
        result.append(alpha)
        
        result.append(lightRed)
        result.append(lightGreen)
        result.append(lightBlue)
        
        result.append(lightAmbientIntensity)
        result.append(lightDiffuseIntensity)
        
        result.append(lightDirX)
        result.append(lightDirY)
        result.append(lightDirZ)
        
        return result
    }
}

struct UniformsSpriteNodeIndexedPhongFragment: UniformsFragment {
    
    var red: Float
    var green: Float
    var blue: Float
    var alpha: Float
    
    var lightRed: Float
    var lightGreen: Float
    var lightBlue: Float
    
    var lightAmbientIntensity: Float
    var lightDiffuseIntensity: Float
    var lightSpecularIntensity: Float
    
    var lightDirX: Float
    var lightDirY: Float
    var lightDirZ: Float
    
    var lightShininess: Float

    init() {
        red = 1.0
        green = 1.0
        blue = 1.0
        alpha = 1.0
        
        lightRed = 1.0
        lightGreen = 1.0
        lightBlue = 1.0
        
        lightAmbientIntensity = 0.0
        lightDiffuseIntensity = 0.25
        lightSpecularIntensity = 0.75
        
        lightDirX = 0.0
        lightDirY = 0.0
        lightDirZ = -1.0
        
        lightShininess = 8.0
    }
    
    mutating func set(red: Float, green: Float, blue: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = 1.0
    }
    
    mutating func set(red: Float, green: Float, blue: Float, alpha: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    var size: Int {
        var result = 0
        result += (MemoryLayout<Float>.size * 14)
        return result
    }
    
    var data: [Float] {
        var result = [Float]()
        result.reserveCapacity(size)
        result.append(red)
        result.append(green)
        result.append(blue)
        result.append(alpha)
        
        result.append(lightRed)
        result.append(lightGreen)
        result.append(lightBlue)
        
        result.append(lightAmbientIntensity)
        result.append(lightDiffuseIntensity)
        result.append(lightSpecularIntensity)
        
        result.append(lightDirX)
        result.append(lightDirY)
        result.append(lightDirZ)
        
        result.append(lightShininess)
        
        return result
    }
}

struct UniformsSpriteNodeIndexedLightsVertex: UniformsVertex {
    
    var projectionMatrix: matrix_float4x4
    var modelViewMatrix: matrix_float4x4
    var normalMatrix: matrix_float4x4
    init() {
        projectionMatrix = matrix_identity_float4x4
        modelViewMatrix = matrix_identity_float4x4
        normalMatrix = matrix_identity_float4x4
    }
    
    var size: Int {
        var result = 0
        result += (MemoryLayout<matrix_float4x4>.size)
        result += (MemoryLayout<matrix_float4x4>.size)
        result += (MemoryLayout<matrix_float4x4>.size)
        return result
    }
    
    var data: [Float] {
        var result = [Float]()
        result.reserveCapacity(size)
        result.append(contentsOf: projectionMatrix.array())
        result.append(contentsOf: modelViewMatrix.array())
        result.append(contentsOf: normalMatrix.array())
        return result
    }
}
