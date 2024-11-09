//
//  IndexedShapeBuffer.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/25/24.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation
import Metal
import simd

class IndexedShapeBuffer<NodeType: PositionConforming2D,
                         UniformsVertexType: UniformsVertex,
                         UniformsFragmentType: UniformsFragment>: IndexedBuffer<NodeType, UniformsVertexType, UniformsFragmentType> {
    
}

class IndexedShapeBuffer2D: IndexedShapeBuffer<Shape2DVertex, UniformsShapeVertex, UniformsShapeFragment> { }
class IndexedShapeBuffer2DColored: IndexedShapeBuffer<Shape2DColoredVertex, UniformsShapeVertex, UniformsShapeFragment> { }

class IndexedShapeBuffer3D: IndexedShapeBuffer<Shape3DVertex, UniformsShapeVertex, UniformsShapeFragment> { }
class IndexedShapeBuffer3DColored: IndexedShapeBuffer<Shape3DColoredVertex, UniformsShapeVertex, UniformsShapeFragment> { }

extension IndexedShapeBuffer2D {
    
    func add(x: Float, y: Float,
             width: Float, height: Float,
             translation: Math.Point, scale: Float, rotation: Float) {
        add(cornerX1: x, cornerY1: y,
            cornerX2: x + width, cornerY2: y,
            cornerX3: x, cornerY3: y + height,
            cornerX4: x + width, cornerY4: y + height,
            translation: translation,
            scale: scale, rotation: rotation)
    }
    
    
    func add(cornerX1: Float, cornerY1: Float,
             cornerX2: Float, cornerY2: Float,
             cornerX3: Float, cornerY3: Float,
             cornerX4: Float, cornerY4: Float,
             translation: Math.Point, scale: Float, rotation: Float) {
        
        transformCorners(cornerX1: cornerX1, cornerY1: cornerY1, cornerX2: cornerX2, cornerY2: cornerY2,
                         cornerX3: cornerX3, cornerY3: cornerY3, cornerX4: cornerX4, cornerY4: cornerY4,
                         translation: translation, scale: scale, rotation: rotation)
        
        let index1 = UInt32(vertexCount)
        let index2 = index1 + 1
        let index3 = index2 + 1
        let index4 = index3 + 1
        //
        add(index1: index1, index2: index2, index3: index3)
        add(index1: index3, index2: index2, index3: index4)
        //
        add(vertex: .init(x: _cornerX[0], y: _cornerY[0]))
        add(vertex: .init(x: _cornerX[1], y: _cornerY[1]))
        add(vertex: .init(x: _cornerX[2], y: _cornerY[2]))
        add(vertex: .init(x: _cornerX[3], y: _cornerY[3]))
        //
    }
    
    func add(lineX1: Float, lineY1: Float,
             lineX2: Float, lineY2: Float,
             lineThickness: Float,
             translation: Math.Point, scale: Float, rotation: Float) {
        
        var dirX = lineX2 - lineX1
        var dirY = lineY2 - lineY1
        var length = dirX * dirX + dirY * dirY
        if length <= Math.epsilon { return }
        
        let thickness = lineThickness * 0.5
        length = sqrtf(length)
        dirX /= length
        dirY /= length
        
        let hold = dirX
        dirX = dirY * (-thickness)
        dirY = hold * thickness
        
        add(cornerX1: lineX2 - dirX, cornerY1: lineY2 - dirY,
            cornerX2: lineX2 + dirX, cornerY2: lineY2 + dirY,
            cornerX3: lineX1 - dirX, cornerY3: lineY1 - dirY,
            cornerX4: lineX1 + dirX, cornerY4: lineY1 + dirY,
            translation: translation, scale: scale, rotation: rotation)
    }
}

extension IndexedShapeBuffer2DColored {
    
