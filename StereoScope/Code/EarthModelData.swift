//
//  EarthModelData.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

import Foundation
import simd
import UIKit

class EarthModelData {
    
    static let tileCountV = 48
    static let tileCountH = 96
    
    let points: [[simd_float3]]
    let normals: [[simd_float3]]
    let textureCoords: [[simd_float2]]
    init(width: Float, height: Float) {
        var _points = [[simd_float3]](repeating: [simd_float3](), count: Self.tileCountH + 1)
        var _normals = [[simd_float3]](repeating: [simd_float3](), count: Self.tileCountH + 1)
        
        var _textureCoords = [[simd_float2]](repeating: [simd_float2](), count: Self.tileCountH + 1)
        for x in 0...Self.tileCountH {
            _points[x].reserveCapacity(Self.tileCountV + 1)
            _normals[x].reserveCapacity(Self.tileCountV + 1)
            _textureCoords[x].reserveCapacity(Self.tileCountV + 1)
            for _ in 0...Self.tileCountV {
                _points[x].append(simd_float3(0.0, 0.0, 0.0))
                _normals[x].append(simd_float3(0.0, 0.0, 0.0))
                _textureCoords[x].append(simd_float2(0.0, 0.0))
            }
        }
        
        let radius: Float
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            radius = min(width, height) * (0.5 * 0.75)
        } else {
            radius = min(width, height) * (0.5 * 0.85)
        }
        
        let startRotationH = Float(Float.pi)
        let endRotationH = startRotationH + Float.pi * 2.0
        let startRotationV = Float.pi
        let endRotationV = Float(0.0)
        var indexV = 0
        while indexV <= Self.tileCountV {
            let percentV = (Float(indexV) / Float(Self.tileCountV))
            let _angleV = startRotationV + (endRotationV - startRotationV) * percentV
            var indexH = 0
            while indexH <= Self.tileCountH {
                let percentH = (Float(indexH) / Float(Self.tileCountH))
                let _angleH = startRotationH + (endRotationH - startRotationH) * percentH
                var point = simd_float3(0.0, 1.0, 0.0)
                point = Math.rotateX(float3: point, radians: _angleV)
                point = Math.rotateY(float3: point, radians: _angleH)
                _points[indexH][indexV].x = point.x * radius
                _points[indexH][indexV].y = point.y * radius
                _points[indexH][indexV].z = point.z * radius
                _normals[indexH][indexV].x = point.x
                _normals[indexH][indexV].y = point.y
                _normals[indexH][indexV].z = point.z
                _textureCoords[indexH][indexV].x = percentH
                _textureCoords[indexH][indexV].y = percentV
                indexH += 1
            }
            indexV += 1
        }
        self.points = _points
        self.normals = _normals
        self.textureCoords = _textureCoords
        
    }
}
