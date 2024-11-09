//
//  Graphics.swift
//  RebuildEarth
//
//  Created by Nicky Taylor on 2/9/23.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation
import Metal
import MetalKit
import UIKit

protocol GraphicsDelegate: AnyObject {
    
    var graphics: Graphics? { get set }
    
    @MainActor func load()
    
    @MainActor func loadComplete()
    
    @MainActor func initialize()
    
    @MainActor func update(deltaTime: Float,
                stereoSpreadBase: Float,
                stereoSpreadMax: Float,
                isStereoscopicEnabled: Bool)
    
    @MainActor func predraw(isStereoscopicEnabled: Bool)
    @MainActor func draw3DPrebloom(renderEncoder: MTLRenderCommandEncoder)
    @MainActor func draw3DBloom(renderEncoder: MTLRenderCommandEncoder)
    
    @MainActor func draw3DStereoscopicBlue(renderEncoder: MTLRenderCommandEncoder, stereoSpreadBase: Float, stereoSpreadMax: Float)
    @MainActor func draw3DStereoscopicRed(renderEncoder: MTLRenderCommandEncoder, stereoSpreadBase: Float, stereoSpreadMax: Float)
    
    @MainActor func draw3D(renderEncoder: MTLRenderCommandEncoder)
    @MainActor func draw2D(renderEncoder: MTLRenderCommandEncoder)
}

class Graphics {
    
    weak var metalView: MetalView?
    weak var metalDevice: MTLDevice?
    weak var metalEngine: MetalEngine?
    weak var metalPipeline: MetalPipeline?
    
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
        case spriteNodeStereoscopicBlueIndexed3DNoBlending
        case spriteNodeStereoscopicBlueIndexed3DAlphaBlending
        case spriteNodeStereoscopicBlueIndexed3DAdditiveBlending
        case spriteNodeStereoscopicBlueIndexed3DPremultipliedBlending
        case spriteNodeStereoscopicRedIndexed3DNoBlending
        case spriteNodeStereoscopicRedIndexed3DAlphaBlending
        case spriteNodeStereoscopicRedIndexed3DAdditiveBlending
        case spriteNodeNodeStereoscopicRedIndexed3DPremultipliedBlending
        case spriteNodeColoredStereoscopicBlueIndexed3DNoBlending
        case spriteNodeColoredStereoscopicBlueIndexed3DAlphaBlending
        case spriteNodeColoredStereoscopicBlueIndexed3DAdditiveBlending
        case spriteNodeColoredStereoscopicBlueIndexed3DPremultipliedBlending
        case spriteNodeColoredStereoscopicRedIndexed3DNoBlending
        case spriteNodeColoredStereoscopicRedIndexed3DAlphaBlending
        case spriteNodeColoredStereoscopicRedIndexed3DAdditiveBlending
        case spriteNodeNodeColoredStereoscopicRedIndexed3DPremultipliedBlending
        case spriteNodeIndexedDiffuse3DNoBlending
        case spriteNodeIndexedDiffuseStereoscopicBlue3DNoBlending
        case spriteNodeIndexedDiffuseStereoscopicRed3DNoBlending
        case spriteNodeIndexedDiffuseColored3DNoBlending
        case spriteNodeIndexedDiffuseColoredStereoscopicBlue3DNoBlending
        case spriteNodeIndexedDiffuseColoredStereoscopicRed3DNoBlending
        case spriteNodeIndexedPhong3DNoBlending
        case spriteNodeIndexedPhongStereoscopicRed3DNoBlending
        case spriteNodeIndexedPhongStereoscopicBlue3DNoBlending
        case spriteNodeIndexedPhongColored3DNoBlending
        case spriteNodeIndexedPhongColoredStereoscopicRed3DNoBlending
        case spriteNodeIndexedPhongColoredStereoscopicBlue3DNoBlending
        case spriteNodeIndexedNight3DNoBlending
        case spriteNodeIndexedNightStereoscopicBlue3DNoBlending
        case spriteNodeIndexedNightStereoscopicRed3DNoBlending
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
        
