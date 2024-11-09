//
//  MetalEngine.swift
//  RebuildEarth
//
//  Created by Nicky Taylor on 2/10/23.
//

import Foundation
import UIKit
import Metal
import simd

class MetalEngine {
    
    weak var metalLayer: CAMetalLayer?
    weak var graphics: Graphics?
    weak var delegate: GraphicsDelegate?
    
    var scale: Float
    var metalDevice: MTLDevice
    var metalLibrary: MTLLibrary
    var commandQueue: MTLCommandQueue
    
    var samplerStateLinearClamp: MTLSamplerState!
    var samplerStateLinearRepeat: MTLSamplerState!
    
    var samplerStateNearestClamp: MTLSamplerState!
    var samplerStateNearestRepeat: MTLSamplerState!
    
    var depthStateDisabled: MTLDepthStencilState!
    var depthStateLessThan: MTLDepthStencilState!
    var depthStateLessThanEqual: MTLDepthStencilState!
    
    var storageTexture: MTLTexture!
    let storageSprite = Sprite()
    
    var storageTexturePrebloom: MTLTexture! // Note: We use this for stereoscopic blue as well...
    let storageSpritePrebloom = Sprite()
    
    var storageTextureBloom: MTLTexture!
    let storageSpriteBloom = Sprite()
    
    var antialiasingTexture: MTLTexture!
    
    var bloomTexture1: MTLTexture!
    let bloomSprite1 = Sprite()
    
    var bloomTexture2: MTLTexture!
    let bloomSprite2 = Sprite()
    
    var depthTexture: MTLTexture!
    
    private var tileSprite = IndexedSpriteInstance2D()
    private var stereoscopicSprite3D = IndexedSpriteInstance3DStereoscopic()
    private var bloomSprite2D = IndexedSpriteInstance2D()
    private var bloomCombineSprite3D = IndexedSpriteInstance3D()
    
    @MainActor required init(metalLayer: CAMetalLayer,
                  width: Float,
                  height: Float) {
        
        self.metalLayer = metalLayer
        
        scale = Float(UIScreen.main.scale)
        metalDevice = MTLCreateSystemDefaultDevice()!
        metalLibrary = metalDevice.makeDefaultLibrary()!
        commandQueue = metalDevice.makeCommandQueue()!
        
        metalLayer.device = metalDevice
        metalLayer.contentsScale = UIScreen.main.scale
        metalLayer.frame = CGRect(x: 0.0,
                                  y: 0.0,
                                  width: CGFloat(width),
                                  height: CGFloat(height))
    }
    
    @MainActor func load() {
        buildSamplerStates()
        buildDepthStates()
        
        if let graphics {
            tileSprite.load(graphics: graphics, sprite: nil)
            stereoscopicSprite3D.load(graphics: graphics, sprite: nil)
            bloomSprite2D.load(graphics: graphics, sprite: nil)
            bloomCombineSprite3D.load(graphics: graphics, sprite: nil)
        }
    }
    
