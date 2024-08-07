//
//  Graphics.swift
//  RebuildEarth
//
//  Created by Nicky Taylor on 2/9/23.
//

import Foundation
import Metal
import MetalKit
import UIKit

protocol GraphicsDelegate: AnyObject {
    
    var graphics: Graphics! { get set }
    
    func load()
    
    func loadComplete()
    
    func initialize()
    
    func update(deltaTime: Float, stereoSpreadBase: Float, stereoSpreadMax: Float)
    
    
    func predraw()
    func draw3DPrebloom(renderEncoder: MTLRenderCommandEncoder)
    func draw3DBloom(renderEncoder: MTLRenderCommandEncoder)
    
    func draw3DStereoscopicBlue(renderEncoder: MTLRenderCommandEncoder, stereoSpreadBase: Float, stereoSpreadMax: Float)
    func draw3DStereoscopicRed(renderEncoder: MTLRenderCommandEncoder, stereoSpreadBase: Float, stereoSpreadMax: Float)
    
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
        // 4
        
        case shapeNodeIndexed3DNoBlending
        case shapeNodeIndexed3DAlphaBlending
        case shapeNodeIndexed3DAdditiveBlending
        case shapeNodeIndexed3DPremultipliedBlending
        // 8
        
        case shapeNodeIndexedDiffuse3DNoBlending
        case shapeNodeIndexedDiffuseColored3DNoBlending
        case shapeNodeIndexedPhong3DNoBlending
        case shapeNodeIndexedPhongColored3DNoBlending
        // 12
        
        case shapeNodeColoredIndexed2DNoBlending
        case shapeNodeColoredIndexed2DAlphaBlending
        case shapeNodeColoredIndexed2DAdditiveBlending
        case shapeNodeColoredIndexed2DPremultipliedBlending
        // 16
        
        case shapeNodeColoredIndexed3DNoBlending
        case shapeNodeColoredIndexed3DAlphaBlending
        case shapeNodeColoredIndexed3DAdditiveBlending
        case shapeNodeColoredIndexed3DPremultipliedBlending
        // 20
        
        case spriteNodeIndexed2DNoBlending
        case spriteNodeIndexed2DAlphaBlending
        case spriteNodeIndexed2DAdditiveBlending
        case spriteNodeIndexed2DPremultipliedBlending
        // 24
        
        case spriteNodeIndexed3DNoBlending
        case spriteNodeIndexed3DAlphaBlending
        case spriteNodeIndexed3DAdditiveBlending
        case spriteNodeIndexed3DPremultipliedBlending
        // 28
        
        case spriteNodeStereoscopicBlueIndexed3DNoBlending
        case spriteNodeStereoscopicBlueIndexed3DAlphaBlending
        case spriteNodeStereoscopicBlueIndexed3DAdditiveBlending
        case spriteNodeStereoscopicBlueIndexed3DPremultipliedBlending
        // 32
        
        case spriteNodeStereoscopicRedIndexed3DNoBlending
        case spriteNodeStereoscopicRedIndexed3DAlphaBlending
        case spriteNodeStereoscopicRedIndexed3DAdditiveBlending
        case spriteNodeNodeStereoscopicRedIndexed3DPremultipliedBlending
        // 36
        
        case spriteNodeColoredStereoscopicBlueIndexed3DNoBlending
        case spriteNodeColoredStereoscopicBlueIndexed3DAlphaBlending
        case spriteNodeColoredStereoscopicBlueIndexed3DAdditiveBlending
        case spriteNodeColoredStereoscopicBlueIndexed3DPremultipliedBlending
        // 40
        
        case spriteNodeColoredStereoscopicRedIndexed3DNoBlending
        case spriteNodeColoredStereoscopicRedIndexed3DAlphaBlending
        case spriteNodeColoredStereoscopicRedIndexed3DAdditiveBlending
        case spriteNodeNodeColoredStereoscopicRedIndexed3DPremultipliedBlending
        // 44
        
        case spriteNodeIndexedDiffuse3DNoBlending
        case spriteNodeIndexedDiffuseStereoscopicBlue3DNoBlending
        case spriteNodeIndexedDiffuseStereoscopicRed3DNoBlending
        // 47
        
