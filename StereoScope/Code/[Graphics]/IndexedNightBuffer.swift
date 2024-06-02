//
//  IndexedNightBuffer.swift
//  StereoScope
//
//  Created by Nicky Taylor on 6/2/24.
//

import Foundation
import Metal
import simd

class IndexedNightBuffer<NodeType: PositionConforming2D & TextureCoordinateConforming,
                         UniformsVertexType: UniformsVertex,
                         UniformsFragmentType: UniformsFragment>: IndexedBuffer<NodeType, UniformsVertexType, UniformsFragmentType> {
    
    
    private(set) weak var sprite: Sprite?
    private(set) weak var lights: Sprite?
    
    var samplerState = Graphics.SamplerState.linearClamp
    
    func load(graphics: Graphics, sprite: Sprite?, lights: Sprite?) {
        self.sprite = sprite
        self.lights = lights
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
        
        guard let lights = lights else {
            return
        }
        
        guard let textureLight = lights.texture else {
            return
        }
        
        graphics.setFragmentTexture(texture, renderEncoder: renderEncoder)
        graphics.setFragmentLightTexture(textureLight, renderEncoder: renderEncoder)
        
        graphics.set(samplerState: samplerState, renderEncoder: renderEncoder)
    }
}

class IndexedNightBuffer3D: IndexedNightBuffer<Sprite3DVertex, UniformsShapeVertex, UniformsNightFragment> { }
class IndexedNightBuffer3DStereoscopic: IndexedNightBuffer<Sprite3DVertexStereoscopic, UniformsShapeVertex, UniformsNightFragment> { }
