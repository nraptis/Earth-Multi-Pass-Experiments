//
//  Graphics.swift
//  RebuildEarth
//
//  Created by Nicky Taylor on 2/9/23.
//

import Foundation
import Metal


protocol GraphicsDelegate: AnyObject {
    
    var graphics: Graphics! { get set }
    
    //2nd
    func load()
    
    //3rd
    func loadComplete()
    
    //4th (repeats)
    func update(deltaTime: Float)
    
    //5th (repeats)
    
    func draw3DBloom(renderEncoder: MTLRenderCommandEncoder)
    
    func draw3DStereoscopicLeft(renderEncoder: MTLRenderCommandEncoder)
    func draw3DStereoscopicRight(renderEncoder: MTLRenderCommandEncoder)
    
    func draw3D(renderEncoder: MTLRenderCommandEncoder)
    func draw2D(renderEncoder: MTLRenderCommandEncoder)
}

class Graphics {
    
    unowned var metalView: MetalView!
    unowned var metalDevice: MTLDevice!
    unowned var metalEngine: MetalEngine!
    unowned var metalPipeline: MetalPipeline!
    
    var renderTargetWidth = 0
    var renderTargetHeight = 0
    
    enum PipelineState {
        case invalid
        
        case shape2DNoBlending
        case shape2DAlphaBlending
        case shape2DAdditiveBlending
        case shape2DPremultipliedBlending
        case shape3DNoBlending
        case shape3DAlphaBlending
        case shape3DAdditiveBlending
        case shape3DPremultipliedBlending
        
        case shapeNodeIndexed2DNoBlending
        case shapeNodeIndexed2DAlphaBlending
        case shapeNodeIndexed2DAdditiveBlending
        case shapeNodeIndexed2DPremultipliedBlending
        case shapeNodeIndexed3DNoBlending
        case shapeNodeIndexed3DAlphaBlending
        case shapeNodeIndexed3DAdditiveBlending
        case shapeNodeIndexed3DPremultipliedBlending
        
        case shapeNodeColoredIndexed2DNoBlending
        case shapeNodeColoredIndexed2DAlphaBlending
        case shapeNodeColoredIndexed2DAdditiveBlending
        case shapeNodeColoredIndexed2DPremultipliedBlending
        case shapeNodeColoredIndexed3DNoBlending
        case shapeNodeColoredIndexed3DAlphaBlending
        case shapeNodeColoredIndexed3DAdditiveBlending
        case shapeNodeColoredIndexed3DPremultipliedBlending
        
        case sprite2DNoBlending
        case sprite2DAlphaBlending
        case sprite2DAdditiveBlending
        case sprite2DPremultipliedBlending
        case sprite3DNoBlending
        case sprite3DAlphaBlending
        case sprite3DAdditiveBlending
        case sprite3DPremultipliedBlending
        
        case spriteNodeIndexed2DNoBlending
        case spriteNodeIndexed2DAlphaBlending
        case spriteNodeIndexed2DAdditiveBlending
        case spriteNodeIndexed2DPremultipliedBlending
        case spriteNodeIndexed3DNoBlending
        case spriteNodeIndexed3DAlphaBlending
        case spriteNodeIndexed3DAdditiveBlending
        case spriteNodeIndexed3DPremultipliedBlending
        
        case spriteNodeIndexedDiffuse3DNoBlending
        case spriteNodeIndexedDiffuseColored3DNoBlending
        
        case spriteNodeIndexedPhong3DNoBlending
        case spriteNodeIndexedPhongColored3DNoBlending
        
        case spriteNodeWhiteIndexed2DNoBlending
        case spriteNodeWhiteIndexed2DAlphaBlending
        case spriteNodeWhiteIndexed2DAdditiveBlending
        case spriteNodeWhiteIndexed2DPremultipliedBlending
        case spriteNodeWhiteIndexed3DNoBlending
        case spriteNodeWhiteIndexed3DAlphaBlending
        case spriteNodeWhiteIndexed3DAdditiveBlending
        case spriteNodeWhiteIndexed3DPremultipliedBlending
        
        case spriteNodeColoredIndexed2DNoBlending
        case spriteNodeColoredIndexed2DAlphaBlending
        case spriteNodeColoredIndexed2DAdditiveBlending
        case spriteNodeColoredIndexed2DPremultipliedBlending
        
        case spriteNodeColoredIndexed3DNoBlending
        case spriteNodeColoredIndexed3DAlphaBlending
        case spriteNodeColoredIndexed3DAdditiveBlending
        case spriteNodeColoredIndexed3DPremultipliedBlending
        
        case spriteNodeStereoscopicLeftColoredIndexed3DNoBlending
        case spriteNodeStereoscopicRightColoredIndexed3DNoBlending
        
        case spriteNodeColoredWhiteIndexed2DNoBlending
        case spriteNodeColoredWhiteIndexed2DAlphaBlending
        case spriteNodeColoredWhiteIndexed2DAdditiveBlending
        case spriteNodeColoredWhiteIndexed2DPremultipliedBlending
        case spriteNodeColoredWhiteIndexed3DNoBlending
        case spriteNodeColoredWhiteIndexed3DAlphaBlending
        case spriteNodeColoredWhiteIndexed3DAdditiveBlending
        case spriteNodeColoredWhiteIndexed3DPremultipliedBlending
        
