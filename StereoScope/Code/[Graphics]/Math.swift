//
//  Math.swift
//  RebuildEarth
//
//  Created by Nicky Taylor on 2/12/23.
//

import Foundation
import simd

struct Math {
    
    static let pi = Float.pi
    static let pi2 = Float.pi * 2.0
    static let pi_2 = Float.pi / 2.0
    
    static let epsilon: Float = 0.00001
    
    static func radians(degrees: Float) -> Float {
        return degrees * Float.pi / 180.0
    }

    static func degrees(radians: Float) -> Float {
        return radians * 180.0 / Float.pi
    }
    
    static func rotateX(float3: simd_float3, radians: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotationX(radians: radians)
        return rotationMatrix.processRotationOnly(point3: float3)
    }

    static func rotateX(float3: simd_float3, degrees: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotationX(degrees: degrees)
        return rotationMatrix.processRotationOnly(point3: float3)
    }
    
    static func rotateY(float3: simd_float3, radians: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotationY(radians: radians)
        return rotationMatrix.processRotationOnly(point3: float3)
    }

    static func rotateY(float3: simd_float3, degrees: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotationY(degrees: degrees)
        return rotationMatrix.processRotationOnly(point3: float3)
    }
    
    static func rotateZ(float3: simd_float3, radians: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotationZ(radians: radians)
        return rotationMatrix.processRotationOnly(point3: float3)
    }

    static func rotateZ(float3: simd_float3, degrees: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotationZ(degrees: degrees)
        return rotationMatrix.processRotationOnly(point3: float3)
    }

}