        case spriteNodeIndexedDiffuseColored3DNoBlending
        case spriteNodeIndexedDiffuseColoredStereoscopicBlue3DNoBlending
        case spriteNodeIndexedDiffuseColoredStereoscopicRed3DNoBlending
        // 50
        
        case spriteNodeIndexedPhong3DNoBlending
        case spriteNodeIndexedPhongStereoscopicRed3DNoBlending
        case spriteNodeIndexedPhongStereoscopicBlue3DNoBlending
        // 53
        
        case spriteNodeIndexedPhongColored3DNoBlending
        case spriteNodeIndexedPhongColoredStereoscopicRed3DNoBlending
        case spriteNodeIndexedPhongColoredStereoscopicBlue3DNoBlending
        // 56
        
        case spriteNodeIndexedNight3DNoBlending
        case spriteNodeIndexedNightStereoscopicBlue3DNoBlending
        case spriteNodeIndexedNightStereoscopicRed3DNoBlending
        // 59
        
        case spriteNodeWhiteIndexed2DNoBlending
        case spriteNodeWhiteIndexed2DAlphaBlending
        case spriteNodeWhiteIndexed2DAdditiveBlending
        case spriteNodeWhiteIndexed2DPremultipliedBlending
        // 63
        
        case spriteNodeWhiteIndexed3DNoBlending
        case spriteNodeWhiteIndexed3DAlphaBlending
        case spriteNodeWhiteIndexed3DAdditiveBlending
        case spriteNodeWhiteIndexed3DPremultipliedBlending
        //67
        
        case spriteNodeColoredIndexed2DNoBlending
        case spriteNodeColoredIndexed2DAlphaBlending
        case spriteNodeColoredIndexed2DAdditiveBlending
        case spriteNodeColoredIndexed2DPremultipliedBlending
        //71
        
        case spriteNodeColoredIndexed3DNoBlending
        case spriteNodeColoredIndexed3DAlphaBlending
        case spriteNodeColoredIndexed3DAdditiveBlending
        case spriteNodeColoredIndexed3DPremultipliedBlending
        //75
        
        case spriteNodeColoredWhiteIndexed2DNoBlending
        case spriteNodeColoredWhiteIndexed2DAlphaBlending
        case spriteNodeColoredWhiteIndexed2DAdditiveBlending
        case spriteNodeColoredWhiteIndexed2DPremultipliedBlending
        //79
        
        case spriteNodeColoredWhiteIndexed3DNoBlending
        case spriteNodeColoredWhiteIndexed3DAlphaBlending
        case spriteNodeColoredWhiteIndexed3DAdditiveBlending
        case spriteNodeColoredWhiteIndexed3DPremultipliedBlending
        //83
        
        case gaussianBlurHorizontalIndexedNoBlending
        case gaussianBlurVerticalIndexedNoBlending
        //85
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
    
