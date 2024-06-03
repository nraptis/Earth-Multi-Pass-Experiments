//
//  IndexedSpriteInstance.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/25/24.
//

import Foundation
import Metal
import simd

class IndexedSpriteInstance<NodeType: PositionConforming2D & TextureCoordinateConforming,
                            UniformsVertexType: UniformsVertex,
                            UniformsFragmentType: UniformsFragment>: IndexedInstance<NodeType, UniformsVertexType, UniformsFragmentType> {
    
    weak var sprite: Sprite?
    var samplerState = Graphics.SamplerState.linearClamp
    
    func load(graphics: Graphics, sprite: Sprite?) {
        if let sprite = sprite {
            //
            let startU = sprite.startU
            let startV = sprite.startV
            let endU = sprite.endU
            let endV = sprite.endV
            //
            vertices[0].u = startU
            vertices[0].v = startV
            vertices[1].u = endU
            vertices[1].v = startV
            vertices[2].u = startU
            vertices[2].v = endV
            vertices[3].u = endU
            vertices[3].v = endV
            //
            let width2 = sprite.width2
            let height2 = sprite.height2
            let _width2 = -sprite.width2
            let _height2 = -sprite.height2
            //
            vertices[0].x = _width2
            vertices[0].y = _height2
            vertices[1].x = width2
            vertices[1].y = _height2
            vertices[2].x = _width2
            vertices[2].y = height2
            vertices[3].x = width2
            vertices[3].y = height2
            //
            self.sprite = sprite
        }
        
        /*
        else {
            //
            // This isn't 100% necessary, but let's
            // keep it in-case we're dealing with new types...
            //
            vertices[0].u = 0.0
            vertices[0].v = 0.0
            vertices[1].u = 1.0
            vertices[1].v = 0.0
            vertices[2].u = 0.0
            vertices[2].v = 1.0
            vertices[3].u = 1.0
            vertices[3].v = 1.0
            //
            vertices[0].x = -128.0
            vertices[0].y = -128.0
            vertices[1].x = 128.0
            vertices[1].y = -128.0
            vertices[2].x = -128.0
            vertices[2].y = 128.0
            vertices[3].x = 128.0
            vertices[3].y = 128.0
            //
            self.sprite = nil
        }
        */
        
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

class IndexedSpriteInstance2D: IndexedSpriteInstance<Sprite2DVertex, UniformsShapeVertex, UniformsShapeFragment> {
    init() {
        super.init(node1: .init(x: -128.0, y: -128.0, u: 0.0, v: 0.0),
                   node2: .init(x: 128.0, y: -128.0, u: 1.0, v: 0.0),
                   node3: .init(x: -128.0, y: 128.0, u: 0.0, v: 1.0),
                   node4: .init(x: 128.0, y: 128.0, u: 1.0, v: 1.0))
    }
}
class IndexedSpriteInstance2DColored: IndexedSpriteInstance<Sprite2DColoredVertex, UniformsShapeVertex, UniformsShapeFragment> {
    init() {
        super.init(node1: .init(x: -128.0, y: -128.0, u: 0.0, v: 0.0),
                   node2: .init(x: 128.0, y: -128.0, u: 1.0, v: 0.0),
                   node3: .init(x: -128.0, y: 128.0, u: 0.0, v: 1.0),
                   node4: .init(x: 128.0, y: 128.0, u: 1.0, v: 1.0))
    }
}

class IndexedSpriteInstance3D: IndexedSpriteInstance<Sprite3DVertex, UniformsShapeVertex, UniformsShapeFragment> {
    init() {
        super.init(node1: .init(x: -128.0, y: -128.0, u: 0.0, v: 0.0),
                   node2: .init(x: 128.0, y: -128.0, u: 1.0, v: 0.0),
                   node3: .init(x: -128.0, y: 128.0, u: 0.0, v: 1.0),
                   node4: .init(x: 128.0, y: 128.0, u: 1.0, v: 1.0))
    }
}
class IndexedSpriteInstance3DColored: IndexedSpriteInstance<Sprite3DColoredVertex, UniformsShapeVertex, UniformsShapeFragment> {
    init() {
        super.init(node1: .init(x: -128.0, y: -128.0, u: 0.0, v: 0.0),
                   node2: .init(x: 128.0, y: -128.0, u: 1.0, v: 0.0),
                   node3: .init(x: -128.0, y: 128.0, u: 0.0, v: 1.0),
                   node4: .init(x: 128.0, y: 128.0, u: 1.0, v: 1.0))
    }
}

class IndexedSpriteInstance3DStereoscopic: IndexedSpriteInstance<Sprite3DVertexStereoscopic, UniformsShapeVertex, UniformsShapeFragment> { 
    init() {
        super.init(node1: .init(x: -128.0, y: -128.0, u: 0.0, v: 0.0),
                   node2: .init(x: 128.0, y: -128.0, u: 1.0, v: 0.0),
                   node3: .init(x: -128.0, y: 128.0, u: 0.0, v: 1.0),
                   node4: .init(x: 128.0, y: 128.0, u: 1.0, v: 1.0))
    }
}
class IndexedSpriteInstance3DColoredStereoscopic: IndexedSpriteInstance<Sprite3DVertexColoredStereoscopic, UniformsShapeVertex, UniformsShapeFragment> {
    init() {
        super.init(node1: .init(x: -128.0, y: -128.0, u: 0.0, v: 0.0),
                   node2: .init(x: 128.0, y: -128.0, u: 1.0, v: 0.0),
                   node3: .init(x: -128.0, y: 128.0, u: 0.0, v: 1.0),
                   node4: .init(x: 128.0, y: 128.0, u: 1.0, v: 1.0))
    }
}