        case gaussianBlurHorizontalIndexedNoBlending
        case gaussianBlurVerticalIndexedNoBlending
    }
    
    enum SamplerState {
        case invalid
        case linearClamp
        case linearRepeat
        case nearestClamp
        case nearestRepeat
    }
    
    enum DepthState {
        case invalid
        case disabled
        case lessThan
        case lessThanEqual
    }
    
    private(set) var width: Float
    private(set) var height: Float
    private(set) var width2: Float
    private(set) var height2: Float
    
    let scaleFactor: Float
    init(width: Float,
         height: Float,
         scaleFactor: Float) {
        
        //self.delegate = delegate
        self.width = width
        self.height = height
        width2 = Float(Int(width * 0.5 + 0.5))
        height2 = Float(Int(height * 0.5 + 0.5))
        self.scaleFactor = scaleFactor
        
        print("[++] Graphics [\(width) x \(height)]")
    }
    
    deinit {
        print("[--] Graphics")
    }
    
    private(set) var pipelineState = PipelineState.invalid
    private(set) var samplerState = SamplerState.invalid
    private(set) var depthState = DepthState.invalid
    
    func buffer<Element>(array: Array<Element>) -> MTLBuffer! {
        let length = MemoryLayout<Element>.size * array.count
        return metalDevice.makeBuffer(bytes: array, length: length)
    }
    
    func write<Element>(buffer: MTLBuffer, array: Array<Element>) {
        let length = MemoryLayout<Element>.size * array.count
        buffer.contents().copyMemory(from: array,
                                     byteCount: length)
    }
    
    func buffer(uniform: Uniforms) -> MTLBuffer! {
        metalDevice.makeBuffer(bytes: uniform.data, length: uniform.size, options: [])
    }
    
    func write(buffer: MTLBuffer, uniform: Uniforms) {
        buffer.contents().copyMemory(from: uniform.data, byteCount: uniform.size)
    }
    