    func add(x: Float, y: Float,
             width: Float, height: Float,
             translation: Math.Point, scale: Float, rotation: Float,
             red: Float, green: Float, blue: Float, alpha: Float) {
        add(cornerX1: x, cornerY1: y,
            cornerX2: x + width, cornerY2: y,
            cornerX3: x, cornerY3: y + height,
            cornerX4: x + width, cornerY4: y + height,
            translation: translation,
            scale: scale, rotation: rotation,
            red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func add(x: Float, y: Float,
             width: Float, height: Float,
             red: Float, green: Float, blue: Float, alpha: Float) {
        add(cornerX1: x, cornerY1: y,
            cornerX2: x + width, cornerY2: y,
            cornerX3: x, cornerY3: y + height,
            cornerX4: x + width, cornerY4: y + height,
            translation: .zero,
            scale: 1.0, rotation: 0.0,
            red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func add(cornerX1: Float, cornerY1: Float,
             cornerX2: Float, cornerY2: Float,
             cornerX3: Float, cornerY3: Float,
             cornerX4: Float, cornerY4: Float,
             translation: Math.Point, scale: Float, rotation: Float,
             red: Float, green: Float, blue: Float, alpha: Float) {
        
        transformCorners(cornerX1: cornerX1, cornerY1: cornerY1, cornerX2: cornerX2, cornerY2: cornerY2,
                         cornerX3: cornerX3, cornerY3: cornerY3, cornerX4: cornerX4, cornerY4: cornerY4,
                         translation: translation, scale: scale, rotation: rotation)
        
        //
        let index1 = UInt32(vertexCount)
        let index2 = index1 + 1
        let index3 = index2 + 1
        let index4 = index3 + 1
        //
        add(index1: index1, index2: index2, index3: index3)
        add(index1: index3, index2: index2, index3: index4)
        //
        add(vertex: .init(x: _cornerX[0], y: _cornerY[0],
                          r: red, g: green, b: blue, a: alpha))
        add(vertex: .init(x: _cornerX[1], y: _cornerY[1],
                          r: red, g: green, b: blue, a: alpha))
        add(vertex: .init(x: _cornerX[2], y: _cornerY[2],
                          r: red, g: green, b: blue, a: alpha))
        add(vertex: .init(x: _cornerX[3], y: _cornerY[3],
                          r: red, g: green, b: blue, a: alpha))
    }
    
    func add(cornerX1: Float, cornerY1: Float, cornerR1: Float, cornerG1: Float, cornerB1: Float, cornerA1: Float,
             cornerX2: Float, cornerY2: Float, cornerR2: Float, cornerG2: Float, cornerB2: Float, cornerA2: Float,
             cornerX3: Float, cornerY3: Float, cornerR3: Float, cornerG3: Float, cornerB3: Float, cornerA3: Float,
             cornerX4: Float, cornerY4: Float, cornerR4: Float, cornerG4: Float, cornerB4: Float, cornerA4: Float,
             translation: Math.Point, scale: Float, rotation: Float) {
        
        transformCorners(cornerX1: cornerX1, cornerY1: cornerY1, cornerX2: cornerX2, cornerY2: cornerY2,
                         cornerX3: cornerX3, cornerY3: cornerY3, cornerX4: cornerX4, cornerY4: cornerY4,
                         translation: translation, scale: scale, rotation: rotation)
        
        //
        let index1 = UInt32(vertexCount)
        let index2 = index1 + 1
        let index3 = index2 + 1
        let index4 = index3 + 1
        //
        add(index1: index1, index2: index2, index3: index3)
        add(index1: index3, index2: index2, index3: index4)
        //
        add(vertex: .init(x: _cornerX[0], y: _cornerY[0],
                          r: cornerR1, g: cornerG1, b: cornerB1, a: cornerA1))
        add(vertex: .init(x: _cornerX[1], y: _cornerY[1],
                          r: cornerR2, g: cornerG2, b: cornerB2, a: cornerA2))
        add(vertex: .init(x: _cornerX[2], y: _cornerY[2],
                          r: cornerR3, g: cornerG3, b: cornerB3, a: cornerA3))
        add(vertex: .init(x: _cornerX[3], y: _cornerY[3],
                          r: cornerR4, g: cornerG4, b: cornerB4, a: cornerA4))
    }
    
    func add(lineX1: Float, lineY1: Float,
             lineX2: Float, lineY2: Float,
             lineThickness: Float,
             translation: Math.Point, scale: Float, rotation: Float,
             red: Float, green: Float, blue: Float, alpha: Float) {
        
        var dirX = lineX2 - lineX1
        var dirY = lineY2 - lineY1
        var length = dirX * dirX + dirY * dirY
        if length <= Math.epsilon { return }
        
        let thickness = lineThickness * 0.5
        length = sqrtf(length)
        dirX /= length
        dirY /= length
        
        let hold = dirX
        dirX = dirY * (-thickness)
        dirY = hold * thickness
        
        add(cornerX1: lineX2 - dirX, cornerY1: lineY2 - dirY,
            cornerX2: lineX2 + dirX, cornerY2: lineY2 + dirY,
            cornerX3: lineX1 - dirX, cornerY3: lineY1 - dirY,
            cornerX4: lineX1 + dirX, cornerY4: lineY1 + dirY,
            translation: translation, scale: scale, rotation: rotation,
            red: red, green: green, blue: blue, alpha: alpha)
    }
}


extension IndexedShapeBuffer3D {
    
    func add(x: Float, y: Float,
             width: Float, height: Float,
             translation: Math.Point, scale: Float, rotation: Float) {
        add(cornerX1: x, cornerY1: y,
            cornerX2: x + width, cornerY2: y,
            cornerX3: x, cornerY3: y + height,
            cornerX4: x + width, cornerY4: y + height,
            translation: translation,
            scale: scale, rotation: rotation)
    }
    
    
    func add(cornerX1: Float, cornerY1: Float,
             cornerX2: Float, cornerY2: Float,
             cornerX3: Float, cornerY3: Float,
             cornerX4: Float, cornerY4: Float,
             translation: Math.Point, scale: Float, rotation: Float) {
        
        transformCorners(cornerX1: cornerX1, cornerY1: cornerY1, cornerX2: cornerX2, cornerY2: cornerY2,
                         cornerX3: cornerX3, cornerY3: cornerY3, cornerX4: cornerX4, cornerY4: cornerY4,
                         translation: translation, scale: scale, rotation: rotation)
        
        let index1 = UInt32(vertexCount)
        let index2 = index1 + 1
        let index3 = index2 + 1
        let index4 = index3 + 1
        //
        add(index1: index1, index2: index2, index3: index3)
        add(index1: index3, index2: index2, index3: index4)
        //
        add(vertex: .init(x: _cornerX[0], y: _cornerY[0], z: 0.0))
        add(vertex: .init(x: _cornerX[1], y: _cornerY[1], z: 0.0))
        add(vertex: .init(x: _cornerX[2], y: _cornerY[2], z: 0.0))
        add(vertex: .init(x: _cornerX[3], y: _cornerY[3], z: 0.0))
        //
    }
    
    func add(lineX1: Float, lineY1: Float,
             lineX2: Float, lineY2: Float,
             lineThickness: Float,
             translation: Math.Point, scale: Float, rotation: Float) {
        
        var dirX = lineX2 - lineX1
        var dirY = lineY2 - lineY1
        var length = dirX * dirX + dirY * dirY
        if length <= Math.epsilon { return }
        
        let thickness = lineThickness * 0.5
        length = sqrtf(length)
        dirX /= length
        dirY /= length
        
        let hold = dirX
        dirX = dirY * (-thickness)
        dirY = hold * thickness
        
        add(cornerX1: lineX2 - dirX, cornerY1: lineY2 - dirY,
            cornerX2: lineX2 + dirX, cornerY2: lineY2 + dirY,
            cornerX3: lineX1 - dirX, cornerY3: lineY1 - dirY,
            cornerX4: lineX1 + dirX, cornerY4: lineY1 + dirY,
            translation: translation, scale: scale, rotation: rotation)
    }
}

extension IndexedShapeBuffer3DColored {
    
    func add(x: Float, y: Float,
             width: Float, height: Float,
             translation: Math.Point, scale: Float, rotation: Float,
             red: Float, green: Float, blue: Float, alpha: Float) {
        add(cornerX1: x, cornerY1: y,
            cornerX2: x + width, cornerY2: y,
            cornerX3: x, cornerY3: y + height,
            cornerX4: x + width, cornerY4: y + height,
            translation: translation,
            scale: scale, rotation: rotation,
            red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func add(x: Float, y: Float,
             width: Float, height: Float,
             red: Float, green: Float, blue: Float, alpha: Float) {
        add(cornerX1: x, cornerY1: y,
            cornerX2: x + width, cornerY2: y,
            cornerX3: x, cornerY3: y + height,
            cornerX4: x + width, cornerY4: y + height,
            translation: .zero,
            scale: 1.0, rotation: 0.0,
            red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func add(cornerX1: Float, cornerY1: Float,
             cornerX2: Float, cornerY2: Float,
             cornerX3: Float, cornerY3: Float,
             cornerX4: Float, cornerY4: Float,
             translation: Math.Point, scale: Float, rotation: Float,
             red: Float, green: Float, blue: Float, alpha: Float) {
        
        transformCorners(cornerX1: cornerX1, cornerY1: cornerY1, cornerX2: cornerX2, cornerY2: cornerY2,
                         cornerX3: cornerX3, cornerY3: cornerY3, cornerX4: cornerX4, cornerY4: cornerY4,
                         translation: translation, scale: scale, rotation: rotation)
        
        //
        let index1 = UInt32(vertexCount)
        let index2 = index1 + 1
        let index3 = index2 + 1
        let index4 = index3 + 1
        //
        add(index1: index1, index2: index2, index3: index3)
        add(index1: index3, index2: index2, index3: index4)
        //
        add(vertex: .init(x: _cornerX[0], y: _cornerY[0], z: 0.0,
                          r: red, g: green, b: blue, a: alpha))
        add(vertex: .init(x: _cornerX[1], y: _cornerY[1], z: 0.0,
                          r: red, g: green, b: blue, a: alpha))
        add(vertex: .init(x: _cornerX[2], y: _cornerY[2], z: 0.0,
                          r: red, g: green, b: blue, a: alpha))
        add(vertex: .init(x: _cornerX[3], y: _cornerY[3], z: 0.0,
                          r: red, g: green, b: blue, a: alpha))
    }
    
    func add(cornerX1: Float, cornerY1: Float, cornerR1: Float, cornerG1: Float, cornerB1: Float, cornerA1: Float,
             cornerX2: Float, cornerY2: Float, cornerR2: Float, cornerG2: Float, cornerB2: Float, cornerA2: Float,
             cornerX3: Float, cornerY3: Float, cornerR3: Float, cornerG3: Float, cornerB3: Float, cornerA3: Float,
             cornerX4: Float, cornerY4: Float, cornerR4: Float, cornerG4: Float, cornerB4: Float, cornerA4: Float,
             translation: Math.Point, scale: Float, rotation: Float) {
        
        transformCorners(cornerX1: cornerX1, cornerY1: cornerY1, cornerX2: cornerX2, cornerY2: cornerY2,
                         cornerX3: cornerX3, cornerY3: cornerY3, cornerX4: cornerX4, cornerY4: cornerY4,
                         translation: translation, scale: scale, rotation: rotation)
        
        //
        let index1 = UInt32(vertexCount)
        let index2 = index1 + 1
        let index3 = index2 + 1
        let index4 = index3 + 1
        //
        add(index1: index1, index2: index2, index3: index3)
        add(index1: index3, index2: index2, index3: index4)
        //
        add(vertex: .init(x: _cornerX[0], y: _cornerY[0], z: 0.0,
                          r: cornerR1, g: cornerG1, b: cornerB1, a: cornerA1))
        add(vertex: .init(x: _cornerX[1], y: _cornerY[1], z: 0.0,
                          r: cornerR2, g: cornerG2, b: cornerB2, a: cornerA2))
        add(vertex: .init(x: _cornerX[2], y: _cornerY[2], z: 0.0,
                          r: cornerR3, g: cornerG3, b: cornerB3, a: cornerA3))
        add(vertex: .init(x: _cornerX[3], y: _cornerY[3], z: 0.0,
                          r: cornerR4, g: cornerG4, b: cornerB4, a: cornerA4))
    }
    
    func add(lineX1: Float, lineY1: Float,
             lineX2: Float, lineY2: Float,
             lineThickness: Float,
             translation: Math.Point, scale: Float, rotation: Float,
             red: Float, green: Float, blue: Float, alpha: Float) {
        
        var dirX = lineX2 - lineX1
        var dirY = lineY2 - lineY1
        var length = dirX * dirX + dirY * dirY
        if length <= Math.epsilon { return }
        
        let thickness = lineThickness * 0.5
        length = sqrtf(length)
        dirX /= length
        dirY /= length
        
        let hold = dirX
        dirX = dirY * (-thickness)
        dirY = hold * thickness
        
        add(cornerX1: lineX2 - dirX, cornerY1: lineY2 - dirY,
            cornerX2: lineX2 + dirX, cornerY2: lineY2 + dirY,
            cornerX3: lineX1 - dirX, cornerY3: lineY1 - dirY,
            cornerX4: lineX1 + dirX, cornerY4: lineY1 + dirY,
            translation: translation, scale: scale, rotation: rotation,
            red: red, green: green, blue: blue, alpha: alpha)
    }
}