    lazy var scaledTextureSuffix: String = {
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
    
    func loadTexture(name: String, `extension`: String) -> MTLTexture? {
        if let bundleResourcePath = Bundle.main.resourcePath {
            let filePath = bundleResourcePath + "/" + name + "." + `extension`
            let fileURL = URL(filePath: filePath)
            return loadTexture(url: fileURL)
        }
        return nil
    }
    
    func loadTexture(nameWithExtension: String) -> MTLTexture? {
        if let bundleResourcePath = Bundle.main.resourcePath {
            let filePath = bundleResourcePath + "/" + nameWithExtension
            let fileURL = URL(filePath: filePath)
            return loadTexture(url: fileURL)
        }
        return nil
    }
    
    func loadTextureScaled(name: String, `extension`: String) -> MTLTexture? {
        if let bundleResourcePath = Bundle.main.resourcePath {
            let filePath = bundleResourcePath + "/" + name + scaledTextureSuffix + "." + `extension`
            let fileURL = URL(filePath: filePath)
            return loadTexture(url: fileURL)
        }
        return nil
    }
    
    func loadTexture(url: URL) -> MTLTexture? {
        guard let uiImage = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        return loadTexture(cgImage: uiImage.cgImage)
    }
    
    func loadTexture(cgImage: CGImage?) -> MTLTexture? {
        
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
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
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
    
    func loadTexture(uiImage: UIImage?) -> MTLTexture? {
        loadTexture(cgImage: uiImage?.cgImage)
    }
    
    func loadTexture(fileName: String) -> MTLTexture? {
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
            
                case .spriteNodeIndexedPhongStereoscopicBlue3DNoBlending:
                    renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedPhongStereoscopicBlue3DNoBlending)

                case .spriteNodeIndexedPhongStereoscopicRed3DNoBlending:
                    renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedPhongStereoscopicRed3DNoBlending)
            
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
            
            
            
            
        case .spriteNodeStereoscopicBlueIndexed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicBlueIndexed3DNoBlending)
        case .spriteNodeStereoscopicBlueIndexed3DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicBlueIndexed3DAlphaBlending)
        case .spriteNodeStereoscopicBlueIndexed3DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicBlueIndexed3DAdditiveBlending)
        case .spriteNodeStereoscopicBlueIndexed3DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicBlueIndexed3DPremultipliedBlending)
        
        case .spriteNodeStereoscopicRedIndexed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicRedIndexed3DNoBlending)
        case .spriteNodeStereoscopicRedIndexed3DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicRedIndexed3DAlphaBlending)
        case .spriteNodeStereoscopicRedIndexed3DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicRedIndexed3DAdditiveBlending)
        case .spriteNodeNodeStereoscopicRedIndexed3DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeStereoscopicRedIndexed3DPremultipliedBlending)
            
        case .spriteNodeColoredStereoscopicBlueIndexed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DNoBlending)
        case .spriteNodeColoredStereoscopicBlueIndexed3DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DAlphaBlending)
        case .spriteNodeColoredStereoscopicBlueIndexed3DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DAdditiveBlending)
        case .spriteNodeColoredStereoscopicBlueIndexed3DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DPremultipliedBlending)
        
        case .spriteNodeColoredStereoscopicRedIndexed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DNoBlending)
        case .spriteNodeColoredStereoscopicRedIndexed3DAlphaBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DAlphaBlending)
        case .spriteNodeColoredStereoscopicRedIndexed3DAdditiveBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DAdditiveBlending)
        case .spriteNodeNodeColoredStereoscopicRedIndexed3DPremultipliedBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DPremultipliedBlending)
            
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
            
        


        case .spriteNodeIndexedDiffuseStereoscopicBlue3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedDiffuseStereoscopicBlue3DNoBlending)
        case .spriteNodeIndexedDiffuseStereoscopicRed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedDiffuseStereoscopicRed3DNoBlending)
            
            
        case .spriteNodeIndexedDiffuseColored3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedDiffuseColored3DNoBlending)
        case .spriteNodeIndexedDiffuseColoredStereoscopicBlue3DNoBlending:
                    renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedDiffuseColoredStereoscopicBlue3DNoBlending)
                case .spriteNodeIndexedDiffuseColoredStereoscopicRed3DNoBlending:
                    renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedDiffuseColoredStereoscopicRed3DNoBlending)
            
        case .spriteNodeIndexedPhong3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedPhong3DNoBlending)
            
            
        case .spriteNodeIndexedPhongColored3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedPhongColored3DNoBlending)
            
        case .spriteNodeIndexedPhongColoredStereoscopicRed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedPhongColoredStereoscopicRed3DNoBlending)
        case .spriteNodeIndexedPhongColoredStereoscopicBlue3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedPhongColoredStereoscopicBlue3DNoBlending)
            
            
            
        case .spriteNodeIndexedNight3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedNight3DNoBlending)
            
            
        case .spriteNodeIndexedNightStereoscopicBlue3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedNightStereoscopicBlue3DNoBlending)
        case .spriteNodeIndexedNightStereoscopicRed3DNoBlending:
            renderEncoder.setRenderPipelineState(metalPipeline.pipelineStateSpriteNodeIndexedNightStereoscopicRed3DNoBlending)
            
            
       
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
