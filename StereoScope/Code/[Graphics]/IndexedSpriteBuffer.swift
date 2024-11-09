//
//  IndexedTriangleBufferSprite3D.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation
import Metal
import simd

class IndexedSpriteBuffer<NodeType: PositionConforming2D & TextureCoordinateConforming,
                          UniformsVertexType: UniformsVertex,
                          UniformsFragmentType: UniformsFragment>: IndexedBuffer<NodeType, UniformsVertexType, UniformsFragmentType> {
    
    
    private(set) weak var sprite: Sprite?
    var samplerState = Graphics.SamplerState.linearClamp
    
    func load(graphics: Graphics, sprite: Sprite?) {
        self.sprite = sprite
        super.load(graphics: graphics)
    }
    
    override func linkRender(renderEncoder: any MTLRenderCommandEncoder, pipelineState: Graphics.PipelineState) {
        
        super.linkRender(renderEncoder: renderEncoder, pipelineState: pipelineState)
        
        guard let graphics = graphics else {
            return
        }
        
        guard let sprite = sprite else {
            return
        }
        
        guard let texture = sprite.texture else {
            return
        }
        
        graphics.setFragmentTexture(texture, renderEncoder: renderEncoder)
        graphics.set(samplerState: samplerState, renderEncoder: renderEncoder)
    }
}

class IndexedSpriteBuffer2D: IndexedSpriteBuffer<Sprite2DVertex, UniformsShapeVertex, UniformsShapeFragment> { }
class IndexedSpriteBuffer2DColored: IndexedSpriteBuffer<Sprite2DColoredVertex, UniformsShapeVertex, UniformsShapeFragment> { }

class IndexedSpriteBuffer3D: IndexedSpriteBuffer<Sprite3DVertex, UniformsShapeVertex, UniformsShapeFragment> { }
class IndexedSpriteBuffer3DColored: IndexedSpriteBuffer<Sprite3DColoredVertex, UniformsShapeVertex, UniformsShapeFragment> { }

class IndexedSpriteBuffer3DStereoscopic: IndexedSpriteBuffer<Sprite3DVertexStereoscopic, UniformsShapeVertex, UniformsShapeFragment> { }
class IndexedSpriteBuffer3DColoredStereoscopic: IndexedSpriteBuffer<Sprite3DVertexColoredStereoscopic, UniformsShapeVertex, UniformsShapeFragment> { }

extension IndexedSpriteBuffer2D {
    
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
        
        var startU = Float(0.0)
        var startV = Float(0.0)
        var endU = Float(1.0)
        var endV = Float(1.0)
        if let sprite = sprite {
            startU = sprite.startU
            startV = sprite.startV
            endU = sprite.endU
            endV = sprite.endV
        }
        