        print("Grapgics Init: width(\(width)) height(\(height)) scaleFactor(\(scaleFactor))")
    }
    
    private(set) var pipelineState = PipelineState.invalid
    private(set) var samplerState = SamplerState.invalid
    private(set) var depthState = DepthState.invalid
    
    @MainActor lazy var scaledTextureSuffix: String = {
        var deviceScale = Int(scaleFactor + 0.5)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if deviceScale <= 1 {
                return "_1_5"
            } else {
                return "_3_0"
            }
        } else {
            if deviceScale <= 1 {
                return "_1_0"
            } else if deviceScale == 2 {
                return "_2_0"
            } else {
                return "_3_0"
            }
        }
    }()
    
    @MainActor func loadTexture(name: String, `extension`: String) -> MTLTexture? {
        if let bundleResourcePath = Bundle.main.resourcePath {
            let filePath = bundleResourcePath + "/" + name + "." + `extension`
            let fileURL = URL(filePath: filePath)
            return loadTexture(url: fileURL)
        }
        return nil
    }
    
    @MainActor func loadTexture(nameWithExtension: String) -> MTLTexture? {
        if let bundleResourcePath = Bundle.main.resourcePath {
            let filePath = bundleResourcePath + "/" + nameWithExtension
            let fileURL = URL(filePath: filePath)
            return loadTexture(url: fileURL)
        }
        return nil
    }
    
    @MainActor func loadTextureScaled(name: String, `extension`: String) -> MTLTexture? {
        if let bundleResourcePath = Bundle.main.resourcePath {
            let filePath = bundleResourcePath + "/" + name + scaledTextureSuffix + "." + `extension`
            let fileURL = URL(filePath: filePath)
            return loadTexture(url: fileURL)
        }
        return nil
    }
    
    @MainActor func loadTexture(url: URL) -> MTLTexture? {
        guard let uiImage = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        return loadTexture(cgImage: uiImage.cgImage)
    }
    
    @MainActor func loadTexture(cgImage: CGImage?) -> MTLTexture? {
        
        guard let metalDevice = metalDevice else {
            return nil
        }
        
        guard let cgImage = cgImage else {
            return nil
        }
        
        let width = cgImage.width
        let height = cgImage.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapData = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * bytesPerPixel)
        
        guard let context = CGContext(data: bitmapData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            bitmapData.deallocate()
            return nil
        }
        
        //context.setFillColor(UIColor(red: 0.09, green: 0.09, blue: 0.11, alpha: 1.0).cgColor)
        //context.fill(CGRect(x: 0.0, y: 0.0, width: resultWidth, height: resultHeight))
        
        let rect = CGRect(x: CGFloat(0.0),
                          y: CGFloat(0.0),
                          width: CGFloat(width),
                          height: CGFloat(height))
        context.clear(rect)
        context.draw(cgImage, in: rect)
        
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.pixelFormat = .rgba8Unorm
        textureDescriptor.width = width
        textureDescriptor.height = height
        textureDescriptor.usage = [.shaderRead]
        
        guard let texture = metalDevice.makeTexture(descriptor: textureDescriptor) else {
            bitmapData.deallocate()
            return nil
        }
        
        let region = MTLRegionMake2D(0, 0, width, height)
        texture.replace(region: region, mipmapLevel: 0, withBytes: bitmapData, bytesPerRow: bytesPerRow)
        
        return texture
    }
    
    @MainActor func loadTexture(uiImage: UIImage?) -> MTLTexture? {
        loadTexture(cgImage: uiImage?.cgImage)
    }
    
    @MainActor func loadTexture(fileName: String) -> MTLTexture? {
        if let bundleResourcePath = Bundle.main.resourcePath {
            let filePath = bundleResourcePath + "/" + fileName
            let fileURL: URL
            if #available(iOS 16.0, *) {
                fileURL = URL(filePath: filePath)
            } else {
                fileURL = URL(fileURLWithPath: filePath)
            }
            return loadTexture(url: fileURL)
        }
        return nil
    }
    
    func buffer<Element>(array: Array<Element>) -> MTLBuffer? {
        guard let metalDevice = metalDevice else {
            return nil
        }
        let length = MemoryLayout<Element>.size * array.count
        return metalDevice.makeBuffer(bytes: array, length: length)
    }
    
    func write<Element>(buffer: MTLBuffer, array: Array<Element>) {
        let length = MemoryLayout<Element>.size * array.count
        buffer.contents().copyMemory(from: array,
                                     byteCount: length)
    }
    
    func buffer(uniform: Uniforms) -> MTLBuffer? {
        guard let metalDevice = metalDevice else {
            return nil
        }
        return metalDevice.makeBuffer(bytes: uniform.data, length: uniform.size, options: [])
    }
    
    func write(buffer: MTLBuffer, uniform: Uniforms) {
        buffer.contents().copyMemory(from: uniform.data, byteCount: uniform.size)
    }
    
    var _pipelineStateTable = [PipelineState: MTLRenderPipelineState]()
    func buildPipelineStateTable(metalPipeline: MetalPipeline) {
        _pipelineStateTable[.shapeNodeIndexed2DNoBlending] = metalPipeline.pipelineStateShapeNodeIndexed2DNoBlending
        _pipelineStateTable[.shapeNodeIndexed2DAlphaBlending] = metalPipeline.pipelineStateShapeNodeIndexed2DAlphaBlending
        _pipelineStateTable[.shapeNodeIndexed2DAdditiveBlending] = metalPipeline.pipelineStateShapeNodeIndexed2DAdditiveBlending
        _pipelineStateTable[.shapeNodeIndexed2DPremultipliedBlending] = metalPipeline.pipelineStateShapeNodeIndexed2DPremultipliedBlending
        _pipelineStateTable[.shapeNodeIndexed3DNoBlending] = metalPipeline.pipelineStateShapeNodeIndexed3DNoBlending
        _pipelineStateTable[.shapeNodeIndexed3DAlphaBlending] = metalPipeline.pipelineStateShapeNodeIndexed3DAlphaBlending
        _pipelineStateTable[.shapeNodeIndexed3DAdditiveBlending] = metalPipeline.pipelineStateShapeNodeIndexed3DAdditiveBlending
        _pipelineStateTable[.shapeNodeIndexed3DPremultipliedBlending] = metalPipeline.pipelineStateShapeNodeIndexed3DPremultipliedBlending
        _pipelineStateTable[.shapeNodeColoredIndexed2DNoBlending] = metalPipeline.pipelineStateShapeNodeColoredIndexed2DNoBlending
        _pipelineStateTable[.shapeNodeColoredIndexed2DAlphaBlending] = metalPipeline.pipelineStateShapeNodeColoredIndexed2DAlphaBlending
        _pipelineStateTable[.shapeNodeColoredIndexed2DAdditiveBlending] = metalPipeline.pipelineStateShapeNodeColoredIndexed2DAdditiveBlending
        _pipelineStateTable[.shapeNodeColoredIndexed2DPremultipliedBlending] = metalPipeline.pipelineStateShapeNodeColoredIndexed2DPremultipliedBlending
        _pipelineStateTable[.shapeNodeIndexedDiffuse3DNoBlending] = metalPipeline.pipelineStateShapeNodeIndexedDiffuse3DNoBlending
        _pipelineStateTable[.shapeNodeIndexedDiffuseColored3DNoBlending] = metalPipeline.pipelineStateShapeNodeIndexedDiffuseColored3DNoBlending
        _pipelineStateTable[.shapeNodeIndexedPhong3DNoBlending] = metalPipeline.pipelineStateShapeNodeIndexedPhong3DNoBlending
        _pipelineStateTable[.spriteNodeIndexedPhongStereoscopicBlue3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedPhongStereoscopicBlue3DNoBlending
        _pipelineStateTable[.spriteNodeIndexedPhongStereoscopicRed3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedPhongStereoscopicRed3DNoBlending
        _pipelineStateTable[.shapeNodeIndexedPhongColored3DNoBlending] = metalPipeline.pipelineStateShapeNodeIndexedPhongColored3DNoBlending
        _pipelineStateTable[.shapeNodeColoredIndexed3DNoBlending] = metalPipeline.pipelineStateShapeNodeColoredIndexed3DNoBlending
        _pipelineStateTable[.shapeNodeColoredIndexed3DAlphaBlending] = metalPipeline.pipelineStateShapeNodeColoredIndexed3DAlphaBlending
        _pipelineStateTable[.shapeNodeColoredIndexed3DAdditiveBlending] = metalPipeline.pipelineStateShapeNodeColoredIndexed3DAdditiveBlending
        _pipelineStateTable[.shapeNodeColoredIndexed3DPremultipliedBlending] = metalPipeline.pipelineStateShapeNodeColoredIndexed3DPremultipliedBlending
        _pipelineStateTable[.spriteNodeIndexed2DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexed2DNoBlending
        _pipelineStateTable[.spriteNodeIndexed2DAlphaBlending] = metalPipeline.pipelineStateSpriteNodeIndexed2DAlphaBlending
        _pipelineStateTable[.spriteNodeIndexed2DAdditiveBlending] = metalPipeline.pipelineStateSpriteNodeIndexed2DAdditiveBlending
        _pipelineStateTable[.spriteNodeIndexed2DPremultipliedBlending] = metalPipeline.pipelineStateSpriteNodeIndexed2DPremultipliedBlending
        _pipelineStateTable[.spriteNodeIndexed3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexed3DNoBlending
        _pipelineStateTable[.spriteNodeIndexed3DAlphaBlending] = metalPipeline.pipelineStateSpriteNodeIndexed3DAlphaBlending
        _pipelineStateTable[.spriteNodeIndexed3DAdditiveBlending] = metalPipeline.pipelineStateSpriteNodeIndexed3DAdditiveBlending
        _pipelineStateTable[.spriteNodeIndexed3DPremultipliedBlending] = metalPipeline.pipelineStateSpriteNodeIndexed3DPremultipliedBlending
        _pipelineStateTable[.spriteNodeStereoscopicBlueIndexed3DNoBlending] = metalPipeline.pipelineStateSpriteNodeStereoscopicBlueIndexed3DNoBlending
        _pipelineStateTable[.spriteNodeStereoscopicBlueIndexed3DAlphaBlending] = metalPipeline.pipelineStateSpriteNodeStereoscopicBlueIndexed3DAlphaBlending
        _pipelineStateTable[.spriteNodeStereoscopicBlueIndexed3DAdditiveBlending] = metalPipeline.pipelineStateSpriteNodeStereoscopicBlueIndexed3DAdditiveBlending
        _pipelineStateTable[.spriteNodeStereoscopicBlueIndexed3DPremultipliedBlending] = metalPipeline.pipelineStateSpriteNodeStereoscopicBlueIndexed3DPremultipliedBlending
        _pipelineStateTable[.spriteNodeStereoscopicRedIndexed3DNoBlending] = metalPipeline.pipelineStateSpriteNodeStereoscopicRedIndexed3DNoBlending
        _pipelineStateTable[.spriteNodeStereoscopicRedIndexed3DAlphaBlending] = metalPipeline.pipelineStateSpriteNodeStereoscopicRedIndexed3DAlphaBlending
        _pipelineStateTable[.spriteNodeStereoscopicRedIndexed3DAdditiveBlending] = metalPipeline.pipelineStateSpriteNodeStereoscopicRedIndexed3DAdditiveBlending
        _pipelineStateTable[.spriteNodeNodeStereoscopicRedIndexed3DPremultipliedBlending] = metalPipeline.pipelineStateSpriteNodeStereoscopicRedIndexed3DPremultipliedBlending
        _pipelineStateTable[.spriteNodeColoredStereoscopicBlueIndexed3DNoBlending] = metalPipeline.pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DNoBlending
        _pipelineStateTable[.spriteNodeColoredStereoscopicBlueIndexed3DAlphaBlending] = metalPipeline.pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DAlphaBlending
        _pipelineStateTable[.spriteNodeColoredStereoscopicBlueIndexed3DAdditiveBlending] = metalPipeline.pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DAdditiveBlending
        _pipelineStateTable[.spriteNodeColoredStereoscopicBlueIndexed3DPremultipliedBlending] = metalPipeline.pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DPremultipliedBlending
        _pipelineStateTable[.spriteNodeColoredStereoscopicRedIndexed3DNoBlending] = metalPipeline.pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DNoBlending
        _pipelineStateTable[.spriteNodeColoredStereoscopicRedIndexed3DAlphaBlending] = metalPipeline.pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DAlphaBlending
        _pipelineStateTable[.spriteNodeColoredStereoscopicRedIndexed3DAdditiveBlending] = metalPipeline.pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DAdditiveBlending
        _pipelineStateTable[.spriteNodeNodeColoredStereoscopicRedIndexed3DPremultipliedBlending] = metalPipeline.pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DPremultipliedBlending
        _pipelineStateTable[.spriteNodeWhiteIndexed2DNoBlending] = metalPipeline.pipelineStateSpriteNodeWhiteIndexed2DNoBlending
        _pipelineStateTable[.spriteNodeWhiteIndexed2DAlphaBlending] = metalPipeline.pipelineStateSpriteNodeWhiteIndexed2DAlphaBlending
        _pipelineStateTable[.spriteNodeWhiteIndexed2DAdditiveBlending] = metalPipeline.pipelineStateSpriteNodeWhiteIndexed2DAdditiveBlending
        _pipelineStateTable[.spriteNodeWhiteIndexed2DPremultipliedBlending] = metalPipeline.pipelineStateSpriteNodeWhiteIndexed2DPremultipliedBlending
        _pipelineStateTable[.spriteNodeWhiteIndexed3DNoBlending] = metalPipeline.pipelineStateSpriteNodeWhiteIndexed3DNoBlending
        _pipelineStateTable[.spriteNodeWhiteIndexed3DAlphaBlending] = metalPipeline.pipelineStateSpriteNodeWhiteIndexed3DAlphaBlending
        _pipelineStateTable[.spriteNodeWhiteIndexed3DAdditiveBlending] = metalPipeline.pipelineStateSpriteNodeWhiteIndexed3DAdditiveBlending
        _pipelineStateTable[.spriteNodeWhiteIndexed3DPremultipliedBlending] = metalPipeline.pipelineStateSpriteNodeWhiteIndexed3DPremultipliedBlending
        _pipelineStateTable[.spriteNodeColoredIndexed2DNoBlending] = metalPipeline.pipelineStateSpriteNodeColoredIndexed2DNoBlending
        _pipelineStateTable[.spriteNodeColoredIndexed2DAlphaBlending] = metalPipeline.pipelineStateSpriteNodeColoredIndexed2DAlphaBlending
        _pipelineStateTable[.spriteNodeColoredIndexed2DAdditiveBlending] = metalPipeline.pipelineStateSpriteNodeColoredIndexed2DAdditiveBlending
        _pipelineStateTable[.spriteNodeColoredIndexed2DPremultipliedBlending] = metalPipeline.pipelineStateSpriteNodeColoredIndexed2DPremultipliedBlending
        _pipelineStateTable[.spriteNodeIndexedDiffuse3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedDiffuse3DNoBlending
        _pipelineStateTable[.spriteNodeIndexedDiffuseStereoscopicBlue3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedDiffuseStereoscopicBlue3DNoBlending
        _pipelineStateTable[.spriteNodeIndexedDiffuseStereoscopicRed3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedDiffuseStereoscopicRed3DNoBlending
        _pipelineStateTable[.spriteNodeIndexedDiffuseColored3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedDiffuseColored3DNoBlending
        _pipelineStateTable[.spriteNodeIndexedDiffuseColoredStereoscopicBlue3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedDiffuseColoredStereoscopicBlue3DNoBlending
        _pipelineStateTable[.spriteNodeIndexedDiffuseColoredStereoscopicRed3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedDiffuseColoredStereoscopicRed3DNoBlending
        _pipelineStateTable[.spriteNodeIndexedPhong3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedPhong3DNoBlending
        _pipelineStateTable[.spriteNodeIndexedPhongColored3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedPhongColored3DNoBlending
        _pipelineStateTable[.spriteNodeIndexedPhongColoredStereoscopicRed3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedPhongColoredStereoscopicRed3DNoBlending
        _pipelineStateTable[.spriteNodeIndexedPhongColoredStereoscopicBlue3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedPhongColoredStereoscopicBlue3DNoBlending
        _pipelineStateTable[.spriteNodeIndexedNight3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedNight3DNoBlending
        _pipelineStateTable[.spriteNodeIndexedNightStereoscopicBlue3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedNightStereoscopicBlue3DNoBlending
        _pipelineStateTable[.spriteNodeIndexedNightStereoscopicRed3DNoBlending] = metalPipeline.pipelineStateSpriteNodeIndexedNightStereoscopicRed3DNoBlending
        _pipelineStateTable[.spriteNodeColoredWhiteIndexed2DNoBlending] = metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed2DNoBlending
        _pipelineStateTable[.spriteNodeColoredWhiteIndexed2DAlphaBlending] = metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed2DAlphaBlending
        _pipelineStateTable[.spriteNodeColoredWhiteIndexed2DAdditiveBlending] = metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed2DAdditiveBlending
        _pipelineStateTable[.spriteNodeColoredWhiteIndexed2DPremultipliedBlending] = metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed2DPremultipliedBlending
        _pipelineStateTable[.spriteNodeColoredIndexed3DNoBlending] = metalPipeline.pipelineStateSpriteNodeColoredIndexed3DNoBlending
        _pipelineStateTable[.spriteNodeColoredIndexed3DAlphaBlending] = metalPipeline.pipelineStateSpriteNodeColoredIndexed3DAlphaBlending
        _pipelineStateTable[.spriteNodeColoredIndexed3DAdditiveBlending] = metalPipeline.pipelineStateSpriteNodeColoredIndexed3DAdditiveBlending
        _pipelineStateTable[.spriteNodeColoredIndexed3DPremultipliedBlending] = metalPipeline.pipelineStateSpriteNodeColoredIndexed3DPremultipliedBlending
        _pipelineStateTable[.spriteNodeColoredWhiteIndexed3DNoBlending] = metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed3DNoBlending
        _pipelineStateTable[.spriteNodeColoredWhiteIndexed3DAlphaBlending] = metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed3DAlphaBlending
        _pipelineStateTable[.spriteNodeColoredWhiteIndexed3DAdditiveBlending] = metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed3DAdditiveBlending
        _pipelineStateTable[.spriteNodeColoredWhiteIndexed3DPremultipliedBlending] = metalPipeline.pipelineStateSpriteNodeColoredWhiteIndexed3DPremultipliedBlending
        _pipelineStateTable[.gaussianBlurHorizontalIndexedNoBlending] = metalPipeline.pipelineStateGaussianBlurHorizontalIndexedNoBlending
        _pipelineStateTable[.gaussianBlurVerticalIndexedNoBlending] = metalPipeline.pipelineStateGaussianBlurVerticalIndexedNoBlending
    }
    
    func set(pipelineState: PipelineState, renderEncoder: MTLRenderCommandEncoder) {
        self.pipelineState = pipelineState
        if let metalState = _pipelineStateTable[pipelineState] {
            renderEncoder.setRenderPipelineState(metalState)
        }
    }
    
    func set(depthState: DepthState, renderEncoder: MTLRenderCommandEncoder) {
        if let metalEngine {
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
    }
    
    func set(samplerState: SamplerState, renderEncoder: MTLRenderCommandEncoder) {
        
        self.samplerState = samplerState
        
        if let metalEngine {
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
