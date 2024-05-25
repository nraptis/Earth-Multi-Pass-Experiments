//
//  MetalEngine.swift
//  RebuildEarth
//
//  Created by Nicky Taylor on 2/10/23.
//

import Foundation
import UIKit
import Metal

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
    
    private var tileSpritePositions: [Float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    private var tileSpriteTextureCoords: [Float] = [0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0]
    private var tileUniformVertex = UniformsSpriteVertex()
    private var tileUniformFragment = UniformsSpriteFragment()
    private var tileSpritePositionsBuffer: MTLBuffer!
    private var tileSpriteTextureCoordsBuffer: MTLBuffer!
    private var tileUniformVertexBuffer: MTLBuffer!
    private var tileUniformFragmentBuffer: MTLBuffer!
    private var tileSpriteWidth: Float = 0.0
    private var tileSpriteHeight: Float = 0.0
    
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
        
        tileSpritePositionsBuffer = graphics.buffer(array: tileSpritePositions)
        tileSpriteTextureCoordsBuffer = graphics.buffer(array: tileSpriteTextureCoords)
        tileUniformVertexBuffer = graphics.buffer(uniform: tileUniformVertex)
        tileUniformFragmentBuffer = graphics.buffer(uniform: tileUniformFragment)
        
        tileStereoscopicSpritePositionsBuffer = graphics.buffer(array: tileStereoscopicSpritePositions)
        tileStereoscopicSpriteTextureCoordsBuffer = graphics.buffer(array: tileStereoscopicSpriteTextureCoords)
        tileStereoscopicUniformVertexBuffer = graphics.buffer(uniform: tileStereoscopicUniformVertex)
        tileStereoscopicUniformFragmentBuffer = graphics.buffer(uniform: tileStereoscopicUniformFragment)
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
            
            //
            //
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
    
    func drawTile(renderEncoder: MTLRenderCommandEncoder) {
        if (tileSpriteWidth != graphics.width) || (tileSpriteHeight != graphics.height) {
            tileSpriteWidth = graphics.width
            tileSpriteHeight = graphics.height
            
            tileSpritePositions[0] = 0.0
            tileSpritePositions[1] = 0.0
            tileSpritePositions[2] = graphics.width
            tileSpritePositions[3] = 0.0
            tileSpritePositions[4] = 0.0
            tileSpritePositions[5] = graphics.height
            tileSpritePositions[6] = graphics.width
            tileSpritePositions[7] = graphics.height
            graphics.write(buffer: tileSpritePositionsBuffer, array: tileSpritePositions)
            
            tileUniformVertex.projectionMatrix.ortho(width: graphics.width,
                                                     height: graphics.height)
            graphics.write(buffer: tileUniformVertexBuffer,
                           uniform: tileUniformVertex)
        }
        
        graphics.set(pipelineState: .sprite2DNoBlending, renderEncoder: renderEncoder)
        graphics.set(samplerState: .linearClamp, renderEncoder: renderEncoder)
        
        graphics.setVertexPositionsBuffer(tileSpritePositionsBuffer, renderEncoder: renderEncoder)
        graphics.setVertexTextureCoordsBuffer(tileSpriteTextureCoordsBuffer, renderEncoder: renderEncoder)

        graphics.setVertexUniformsBuffer(tileUniformVertexBuffer, renderEncoder: renderEncoder)
        graphics.setFragmentUniformsBuffer(tileUniformFragmentBuffer, renderEncoder: renderEncoder)
        graphics.setFragmentTexture(storageTexture, renderEncoder: renderEncoder)
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
    }
    
    func drawTileStereoscopic(renderEncoder: MTLRenderCommandEncoder) {
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
