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
    
    unowned var metalLayer: CAMetalLayer!
    unowned var graphics: Graphics!
    unowned var delegate: GraphicsDelegate!
    
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
    
    var storageTextureStereoscopicLeft: MTLTexture!
    var storageTextureStereoscopicRight: MTLTexture!
    
    
    var storageTexturePrebloom: MTLTexture!
    
    var storageTextureBloom: MTLTexture!
    
    
    var antialiasingTexture: MTLTexture!
    var depthTexture: MTLTexture!
    
    var bloomTexture1: MTLTexture!
    var bloomTexture2: MTLTexture!
    //var bloomTexture3: MTLTexture!
    //var bloomTexture4: MTLTexture!
    
    private var tileSprite = IndexedSpriteInstance<Sprite2DVertex,
                                                   UniformsSpriteVertex,
                                                   UniformsSpriteFragment>(sentinelNode: Sprite2DVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0))
    
    private var stereoscopicLeftSpriteA = IndexedSpriteInstance<Sprite3DVertexStereoscopic,
                                                               UniformsSpriteVertex,
                                                                UniformsSpriteFragment>(sentinelNode: Sprite3DVertexStereoscopic(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0, shiftRed: 2.0, shiftBlue: 2.0))
    private var stereoscopicRightSpriteA = IndexedSpriteInstance<Sprite3DVertexStereoscopic,
                                                               UniformsSpriteVertex,
                                                                UniformsSpriteFragment>(sentinelNode: Sprite3DVertexStereoscopic(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0, shiftRed: 2.0, shiftBlue: 2.0))
    
    
    private var stereoscopicLeftSpriteB = IndexedSpriteInstance<Sprite2DVertex,
                                                               UniformsSpriteVertex,
                                                               UniformsSpriteFragment>(sentinelNode: Sprite2DVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0))
    
    private var stereoscopicRightSpriteB = IndexedSpriteInstance<Sprite2DVertex,
                                                               UniformsSpriteVertex,
                                                               UniformsSpriteFragment>(sentinelNode: Sprite2DVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0))
    
    private var stereoscopicLeftBloomSprite = IndexedSpriteInstance<Sprite3DVertex,
                                                               UniformsSpriteVertex,
                                                              UniformsSpriteFragment>(sentinelNode: Sprite3DVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0))
    private var stereoscopicRightBloomSprite = IndexedSpriteInstance<Sprite3DVertex,
                                                               UniformsSpriteVertex,
                                                              UniformsSpriteFragment>(sentinelNode: Sprite3DVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0))
    
    
    
    private var bloomSprite = IndexedSpriteInstance<Sprite2DVertex,
                                                   UniformsSpriteVertex,
                                                   UniformsSpriteFragment>(sentinelNode: Sprite2DVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0))
    
    private var bloomCombineSprite3D = IndexedSpriteInstance<Sprite3DVertex,
                                                             UniformsSpriteVertex,
                                                             UniformsSpriteFragment>(sentinelNode: Sprite3DVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0))
    
    private var bloomStampSprite3D = IndexedSpriteInstance<Sprite3DVertex,
                                                          UniformsSpriteVertex,
                                                          UniformsSpriteFragment>(sentinelNode: Sprite3DVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0))
    
    private var prebloomStampSprite3D = IndexedSpriteInstance<Sprite3DVertex,
                                                          UniformsSpriteVertex,
                                                          UniformsSpriteFragment>(sentinelNode: Sprite3DVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0))
    
    
    required init(metalLayer: CAMetalLayer,
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
        
        print("[++] MetalEngine")
    }
    
    deinit {
        print("[--] MetalEngine")
    }
    
    func load() {
        buildSamplerStates()
        buildDepthStates()
        
        //tileStereoscopicSpritePositionsBuffer = graphics.buffer(array: tileStereoscopicSpritePositions)
        //tileStereoscopicSpriteTextureCoordsBuffer = graphics.buffer(array: tileStereoscopicSpriteTextureCoords)
        //tileStereoscopicUniformVertexBuffer = graphics.buffer(uniform: tileStereoscopicUniformVertex)
        //tileStereoscopicUniformFragmentBuffer = graphics.buffer(uniform: tileStereoscopicUniformFragment)
        
        tileSprite.load(graphics: graphics, texture: nil)
        
        stereoscopicLeftSpriteA.load(graphics: graphics, texture: nil)
        stereoscopicLeftSpriteB.load(graphics: graphics, texture: nil)
        
        stereoscopicRightSpriteA.load(graphics: graphics, texture: nil)
        stereoscopicRightSpriteB.load(graphics: graphics, texture: nil)
        
        bloomSprite.load(graphics: graphics, texture: nil)
        bloomStampSprite3D.load(graphics: graphics, texture: nil)
        prebloomStampSprite3D.load(graphics: graphics, texture: nil)
        bloomCombineSprite3D.load(graphics: graphics, texture: nil)
        
        stereoscopicLeftBloomSprite.load(graphics: graphics, texture: nil)
        stereoscopicRightBloomSprite.load(graphics: graphics, texture: nil)
    }
    
    func draw(isStereoscopicEnabled: Bool,
              isBloomEnabled: Bool) {
        
        guard let drawable = metalLayer.nextDrawable() else { return }
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        
        if storageTexture === nil {
            
            //
            // Note: The textures should always be sized to DRAWABLE width, this has caused
            // crashes for more than 3 years...
            //
            
            storageTexture = createStorageTexture(width: drawable.texture.width,
                                                  height: drawable.texture.height)
            storageTextureStereoscopicLeft = createStorageTexture(width: drawable.texture.width,
                                                                  height: drawable.texture.height)
            storageTextureStereoscopicRight = createStorageTexture(width: drawable.texture.width,
                                                                   height: drawable.texture.height)
            
            storageTexturePrebloom = createStorageTexture(width: drawable.texture.width,
                                                          height: drawable.texture.height)
            
            storageTextureBloom = createStorageTexture(width: drawable.texture.width,
                                                       height: drawable.texture.height)
            
            antialiasingTexture = createAntialiasingTexture(width: drawable.texture.width,
                                                            height: drawable.texture.height)
            depthTexture = createDepthTexture(width: drawable.texture.width,
                                              height: drawable.texture.height)
            
            bloomTexture1 = createStorageTexture(width: drawable.texture.width >> 2,
                                                  height: drawable.texture.height >> 2)
            bloomTexture2 = createStorageTexture(width: drawable.texture.width >> 2,
                                                  height: drawable.texture.height >> 2)
        }
        
        if isStereoscopicEnabled {
            
            let renderPassDescriptorPrebloom = MTLRenderPassDescriptor()
            renderPassDescriptorPrebloom.colorAttachments[0].texture = storageTexturePrebloom
            renderPassDescriptorPrebloom.colorAttachments[0].loadAction = .dontCare
            renderPassDescriptorPrebloom.colorAttachments[0].storeAction = .store
            renderPassDescriptorPrebloom.depthAttachment.loadAction = .dontCare
            renderPassDescriptorPrebloom.depthAttachment.clearDepth = 1.0
            renderPassDescriptorPrebloom.depthAttachment.texture = depthTexture
            graphics.renderTargetWidth = storageTexture.width
            graphics.renderTargetHeight = storageTexture.height
            if let renderEncoderPrebloom = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorPrebloom) {
                delegate.draw3DPrebloom(renderEncoder: renderEncoderPrebloom)
                renderEncoderPrebloom.endEncoding()
            }
            
            
            if isBloomEnabled {
                drawBloom(commandBuffer: commandBuffer)
                
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
                
                bloomCombineSprite3D.uniformsVertex.projectionMatrix.ortho(width: width,
                                                                             height: height)
                bloomCombineSprite3D.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
                bloomCombineSprite3D.setPositionQuad(x1: 0.0, y1: 0.0, x2: width, y2: 0.0,
                                                       x3: 0.0, y3: height, x4: width, y4: height)
                bloomCombineSprite3D.texture = storageTexturePrebloom
                bloomCombineSprite3D.render(renderEncoder: renderEncoderBloomCombine, pipelineState: .spriteNodeIndexed3DNoBlending)
                
                if isBloomEnabled {
                    bloomStampSprite3D.uniformsVertex.projectionMatrix.ortho(width: width,
                                                                             height: height)
                    bloomStampSprite3D.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
                    bloomStampSprite3D.setPositionQuad(x1: 0.0, y1: 0.0, x2: width, y2: 0.0,
                                                       x3: 0.0, y3: height, x4: width, y4: height)
                    bloomStampSprite3D.texture = bloomTexture2
                    bloomStampSprite3D.render(renderEncoder: renderEncoderBloomCombine, pipelineState: .spriteNodeIndexed3DAdditiveBlending)
                }
                renderEncoderBloomCombine.endEncoding()
            }
            
            
            // We then combine the pre-bloom and bloom into the "storageTextureBloom" texture....
            
            
            
            let renderPassDescriptor3DLeft = MTLRenderPassDescriptor()
            renderPassDescriptor3DLeft.colorAttachments[0].texture = storageTextureStereoscopicLeft
            renderPassDescriptor3DLeft.colorAttachments[0].loadAction = .clear
            renderPassDescriptor3DLeft.colorAttachments[0].storeAction = .store
            renderPassDescriptor3DLeft.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            renderPassDescriptor3DLeft.depthAttachment.loadAction = .clear
            renderPassDescriptor3DLeft.depthAttachment.clearDepth = 1.0
            renderPassDescriptor3DLeft.depthAttachment.texture = depthTexture
            
            graphics.renderTargetWidth = storageTextureStereoscopicLeft.width
            graphics.renderTargetHeight = storageTextureStereoscopicLeft.height
            
            if let renderEncoder3D = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor3DLeft) {
                
                let width = Float(storageTextureBloom.width)
                let height = Float(storageTextureBloom.height)
                
                /*
                stereoscopicLeftSpriteA.uniformsVertex.projectionMatrix.ortho(width: width,
                                                                             height: height)
                stereoscopicLeftSpriteA.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
                stereoscopicLeftSpriteA.setPositionQuad(x1: 0.0, y1: 0.0, x2: width, y2: 0.0,
                                                       x3: 0.0, y3: height, x4: width, y4: height)
                stereoscopicLeftSpriteA.texture = storageTextureBloom
                stereoscopicLeftSpriteA.render(renderEncoder: renderEncoder3D, pipelineState: .spriteNodeStereoscopicLeftIndexed3DNoBlending)
                */
                
                stereoscopicLeftSpriteA.uniformsVertex.projectionMatrix.ortho(width: width,
                                                                             height: height)
                stereoscopicLeftSpriteA.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
                stereoscopicLeftSpriteA.uniformsVertex.modelViewMatrix.translate(x: 2.0, y: 0.0, z: 0.0)
                
                stereoscopicLeftSpriteA.setPositionQuad(x1: 0.0, y1: 0.0, x2: width, y2: 0.0,
                                                       x3: 0.0, y3: height, x4: width, y4: height)
                stereoscopicLeftSpriteA.texture = storageTextureBloom
                stereoscopicLeftSpriteA.setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
                stereoscopicLeftSpriteA.render(renderEncoder: renderEncoder3D, pipelineState: .spriteNodeStereoscopicLeftIndexed3DNoBlending)
                
                
                delegate.draw3DStereoscopicLeft(renderEncoder: renderEncoder3D)
                renderEncoder3D.endEncoding()
            }
            
            let renderPassDescriptor3DRight = MTLRenderPassDescriptor()
            renderPassDescriptor3DRight.colorAttachments[0].texture = storageTextureStereoscopicRight
            renderPassDescriptor3DRight.colorAttachments[0].loadAction = .clear
            renderPassDescriptor3DRight.colorAttachments[0].storeAction = .store
            renderPassDescriptor3DLeft.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            renderPassDescriptor3DRight.depthAttachment.loadAction = .clear
            renderPassDescriptor3DRight.depthAttachment.clearDepth = 1.0
            renderPassDescriptor3DRight.depthAttachment.texture = depthTexture
            
            graphics.renderTargetWidth = storageTextureStereoscopicRight.width
            graphics.renderTargetHeight = storageTextureStereoscopicRight.height
            
            if let renderEncoder3D = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor3DRight) {
                
                let width = Float(storageTextureBloom.width)
                let height = Float(storageTextureBloom.height)
                
                /*
                
                */
                
                stereoscopicRightSpriteA.uniformsVertex.projectionMatrix.ortho(width: width,
                                                                               height: height)
                stereoscopicRightSpriteA.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
                stereoscopicRightSpriteA.uniformsVertex.modelViewMatrix.translate(x: -2.0, y: 0.0, z: 0.0)
                stereoscopicRightSpriteA.setPositionQuad(x1: 0.0, y1: 0.0, x2: width, y2: 0.0,
                                                         x3: 0.0, y3: height, x4: width, y4: height)
                stereoscopicRightSpriteA.texture = storageTextureBloom
                stereoscopicRightSpriteA.setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
                stereoscopicRightSpriteA.render(renderEncoder: renderEncoder3D, pipelineState: .spriteNodeStereoscopicRightIndexed3DNoBlending)
                
                
                delegate.draw3DStereoscopicRight(renderEncoder: renderEncoder3D)
                renderEncoder3D.endEncoding()
            }
            
            let renderPassDescriptor2D = MTLRenderPassDescriptor()
            renderPassDescriptor2D.colorAttachments[0].texture = antialiasingTexture
            renderPassDescriptor2D.colorAttachments[0].loadAction = .clear
            renderPassDescriptor2D.colorAttachments[0].storeAction = .multisampleResolve
            renderPassDescriptor2D.colorAttachments[0].resolveTexture = drawable.texture
            graphics.renderTargetWidth = antialiasingTexture.width
            graphics.renderTargetHeight = antialiasingTexture.height
            if let renderEncoder2D = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor2D) {
                drawTilesStereoscopic(renderEncoder: renderEncoder2D)
                delegate.draw2D(renderEncoder: renderEncoder2D)
                renderEncoder2D.endEncoding()
            }
            
            
        } else {
            
            if isBloomEnabled {
                
                let renderPassDescriptorPrebloom = MTLRenderPassDescriptor()
                                renderPassDescriptorPrebloom.colorAttachments[0].texture = storageTexturePrebloom
                                renderPassDescriptorPrebloom.colorAttachments[0].loadAction = .dontCare
                                renderPassDescriptorPrebloom.colorAttachments[0].storeAction = .store
                                renderPassDescriptorPrebloom.depthAttachment.loadAction = .dontCare
                                renderPassDescriptorPrebloom.depthAttachment.clearDepth = 1.0
                                renderPassDescriptorPrebloom.depthAttachment.texture = depthTexture
                                graphics.renderTargetWidth = storageTexture.width
                                graphics.renderTargetHeight = storageTexture.height
                                if let renderEncoderPrebloom = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorPrebloom) {
                                    delegate.draw3DPrebloom(renderEncoder: renderEncoderPrebloom)
                                    renderEncoderPrebloom.endEncoding()
                                }
                
                drawBloom(commandBuffer: commandBuffer)
                
                let renderPassDescriptor3D = MTLRenderPassDescriptor()
                renderPassDescriptor3D.colorAttachments[0].texture = storageTexture
                renderPassDescriptor3D.colorAttachments[0].loadAction = .dontCare
                renderPassDescriptor3D.colorAttachments[0].storeAction = .store
                renderPassDescriptor3D.depthAttachment.loadAction = .dontCare
                renderPassDescriptor3D.depthAttachment.clearDepth = 1.0
                renderPassDescriptor3D.depthAttachment.texture = depthTexture
                graphics.renderTargetWidth = storageTexture.width
                graphics.renderTargetHeight = storageTexture.height
                if let renderEncoder3D = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor3D) {
                    
                    let width = Float(graphics.width)
                    let height =  Float(graphics.height)
                    
                    
                    prebloomStampSprite3D.uniformsVertex.projectionMatrix.ortho(width: width,
                                                                                height: height)
                    prebloomStampSprite3D.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
                    prebloomStampSprite3D.setPositionQuad(x1: 0.0, y1: 0.0, x2: width, y2: 0.0,
                                                          x3: 0.0, y3: height, x4: width, y4: height)
                    prebloomStampSprite3D.texture = storageTexturePrebloom
                    prebloomStampSprite3D.render(renderEncoder: renderEncoder3D, pipelineState: .spriteNodeIndexed3DNoBlending)
                    
                    bloomStampSprite3D.uniformsVertex.projectionMatrix.ortho(width: width,
                                                                             height: height)
                    bloomStampSprite3D.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
                    bloomStampSprite3D.setPositionQuad(x1: 0.0, y1: 0.0, x2: width * 2.0, y2: 0.0,
                                                       x3: 0.0, y3: height * 2.0, x4: width * 2.0, y4: height * 2.0)
                    bloomStampSprite3D.texture = bloomTexture2
                    bloomStampSprite3D.render(renderEncoder: renderEncoder3D, pipelineState: .spriteNodeIndexed3DAdditiveBlending)
                    
                    delegate.draw3D(renderEncoder: renderEncoder3D)
                    renderEncoder3D.endEncoding()
                }
                
            } else {
                
                let renderPassDescriptor3D = MTLRenderPassDescriptor()
                renderPassDescriptor3D.colorAttachments[0].texture = storageTexture
                renderPassDescriptor3D.colorAttachments[0].loadAction = .clear
                renderPassDescriptor3D.colorAttachments[0].storeAction = .store
                renderPassDescriptor3D.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                renderPassDescriptor3D.depthAttachment.loadAction = .clear
                renderPassDescriptor3D.depthAttachment.clearDepth = 1.0
                renderPassDescriptor3D.depthAttachment.texture = depthTexture
                graphics.renderTargetWidth = storageTexture.width
                graphics.renderTargetHeight = storageTexture.height
                if let renderEncoder3D = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor3D) {
                    delegate.draw3DPrebloom(renderEncoder: renderEncoder3D)
                    delegate.draw3D(renderEncoder: renderEncoder3D)
                    renderEncoder3D.endEncoding()
                }
            }
            
            let renderPassDescriptor2D = MTLRenderPassDescriptor()
            renderPassDescriptor2D.colorAttachments[0].texture = antialiasingTexture
            renderPassDescriptor2D.colorAttachments[0].loadAction = .dontCare
            renderPassDescriptor2D.colorAttachments[0].storeAction = .multisampleResolve
            renderPassDescriptor2D.colorAttachments[0].resolveTexture = drawable.texture
            graphics.renderTargetWidth = antialiasingTexture.width
            graphics.renderTargetHeight = antialiasingTexture.height
            if let renderEncoder2D = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor2D) {
                drawTile(renderEncoder: renderEncoder2D)
                delegate.draw2D(renderEncoder: renderEncoder2D)
                renderEncoder2D.endEncoding()
            }
        }
        
        
        
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func drawBloom(commandBuffer: MTLCommandBuffer) {
        
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
            
            let width = Float(bloomTexture1.width)
            let height =  Float(bloomTexture1.height)
            
            bloomSprite.uniformsVertex.projectionMatrix.ortho(width: width,
                                                             height: height)
            bloomSprite.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
            bloomSprite.setPositionQuad(x1: 0.0, y1: 0.0,
                                       x2: width, y2: 0.0,
                                       x3: 0.0, y3: height,
                                       x4: width, y4: height)
            bloomSprite.setTextureCoordQuad(u1: 0.0, v1: 0.0,
                                           u2: 1.0, v2: 0.0,
                                           u3: 0.0, v3: 1.0,
                                           u4: 1.0, v4: 1.0)
            
            let renderPassDescriptorHorizontal1 = MTLRenderPassDescriptor()
            renderPassDescriptorHorizontal1.colorAttachments[0].texture = bloomTexture1
            renderPassDescriptorHorizontal1.colorAttachments[0].loadAction = .clear
            renderPassDescriptorHorizontal1.colorAttachments[0].storeAction = .store
            renderPassDescriptorHorizontal1.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            graphics.renderTargetWidth = bloomTexture1.width
            graphics.renderTargetHeight = bloomTexture1.height
            if let renderEncoderHorizontal1 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorHorizontal1) {
                bloomSprite.texture = storageTexture
                bloomSprite.render(renderEncoder: renderEncoderHorizontal1, pipelineState: .gaussianBlurHorizontalIndexedNoBlending)
                renderEncoderHorizontal1.endEncoding()
            }
            
            let renderPassDescriptorVertical1 = MTLRenderPassDescriptor()
            renderPassDescriptorVertical1.colorAttachments[0].texture = bloomTexture2
            renderPassDescriptorVertical1.colorAttachments[0].loadAction = .load
            renderPassDescriptorVertical1.colorAttachments[0].storeAction = .store
            graphics.renderTargetWidth = bloomTexture2.width
            graphics.renderTargetHeight = bloomTexture2.height
            if let renderEncoderVertical1 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorVertical1) {
                bloomSprite.texture = bloomTexture1
                bloomSprite.render(renderEncoder: renderEncoderVertical1, pipelineState: .gaussianBlurVerticalIndexedNoBlending)
                renderEncoderVertical1.endEncoding()
            }
            
            let renderPassDescriptorHorizontal2 = MTLRenderPassDescriptor()
            renderPassDescriptorHorizontal2.colorAttachments[0].texture = bloomTexture1
            renderPassDescriptorHorizontal2.colorAttachments[0].loadAction = .clear
            renderPassDescriptorHorizontal2.colorAttachments[0].storeAction = .store
            renderPassDescriptorHorizontal2.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            graphics.renderTargetWidth = bloomTexture1.width
            graphics.renderTargetHeight = bloomTexture1.height
            if let renderEncoderHorizontal2 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorHorizontal2) {
                bloomSprite.texture = bloomTexture2
                bloomSprite.render(renderEncoder: renderEncoderHorizontal2, pipelineState: .gaussianBlurHorizontalIndexedNoBlending)
                renderEncoderHorizontal2.endEncoding()
            }
            
            let renderPassDescriptorVertical2 = MTLRenderPassDescriptor()
            renderPassDescriptorVertical2.colorAttachments[0].texture = bloomTexture2
            renderPassDescriptorVertical2.colorAttachments[0].loadAction = .load
            renderPassDescriptorVertical2.colorAttachments[0].storeAction = .store
            graphics.renderTargetWidth = bloomTexture1.width
            graphics.renderTargetHeight = bloomTexture1.height
            if let renderEncoderVertical2 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorVertical2) {
                bloomSprite.texture = bloomTexture1
                bloomSprite.render(renderEncoder: renderEncoderVertical2, pipelineState: .gaussianBlurVerticalIndexedNoBlending)
                renderEncoderVertical2.endEncoding()
            }
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                let renderPassDescriptorHorizontal3 = MTLRenderPassDescriptor()
                renderPassDescriptorHorizontal3.colorAttachments[0].texture = bloomTexture1
                renderPassDescriptorHorizontal3.colorAttachments[0].loadAction = .clear
                renderPassDescriptorHorizontal3.colorAttachments[0].storeAction = .store
                renderPassDescriptorHorizontal3.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                graphics.renderTargetWidth = bloomTexture1.width
                graphics.renderTargetHeight = bloomTexture1.height
                if let renderEncoderHorizontal3 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorHorizontal3) {
                    bloomSprite.texture = bloomTexture2
                    bloomSprite.render(renderEncoder: renderEncoderHorizontal3, pipelineState: .gaussianBlurHorizontalIndexedNoBlending)
                    renderEncoderHorizontal3.endEncoding()
                }
                
                let renderPassDescriptorVertical3 = MTLRenderPassDescriptor()
                renderPassDescriptorVertical3.colorAttachments[0].texture = bloomTexture2
                renderPassDescriptorVertical3.colorAttachments[0].loadAction = .load
                renderPassDescriptorVertical3.colorAttachments[0].storeAction = .store
                graphics.renderTargetWidth = bloomTexture1.width
                graphics.renderTargetHeight = bloomTexture1.height
                if let renderEncoderVertical3 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorVertical3) {
                    bloomSprite.texture = bloomTexture1
                    bloomSprite.render(renderEncoder: renderEncoderVertical3, pipelineState: .gaussianBlurVerticalIndexedNoBlending)
                    renderEncoderVertical3.endEncoding()
                }
            }
        }
    }
    
    func drawTile(renderEncoder: MTLRenderCommandEncoder) {
        
        let width = Float(storageTexture.width)
        let height =  Float(storageTexture.height)
        
        tileSprite.uniformsVertex.projectionMatrix.ortho(width: width,
                                                         height: height)
        tileSprite.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
        tileSprite.setPositionQuad(x1: 0.0, y1: 0.0,
                                   x2: width, y2: 0.0,
                                   x3: 0.0, y3: height,
                                   x4: width, y4: height)
        tileSprite.setTextureCoordQuad(u1: 0.0, v1: 0.0,
                                       u2: 1.0, v2: 0.0,
                                       u3: 0.0, v3: 1.0,
                                       u4: 1.0, v4: 1.0)
        
        tileSprite.texture = storageTexture
        tileSprite.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed2DNoBlending)
    }
    
    func drawTilesStereoscopic(renderEncoder: MTLRenderCommandEncoder) {
        
        let widthLeft = Float(storageTextureStereoscopicLeft.width)
        let heightLeft =  Float(storageTextureStereoscopicLeft.height)
        
        stereoscopicLeftSpriteB.uniformsVertex.projectionMatrix.ortho(width: widthLeft,
                                                                     height: heightLeft)
        stereoscopicLeftSpriteB.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
        stereoscopicLeftSpriteB.uniformsVertex.modelViewMatrix.translate(x: 2.0, y: 0.0, z: 0.0)
        
        stereoscopicLeftSpriteB.setPositionQuad(x1: 0.0, y1: 0.0,
                                               x2: widthLeft, y2: 0.0,
                                               x3: 0.0, y3: heightLeft,
                                               x4: widthLeft, y4: heightLeft)
        stereoscopicLeftSpriteB.setTextureCoordQuad(u1: 0.0, v1: 0.0,
                                                   u2: 1.0, v2: 0.0,
                                                   u3: 0.0, v3: 1.0,
                                                   u4: 1.0, v4: 1.0)
        
        stereoscopicLeftSpriteB.texture = storageTextureStereoscopicLeft
        stereoscopicLeftSpriteB.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed2DNoBlending)
        
        
        let widthRight = Float(storageTextureStereoscopicRight.width)
        let heightRight =  Float(storageTextureStereoscopicRight.height)
        
        stereoscopicRightSpriteB.uniformsVertex.projectionMatrix.ortho(width: widthRight,
                                                                      height: heightRight)
        stereoscopicRightSpriteB.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
        stereoscopicRightSpriteB.uniformsVertex.modelViewMatrix.translate(x: -2.0, y: 0.0, z: 0.0)
        
        stereoscopicRightSpriteB.setPositionQuad(x1: 0.0, y1: 0.0,
                                                x2: widthRight, y2: 0.0,
                                                x3: 0.0, y3: heightRight,
                                                x4: widthRight, y4: heightRight)
        stereoscopicRightSpriteB.setTextureCoordQuad(u1: 0.0, v1: 0.0,
                                                    u2: 1.0, v2: 0.0,
                                                    u3: 0.0, v3: 1.0,
                                                    u4: 1.0, v4: 1.0)
        
        stereoscopicRightSpriteB.texture = storageTextureStereoscopicRight
        stereoscopicRightSpriteB.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed2DAdditiveBlending)
    }
    
    private func buildSamplerStates() {
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
    
    private func buildDepthStates() {
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
    
    func createAntialiasingTexture(width: Int, height: Int) -> MTLTexture {
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.sampleCount = 4
        textureDescriptor.pixelFormat = metalLayer.pixelFormat
        textureDescriptor.width = width
        textureDescriptor.height = height
        textureDescriptor.textureType = .type2DMultisample
        textureDescriptor.usage = .renderTarget
        textureDescriptor.resourceOptions = .storageModePrivate
        return metalDevice.makeTexture(descriptor: textureDescriptor)!
    }
    
    func createStorageTexture(width: Int, height: Int) -> MTLTexture {
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.pixelFormat = metalLayer.pixelFormat
        textureDescriptor.width = width
        textureDescriptor.height = height
        textureDescriptor.textureType = .type2D
        textureDescriptor.usage = .renderTarget.union(.shaderRead)
        return metalDevice.makeTexture(descriptor: textureDescriptor)!
    }
    
    func createDepthTexture(width: Int, height: Int) -> MTLTexture {
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