    func set(pipelineState: PipelineState, renderEncoder: MTLRenderCommandEncoder) {
        self.pipelineState = pipelineState
        switch pipelineState {
        case .invalid:
            break
        case .shape2DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShape2DNoBlending)
        case .shape2DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShape2DAlphaBlending)
        case .shape2DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShape2DAdditiveBlending)
        case .shape2DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShape2DPremultipliedBlending)
            
        case .shape3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShape3DNoBlending)
        case .shape3DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShape3DAlphaBlending)
        case .shape3DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShape3DAdditiveBlending)
        case .shape3DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShape3DPremultipliedBlending)
            
        case .shapeNodeIndexed2DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeIndexed2DNoBlending)
        case .shapeNodeIndexed2DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeIndexed2DAlphaBlending)
        case .shapeNodeIndexed2DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeIndexed2DAdditiveBlending)
        case .shapeNodeIndexed2DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeIndexed2DPremultipliedBlending)
            
        case .shapeNodeIndexed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeIndexed3DNoBlending)
        case .shapeNodeIndexed3DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeIndexed3DAlphaBlending)
        case .shapeNodeIndexed3DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeIndexed3DAdditiveBlending)
        case .shapeNodeIndexed3DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeIndexed3DPremultipliedBlending)
            
        case .shapeNodeColoredIndexed2DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeColoredIndexed2DNoBlending)
        case .shapeNodeColoredIndexed2DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeColoredIndexed2DAlphaBlending)
        case .shapeNodeColoredIndexed2DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeColoredIndexed2DAdditiveBlending)
        case .shapeNodeColoredIndexed2DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeColoredIndexed2DPremultipliedBlending)
            
        case .shapeNodeColoredIndexed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeColoredIndexed3DNoBlending)
        case .shapeNodeColoredIndexed3DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeColoredIndexed3DAlphaBlending)
        case .shapeNodeColoredIndexed3DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeColoredIndexed3DAdditiveBlending)
        case .shapeNodeColoredIndexed3DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeColoredIndexed3DPremultipliedBlending)
            
        case .sprite2DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNoBlending)
        case .sprite2DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteAlphaBlending)
        case .sprite2DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteAdditiveBlending)
        case .sprite2DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpritePremultipliedBlending)
            
        case .sprite3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSprite3DNoBlending)
        case .sprite3DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSprite3DAlphaBlending)
        case .sprite3DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSprite3DAdditiveBlending)
        case .sprite3DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSprite3DPremultipliedBlending)
            
            
        case .spriteNodeIndexed2DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexed2DNoBlending)
        case .spriteNodeIndexed2DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexed2DAlphaBlending)
        case .spriteNodeIndexed2DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexed2DAdditiveBlending)
        case .spriteNodeIndexed2DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexed2DPremultipliedBlending)
        case .spriteNodeIndexed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexed3DNoBlending)
        case .spriteNodeIndexed3DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexed3DAlphaBlending)
        case .spriteNodeIndexed3DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexed3DAdditiveBlending)
        case .spriteNodeIndexed3DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexed3DPremultipliedBlending)
            
            
            
        case .spriteNodeWhiteIndexed2DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeWhiteIndexed2DNoBlending)
        case .spriteNodeWhiteIndexed2DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeWhiteIndexed2DAlphaBlending)
        case .spriteNodeWhiteIndexed2DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeWhiteIndexed2DAdditiveBlending)
        case .spriteNodeWhiteIndexed2DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeWhiteIndexed2DPremultipliedBlending)
        case .spriteNodeWhiteIndexed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeWhiteIndexed3DNoBlending)
        case .spriteNodeWhiteIndexed3DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeWhiteIndexed3DAlphaBlending)
        case .spriteNodeWhiteIndexed3DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeWhiteIndexed3DAdditiveBlending)
        case .spriteNodeWhiteIndexed3DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeWhiteIndexed3DPremultipliedBlending)
            
            
            
        case .spriteNodeColoredIndexed2DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredIndexed2DNoBlending)
        case .spriteNodeColoredIndexed2DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredIndexed2DAlphaBlending)
        case .spriteNodeColoredIndexed2DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredIndexed2DAdditiveBlending)
        case .spriteNodeColoredIndexed2DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredIndexed2DPremultipliedBlending)
       
        case .spriteNodeIndexedDiffuse3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedDiffuse3DNoBlending)
            
        case .spriteNodeIndexedDiffuseColored3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedDiffuseColored3DNoBlending)
            
        case .spriteNodeIndexedPhong3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedPhong3DNoBlending)
            
        case .spriteNodeIndexedPhongColored3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedPhongColored3DNoBlending)
        
            
       
        case .spriteNodeColoredWhiteIndexed2DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed2DNoBlending)
        case .spriteNodeColoredWhiteIndexed2DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed2DAlphaBlending)
        case .spriteNodeColoredWhiteIndexed2DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed2DAdditiveBlending)
        case .spriteNodeColoredWhiteIndexed2DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed2DPremultipliedBlending)
            
            
        case .spriteNodeColoredIndexed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredIndexed3DNoBlending)
        case .spriteNodeColoredIndexed3DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredIndexed3DAlphaBlending)
        case .spriteNodeColoredIndexed3DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredIndexed3DAdditiveBlending)
        case .spriteNodeColoredIndexed3DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredIndexed3DPremultipliedBlending)
            
            
            
        case .spriteNodeStereoscopicLeftColoredIndexed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicLeftColoredIndexed3DNoBlending)
        
        case .spriteNodeStereoscopicRightColoredIndexed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicRightColoredIndexed3DNoBlending)
            
        case .spriteNodeColoredWhiteIndexed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed3DNoBlending)
        case .spriteNodeColoredWhiteIndexed3DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed3DAlphaBlending)
        case .spriteNodeColoredWhiteIndexed3DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed3DAdditiveBlending)
        case .spriteNodeColoredWhiteIndexed3DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed3DPremultipliedBlending)
            
        case .gaussianBlurHorizontalIndexedNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateGaussianBlurHorizontalIndexedNoBlending)
        case .gaussianBlurVerticalIndexedNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateGaussianBlurVerticalIndexedNoBlending)
        }
    }
    
    func set(depthState: DepthState, renderEncoder: MTLRenderCommandEncoder) {
        self.depthState = depthState
        switch depthState {
        case .invalid:
            break
        case .disabled:
            renderEncoder.setDepthStencilState(metalEngine.depthStateDisabled)
        case .lessThan:
            renderEncoder.setDepthStencilState(metalEngine.depthStateLessThan)
        case .lessThanEqual:
            renderEncoder.setDepthStencilState(metalEngine.depthStateLessThanEqual)
        }
    }
    
    func set(samplerState: SamplerState, renderEncoder: MTLRenderCommandEncoder) {
        
        self.samplerState = samplerState
        
        var metalSamplerState: MTLSamplerState!
        switch samplerState {
        case .linearClamp:
            metalSamplerState = metalEngine.samplerStateLinearClamp
        case .linearRepeat:
            metalSamplerState = metalEngine.samplerStateLinearRepeat
        case .nearestClamp:
            metalSamplerState = metalEngine.samplerStateNearestClamp
        case .nearestRepeat:
            metalSamplerState = metalEngine.samplerStateNearestRepeat
        default:
            break
        }
        
        switch pipelineState {
        case .sprite2DNoBlending,
                .sprite2DAlphaBlending,
                .sprite2DAdditiveBlending,
                .sprite2DPremultipliedBlending,
                .sprite3DNoBlending,
                .sprite3DAlphaBlending,
                .sprite3DAdditiveBlending,
                .sprite3DPremultipliedBlending:
            renderEncoder.setFragmentSamplerState(metalSamplerState, index: MetalPipeline.spriteFragmentIndexSampler)
        case .spriteNodeIndexed2DNoBlending,
                .spriteNodeIndexed2DAlphaBlending,
                .spriteNodeIndexed2DAdditiveBlending,
                .spriteNodeIndexed2DPremultipliedBlending,
            
                .spriteNodeWhiteIndexed2DNoBlending,
                .spriteNodeWhiteIndexed2DAlphaBlending,
                .spriteNodeWhiteIndexed2DAdditiveBlending,
                .spriteNodeWhiteIndexed2DPremultipliedBlending,
            
                .spriteNodeColoredIndexed2DNoBlending,
                .spriteNodeColoredIndexed2DAlphaBlending,
                .spriteNodeColoredIndexed2DAdditiveBlending,
                .spriteNodeColoredIndexed2DPremultipliedBlending,
                .spriteNodeColoredWhiteIndexed2DNoBlending,
                .spriteNodeColoredWhiteIndexed2DAlphaBlending,
                .spriteNodeColoredWhiteIndexed2DAdditiveBlending,
                .spriteNodeColoredWhiteIndexed2DPremultipliedBlending,
            
                .spriteNodeIndexed3DNoBlending,
                .spriteNodeIndexed3DAlphaBlending,
                .spriteNodeIndexed3DAdditiveBlending,
                .spriteNodeIndexed3DPremultipliedBlending,
            
                .spriteNodeIndexedDiffuse3DNoBlending,
                .spriteNodeIndexedDiffuseColored3DNoBlending,
            
                .spriteNodeIndexedPhong3DNoBlending,
                .spriteNodeIndexedPhongColored3DNoBlending,
            
                .spriteNodeWhiteIndexed3DNoBlending,
                .spriteNodeWhiteIndexed3DAlphaBlending,
                .spriteNodeWhiteIndexed3DAdditiveBlending,
                .spriteNodeWhiteIndexed3DPremultipliedBlending,
            
                .spriteNodeColoredIndexed3DNoBlending,
                .spriteNodeColoredIndexed3DAlphaBlending,
                .spriteNodeColoredIndexed3DAdditiveBlending,
                .spriteNodeColoredIndexed3DPremultipliedBlending,
            
                .spriteNodeStereoscopicLeftColoredIndexed3DNoBlending,
            
                .spriteNodeStereoscopicRightColoredIndexed3DNoBlending,
            
                .spriteNodeColoredWhiteIndexed3DNoBlending,
                .spriteNodeColoredWhiteIndexed3DAlphaBlending,
                .spriteNodeColoredWhiteIndexed3DAdditiveBlending,
                .spriteNodeColoredWhiteIndexed3DPremultipliedBlending,
            
                .gaussianBlurHorizontalIndexedNoBlending,
                .gaussianBlurVerticalIndexedNoBlending:
            renderEncoder.setFragmentSamplerState(metalSamplerState, index: MetalPipeline.spriteNodeIndexedFragmentIndexSampler)
        default:
            break
        }
    }
    
    func setVertexUniformsBuffer(_ uniformsBuffer: MTLBuffer?, renderEncoder: MTLRenderCommandEncoder) {
        if let uniformsBuffer = uniformsBuffer {
            switch pipelineState {
            case .shape2DNoBlending,
                    .shape2DAlphaBlending,
                    .shape2DAdditiveBlending,
                    .shape2DPremultipliedBlending,
                    .shape3DNoBlending,
                    .shape3DAlphaBlending,
                    .shape3DAdditiveBlending,
                    .shape3DPremultipliedBlending:
                renderEncoder.setVertexBuffer(uniformsBuffer, offset: 0, index: MetalPipeline.shapeVertexIndexUniforms)
                
            case .shapeNodeIndexed2DNoBlending,
                    .shapeNodeIndexed2DAlphaBlending,
                    .shapeNodeIndexed2DAdditiveBlending,
                    .shapeNodeIndexed2DPremultipliedBlending,
                    .shapeNodeColoredIndexed2DNoBlending,
                    .shapeNodeColoredIndexed2DAlphaBlending,
                    .shapeNodeColoredIndexed2DAdditiveBlending,
                    .shapeNodeColoredIndexed2DPremultipliedBlending,
                    .shapeNodeIndexed3DNoBlending,
                    .shapeNodeIndexed3DAlphaBlending,
                    .shapeNodeIndexed3DAdditiveBlending,
                    .shapeNodeIndexed3DPremultipliedBlending,
                    .shapeNodeColoredIndexed3DNoBlending,
                    .shapeNodeColoredIndexed3DAlphaBlending,
                    .shapeNodeColoredIndexed3DAdditiveBlending,
                    .shapeNodeColoredIndexed3DPremultipliedBlending:
                
                renderEncoder.setVertexBuffer(uniformsBuffer, offset: 0, index: MetalPipeline.shapeNodeIndexedVertexIndexUniforms)
                
            case .sprite2DNoBlending,
                    .sprite2DAlphaBlending,
                    .sprite2DAdditiveBlending,
                    .sprite2DPremultipliedBlending,
                    .sprite3DNoBlending,
                    .sprite3DAlphaBlending,
                    .sprite3DAdditiveBlending,
                    .sprite3DPremultipliedBlending:
                renderEncoder.setVertexBuffer(uniformsBuffer, offset: 0, index: MetalPipeline.spriteVertexIndexUniforms)
                
            case .spriteNodeIndexed2DNoBlending,
                    .spriteNodeIndexed2DAlphaBlending,
                    .spriteNodeIndexed2DAdditiveBlending,
                    .spriteNodeIndexed2DPremultipliedBlending,
                
                    .spriteNodeWhiteIndexed2DNoBlending,
                    .spriteNodeWhiteIndexed2DAlphaBlending,
                    .spriteNodeWhiteIndexed2DAdditiveBlending,
                    .spriteNodeWhiteIndexed2DPremultipliedBlending,
                
                
                    .spriteNodeColoredIndexed2DNoBlending,
                    .spriteNodeColoredIndexed2DAlphaBlending,
                    .spriteNodeColoredIndexed2DAdditiveBlending,
                    .spriteNodeColoredIndexed2DPremultipliedBlending,
                
                    .spriteNodeColoredWhiteIndexed2DNoBlending,
                    .spriteNodeColoredWhiteIndexed2DAlphaBlending,
                    .spriteNodeColoredWhiteIndexed2DAdditiveBlending,
                    .spriteNodeColoredWhiteIndexed2DPremultipliedBlending,
                
                
                    .spriteNodeIndexed3DNoBlending,
                    .spriteNodeIndexed3DAlphaBlending,
                    .spriteNodeIndexed3DAdditiveBlending,
                    .spriteNodeIndexed3DPremultipliedBlending,
                
                    .spriteNodeIndexedDiffuse3DNoBlending,
                    .spriteNodeIndexedDiffuseColored3DNoBlending,
                
                    .spriteNodeIndexedPhong3DNoBlending,
                    .spriteNodeIndexedPhongColored3DNoBlending,
                
                    .spriteNodeWhiteIndexed3DNoBlending,
                    .spriteNodeWhiteIndexed3DAlphaBlending,
                    .spriteNodeWhiteIndexed3DAdditiveBlending,
                    .spriteNodeWhiteIndexed3DPremultipliedBlending,
                
                    .spriteNodeColoredIndexed3DNoBlending,
                    .spriteNodeColoredIndexed3DAlphaBlending,
                    .spriteNodeColoredIndexed3DAdditiveBlending,
                    .spriteNodeColoredIndexed3DPremultipliedBlending,
                
                    .spriteNodeStereoscopicLeftColoredIndexed3DNoBlending,
                
                    .spriteNodeStereoscopicRightColoredIndexed3DNoBlending,
                
                    .spriteNodeColoredWhiteIndexed3DNoBlending,
                    .spriteNodeColoredWhiteIndexed3DAlphaBlending,
                    .spriteNodeColoredWhiteIndexed3DAdditiveBlending,
                    .spriteNodeColoredWhiteIndexed3DPremultipliedBlending,
                
                    .gaussianBlurHorizontalIndexedNoBlending,
                    .gaussianBlurVerticalIndexedNoBlending:
                
                renderEncoder.setVertexBuffer(uniformsBuffer, offset: 0, index: MetalPipeline.spriteNodeIndexedVertexIndexUniforms)
                
            default:
                break
            }
        }
    }
    
    func setFragmentUniformsBuffer(_ uniformsBuffer: MTLBuffer?, renderEncoder: MTLRenderCommandEncoder) {
        if let uniformsBuffer = uniformsBuffer {
            switch pipelineState {
            case .shape2DNoBlending,
                    .shape2DAlphaBlending,
                    .shape2DAdditiveBlending,
                    .shape2DPremultipliedBlending,
                    .shape3DNoBlending,
                    .shape3DAlphaBlending,
                    .shape3DAdditiveBlending,
                    .shape3DPremultipliedBlending:
                renderEncoder.setFragmentBuffer(uniformsBuffer, offset: 0, index: MetalPipeline.shapeFragmentIndexUniforms)
                
            case .shapeNodeIndexed2DNoBlending,
                    .shapeNodeIndexed2DAlphaBlending,
                    .shapeNodeIndexed2DAdditiveBlending,
                    .shapeNodeIndexed2DPremultipliedBlending,
                    .shapeNodeColoredIndexed2DNoBlending,
                    .shapeNodeColoredIndexed2DAlphaBlending,
                    .shapeNodeColoredIndexed2DAdditiveBlending,
                    .shapeNodeColoredIndexed2DPremultipliedBlending,
                    .shapeNodeIndexed3DNoBlending,
                    .shapeNodeIndexed3DAlphaBlending,
                    .shapeNodeIndexed3DAdditiveBlending,
                    .shapeNodeIndexed3DPremultipliedBlending,
                    .shapeNodeColoredIndexed3DNoBlending,
                    .shapeNodeColoredIndexed3DAlphaBlending,
                    .shapeNodeColoredIndexed3DAdditiveBlending,
                    .shapeNodeColoredIndexed3DPremultipliedBlending:
                renderEncoder.setFragmentBuffer(uniformsBuffer, offset: 0, index: MetalPipeline.shapeNodeIndexedFragmentIndexUniforms)
                
            case .sprite2DNoBlending,
                    .sprite2DAlphaBlending,
                    .sprite2DAdditiveBlending,
                    .sprite2DPremultipliedBlending,
                    .sprite3DNoBlending,
                    .sprite3DAlphaBlending,
                    .sprite3DAdditiveBlending,
                    .sprite3DPremultipliedBlending:
                renderEncoder.setFragmentBuffer(uniformsBuffer, offset: 0, index: MetalPipeline.spriteFragmentIndexUniforms)
                
            case .spriteNodeIndexed2DNoBlending,
                    .spriteNodeIndexed2DAlphaBlending,
                    .spriteNodeIndexed2DAdditiveBlending,
                    .spriteNodeIndexed2DPremultipliedBlending,
                
                    .spriteNodeWhiteIndexed2DNoBlending,
                    .spriteNodeWhiteIndexed2DAlphaBlending,
                    .spriteNodeWhiteIndexed2DAdditiveBlending,
                    .spriteNodeWhiteIndexed2DPremultipliedBlending,
                
                    .spriteNodeColoredIndexed2DNoBlending,
                    .spriteNodeColoredIndexed2DAlphaBlending,
                    .spriteNodeColoredIndexed2DAdditiveBlending,
                    .spriteNodeColoredIndexed2DPremultipliedBlending,
                
                    .spriteNodeColoredWhiteIndexed2DNoBlending,
                    .spriteNodeColoredWhiteIndexed2DAlphaBlending,
                    .spriteNodeColoredWhiteIndexed2DAdditiveBlending,
                    .spriteNodeColoredWhiteIndexed2DPremultipliedBlending,
                
                    .spriteNodeIndexed3DNoBlending,
                    .spriteNodeIndexed3DAlphaBlending,
                    .spriteNodeIndexed3DAdditiveBlending,
                    .spriteNodeIndexed3DPremultipliedBlending,
                
                    .spriteNodeIndexedDiffuse3DNoBlending,
                    .spriteNodeIndexedDiffuseColored3DNoBlending,
                
                    .spriteNodeIndexedPhong3DNoBlending,
                    .spriteNodeIndexedPhongColored3DNoBlending,
                
                    .spriteNodeWhiteIndexed3DNoBlending,
                    .spriteNodeWhiteIndexed3DAlphaBlending,
                    .spriteNodeWhiteIndexed3DAdditiveBlending,
                    .spriteNodeWhiteIndexed3DPremultipliedBlending,
                
                    .spriteNodeColoredIndexed3DNoBlending,
                    .spriteNodeColoredIndexed3DAlphaBlending,
                    .spriteNodeColoredIndexed3DAdditiveBlending,
                    .spriteNodeColoredIndexed3DPremultipliedBlending,
                
                    .spriteNodeStereoscopicLeftColoredIndexed3DNoBlending,
                    .spriteNodeStereoscopicRightColoredIndexed3DNoBlending,
                
                    .spriteNodeColoredWhiteIndexed3DNoBlending,
                    .spriteNodeColoredWhiteIndexed3DAlphaBlending,
                    .spriteNodeColoredWhiteIndexed3DAdditiveBlending,
                    .spriteNodeColoredWhiteIndexed3DPremultipliedBlending,
                
                    .gaussianBlurHorizontalIndexedNoBlending,
                    .gaussianBlurVerticalIndexedNoBlending:
                
                renderEncoder.setFragmentBuffer(uniformsBuffer, offset: 0, index: MetalPipeline.spriteNodeIndexedFragmentIndexUniforms)
                
            default:
                break
            }
        }
    }
    
    func setVertexDataBuffer(_ dataBuffer: MTLBuffer?, renderEncoder: MTLRenderCommandEncoder) {
        if let dataBuffer = dataBuffer {
            switch pipelineState {
            case .shapeNodeIndexed2DNoBlending,
                    .shapeNodeIndexed2DAlphaBlending,
                    .shapeNodeIndexed2DAdditiveBlending,
                    .shapeNodeIndexed2DPremultipliedBlending,
                    .shapeNodeColoredIndexed2DNoBlending,
                    .shapeNodeColoredIndexed2DAlphaBlending,
                    .shapeNodeColoredIndexed2DAdditiveBlending,
                    .shapeNodeColoredIndexed2DPremultipliedBlending,
                    .shapeNodeIndexed3DNoBlending,
                    .shapeNodeIndexed3DAlphaBlending,
                    .shapeNodeIndexed3DAdditiveBlending,
                    .shapeNodeIndexed3DPremultipliedBlending,
                    .shapeNodeColoredIndexed3DNoBlending,
                    .shapeNodeColoredIndexed3DAlphaBlending,
                    .shapeNodeColoredIndexed3DAdditiveBlending,
                    .shapeNodeColoredIndexed3DPremultipliedBlending:
                renderEncoder.setVertexBuffer(dataBuffer, offset: 0, index: MetalPipeline.shapeNodeIndexedVertexIndexData)
                
            case .spriteNodeIndexed2DNoBlending,
                    .spriteNodeIndexed2DAlphaBlending,
                    .spriteNodeIndexed2DAdditiveBlending,
                    .spriteNodeIndexed2DPremultipliedBlending,
                
                    .spriteNodeWhiteIndexed2DNoBlending,
                    .spriteNodeWhiteIndexed2DAlphaBlending,
                    .spriteNodeWhiteIndexed2DAdditiveBlending,
                    .spriteNodeWhiteIndexed2DPremultipliedBlending,
                
                
                    .spriteNodeColoredIndexed2DNoBlending,
                    .spriteNodeColoredIndexed2DAlphaBlending,
                    .spriteNodeColoredIndexed2DAdditiveBlending,
                    .spriteNodeColoredIndexed2DPremultipliedBlending,
                
                    .spriteNodeColoredWhiteIndexed2DNoBlending,
                    .spriteNodeColoredWhiteIndexed2DAlphaBlending,
                    .spriteNodeColoredWhiteIndexed2DAdditiveBlending,
                    .spriteNodeColoredWhiteIndexed2DPremultipliedBlending,
                
                
                    .spriteNodeIndexed3DNoBlending,
                    .spriteNodeIndexed3DAlphaBlending,
                    .spriteNodeIndexed3DAdditiveBlending,
                    .spriteNodeIndexed3DPremultipliedBlending,
                
                    .spriteNodeIndexedDiffuse3DNoBlending,
                    .spriteNodeIndexedDiffuseColored3DNoBlending,
                
                    .spriteNodeIndexedPhong3DNoBlending,
                    .spriteNodeIndexedPhongColored3DNoBlending,
                
                    .spriteNodeWhiteIndexed3DNoBlending,
                    .spriteNodeWhiteIndexed3DAlphaBlending,
                    .spriteNodeWhiteIndexed3DAdditiveBlending,
                    .spriteNodeWhiteIndexed3DPremultipliedBlending,
                
                    .spriteNodeColoredIndexed3DNoBlending,
                    .spriteNodeColoredIndexed3DAlphaBlending,
                    .spriteNodeColoredIndexed3DAdditiveBlending,
                    .spriteNodeColoredIndexed3DPremultipliedBlending,
                
                    .spriteNodeStereoscopicLeftColoredIndexed3DNoBlending,
                
                    .spriteNodeStereoscopicRightColoredIndexed3DNoBlending,
                
                    .spriteNodeColoredWhiteIndexed3DNoBlending,
                    .spriteNodeColoredWhiteIndexed3DAlphaBlending,
                    .spriteNodeColoredWhiteIndexed3DAdditiveBlending,
                    .spriteNodeColoredWhiteIndexed3DPremultipliedBlending,
                
                    .gaussianBlurHorizontalIndexedNoBlending,
                    .gaussianBlurVerticalIndexedNoBlending:
                
                renderEncoder.setVertexBuffer(dataBuffer, offset: 0, index: MetalPipeline.spriteNodeIndexedVertexIndexData)
                
            default:
                break
            }
        }
    }
    
    func setVertexPositionsBuffer(_ positionsBuffer: MTLBuffer?, renderEncoder: MTLRenderCommandEncoder) {
        if let positionsBuffer = positionsBuffer {
            switch pipelineState {
            case .shape2DNoBlending,
                    .shape2DAlphaBlending,
                    .shape2DAdditiveBlending,
                    .shape2DPremultipliedBlending,
                    .shape3DNoBlending,
                    .shape3DAlphaBlending,
                    .shape3DAdditiveBlending,
                    .shape3DPremultipliedBlending:
                renderEncoder.setVertexBuffer(positionsBuffer, offset: 0, index: MetalPipeline.shapeVertexIndexPosition)
            case .sprite2DNoBlending,
                    .sprite2DAlphaBlending,
                    .sprite2DAdditiveBlending,
                    .sprite2DPremultipliedBlending,
                    .sprite3DNoBlending,
                    .sprite3DAlphaBlending,
                    .sprite3DAdditiveBlending,
                    .sprite3DPremultipliedBlending:
                renderEncoder.setVertexBuffer(positionsBuffer, offset: 0, index: MetalPipeline.spriteVertexIndexPosition)
            default:
                break
            }
        }
    }
    
    func setVertexTextureCoordsBuffer(_ textureCoordsBuffer: MTLBuffer?, renderEncoder: MTLRenderCommandEncoder) {
        if let textureCoordsBuffer = textureCoordsBuffer {
            switch pipelineState {
            case .sprite2DNoBlending,
                    .sprite2DAlphaBlending,
                    .sprite2DAdditiveBlending,
                    .sprite2DPremultipliedBlending,
                    .sprite3DNoBlending,
                    .sprite3DAlphaBlending,
                    .sprite3DAdditiveBlending,
                    .sprite3DPremultipliedBlending:
                renderEncoder.setVertexBuffer(textureCoordsBuffer, offset: 0, index: MetalPipeline.spriteVertexIndexTextureCoord)
            default:
                break
            }
        }
    }
    
    func setFragmentTexture(_ texture: MTLTexture?, renderEncoder: MTLRenderCommandEncoder) {
        if let texture = texture {
            switch pipelineState {
            case .sprite2DNoBlending,
                    .sprite2DAlphaBlending,
                    .sprite2DAdditiveBlending,
                    .sprite2DPremultipliedBlending,
                    .sprite3DNoBlending,
                    .sprite3DAlphaBlending,
                    .sprite3DAdditiveBlending,
                    .sprite3DPremultipliedBlending:
                renderEncoder.setFragmentTexture(texture, index: MetalPipeline.spriteFragmentIndexTexture)
            case .spriteNodeIndexed2DNoBlending,
                    .spriteNodeIndexed2DAlphaBlending,
                    .spriteNodeIndexed2DAdditiveBlending,
                    .spriteNodeIndexed2DPremultipliedBlending,
                
                    .spriteNodeWhiteIndexed2DNoBlending,
                    .spriteNodeWhiteIndexed2DAlphaBlending,
                    .spriteNodeWhiteIndexed2DAdditiveBlending,
                    .spriteNodeWhiteIndexed2DPremultipliedBlending,
                
                
                    .spriteNodeColoredIndexed2DNoBlending,
                    .spriteNodeColoredIndexed2DAlphaBlending,
                    .spriteNodeColoredIndexed2DAdditiveBlending,
                    .spriteNodeColoredIndexed2DPremultipliedBlending,
                
                    .spriteNodeColoredWhiteIndexed2DNoBlending,
                    .spriteNodeColoredWhiteIndexed2DAlphaBlending,
                    .spriteNodeColoredWhiteIndexed2DAdditiveBlending,
                    .spriteNodeColoredWhiteIndexed2DPremultipliedBlending,
                
                    .spriteNodeIndexed3DNoBlending,
                    .spriteNodeIndexed3DAlphaBlending,
                    .spriteNodeIndexed3DAdditiveBlending,
                    .spriteNodeIndexed3DPremultipliedBlending,
                
                    .spriteNodeIndexedDiffuse3DNoBlending,
                    .spriteNodeIndexedDiffuseColored3DNoBlending,
                
                    .spriteNodeIndexedPhong3DNoBlending,
                    .spriteNodeIndexedPhongColored3DNoBlending,
                
                    .spriteNodeWhiteIndexed3DNoBlending,
                    .spriteNodeWhiteIndexed3DAlphaBlending,
                    .spriteNodeWhiteIndexed3DAdditiveBlending,
                    .spriteNodeWhiteIndexed3DPremultipliedBlending,
                
                    .spriteNodeColoredIndexed3DNoBlending,
                    .spriteNodeColoredIndexed3DAlphaBlending,
                    .spriteNodeColoredIndexed3DAdditiveBlending,
                    .spriteNodeColoredIndexed3DPremultipliedBlending,
                
                    .spriteNodeStereoscopicLeftColoredIndexed3DNoBlending,
                
                    .spriteNodeStereoscopicRightColoredIndexed3DNoBlending,
                
                    .spriteNodeColoredWhiteIndexed3DNoBlending,
                    .spriteNodeColoredWhiteIndexed3DAlphaBlending,
                    .spriteNodeColoredWhiteIndexed3DAdditiveBlending,
                    .spriteNodeColoredWhiteIndexed3DPremultipliedBlending,
                
                    .gaussianBlurHorizontalIndexedNoBlending,
                    .gaussianBlurVerticalIndexedNoBlending:
                renderEncoder.setFragmentTexture(texture, index: MetalPipeline.spriteNodeIndexedFragmentIndexTexture)
            default:
                break
            }
        }
    }
    
    func clip(renderEncoder: MTLRenderCommandEncoder) {
        renderEncoder.setScissorRect(MTLScissorRect(x: 0,
                                                    y: 0,
                                                    width: renderTargetWidth,
                                                    height: renderTargetHeight))
    }
    
    func clip(x: Float, y: Float, width: Float, height: Float, renderEncoder: MTLRenderCommandEncoder) {
        var x = Int(x * scaleFactor + 0.5)
        var y = Int(y * scaleFactor + 0.5)
        var width = Int(width * scaleFactor + 0.5)
        var height = Int(height * scaleFactor + 0.5)
        if x < 0 {
            width += x
            x = 0
        }
        if y < 0 {
            height += y
            y = 0
        }
        if (x >= renderTargetWidth) || (y >= renderTargetHeight) {
            renderEncoder.setScissorRect(MTLScissorRect(x: 0, y: 0, width: 0, height: 0))
        } else {
            let right = x + width
            if right > renderTargetWidth {
                let difference = (right - renderTargetWidth)
                width -= difference
            }
            let bottom = y + height
            if bottom > renderTargetHeight {
                let difference = (bottom - renderTargetHeight)
                height -= difference
            }
            if width > 0 && height > 0 {
                renderEncoder.setScissorRect(MTLScissorRect(x: x, y: y,
                                                            width: width, height: height))
            } else {
                renderEncoder.setScissorRect(MTLScissorRect(x: 0, y: 0, width: 0, height: 0))
            }
        }
    }
}