    @MainActor func draw(isStereoscopicEnabled: Bool,
              isBloomEnabled: Bool,
              bloomPasses: Int,
              stereoSpreadBase: Float,
              stereoSpreadMax: Float) {
        
        guard let metalLayer = metalLayer else { return }
        guard let delegate = delegate else { return }
        guard let graphics = graphics else { return }
        guard let drawable = metalLayer.nextDrawable() else { return }
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        
        if storageTexture === nil {
            storageTexture = createStorageTexture(width: drawable.texture.width, height: drawable.texture.height)
            storageTexturePrebloom = createStorageTexture(width: drawable.texture.width, height: drawable.texture.height)
            storageTextureBloom = createStorageTexture(width: drawable.texture.width, height: drawable.texture.height)
            antialiasingTexture = createAntialiasingTexture(width: drawable.texture.width, height: drawable.texture.height)
            depthTexture = createDepthTexture(width: drawable.texture.width, height: drawable.texture.height)
            bloomTexture1 = createStorageTexture(width: drawable.texture.width >> 2, height: drawable.texture.height >> 2)
            bloomTexture2 = createStorageTexture(width: drawable.texture.width >> 2, height: drawable.texture.height >> 2)
            
            storageSprite.load(graphics: graphics, texture: storageTexture, scaleFactor: scale)
            storageSpritePrebloom.load(graphics: graphics, texture: storageTexturePrebloom, scaleFactor: scale)
            storageSpriteBloom.load(graphics: graphics, texture: storageTextureBloom, scaleFactor: scale)
            bloomSprite1.load(graphics: graphics, texture: bloomTexture1, scaleFactor: scale)
            bloomSprite2.load(graphics: graphics, texture: bloomTexture2, scaleFactor: scale)
        }
        
        delegate.predraw(isStereoscopicEnabled: isStereoscopicEnabled)
        
        let renderPassDescriptorPrebloom = MTLRenderPassDescriptor()
        renderPassDescriptorPrebloom.colorAttachments[0].texture = storageTexturePrebloom
        renderPassDescriptorPrebloom.colorAttachments[0].loadAction = .dontCare
        renderPassDescriptorPrebloom.colorAttachments[0].storeAction = .store
        renderPassDescriptorPrebloom.depthAttachment.loadAction = .clear
        renderPassDescriptorPrebloom.depthAttachment.clearDepth = 1.0
        renderPassDescriptorPrebloom.depthAttachment.texture = depthTexture
        graphics.renderTargetWidth = storageTexture.width
        graphics.renderTargetHeight = storageTexture.height
        if let renderEncoderPrebloom = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorPrebloom) {
            delegate.draw3DPrebloom(renderEncoder: renderEncoderPrebloom)
            renderEncoderPrebloom.endEncoding()
        }
        
        if isBloomEnabled {
            drawBloom(commandBuffer: commandBuffer, passes: bloomPasses)
        }
        
