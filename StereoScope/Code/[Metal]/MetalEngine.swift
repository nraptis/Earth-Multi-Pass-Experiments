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
    var storageTextureStereoscopic: MTLTexture!
    
    var antialiasingTexture: MTLTexture!
    var depthTexture: MTLTexture!
    
    var blurTexture1: MTLTexture!
    var blurTexture2: MTLTexture!
    //var blurTexture3: MTLTexture!
    //var blurTexture4: MTLTexture!
    
    
    private var tileSprite = IndexedSpriteInstance<Sprite2DVertex,
                                                   UniformsSpriteVertex,
                                                   UniformsSpriteFragment>(sentinelNode: Sprite2DVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0))
    
    private var tileStereoscopicSpritePositions: [Float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    private var tileStereoscopicSpriteTextureCoords: [Float] = [0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0]
    private var tileStereoscopicUniformVertex = UniformsSpriteVertex()
    private var tileStereoscopicUniformFragment = UniformsSpriteFragment()
    private var tileStereoscopicSpritePositionsBuffer: MTLBuffer!
    private var tileStereoscopicSpriteTextureCoordsBuffer: MTLBuffer!
    private var tileStereoscopicUniformVertexBuffer: MTLBuffer!
    private var tileStereoscopicUniformFragmentBuffer: MTLBuffer!
    private var tileStereoscopicSpriteWidth: Float = 0.0
    private var tileStereoscopicSpriteHeight: Float = 0.0
    
    private var blurSprite = IndexedSpriteInstance<Sprite2DVertex,
                                                   UniformsSpriteVertex,
                                                   UniformsSpriteFragment>(sentinelNode: Sprite2DVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0))
    private var blurStampSprite3D = IndexedSpriteInstance<Sprite3DVertex,
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
        
        tileStereoscopicSpritePositionsBuffer = graphics.buffer(array: tileStereoscopicSpritePositions)
        tileStereoscopicSpriteTextureCoordsBuffer = graphics.buffer(array: tileStereoscopicSpriteTextureCoords)
        tileStereoscopicUniformVertexBuffer = graphics.buffer(uniform: tileStereoscopicUniformVertex)
        tileStereoscopicUniformFragmentBuffer = graphics.buffer(uniform: tileStereoscopicUniformFragment)
        
        tileSprite.load(graphics: graphics, texture: nil)
        
        blurSprite.load(graphics: graphics, texture: nil)
        blurStampSprite3D.load(graphics: graphics, texture: nil)
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
            storageTextureStereoscopic = createStorageTexture(width: drawable.texture.width,
                                                              height: drawable.texture.height)
            antialiasingTexture = createAntialiasingTexture(width: drawable.texture.width,
                                                            height: drawable.texture.height)
            depthTexture = createDepthTexture(width: drawable.texture.width,
                                              height: drawable.texture.height)
            
            blurTexture1 = createStorageTexture(width: drawable.texture.width >> 2,
                                                  height: drawable.texture.height >> 2)
            blurTexture2 = createStorageTexture(width: drawable.texture.width >> 2,
                                                  height: drawable.texture.height >> 2)
        }
        
        if isStereoscopicEnabled {
            
            let renderPassDescriptor3DLeft = MTLRenderPassDescriptor()
            renderPassDescriptor3DLeft.colorAttachments[0].texture = storageTexture
            renderPassDescriptor3DLeft.colorAttachments[0].loadAction = .clear
            renderPassDescriptor3DLeft.colorAttachments[0].storeAction = .store
            renderPassDescriptor3DLeft.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            renderPassDescriptor3DLeft.depthAttachment.loadAction = .clear
            renderPassDescriptor3DLeft.depthAttachment.clearDepth = 1.0
            renderPassDescriptor3DLeft.depthAttachment.texture = depthTexture
            
            graphics.renderTargetWidth = storageTexture.width
            graphics.renderTargetHeight = storageTexture.height
            
            if let renderEncoder3D = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor3DLeft) {
                delegate.draw3DStereoscopicLeft(renderEncoder: renderEncoder3D)
                renderEncoder3D.endEncoding()
            }
            
            let renderPassDescriptor3DRight = MTLRenderPassDescriptor()
            renderPassDescriptor3DRight.colorAttachments[0].texture = storageTextureStereoscopic
            renderPassDescriptor3DRight.colorAttachments[0].loadAction = .clear
            renderPassDescriptor3DRight.colorAttachments[0].storeAction = .store
            renderPassDescriptor3DLeft.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            renderPassDescriptor3DRight.depthAttachment.loadAction = .clear
            renderPassDescriptor3DRight.depthAttachment.clearDepth = 1.0
            renderPassDescriptor3DRight.depthAttachment.texture = depthTexture
            
            graphics.renderTargetWidth = storageTextureStereoscopic.width
            graphics.renderTargetHeight = storageTextureStereoscopic.height
            
            if let renderEncoder3D = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor3DRight) {
                delegate.draw3DStereoscopicRight(renderEncoder: renderEncoder3D)
                renderEncoder3D.endEncoding()
            }
            
        } else {
            
            if isBloomEnabled {
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
                    
                    blurStampSprite3D.uniformsVertex.projectionMatrix.ortho(width: width,
                                                                            height: height)
                    blurStampSprite3D.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
                    blurStampSprite3D.setPositionQuad(x1: 0.0, y1: 0.0,
                                                      x2: width, y2: 0.0,
                                                      x3: 0.0, y3: height,
                                                      x4: width, y4: height)
                    blurStampSprite3D.setTextureCoordQuad(u1: 0.0, v1: 0.0,
                                                          u2: 1.0, v2: 0.0,
                                                          u3: 0.0, v3: 1.0,
                                                          u4: 1.0, v4: 1.0)
                    blurStampSprite3D.texture = blurTexture2
                    blurStampSprite3D.render(renderEncoder: renderEncoder3D, pipelineState: .spriteNodeIndexed3DNoBlending)
                    
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
                    delegate.draw3D(renderEncoder: renderEncoder3D)
                    renderEncoder3D.endEncoding()
                }
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
            if isStereoscopicEnabled {
                drawTileStereoscopic(renderEncoder: renderEncoder2D)
            }
            delegate.draw2D(renderEncoder: renderEncoder2D)
            renderEncoder2D.endEncoding()
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
            
            let width = Float(blurTexture1.width)
            let height =  Float(blurTexture1.height)
            
            blurSprite.uniformsVertex.projectionMatrix.ortho(width: width,
                                                             height: height)
            blurSprite.uniformsVertex.modelViewMatrix = matrix_identity_float4x4
            blurSprite.setPositionQuad(x1: 0.0, y1: 0.0,
                                       x2: width, y2: 0.0,
                                       x3: 0.0, y3: height,
                                       x4: width, y4: height)
            blurSprite.setTextureCoordQuad(u1: 0.0, v1: 0.0,
                                           u2: 1.0, v2: 0.0,
                                           u3: 0.0, v3: 1.0,
                                           u4: 1.0, v4: 1.0)
            
            let renderPassDescriptorHorizontal1 = MTLRenderPassDescriptor()
            renderPassDescriptorHorizontal1.colorAttachments[0].texture = blurTexture1
            renderPassDescriptorHorizontal1.colorAttachments[0].loadAction = .clear
            renderPassDescriptorHorizontal1.colorAttachments[0].storeAction = .store
            renderPassDescriptorHorizontal1.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            graphics.renderTargetWidth = blurTexture1.width
            graphics.renderTargetHeight = blurTexture1.height
            if let renderEncoderHorizontal1 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorHorizontal1) {
                blurSprite.texture = storageTexture
                blurSprite.render(renderEncoder: renderEncoderHorizontal1, pipelineState: .gaussianBlurHorizontalIndexedNoBlending)
                renderEncoderHorizontal1.endEncoding()
            }
            
            let renderPassDescriptorVertical1 = MTLRenderPassDescriptor()
            renderPassDescriptorVertical1.colorAttachments[0].texture = blurTexture2
            renderPassDescriptorVertical1.colorAttachments[0].loadAction = .load
            renderPassDescriptorVertical1.colorAttachments[0].storeAction = .store
            graphics.renderTargetWidth = blurTexture2.width
            graphics.renderTargetHeight = blurTexture2.height
            if let renderEncoderVertical1 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorVertical1) {
                blurSprite.texture = blurTexture1
                blurSprite.render(renderEncoder: renderEncoderVertical1, pipelineState: .gaussianBlurVerticalIndexedNoBlending)
                renderEncoderVertical1.endEncoding()
            }
            
            let renderPassDescriptorHorizontal2 = MTLRenderPassDescriptor()
            renderPassDescriptorHorizontal2.colorAttachments[0].texture = blurTexture1
            renderPassDescriptorHorizontal2.colorAttachments[0].loadAction = .clear
            renderPassDescriptorHorizontal2.colorAttachments[0].storeAction = .store
            renderPassDescriptorHorizontal2.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            graphics.renderTargetWidth = blurTexture1.width
            graphics.renderTargetHeight = blurTexture1.height
            if let renderEncoderHorizontal2 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorHorizontal2) {
                blurSprite.texture = blurTexture2
                blurSprite.render(renderEncoder: renderEncoderHorizontal2, pipelineState: .gaussianBlurHorizontalIndexedNoBlending)
                renderEncoderHorizontal2.endEncoding()
            }
            
            let renderPassDescriptorVertical2 = MTLRenderPassDescriptor()
            renderPassDescriptorVertical2.colorAttachments[0].texture = blurTexture2
            renderPassDescriptorVertical2.colorAttachments[0].loadAction = .load
            renderPassDescriptorVertical2.colorAttachments[0].storeAction = .store
            graphics.renderTargetWidth = blurTexture1.width
            graphics.renderTargetHeight = blurTexture1.height
            if let renderEncoderVertical2 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorVertical2) {
                blurSprite.texture = blurTexture1
                blurSprite.render(renderEncoder: renderEncoderVertical2, pipelineState: .gaussianBlurVerticalIndexedNoBlending)
                renderEncoderVertical2.endEncoding()
            }
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                let renderPassDescriptorHorizontal3 = MTLRenderPassDescriptor()
                renderPassDescriptorHorizontal3.colorAttachments[0].texture = blurTexture1
                renderPassDescriptorHorizontal3.colorAttachments[0].loadAction = .clear
                renderPassDescriptorHorizontal3.colorAttachments[0].storeAction = .store
                renderPassDescriptorHorizontal3.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                graphics.renderTargetWidth = blurTexture1.width
                graphics.renderTargetHeight = blurTexture1.height
                if let renderEncoderHorizontal3 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorHorizontal3) {
                    blurSprite.texture = blurTexture2
                    blurSprite.render(renderEncoder: renderEncoderHorizontal3, pipelineState: .gaussianBlurHorizontalIndexedNoBlending)
                    renderEncoderHorizontal3.endEncoding()
                }
                
                let renderPassDescriptorVertical3 = MTLRenderPassDescriptor()
                renderPassDescriptorVertical3.colorAttachments[0].texture = blurTexture2
                renderPassDescriptorVertical3.colorAttachments[0].loadAction = .load
                renderPassDescriptorVertical3.colorAttachments[0].storeAction = .store
                graphics.renderTargetWidth = blurTexture1.width
                graphics.renderTargetHeight = blurTexture1.height
                if let renderEncoderVertical3 = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptorVertical3) {
                    blurSprite.texture = blurTexture1
                    blurSprite.render(renderEncoder: renderEncoderVertical3, pipelineState: .gaussianBlurVerticalIndexedNoBlending)
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
    
    func drawTileStereoscopic(renderEncoder: MTLRenderCommandEncoder) {
        /*
        if (tileStereoscopicSpriteWidth != graphics.width) || (tileStereoscopicSpriteHeight != graphics.height) {
            tileStereoscopicSpriteWidth = graphics.width
            tileStereoscopicSpriteHeight = graphics.height
            
            tileStereoscopicSpritePositions[0] = 0.0
            tileStereoscopicSpritePositions[1] = 0.0
            tileStereoscopicSpritePositions[2] = graphics.width
            tileStereoscopicSpritePositions[3] = 0.0
            tileStereoscopicSpritePositions[4] = 0.0
            tileStereoscopicSpritePositions[5] = graphics.height
            tileStereoscopicSpritePositions[6] = graphics.width
            tileStereoscopicSpritePositions[7] = graphics.height
            graphics.write(buffer: tileStereoscopicSpritePositionsBuffer, array: tileStereoscopicSpritePositions)
            
            tileStereoscopicUniformVertex.projectionMatrix.ortho(width: graphics.width,
                                                     height: graphics.height)
            graphics.write(buffer: tileStereoscopicUniformVertexBuffer,
                           uniform: tileStereoscopicUniformVertex)
        }
        
        graphics.set(pipelineState: .sprite2DAdditiveBlending, renderEncoder: renderEncoder)
        graphics.set(samplerState: .linearClamp, renderEncoder: renderEncoder)
        
        graphics.setVertexPositionsBuffer(tileStereoscopicSpritePositionsBuffer, renderEncoder: renderEncoder)
        graphics.setVertexTextureCoordsBuffer(tileStereoscopicSpriteTextureCoordsBuffer, renderEncoder: renderEncoder)
        
        graphics.setVertexUniformsBuffer(tileStereoscopicUniformVertexBuffer, renderEncoder: renderEncoder)
        graphics.setFragmentUniformsBuffer(tileStereoscopicUniformFragmentBuffer, renderEncoder: renderEncoder)
        
        graphics.setFragmentTexture(storageTextureStereoscopic, renderEncoder: renderEncoder)
        
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        */
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
