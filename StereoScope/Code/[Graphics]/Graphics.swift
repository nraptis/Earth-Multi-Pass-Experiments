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
    
    func load()
    
    func loadComplete()
    
    func update(deltaTime: Float)
    
    func draw3DPrebloom(renderEncoder: MTLRenderCommandEncoder)
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
        
        case shapeNodeIndexed2DNoBlending
        case shapeNodeIndexed2DAlphaBlending
        case shapeNodeIndexed2DAdditiveBlending
        case shapeNodeIndexed2DPremultipliedBlending
        case shapeNodeIndexed3DNoBlending
        case shapeNodeIndexed3DAlphaBlending
        case shapeNodeIndexed3DAdditiveBlending
        case shapeNodeIndexed3DPremultipliedBlending
        case shapeNodeIndexedDiffuse3DNoBlending
        case shapeNodeIndexedDiffuseColored3DNoBlending
        case shapeNodeIndexedPhong3DNoBlending
        case shapeNodeIndexedPhongColored3DNoBlending
        
        case shapeNodeColoredIndexed2DNoBlending
        case shapeNodeColoredIndexed2DAlphaBlending
        case shapeNodeColoredIndexed2DAdditiveBlending
        case shapeNodeColoredIndexed2DPremultipliedBlending
        case shapeNodeColoredIndexed3DNoBlending
        case shapeNodeColoredIndexed3DAlphaBlending
        case shapeNodeColoredIndexed3DAdditiveBlending
        case shapeNodeColoredIndexed3DPremultipliedBlending
        
        
        case spriteNodeIndexed2DNoBlending
        case spriteNodeIndexed2DAlphaBlending
        case spriteNodeIndexed2DAdditiveBlending
        case spriteNodeIndexed2DPremultipliedBlending
        case spriteNodeIndexed3DNoBlending
        case spriteNodeIndexed3DAlphaBlending
        case spriteNodeIndexed3DAdditiveBlending
        case spriteNodeIndexed3DPremultipliedBlending
        
        case spriteNodeStereoscopicLeftIndexed3DNoBlending
        case spriteNodeStereoscopicLeftIndexed3DAlphaBlending
        case spriteNodeStereoscopicLeftIndexed3DAdditiveBlending
        case spriteNodeStereoscopicLeftIndexed3DPremultipliedBlending
        
        case spriteNodeStereoscopicRightIndexed3DNoBlending
        case spriteNodeStereoscopicRightIndexed3DAlphaBlending
        case spriteNodeStereoscopicRightIndexed3DAdditiveBlending
        case spriteNodeNodeStereoscopicRightIndexed3DPremultipliedBlending
        
        
        case spriteNodeIndexedDiffuse3DNoBlending
        case spriteNodeIndexedDiffuseColored3DNoBlending
        case spriteNodeIndexedPhong3DNoBlending
        case spriteNodeIndexedPhongColored3DNoBlending
        
        case spriteNodeIndexedNight3DNoBlending
        
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
               
                case .shapeNodeIndexedDiffuse3DNoBlending:
                    renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeIndexedDiffuse3DNoBlending)
                    
                case .shapeNodeIndexedDiffuseColored3DNoBlending:
                    renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeIndexedDiffuseColored3DNoBlending)
                    
                case .shapeNodeIndexedPhong3DNoBlending:
                    renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeIndexedPhong3DNoBlending)
                    
                case .shapeNodeIndexedPhongColored3DNoBlending:
                    renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeIndexedPhongColored3DNoBlending)
                
                    
               
            
                    
                case .shapeNodeColoredIndexed3DNoBlending:
                    renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeColoredIndexed3DNoBlending)
                case .shapeNodeColoredIndexed3DAlphaBlending:
                    renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeColoredIndexed3DAlphaBlending)
                case .shapeNodeColoredIndexed3DAdditiveBlending:
                    renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeColoredIndexed3DAdditiveBlending)
                case .shapeNodeColoredIndexed3DPremultipliedBlending:
                    renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateShapeNodeColoredIndexed3DPremultipliedBlending)
                    
                  
            
            
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
            
            
            
            
        case .spriteNodeStereoscopicLeftIndexed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicLeftIndexed3DNoBlending)
        case .spriteNodeStereoscopicLeftIndexed3DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicLeftIndexed3DAlphaBlending)
        case .spriteNodeStereoscopicLeftIndexed3DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicLeftIndexed3DAdditiveBlending)
        case .spriteNodeStereoscopicLeftIndexed3DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicLeftIndexed3DPremultipliedBlending)
        
        case .spriteNodeStereoscopicRightIndexed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicRightIndexed3DNoBlending)
        case .spriteNodeStereoscopicRightIndexed3DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicRightIndexed3DAlphaBlending)
        case .spriteNodeStereoscopicRightIndexed3DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicRightIndexed3DAdditiveBlending)
        case .spriteNodeNodeStereoscopicRightIndexed3DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicRightIndexed3DPremultipliedBlending)
            
            
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
            
            
        case .spriteNodeIndexedNight3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedNight3DNoBlending)
            
       
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
        renderEncoder.setFragmentSamplerState(metalSamplerState, index: MetalPipeline.slotFragmentSampler)
    }
    
    func setVertexUniformsBuffer(_ uniformsBuffer: MTLBuffer?, renderEncoder: MTLRenderCommandEncoder) {
        if let uniformsBuffer = uniformsBuffer {
            renderEncoder.setVertexBuffer(uniformsBuffer, offset: 0, index: MetalPipeline.slotVertexUniforms)
        }
    }
    
    func setFragmentUniformsBuffer(_ uniformsBuffer: MTLBuffer?, renderEncoder: MTLRenderCommandEncoder) {
        if let uniformsBuffer = uniformsBuffer {
            renderEncoder.setFragmentBuffer(uniformsBuffer, offset: 0, index: MetalPipeline.slotFragmentUniforms)
        }
    }
    
    func setVertexDataBuffer(_ dataBuffer: MTLBuffer?, renderEncoder: MTLRenderCommandEncoder) {
        if let dataBuffer = dataBuffer {
            renderEncoder.setVertexBuffer(dataBuffer, offset: 0, index: MetalPipeline.slotVertexData)
        }
    }
    
    func setFragmentTexture(_ texture: MTLTexture?, renderEncoder: MTLRenderCommandEncoder) {
        if let texture = texture {
            renderEncoder.setFragmentTexture(texture, index: MetalPipeline.slotFragmentTexture)
        }
    }
    
    func setFragmentLightTexture(_ texture: MTLTexture?, renderEncoder: MTLRenderCommandEncoder) {
        if let texture = texture {
            renderEncoder.setFragmentTexture(texture, index: MetalPipeline.slotFragmentLightTexture)
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
