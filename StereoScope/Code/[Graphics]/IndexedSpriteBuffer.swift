//
//  IndexedTriangleBufferSprite3D.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
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