        //
        let index1 = UInt32(vertexCount)
        let index2 = index1 + 1
        let index3 = index2 + 1
        let index4 = index3 + 1
        //
        add(index1: index1, index2: index2, index3: index3)
        add(index1: index3, index2: index2, index3: index4)
        //
        add(vertex: .init(x: _cornerX[0], y: _cornerY[0], u: startU, v: startV))
        add(vertex: .init(x: _cornerX[1], y: _cornerY[1], u: endU, v: startV))
        add(vertex: .init(x: _cornerX[2], y: _cornerY[2], u: startU, v: endV))
        add(vertex: .init(x: _cornerX[3], y: _cornerY[3], u: endU, v: endV))
        //
    }
    
    func add(translation: Math.Point, scale: Float, rotation: Float) {
        var width2 = Float(256.0)
        var height2 = Float(256.0)
        if let sprite = sprite {
            width2 = sprite.width2
            height2 = sprite.height2
        }
        let _width2 = -width2
        let _height2 = -height2
        add(cornerX1: _width2, cornerY1: _height2,
            cornerX2: width2, cornerY2: _height2,
            cornerX3: _width2, cornerY3: height2,
            cornerX4: width2, cornerY4: height2,
            translation: translation, scale: scale, rotation: rotation)
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

extension IndexedSpriteBuffer2DColored {
    
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
    
    func add(cornerX1: Float, cornerY1: Float,
             cornerX2: Float, cornerY2: Float,
             cornerX3: Float, cornerY3: Float,
             cornerX4: Float, cornerY4: Float,
             translation: Math.Point, scale: Float, rotation: Float,
             red: Float, green: Float, blue: Float, alpha: Float) {
        
        transformCorners(cornerX1: cornerX1, cornerY1: cornerY1, cornerX2: cornerX2, cornerY2: cornerY2,
                         cornerX3: cornerX3, cornerY3: cornerY3, cornerX4: cornerX4, cornerY4: cornerY4,
                         translation: translation, scale: scale, rotation: rotation)
        
        var startU = Float(0.0)
        var startV = Float(0.0)
        var endU = Float(1.0)
        var endV = Float(1.0)
        if let sprite = sprite {
            startU = sprite.startU
            startV = sprite.startV
            endU = sprite.endU
            endV = sprite.endV
        }
        
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
                          u: startU, v: startV,
                          r: red, g: green, b: blue, a: alpha))
        add(vertex: .init(x: _cornerX[1], y: _cornerY[1],
                          u: endU, v: startV,
                          r: red, g: green, b: blue, a: alpha))
        add(vertex: .init(x: _cornerX[2], y: _cornerY[2],
                          u: startU, v: endV,
                          r: red, g: green, b: blue, a: alpha))
        add(vertex: .init(x: _cornerX[3], y: _cornerY[3],
                          u: endU, v: endV,
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
        
        var startU = Float(0.0)
        var startV = Float(0.0)
        var endU = Float(1.0)
        var endV = Float(1.0)
        if let sprite = sprite {
            startU = sprite.startU
            startV = sprite.startV
            endU = sprite.endU
            endV = sprite.endV
        }
        
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
                          u: startU, v: startV,
                          r: cornerR1, g: cornerG1, b: cornerB1, a: cornerA1))
        add(vertex: .init(x: _cornerX[1], y: _cornerY[1],
                          u: endU, v: startV,
                          r: cornerR2, g: cornerG2, b: cornerB2, a: cornerA2))
        add(vertex: .init(x: _cornerX[2], y: _cornerY[2],
                          u: startU, v: endV,
                          r: cornerR3, g: cornerG3, b: cornerB3, a: cornerA3))
        add(vertex: .init(x: _cornerX[3], y: _cornerY[3],
                          u: endU, v: endV,
                          r: cornerR4, g: cornerG4, b: cornerB4, a: cornerA4))
    }
    
    func add(translation: Math.Point, scale: Float, rotation: Float,
             red: Float, green: Float, blue: Float, alpha: Float) {
        
        var width2 = Float(256.0)
        var height2 = Float(256.0)
        if let sprite = sprite {
            width2 = sprite.width2
            height2 = sprite.height2
        }
        let _width2 = -width2
        let _height2 = -height2
        add(cornerX1: _width2, cornerY1: _height2,
            cornerX2: width2, cornerY2: _height2,
            cornerX3: _width2, cornerY3: height2,
            cornerX4: width2, cornerY4: height2,
            translation: translation, scale: scale, rotation: rotation,
            red: red, green: green, blue: blue, alpha: alpha)
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

extension IndexedSpriteBuffer3D {
    
    func add(x: Float, y: Float,
             width: Float, height: Float,
             translation: Math.Point, scale: Float, rotation: Float) {
        add(cornerX1: x, cornerY1: y, cornerZ1: 0.0,
            cornerX2: x + width, cornerY2: y, cornerZ2: 0.0,
            cornerX3: x, cornerY3: y + height, cornerZ3: 0.0,
            cornerX4: x + width, cornerY4: y + height, cornerZ4: 0.0,
            translation: translation,
            scale: scale, rotation: rotation)
    }
    
    
    func add(cornerX1: Float, cornerY1: Float, cornerZ1: Float,
             cornerX2: Float, cornerY2: Float, cornerZ2: Float,
             cornerX3: Float, cornerY3: Float, cornerZ3: Float,
             cornerX4: Float, cornerY4: Float, cornerZ4: Float,
             translation: Math.Point, scale: Float, rotation: Float) {
        
        transformCorners(cornerX1: cornerX1, cornerY1: cornerY1, cornerX2: cornerX2, cornerY2: cornerY2,
                         cornerX3: cornerX3, cornerY3: cornerY3, cornerX4: cornerX4, cornerY4: cornerY4,
                         translation: translation, scale: scale, rotation: rotation)
        
        var startU = Float(0.0)
        var startV = Float(0.0)
        var endU = Float(1.0)
        var endV = Float(1.0)
        if let sprite = sprite {
            startU = sprite.startU
            startV = sprite.startV
            endU = sprite.endU
            endV = sprite.endV
        }
        
        //
        let index1 = UInt32(vertexCount)
        let index2 = index1 + 1
        let index3 = index2 + 1
        let index4 = index3 + 1
        //
        add(index1: index1, index2: index2, index3: index3)
        add(index1: index3, index2: index2, index3: index4)
        //
        add(vertex: .init(x: _cornerX[0], y: _cornerY[0], z: cornerZ1, u: startU, v: startV))
        add(vertex: .init(x: _cornerX[1], y: _cornerY[1], z: cornerZ2, u: endU, v: startV))
        add(vertex: .init(x: _cornerX[2], y: _cornerY[2], z: cornerZ3, u: startU, v: endV))
        add(vertex: .init(x: _cornerX[3], y: _cornerY[3], z: cornerZ4, u: endU, v: endV))
        //
    }
    
    func add(translation: Math.Point, scale: Float, rotation: Float) {
        var width2 = Float(256.0)
        var height2 = Float(256.0)
        if let sprite = sprite {
            width2 = sprite.width2
            height2 = sprite.height2
        }
        let _width2 = -width2
        let _height2 = -height2
        add(cornerX1: _width2, cornerY1: _height2, cornerZ1: 0.0,
            cornerX2: width2, cornerY2: _height2, cornerZ2: 0.0,
            cornerX3: _width2, cornerY3: height2, cornerZ3: 0.0,
            cornerX4: width2, cornerY4: height2, cornerZ4: 0.0,
            translation: translation, scale: scale, rotation: rotation)
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
        
        add(cornerX1: lineX2 - dirX, cornerY1: lineY2 - dirY, cornerZ1: 0.0,
            cornerX2: lineX2 + dirX, cornerY2: lineY2 + dirY, cornerZ2: 0.0,
            cornerX3: lineX1 - dirX, cornerY3: lineY1 - dirY, cornerZ3: 0.0,
            cornerX4: lineX1 + dirX, cornerY4: lineY1 + dirY, cornerZ4: 0.0,
            translation: translation, scale: scale, rotation: rotation)
    }
}

extension IndexedSpriteBuffer3DColored {
    
    func add(x: Float, y: Float,
             width: Float, height: Float,
             translation: Math.Point, scale: Float, rotation: Float,
             red: Float, green: Float, blue: Float, alpha: Float) {
        add(cornerX1: x, cornerY1: y, cornerZ1: 0.0,
            cornerX2: x + width, cornerY2: y, cornerZ2: 0.0,
            cornerX3: x, cornerY3: y + height, cornerZ3: 0.0,
            cornerX4: x + width, cornerY4: y + height, cornerZ4: 0.0,
            translation: translation,
            scale: scale, rotation: rotation,
            red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func add(cornerX1: Float, cornerY1: Float, cornerZ1: Float,
             cornerX2: Float, cornerY2: Float, cornerZ2: Float,
             cornerX3: Float, cornerY3: Float, cornerZ3: Float,
             cornerX4: Float, cornerY4: Float, cornerZ4: Float,
             translation: Math.Point, scale: Float, rotation: Float,
             red: Float, green: Float, blue: Float, alpha: Float) {
        
        transformCorners(cornerX1: cornerX1, cornerY1: cornerY1, cornerX2: cornerX2, cornerY2: cornerY2,
                         cornerX3: cornerX3, cornerY3: cornerY3, cornerX4: cornerX4, cornerY4: cornerY4,
                         translation: translation, scale: scale, rotation: rotation)
        
        var startU = Float(0.0)
        var startV = Float(0.0)
        var endU = Float(1.0)
        var endV = Float(1.0)
        if let sprite = sprite {
            startU = sprite.startU
            startV = sprite.startV
            endU = sprite.endU
            endV = sprite.endV
        }
        
        //
        let index1 = UInt32(vertexCount)
        let index2 = index1 + 1
        let index3 = index2 + 1
        let index4 = index3 + 1
        //
        add(index1: index1, index2: index2, index3: index3)
        add(index1: index3, index2: index2, index3: index4)
        //
        add(vertex: .init(x: _cornerX[0], y: _cornerY[0], z: cornerZ1,
                          u: startU, v: startV,
                          r: red, g: green, b: blue, a: alpha))
        add(vertex: .init(x: _cornerX[1], y: _cornerY[1], z: cornerZ2,
                          u: endU, v: startV,
                          r: red, g: green, b: blue, a: alpha))
        add(vertex: .init(x: _cornerX[2], y: _cornerY[2], z: cornerZ3,
                          u: startU, v: endV,
                          r: red, g: green, b: blue, a: alpha))
        add(vertex: .init(x: _cornerX[3], y: _cornerY[3], z: cornerZ4,
                          u: endU, v: endV,
                          r: red, g: green, b: blue, a: alpha))
    }
    
    func add(cornerX1: Float, cornerY1: Float, cornerZ1: Float, cornerR1: Float, cornerG1: Float, cornerB1: Float, cornerA1: Float,
             cornerX2: Float, cornerY2: Float, cornerZ2: Float, cornerR2: Float, cornerG2: Float, cornerB2: Float, cornerA2: Float,
             cornerX3: Float, cornerY3: Float, cornerZ3: Float, cornerR3: Float, cornerG3: Float, cornerB3: Float, cornerA3: Float,
             cornerX4: Float, cornerY4: Float, cornerZ4: Float, cornerR4: Float, cornerG4: Float, cornerB4: Float, cornerA4: Float,
             translation: Math.Point, scale: Float, rotation: Float) {
        
        transformCorners(cornerX1: cornerX1, cornerY1: cornerY1, cornerX2: cornerX2, cornerY2: cornerY2,
                         cornerX3: cornerX3, cornerY3: cornerY3, cornerX4: cornerX4, cornerY4: cornerY4,
                         translation: translation, scale: scale, rotation: rotation)
        
        var startU = Float(0.0)
        var startV = Float(0.0)
        var endU = Float(1.0)
        var endV = Float(1.0)
        if let sprite = sprite {
            startU = sprite.startU
            startV = sprite.startV
            endU = sprite.endU
            endV = sprite.endV
        }
        
        //
        let index1 = UInt32(vertexCount)
        let index2 = index1 + 1
        let index3 = index2 + 1
        let index4 = index3 + 1
        //
        add(index1: index1, index2: index2, index3: index3)
        add(index1: index3, index2: index2, index3: index4)
        //
        add(vertex: .init(x: _cornerX[0], y: _cornerY[0], z: cornerZ1,
                          u: startU, v: startV,
                          r: cornerR1, g: cornerG1, b: cornerB1, a: cornerA1))
        add(vertex: .init(x: _cornerX[1], y: _cornerY[1], z: cornerZ2,
                          u: endU, v: startV,
                          r: cornerR2, g: cornerG2, b: cornerB2, a: cornerA2))
        add(vertex: .init(x: _cornerX[2], y: _cornerY[2], z: cornerZ3,
                          u: startU, v: endV,
                          r: cornerR3, g: cornerG3, b: cornerB3, a: cornerA3))
        add(vertex: .init(x: _cornerX[3], y: _cornerY[3], z: cornerZ4,
                          u: endU, v: endV,
                          r: cornerR4, g: cornerG4, b: cornerB4, a: cornerA4))
    }
    
    func add(translation: Math.Point, scale: Float, rotation: Float,
             red: Float, green: Float, blue: Float, alpha: Float) {
        
        var width2 = Float(256.0)
        var height2 = Float(256.0)
        if let sprite = sprite {
            width2 = sprite.width2
            height2 = sprite.height2
        }
        let _width2 = -width2
        let _height2 = -height2
        add(cornerX1: _width2, cornerY1: _height2, cornerZ1: 0.0,
            cornerX2: width2, cornerY2: _height2, cornerZ2: 0.0,
            cornerX3: _width2, cornerY3: height2, cornerZ3: 0.0,
            cornerX4: width2, cornerY4: height2, cornerZ4: 0.0,
            translation: translation, scale: scale, rotation: rotation,
            red: red, green: green, blue: blue, alpha: alpha)
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
        
        add(cornerX1: lineX2 - dirX, cornerY1: lineY2 - dirY, cornerZ1: 0.0,
            cornerX2: lineX2 + dirX, cornerY2: lineY2 + dirY, cornerZ2: 0.0,
            cornerX3: lineX1 - dirX, cornerY3: lineY1 - dirY, cornerZ3: 0.0,
            cornerX4: lineX1 + dirX, cornerY4: lineY1 + dirY, cornerZ4: 0.0,
            translation: translation, scale: scale, rotation: rotation,
            red: red, green: green, blue: blue, alpha: alpha)
    }
}