        let renderPassDescriptorBloomCombine = MTLRenderPassDescriptor()
        renderPassDescriptorBloomCombine.colorAttachments[0].texture = storageTextureBloom
        renderPassDescriptorBloomCombine.colorAttachments[0].loadAction = .dontCare
        renderPassDescriptorBloomCombine.colorAttachments[0].storeAction = .store
        renderPassDescriptorBloomCombine.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        renderPassDescriptorBloomCombine.depthAttachment.loadAction = .clear
        renderPassDescriptorBloomCombine.depthAttachment.clearDepth = 1.0
        renderPassDescriptorBloomCombine.depthAttachment.texture = depthTexture
        if let renderEncoderBloomCombine = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorBloomCombine) {
            let width = Float(storageTextureBloom.width)
            let height = Float(storageTextureBloom.height)
            bloomCombineSprite3D.uniformsVertex.projectionMatrix.ortho(width: width, height: height)
            bloomCombineSprite3D.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
            bloomCombineSprite3D.setPositionQuad(x1: 0.0, y1: 0.0, x2: width, y2: height)
            bloomCombineSprite3D.sprite = storageSpritePrebloom
            bloomCombineSprite3D.render(renderEncoder: renderEncoderBloomCombine, pipelineState: .spriteNodeIndexed3DNoBlending)
            if isBloomEnabled {
                bloomCombineSprite3D.sprite = bloomSprite2
                bloomCombineSprite3D.render(renderEncoder: renderEncoderBloomCombine, pipelineState: .spriteNodeIndexed3DAdditiveBlending)
            }
            renderEncoderBloomCombine.endEncoding()
        }
        
        if isStereoscopicEnabled {
            
            stereoscopicSprite3D.vertices[0].shift = stereoSpreadBase * 2.0
            stereoscopicSprite3D.vertices[1].shift = stereoSpreadBase * 2.0
            stereoscopicSprite3D.vertices[2].shift = stereoSpreadBase * 2.0
            stereoscopicSprite3D.vertices[3].shift = stereoSpreadBase * 2.0
            
            // We then combine the pre-bloom and bloom into the "storageTextureBloom" texture....
            let renderPassDescriptor3DBlue = MTLRenderPassDescriptor()
            renderPassDescriptor3DBlue.colorAttachments[0].texture = storageTexture
            renderPassDescriptor3DBlue.colorAttachments[0].loadAction = .clear
            renderPassDescriptor3DBlue.colorAttachments[0].storeAction = .store
            renderPassDescriptor3DBlue.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            renderPassDescriptor3DBlue.depthAttachment.loadAction = .clear
            renderPassDescriptor3DBlue.depthAttachment.clearDepth = 1.0
            renderPassDescriptor3DBlue.depthAttachment.texture = depthTexture
            
            graphics.renderTargetWidth = storageTexture.width
            graphics.renderTargetHeight = storageTexture.height
            
            if let renderEncoder3D = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor3DBlue) {
                let width = Float(storageTextureBloom.width)
                let height = Float(storageTextureBloom.height)
                stereoscopicSprite3D.uniformsVertex.projectionMatrix.ortho(width: width, height: height)
                stereoscopicSprite3D.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
                stereoscopicSprite3D.setPositionQuad(x1: 0.0, y1: 0.0, x2: width, y2: height)
                stereoscopicSprite3D.sprite = storageSpriteBloom
                stereoscopicSprite3D.setDirty(isVertexBufferDirty: true, isIndexBufferDirty: false, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
                stereoscopicSprite3D.render(renderEncoder: renderEncoder3D, pipelineState: .spriteNodeStereoscopicBlueIndexed3DNoBlending)
                delegate.draw3DStereoscopicBlue(renderEncoder: renderEncoder3D, stereoSpreadBase: stereoSpreadBase, stereoSpreadMax: stereoSpreadMax)
                renderEncoder3D.endEncoding()
            }
            
            let renderPassDescriptor3DRed = MTLRenderPassDescriptor()
            renderPassDescriptor3DRed.colorAttachments[0].texture = storageTexturePrebloom
            renderPassDescriptor3DRed.colorAttachments[0].loadAction = .clear
            renderPassDescriptor3DRed.colorAttachments[0].storeAction = .store
            renderPassDescriptor3DRed.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            renderPassDescriptor3DRed.depthAttachment.loadAction = .clear
            renderPassDescriptor3DRed.depthAttachment.clearDepth = 1.0
            renderPassDescriptor3DRed.depthAttachment.texture = depthTexture
            
            graphics.renderTargetWidth = storageTexturePrebloom.width
            graphics.renderTargetHeight = storageTexturePrebloom.height
            
            if let renderEncoder3D = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor3DRed) {
                let width = Float(storageTexturePrebloom.width)
                let height = Float(storageTexturePrebloom.height)
                stereoscopicSprite3D.uniformsVertex.projectionMatrix.ortho(width: width, height: height)
                stereoscopicSprite3D.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
                stereoscopicSprite3D.setPositionQuad(x1: 0.0, y1: 0.0, x2: width, y2: height)
                stereoscopicSprite3D.sprite = storageSpriteBloom
                stereoscopicSprite3D.setDirty(isVertexBufferDirty: true, isIndexBufferDirty: false, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
                stereoscopicSprite3D.render(renderEncoder: renderEncoder3D, pipelineState: .spriteNodeStereoscopicRedIndexed3DNoBlending)
                delegate.draw3DStereoscopicRed(renderEncoder: renderEncoder3D, stereoSpreadBase: stereoSpreadBase, stereoSpreadMax: stereoSpreadMax)
                renderEncoder3D.endEncoding()
            }
        } else {
            
            let renderPassDescriptor3DBlue = MTLRenderPassDescriptor()
            renderPassDescriptor3DBlue.colorAttachments[0].texture = storageTexture
            renderPassDescriptor3DBlue.colorAttachments[0].loadAction = .clear
            renderPassDescriptor3DBlue.colorAttachments[0].storeAction = .store
            renderPassDescriptor3DBlue.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            renderPassDescriptor3DBlue.depthAttachment.loadAction = .clear
            renderPassDescriptor3DBlue.depthAttachment.clearDepth = 1.0
            renderPassDescriptor3DBlue.depthAttachment.texture = depthTexture
            
            graphics.renderTargetWidth = storageTexture.width
            graphics.renderTargetHeight = storageTexture.height
            
            if let renderEncoder3D = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor3DBlue) {
                let width = Float(storageTextureBloom.width)
                let height = Float(storageTextureBloom.height)
                bloomCombineSprite3D.uniformsVertex.projectionMatrix.ortho(width: width, height: height)
                bloomCombineSprite3D.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
                bloomCombineSprite3D.setPositionQuad(x1: 0.0, y1: 0.0, x2: width, y2: height)
                bloomCombineSprite3D.sprite = storageSpriteBloom
                bloomCombineSprite3D.setDirty(isVertexBufferDirty: true, isIndexBufferDirty: false, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
                bloomCombineSprite3D.render(renderEncoder: renderEncoder3D, pipelineState: .spriteNodeIndexed3DNoBlending)
                delegate.draw3D(renderEncoder: renderEncoder3D)
                renderEncoder3D.endEncoding()
            }
        }
        
        let renderPassDescriptor2D = MTLRenderPassDescriptor()
        renderPassDescriptor2D.colorAttachments[0].texture = antialiasingTexture
        renderPassDescriptor2D.colorAttachments[0].storeAction = .multisampleResolve
        renderPassDescriptor2D.colorAttachments[0].resolveTexture = drawable.texture
        graphics.renderTargetWidth = antialiasingTexture.width
        graphics.renderTargetHeight = antialiasingTexture.height
        if isStereoscopicEnabled {
            renderPassDescriptor2D.colorAttachments[0].loadAction = .clear
        } else {
            renderPassDescriptor2D.colorAttachments[0].loadAction = .dontCare
        }
        if let renderEncoder2D = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor2D) {
            if isStereoscopicEnabled {
                drawTilesStereoscopic(renderEncoder: renderEncoder2D)
            } else {
                drawTile(renderEncoder: renderEncoder2D)
            }
            delegate.draw2D(renderEncoder: renderEncoder2D)
            renderEncoder2D.endEncoding()
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    // Note: We do not support 0 bloom passes. We had this and
    //       removed it. It makes no sense to do 0 passes of
    //       bloom since an equivalent effect can be achieved with
    //       the main 3D draw pass. OR pre-bloom pass.
    @MainActor func drawBloom(commandBuffer: MTLCommandBuffer, passes: Int) {
        
        guard let graphics = graphics else { return }
        guard let delegate = delegate else { return }
        
        let renderPassDescriptorBloom = MTLRenderPassDescriptor()
        renderPassDescriptorBloom.colorAttachments[0].texture = storageTexture
        renderPassDescriptorBloom.colorAttachments[0].loadAction = .clear
        renderPassDescriptorBloom.colorAttachments[0].storeAction = .store
        renderPassDescriptorBloom.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        renderPassDescriptorBloom.depthAttachment.loadAction = .clear
        renderPassDescriptorBloom.depthAttachment.clearDepth = 1.0
        renderPassDescriptorBloom.depthAttachment.texture = depthTexture
        if let renderEncoderBloom = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorBloom) {
            graphics.renderTargetWidth = storageTexture.width
            graphics.renderTargetHeight = storageTexture.height
            delegate.draw3DBloom(renderEncoder: renderEncoderBloom)
            renderEncoderBloom.endEncoding()
        }
        
        let bloomWidth = Float(bloomTexture1.width)
        let bloomHeight =  Float(bloomTexture1.height)
        bloomSprite2D.uniformsVertex.projectionMatrix.ortho(width: bloomWidth, height: bloomHeight)
        bloomSprite2D.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
        bloomSprite2D.setPositionQuad(x1: 0.0, y1: 0.0, x2: bloomWidth, y2: bloomHeight)
        
        let renderPassDescriptorHorizontal1 = MTLRenderPassDescriptor()
        renderPassDescriptorHorizontal1.colorAttachments[0].texture = bloomTexture1
        renderPassDescriptorHorizontal1.colorAttachments[0].loadAction = .clear
        renderPassDescriptorHorizontal1.colorAttachments[0].storeAction = .store
        renderPassDescriptorHorizontal1.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        graphics.renderTargetWidth = bloomTexture1.width
        graphics.renderTargetHeight = bloomTexture1.height
        if let renderEncoderHorizontal1 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorHorizontal1) {
            bloomSprite2D.sprite = storageSprite
            bloomSprite2D.render(renderEncoder: renderEncoderHorizontal1, pipelineState: .gaussianBlurHorizontalIndexedNoBlending)
            renderEncoderHorizontal1.endEncoding()
        }
        
        let renderPassDescriptorVertical1 = MTLRenderPassDescriptor()
        renderPassDescriptorVertical1.colorAttachments[0].texture = bloomTexture2
        renderPassDescriptorVertical1.colorAttachments[0].loadAction = .load
        renderPassDescriptorVertical1.colorAttachments[0].storeAction = .store
        if let renderEncoderVertical1 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorVertical1) {
            bloomSprite2D.sprite = bloomSprite1
            bloomSprite2D.render(renderEncoder: renderEncoderVertical1, pipelineState: .gaussianBlurVerticalIndexedNoBlending)
            renderEncoderVertical1.endEncoding()
        }
        
        var bloomLoopIndex = 1
        while bloomLoopIndex < passes {
            
            let renderPassDescriptorHorizontal2 = MTLRenderPassDescriptor()
            renderPassDescriptorHorizontal2.colorAttachments[0].texture = bloomTexture1
            renderPassDescriptorHorizontal2.colorAttachments[0].loadAction = .clear
            renderPassDescriptorHorizontal2.colorAttachments[0].storeAction = .store
            renderPassDescriptorHorizontal2.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            if let renderEncoderHorizontal2 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorHorizontal2) {
                bloomSprite2D.sprite = bloomSprite2
                bloomSprite2D.render(renderEncoder: renderEncoderHorizontal2, pipelineState: .gaussianBlurHorizontalIndexedNoBlending)
                renderEncoderHorizontal2.endEncoding()
            }
            
            let renderPassDescriptorVertical2 = MTLRenderPassDescriptor()
            renderPassDescriptorVertical2.colorAttachments[0].texture = bloomTexture2
            renderPassDescriptorVertical2.colorAttachments[0].loadAction = .load
            renderPassDescriptorVertical2.colorAttachments[0].storeAction = .store
            if let renderEncoderVertical2 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorVertical2) {
                bloomSprite2D.sprite = bloomSprite1
                bloomSprite2D.render(renderEncoder: renderEncoderVertical2, pipelineState: .gaussianBlurVerticalIndexedNoBlending)
                renderEncoderVertical2.endEncoding()
            }
            
            bloomLoopIndex += 1
        }
    }
    
    @MainActor func drawTile(renderEncoder: MTLRenderCommandEncoder) {
        let width = Float(storageTexture.width)
        let height =  Float(storageTexture.height)
        tileSprite.uniformsVertex.projectionMatrix.ortho(width: width, height: height)
        tileSprite.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
        tileSprite.setPositionQuad(x1: 0.0, y1: 0.0, x2: width, y2: height)
        tileSprite.sprite = storageSprite
        tileSprite.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed2DNoBlending)
    }
    
    @MainActor func drawTilesStereoscopic(renderEncoder: MTLRenderCommandEncoder) {
        let width = Float(storageTexture.width)
        let height =  Float(storageTexture.height)
        tileSprite.uniformsVertex.projectionMatrix.ortho(width: width, height: height)
        tileSprite.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
        tileSprite.setPositionQuad(x1: 0.0, y1: 0.0, x2: width, y2: height)
        tileSprite.setDirty(isVertexBufferDirty: false, isIndexBufferDirty: false, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: false)
        tileSprite.sprite = storageSprite
        tileSprite.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed2DNoBlending)
        
        tileSprite.uniformsVertex.projectionMatrix.ortho(width: width, height: height)
        tileSprite.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
        tileSprite.setDirty(isVertexBufferDirty: false, isIndexBufferDirty: false, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: false)
        tileSprite.sprite = storageSpritePrebloom
        tileSprite.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed2DAdditiveBlending)
    }
    
    @MainActor private func buildSamplerStates() {
        let samplerDescriptorLinearClamp = MTLSamplerDescriptor()
        samplerDescriptorLinearClamp.minFilter = .linear
        samplerDescriptorLinearClamp.magFilter = .linear
        samplerDescriptorLinearClamp.sAddressMode = .clampToEdge
        samplerDescriptorLinearClamp.tAddressMode = .clampToEdge
        samplerStateLinearClamp = metalDevice.makeSamplerState(descriptor: samplerDescriptorLinearClamp)
        
        let samplerDescriptorLinearRepeat = MTLSamplerDescriptor()
        samplerDescriptorLinearRepeat.minFilter = .linear
        samplerDescriptorLinearRepeat.magFilter = .linear
        samplerDescriptorLinearRepeat.sAddressMode = .repeat
        samplerDescriptorLinearRepeat.tAddressMode = .repeat
        samplerStateLinearRepeat = metalDevice.makeSamplerState(descriptor: samplerDescriptorLinearRepeat)
        
        let samplerDescriptorNearestClamp = MTLSamplerDescriptor()
        samplerDescriptorLinearClamp.minFilter = .nearest
        samplerDescriptorLinearClamp.magFilter = .nearest
        samplerDescriptorLinearClamp.sAddressMode = .clampToEdge
        samplerDescriptorLinearClamp.tAddressMode = .clampToEdge
        samplerStateNearestClamp = metalDevice.makeSamplerState(descriptor: samplerDescriptorNearestClamp)
        
        let samplerDescriptorNearestRepeat = MTLSamplerDescriptor()
        samplerDescriptorLinearRepeat.minFilter = .nearest
        samplerDescriptorLinearRepeat.magFilter = .nearest
        samplerDescriptorLinearRepeat.sAddressMode = .repeat
        samplerDescriptorLinearRepeat.tAddressMode = .repeat
        samplerStateNearestRepeat = metalDevice.makeSamplerState(descriptor: samplerDescriptorNearestRepeat)
    }
    
    @MainActor private func buildDepthStates() {
        let depthDescriptorDisabled = MTLDepthStencilDescriptor()
        depthDescriptorDisabled.depthCompareFunction = .always
        depthDescriptorDisabled.isDepthWriteEnabled = false
        depthStateDisabled = metalDevice.makeDepthStencilState(descriptor: depthDescriptorDisabled)
        
        let depthDescriptorLessThan = MTLDepthStencilDescriptor()
        depthDescriptorLessThan.depthCompareFunction = .less
        depthDescriptorLessThan.isDepthWriteEnabled = true
        depthStateLessThan = metalDevice.makeDepthStencilState(descriptor: depthDescriptorLessThan)
        
        let depthDescriptorLessThanEqual = MTLDepthStencilDescriptor()
        depthDescriptorLessThanEqual.depthCompareFunction = .lessEqual
        depthDescriptorLessThanEqual.isDepthWriteEnabled = true
        depthStateLessThanEqual = metalDevice.makeDepthStencilState(descriptor: depthDescriptorLessThanEqual)
    }
    
    @MainActor func createAntialiasingTexture(width: Int, height: Int) -> MTLTexture {
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.sampleCount = 4
        if let metalLayer {
            textureDescriptor.pixelFormat = metalLayer.pixelFormat
        }
        textureDescriptor.width = width
        textureDescriptor.height = height
        textureDescriptor.textureType = .type2DMultisample
        textureDescriptor.usage = .renderTarget
        textureDescriptor.resourceOptions = .storageModePrivate
        return metalDevice.makeTexture(descriptor: textureDescriptor)!
    }
    
    @MainActor func createStorageTexture(width: Int, height: Int) -> MTLTexture {
        let textureDescriptor = MTLTextureDescriptor()
        if let metalLayer {
            textureDescriptor.pixelFormat = metalLayer.pixelFormat
        }
        textureDescriptor.width = width
        textureDescriptor.height = height
        textureDescriptor.textureType = .type2D
        textureDescriptor.usage = .renderTarget.union(.shaderRead)
        return metalDevice.makeTexture(descriptor: textureDescriptor)!
    }
    
    @MainActor func createDepthTexture(width: Int, height: Int) -> MTLTexture {
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.pixelFormat = .depth32Float
        textureDescriptor.width = width
        textureDescriptor.height = height
        textureDescriptor.textureType = .type2D
        textureDescriptor.usage = .renderTarget
        textureDescriptor.resourceOptions = .storageModePrivate
        return metalDevice.makeTexture(descriptor: textureDescriptor)!
    }
}
