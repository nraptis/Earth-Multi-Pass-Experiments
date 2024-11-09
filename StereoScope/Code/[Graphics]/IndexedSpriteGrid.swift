//
//  IndexedSpriteGrid.swift
//  Jiggle3
//
//  Created by Nicky Taylor on 6/3/24.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation

class IndexedSpriteGrid<NodeType: PositionConforming2D & TextureCoordinateConforming,
                        UniformsVertexType: UniformsVertex,
                        UniformsFragmentType: UniformsFragment>: IndexedSpriteBuffer<NodeType, UniformsVertexType, UniformsFragmentType> {
    
    var _x = Float(0.0)
    var _y = Float(0.0)
    var _width = Float(0.0)
    var _height = Float(0.0)
    
    func tile(x: Float, y: Float, width: Float, height: Float,
              spriteWidth: Int,
              spriteHeight: Int,
              vertex: NodeType) {
        
        if _x == x && _y == y && _width == width && _height == height {
            return
        }
        
        reset()
        
        _x = x
        _y = y
        _width = width
        _height = height
        
        guard let sprite = sprite else {
            return
        }
        
        guard spriteWidth > 0 && spriteHeight > 0 else {
            return
        }
        
        var countH = Int(width / Float(spriteWidth)) + 2
        if countH < 1 {
            countH = 1
        }
        var countV = Int(height / Float(spriteHeight)) + 2
        if countV < 1 {
            countV = 1
        }
        
        let startU = sprite.startU
        let startV = sprite.startV
        let endU = sprite.endU
        let endV = sprite.endV
        
        var index = UInt32(0)
        
        var previousLeft = Int(x + 0.5)
        var left = previousLeft + spriteWidth
        for _ in 1..<countH {
            
            var previousTop = Int(y + 0.5)
            var top = previousTop + spriteHeight
            for _ in 1..<countV {
                
                var vertex1 = vertex
                var vertex2 = vertex
                var vertex3 = vertex
                var vertex4 = vertex
                
                vertex1.x = Float(previousLeft)
                vertex1.y = Float(previousTop)
                vertex1.u = startU
                vertex1.v = startV
                
                vertex2.x = Float(left)
                vertex2.y = Float(previousTop)
                vertex2.u = endU
                vertex2.v = startV
                
                vertex3.x = Float(previousLeft)
                vertex3.y = Float(top)
                vertex3.u = startU
                vertex3.v = endV
                
                vertex4.x = Float(left)
                vertex4.y = Float(top)
                vertex4.u = endU
                vertex4.v = endV
                
                index = addTriangleQuad(startingAt: index,
                                        vertex1: vertex1,
                                        vertex2: vertex2,
                                        vertex3: vertex3,
                                        vertex4: vertex4)
                
                previousTop = top
                top += spriteHeight
            }
            
            previousLeft = left
            left += spriteWidth
        }
    }
}

class IndexedSpriteGrid2D: IndexedSpriteGrid<Sprite2DVertex, UniformsShapeVertex, UniformsShapeFragment> { }
class IndexedSpriteGrid3D: IndexedSpriteGrid<Sprite3DVertex, UniformsShapeVertex, UniformsShapeFragment> { }
