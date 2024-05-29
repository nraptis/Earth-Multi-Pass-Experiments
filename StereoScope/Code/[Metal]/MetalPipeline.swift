//
//  MetalPipeline.swift
//  RebuildEarth
//
//  Created by Nicky Taylor on 2/10/23.
//

import Foundation
import UIKit
import Metal

class MetalPipeline {
    
    static let slotVertexData = 0
    static let slotVertexUniforms = 1
    
    static let slotFragmentTexture = 0
    static let slotFragmentSampler = 1
    static let slotFragmentUniforms = 2
    static let slotFragmentLightTexture = 3
    static let slotFragmentBumpTexture = 4
    static let slotFragmentDisplacementTexture = 5
    
    private let metalEngine: MetalEngine
    private let metalLibrary: MTLLibrary
    private let metalLayer: CAMetalLayer
    private let metalDevice: MTLDevice
    
    init(metalEngine: MetalEngine) {
        self.metalEngine = metalEngine
        metalLibrary = metalEngine.metalLibrary
        metalLayer = metalEngine.metalLayer
        metalDevice = metalEngine.metalDevice
        print("[++] MetalPipeline")
    }
    
    deinit {
        print("[--] MetalPipeline")
    }
    
    
    private var shapeNodeIndexed2DVertexProgram: MTLFunction!
    private var shapeNodeIndexed2DFragmentProgram: MTLFunction!
    private var shapeNodeIndexed3DVertexProgram: MTLFunction!
    private var shapeNodeIndexed3DFragmentProgram: MTLFunction!
    private var shapeNodeIndexedPhong3DVertexProgram: MTLFunction!
    private var shapeNodeIndexedPhong3DFragmentProgram: MTLFunction!
    
    private var shapeNodeIndexedDiffuse3DVertexProgram: MTLFunction!
    private var shapeNodeIndexedDiffuse3DFragmentProgram: MTLFunction!
    private var shapeNodeColoredIndexed2DVertexProgram: MTLFunction!
    private var shapeNodeColoredIndexed2DFragmentProgram: MTLFunction!
    private var shapeNodeColoredIndexed3DVertexProgram: MTLFunction!
    private var shapeNodeColoredIndexed3DFragmentProgram: MTLFunction!
    private var shapeNodeIndexedPhongColored3DVertexProgram: MTLFunction!
    private var shapeNodeIndexedPhongColored3DFragmentProgram: MTLFunction!
    
    private var spriteNodeIndexedPhongColoredStereoscopicRed3DVertexProgram: MTLFunction!
        private var spriteNodeIndexedPhongColoredStereoscopicRed3DFragmentProgram: MTLFunction!
        private var spriteNodeIndexedPhongColoredStereoscopicBlue3DVertexProgram: MTLFunction!
        private var spriteNodeIndexedPhongColoredStereoscopicBlue3DFragmentProgram: MTLFunction!
    
    private var shapeNodeIndexedDiffuseColored3DVertexProgram: MTLFunction!
    private var shapeNodeIndexedDiffuseColored3DFragmentProgram: MTLFunction!
    
    private var spriteNodeIndexed2DVertexProgram: MTLFunction!
    private var spriteNodeIndexed2DFragmentProgram: MTLFunction!
    private var spriteNodeWhiteIndexed2DFragmentProgram: MTLFunction!
    private var spriteNodeIndexed3DVertexProgram: MTLFunction!
    private var spriteNodeIndexed3DFragmentProgram: MTLFunction!
    private var spriteNodeIndexedPhong3DVertexProgram: MTLFunction!
    private var spriteNodeIndexedPhong3DFragmentProgram: MTLFunction!
    
    private var spriteNodeIndexedPhongStereoscopicRed3DVertexProgram: MTLFunction!
    private var spriteNodeIndexedPhongStereoscopicRed3DFragmentProgram: MTLFunction!
    private var spriteNodeIndexedPhongStereoscopicBlue3DVertexProgram: MTLFunction!
    private var spriteNodeIndexedPhongStereoscopicBlue3DFragmentProgram: MTLFunction!
    
    
    private var spriteNodeIndexedDiffuse3DVertexProgram: MTLFunction!
    private var spriteNodeIndexedDiffuse3DFragmentProgram: MTLFunction!
    
    
    private var spriteNodeIndexedDiffuseStereoscopicRed3DVertexProgram: MTLFunction!
    private var spriteNodeIndexedDiffuseStereoscopicRed3DFragmentProgram: MTLFunction!
    private var spriteNodeIndexedDiffuseStereoscopicBlue3DVertexProgram: MTLFunction!
    private var spriteNodeIndexedDiffuseStereoscopicBlue3DFragmentProgram: MTLFunction!
    
    
    
    private var spriteNodeIndexedNight3DVertexProgram: MTLFunction!
    private var spriteNodeIndexedNight3DFragmentProgram: MTLFunction!
    private var spriteNodeIndexedNightStereoscopicRed3DVertexProgram: MTLFunction!
    private var spriteNodeIndexedNightStereoscopicRed3DFragmentProgram: MTLFunction!
    private var spriteNodeIndexedNightStereoscopicBlue3DVertexProgram: MTLFunction!
    private var spriteNodeIndexedNightStereoscopicBlue3DFragmentProgram: MTLFunction!
    
    
    
    private var spriteNodeWhiteIndexed3DFragmentProgram: MTLFunction!
    private var spriteNodeColoredIndexed2DVertexProgram: MTLFunction!
    private var spriteNodeColoredIndexed2DFragmentProgram: MTLFunction!
    private var spriteNodeColoredWhiteIndexed2DFragmentProgram: MTLFunction!
    private var spriteNodeColoredIndexed3DVertexProgram: MTLFunction!
    private var spriteNodeColoredIndexed3DFragmentProgram: MTLFunction!
    
    private var spriteNodeColoredStereoscopicRedIndexed3DVertexProgram: MTLFunction!
    private var spriteNodeColoredStereoscopicRedIndexed3DFragmentProgram: MTLFunction!
    private var spriteNodeColoredStereoscopicBlueIndexed3DVertexProgram: MTLFunction!
    private var spriteNodeColoredStereoscopicBlueIndexed3DFragmentProgram: MTLFunction!
    
    
    private var spriteNodeColoredWhiteIndexed3DFragmentProgram: MTLFunction!
    private var spriteNodeIndexedPhongColored3DVertexProgram: MTLFunction!
    private var spriteNodeIndexedPhongColored3DFragmentProgram: MTLFunction!
    
    private var spriteNodeIndexedDiffuseColored3DVertexProgram: MTLFunction!
    private var spriteNodeIndexedDiffuseColored3DFragmentProgram: MTLFunction!
    
    private var spriteNodeIndexedDiffuseColoredStereoscopicRed3DVertexProgram: MTLFunction!
    private var spriteNodeIndexedDiffuseColoredStereoscopicRed3DFragmentProgram: MTLFunction!
    private var spriteNodeIndexedDiffuseColoredStereoscopicBlue3DVertexProgram: MTLFunction!
    private var spriteNodeIndexedDiffuseColoredStereoscopicBlue3DFragmentProgram: MTLFunction!
    
    private var spriteNodeStereoscopicBlueIndexed3DVertexProgram: MTLFunction!
    private var spriteNodeStereoscopicBlueIndexed3DFragmentProgram: MTLFunction!
    private var spriteNodeStereoscopicRedIndexed3DVertexProgram: MTLFunction!
    private var spriteNodeStereoscopicRedIndexed3DFragmentProgram: MTLFunction!
    
    private var gaussianBlurIndexedVertexProgram: MTLFunction!
    
    private var gaussianBlurIndexedHorizontalFragmentProgram: MTLFunction!
    private var gaussianBlurIndexedVerticalFragmentProgram: MTLFunction!
    
    
    
    
    private(set) var pipelineStateShapeNodeIndexed2DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeIndexed2DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeIndexed2DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeIndexed2DPremultipliedBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeIndexed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeIndexed3DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeIndexed3DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeIndexed3DPremultipliedBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeColoredIndexed2DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeColoredIndexed2DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeColoredIndexed2DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeColoredIndexed2DPremultipliedBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeColoredIndexed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeColoredIndexed3DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeColoredIndexed3DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeColoredIndexed3DPremultipliedBlending: MTLRenderPipelineState!
    
    private(set) var pipelineStateShapeNodeIndexedPhong3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeIndexedPhongColored3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeIndexedDiffuse3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateShapeNodeIndexedDiffuseColored3DNoBlending: MTLRenderPipelineState!
    
    
    
    
    
    
    private(set) var pipelineStateSpriteNodeIndexed2DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexed2DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexed2DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexed2DPremultipliedBlending: MTLRenderPipelineState!
    
    private(set) var pipelineStateSpriteNodeIndexed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexed3DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexed3DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexed3DPremultipliedBlending: MTLRenderPipelineState!
    
    private(set) var pipelineStateSpriteNodeStereoscopicBlueIndexed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeStereoscopicBlueIndexed3DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeStereoscopicBlueIndexed3DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeStereoscopicBlueIndexed3DPremultipliedBlending: MTLRenderPipelineState!
    
    private(set) var pipelineStateSpriteNodeStereoscopicRedIndexed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeStereoscopicRedIndexed3DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeStereoscopicRedIndexed3DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeStereoscopicRedIndexed3DPremultipliedBlending: MTLRenderPipelineState!
    
    private(set) var pipelineStateSpriteNodeWhiteIndexed2DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeWhiteIndexed2DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeWhiteIndexed2DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeWhiteIndexed2DPremultipliedBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeWhiteIndexed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeWhiteIndexed3DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeWhiteIndexed3DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeWhiteIndexed3DPremultipliedBlending: MTLRenderPipelineState!
    
    private(set) var pipelineStateSpriteNodeColoredIndexed2DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredIndexed2DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredIndexed2DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredIndexed2DPremultipliedBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredIndexed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredIndexed3DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredIndexed3DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredIndexed3DPremultipliedBlending: MTLRenderPipelineState!
    
    private(set) var pipelineStateSpriteNodeColoredStereoscopicBlueIndexed2DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredStereoscopicBlueIndexed2DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredStereoscopicBlueIndexed2DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredStereoscopicBlueIndexed2DPremultipliedBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DPremultipliedBlending: MTLRenderPipelineState!
    
    private(set) var pipelineStateSpriteNodeColoredStereoscopicRedIndexed2DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredStereoscopicRedIndexed2DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredStereoscopicRedIndexed2DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredStereoscopicRedIndexed2DPremultipliedBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DPremultipliedBlending: MTLRenderPipelineState!
    
    
    
    private(set) var pipelineStateSpriteNodeIndexedPhong3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexedPhongStereoscopicRed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexedPhongStereoscopicBlue3DNoBlending: MTLRenderPipelineState!
    
    
    private(set) var pipelineStateSpriteNodeIndexedPhongColored3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexedPhongColoredStereoscopicRed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexedPhongColoredStereoscopicBlue3DNoBlending: MTLRenderPipelineState!
    
    
    private(set) var pipelineStateSpriteNodeIndexedDiffuse3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexedDiffuseStereoscopicRed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexedDiffuseStereoscopicBlue3DNoBlending: MTLRenderPipelineState!
    
    private(set) var pipelineStateSpriteNodeIndexedDiffuseColored3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexedDiffuseColoredStereoscopicRed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexedDiffuseColoredStereoscopicBlue3DNoBlending: MTLRenderPipelineState!
    
    private(set) var pipelineStateSpriteNodeIndexedNight3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexedNightStereoscopicRed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeIndexedNightStereoscopicBlue3DNoBlending: MTLRenderPipelineState!
    
    private(set) var pipelineStateSpriteNodeColoredWhiteIndexed2DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredWhiteIndexed2DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredWhiteIndexed2DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredWhiteIndexed2DPremultipliedBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredWhiteIndexed3DNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredWhiteIndexed3DAlphaBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredWhiteIndexed3DAdditiveBlending: MTLRenderPipelineState!
    private(set) var pipelineStateSpriteNodeColoredWhiteIndexed3DPremultipliedBlending: MTLRenderPipelineState!
    
    
    private(set) var pipelineStateGaussianBlurHorizontalIndexedNoBlending: MTLRenderPipelineState!
    private(set) var pipelineStateGaussianBlurVerticalIndexedNoBlending: MTLRenderPipelineState!
    
    func load() {
        buildFunctions()
        
        
        buildPipelineStatesShapeNodeIndexed2D()
        buildPipelineStatesShapeNodeIndexed3D()
        buildPipelineStatesShapeNodeDiffuseIndexed3D()
        buildPipelineStatesShapeNodeDiffuseColoredIndexed3D()
        buildPipelineStatesShapeNodePhongIndexed3D()
        buildPipelineStatesShapeNodePhongColoredIndexed3D()
        buildPipelineStatesShapeNodeColoredIndexed2D()
        buildPipelineStatesShapeNodeColoredIndexed3D()
        
        buildPipelineStatesSpriteNodeColoredStereoscopicBlueIndexed3D()
        buildPipelineStatesSpriteNodeColoredStereoscopicRedIndexed3D()
        
        
        
        buildPipelineStatesSpriteNodeIndexed2D()
        buildPipelineStatesSpriteNodeIndexed3D()
        
        buildPipelineStatesSpriteNodeStereoscopicBlueIndexed3D()
        buildPipelineStatesSpriteNodeStereoscopicRedIndexed3D()
        
        
        buildPipelineStatesSpriteNodeDiffuseIndexed3D()
        buildPipelineStatesSpriteNodeDiffuseStereoscopicRedIndexed3D()
        buildPipelineStatesSpriteNodeDiffuseStereoscopicBlueIndexed3D()
        
        buildPipelineStatesSpriteNodeDiffuseColoredIndexed3D()
        buildPipelineStatesSpriteNodeDiffuseColoredStereoscopicBlueIndexed3D()
        buildPipelineStatesSpriteNodeDiffuseColoredStereoscopicRedIndexed3D()
        
        
        buildPipelineStatesSpriteNodePhongIndexed3D()
        buildPipelineStatesSpriteNodePhongStereoscopicRedIndexed3D()
        buildPipelineStatesSpriteNodePhongStereoscopicBlueIndexed3D()
        
        buildPipelineStatesSpriteNodePhongColoredIndexed3D()
        buildPipelineStatesSpriteNodePhongColoredStereoscopicRedIndexed3D()        
        buildPipelineStatesSpriteNodePhongColoredStereoscopicBlueIndexed3D()
        
        
        buildPipelineStatesSpriteNodeNightIndexed3D()
        buildPipelineStatesSpriteNodeNightStereoscopicRedIndexed3D()
        buildPipelineStatesSpriteNodeNightStereoscopicBlueIndexed3D()
        
        buildPipelineStatesSpriteNodeWhiteIndexed2D()
        buildPipelineStatesSpriteNodeWhiteIndexed3D()
        
        buildPipelineStatesSpriteNodeColoredIndexed2D()
        buildPipelineStatesSpriteNodeColoredIndexed3D()
        buildPipelineStatesSpriteNodeColoredWhiteIndexed2D()
        buildPipelineStatesSpriteNodeColoredWhiteIndexed3D()
        
        buildPipelineStatesGaussianBlur()
    }
    
    private func buildFunctions() {
        
        
        shapeNodeIndexed2DVertexProgram = metalLibrary.makeFunction(name: "shape_node_2d_vertex")
        shapeNodeIndexed2DFragmentProgram = metalLibrary.makeFunction(name: "shape_node_2d_fragment")
        shapeNodeIndexed3DVertexProgram = metalLibrary.makeFunction(name: "shape_node_3d_vertex")!
        shapeNodeIndexed3DFragmentProgram = metalLibrary.makeFunction(name: "shape_node_3d_fragment")!
        
        shapeNodeIndexedPhong3DVertexProgram = metalLibrary.makeFunction(name: "shape_node_phong_3d_vertex")!
        shapeNodeIndexedPhong3DFragmentProgram = metalLibrary.makeFunction(name: "shape_node_phong_3d_fragment")!
        
        shapeNodeIndexedPhongColored3DVertexProgram = metalLibrary.makeFunction(name: "shape_node_phong_colored_3d_vertex")!
        shapeNodeIndexedPhongColored3DFragmentProgram = metalLibrary.makeFunction(name: "shape_node_phong_colored_3d_fragment")!
        
        spriteNodeIndexedPhongColoredStereoscopicRed3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_phong_colored_stereoscopic_red_3d_vertex")!
                spriteNodeIndexedPhongColoredStereoscopicRed3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_phong_colored_stereoscopic_red_3d_fragment")!
                spriteNodeIndexedPhongColoredStereoscopicBlue3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_phong_colored_stereoscopic_blue_3d_vertex")!
                spriteNodeIndexedPhongColoredStereoscopicBlue3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_phong_colored_stereoscopic_blue_3d_fragment")!
        
        
        shapeNodeIndexedDiffuse3DVertexProgram = metalLibrary.makeFunction(name: "shape_node_diffuse_3d_vertex")!
        shapeNodeIndexedDiffuse3DFragmentProgram = metalLibrary.makeFunction(name: "shape_node_diffuse_3d_fragment")!
        
        shapeNodeIndexedDiffuseColored3DVertexProgram = metalLibrary.makeFunction(name: "shape_node_diffuse_colored_3d_vertex")!
        shapeNodeIndexedDiffuseColored3DFragmentProgram = metalLibrary.makeFunction(name: "shape_node_diffuse_colored_3d_fragment")!
        
        shapeNodeColoredIndexed2DVertexProgram = metalLibrary.makeFunction(name: "shape_node_colored_2d_vertex")
        shapeNodeColoredIndexed2DFragmentProgram = metalLibrary.makeFunction(name: "shape_node_colored_2d_fragment")
        shapeNodeColoredIndexed3DVertexProgram = metalLibrary.makeFunction(name: "shape_node_colored_3d_vertex")
        shapeNodeColoredIndexed3DFragmentProgram = metalLibrary.makeFunction(name: "shape_node_colored_3d_fragment")
        
        
        
        spriteNodeIndexed2DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_2d_vertex")
        spriteNodeIndexed2DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_2d_fragment")
        spriteNodeIndexed3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_3d_vertex")!
        spriteNodeIndexed3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_3d_fragment")!
        
        
        spriteNodeStereoscopicBlueIndexed3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_stereoscopic_blue_3d_vertex")!
        spriteNodeStereoscopicBlueIndexed3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_stereoscopic_blue_3d_fragment")!
        spriteNodeStereoscopicRedIndexed3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_stereoscopic_red_3d_vertex")!
        spriteNodeStereoscopicRedIndexed3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_stereoscopic_red_3d_fragment")!
        
        
        spriteNodeIndexedPhong3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_phong_3d_vertex")!
        spriteNodeIndexedPhong3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_phong_3d_fragment")!
        
        spriteNodeIndexedPhongColored3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_phong_colored_3d_vertex")!
        spriteNodeIndexedPhongColored3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_phong_colored_3d_fragment")!
        
        spriteNodeIndexedPhongStereoscopicRed3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_phong_stereoscopic_red_3d_vertex")!
        spriteNodeIndexedPhongStereoscopicRed3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_phong_stereoscopic_red_3d_fragment")!
        spriteNodeIndexedPhongStereoscopicBlue3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_phong_stereoscopic_blue_3d_vertex")!
        spriteNodeIndexedPhongStereoscopicBlue3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_phong_stereoscopic_blue_3d_fragment")!
        
        
        spriteNodeIndexedDiffuse3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_diffuse_3d_vertex")!
        spriteNodeIndexedDiffuse3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_diffuse_3d_fragment")!
        
        
        spriteNodeIndexedDiffuseStereoscopicBlue3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_diffuse_stereoscopic_blue_3d_vertex")!
        spriteNodeIndexedDiffuseStereoscopicBlue3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_diffuse_stereoscopic_blue_3d_fragment")!
        spriteNodeIndexedDiffuseStereoscopicRed3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_diffuse_stereoscopic_red_3d_vertex")!
        spriteNodeIndexedDiffuseStereoscopicRed3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_diffuse_stereoscopic_red_3d_fragment")!
        
        
        spriteNodeIndexedDiffuseColored3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_diffuse_colored_3d_vertex")!
        spriteNodeIndexedDiffuseColored3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_diffuse_colored_3d_fragment")!
        
        spriteNodeIndexedDiffuseColoredStereoscopicBlue3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_diffuse_colored_stereoscopic_blue_3d_vertex")!
        spriteNodeIndexedDiffuseColoredStereoscopicBlue3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_diffuse_colored_stereoscopic_blue_3d_fragment")!
                spriteNodeIndexedDiffuseColoredStereoscopicRed3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_diffuse_colored_stereoscopic_red_3d_vertex")!
                spriteNodeIndexedDiffuseColoredStereoscopicRed3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_diffuse_colored_stereoscopic_red_3d_fragment")!


        
        
        spriteNodeWhiteIndexed2DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_white_2d_fragment")!
        spriteNodeWhiteIndexed3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_white_3d_fragment")!
        
        spriteNodeColoredIndexed2DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_colored_2d_vertex")
        spriteNodeColoredIndexed2DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_colored_2d_fragment")
        spriteNodeColoredIndexed3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_colored_3d_vertex")
        spriteNodeColoredIndexed3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_colored_3d_fragment")
        
        spriteNodeColoredStereoscopicBlueIndexed3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_colored_stereoscopic_blue_3d_vertex")!
        spriteNodeColoredStereoscopicBlueIndexed3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_colored_stereoscopic_blue_3d_fragment")!
        spriteNodeColoredStereoscopicRedIndexed3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_colored_stereoscopic_red_3d_vertex")!
        spriteNodeColoredStereoscopicRedIndexed3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_colored_stereoscopic_red_3d_fragment")!
        
        
        spriteNodeColoredWhiteIndexed2DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_colored_white_2d_fragment")!
        spriteNodeColoredWhiteIndexed3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_colored_white_3d_fragment")!
        
        spriteNodeIndexedNight3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_night_3d_vertex")!
        spriteNodeIndexedNight3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_night_3d_fragment")!
        spriteNodeIndexedNightStereoscopicRed3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_night_stereoscopic_red_3d_vertex")!
        spriteNodeIndexedNightStereoscopicRed3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_night_stereoscopic_red_3d_fragment")!
        spriteNodeIndexedNightStereoscopicBlue3DVertexProgram = metalLibrary.makeFunction(name: "sprite_node_night_stereoscopic_blue_3d_vertex")!
        spriteNodeIndexedNightStereoscopicBlue3DFragmentProgram = metalLibrary.makeFunction(name: "sprite_node_night_stereoscopic_blue_3d_fragment")!
        
        
        
        gaussianBlurIndexedVertexProgram = metalLibrary.makeFunction(name: "gaussian_blur_vertex")!
        
        gaussianBlurIndexedHorizontalFragmentProgram = metalLibrary.makeFunction(name: "gaussian_blur_horizontal_fragment")!
        gaussianBlurIndexedVerticalFragmentProgram = metalLibrary.makeFunction(name: "gaussian_blur_vertical_fragment")!
    }
    
    private func buildPipelineStatesShapeNodeIndexed2D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = shapeNodeIndexed2DVertexProgram
        pipelineDescriptor.fragmentFunction = shapeNodeIndexed2DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.rasterSampleCount = 4
        pipelineStateShapeNodeIndexed2DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateShapeNodeIndexed2DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateShapeNodeIndexed2DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateShapeNodeIndexed2DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    private func buildPipelineStatesShapeNodeIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = shapeNodeIndexed3DVertexProgram
        pipelineDescriptor.fragmentFunction = shapeNodeIndexed3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateShapeNodeIndexed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateShapeNodeIndexed3DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateShapeNodeIndexed3DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateShapeNodeIndexed3DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func buildPipelineStatesShapeNodeDiffuseIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = shapeNodeIndexedDiffuse3DVertexProgram
        pipelineDescriptor.fragmentFunction = shapeNodeIndexedDiffuse3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateShapeNodeIndexedDiffuse3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    
    
    func buildPipelineStatesSpriteNodeDiffuseStereoscopicRedIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexedDiffuseStereoscopicRed3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexedDiffuseStereoscopicRed3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeIndexedDiffuseStereoscopicRed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    


    func buildPipelineStatesSpriteNodeDiffuseStereoscopicBlueIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexedDiffuseStereoscopicBlue3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexedDiffuseStereoscopicBlue3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeIndexedDiffuseStereoscopicBlue3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func buildPipelineStatesShapeNodeDiffuseColoredIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = shapeNodeIndexedDiffuseColored3DVertexProgram
        pipelineDescriptor.fragmentFunction = shapeNodeIndexedDiffuseColored3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateShapeNodeIndexedDiffuseColored3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func buildPipelineStatesShapeNodePhongIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = shapeNodeIndexedPhong3DVertexProgram
        pipelineDescriptor.fragmentFunction = shapeNodeIndexedPhong3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateShapeNodeIndexedPhong3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func buildPipelineStatesShapeNodePhongColoredIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = shapeNodeIndexedPhongColored3DVertexProgram
        pipelineDescriptor.fragmentFunction = shapeNodeIndexedPhongColored3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateShapeNodeIndexedPhongColored3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    private func buildPipelineStatesShapeNodeColoredIndexed2D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = shapeNodeColoredIndexed2DVertexProgram
        pipelineDescriptor.fragmentFunction = shapeNodeColoredIndexed2DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.rasterSampleCount = 4
        pipelineStateShapeNodeColoredIndexed2DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateShapeNodeColoredIndexed2DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateShapeNodeColoredIndexed2DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateShapeNodeColoredIndexed2DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    
    private func buildPipelineStatesShapeNodeColoredIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = shapeNodeColoredIndexed3DVertexProgram
        pipelineDescriptor.fragmentFunction = shapeNodeColoredIndexed3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateShapeNodeColoredIndexed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateShapeNodeColoredIndexed3DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateShapeNodeColoredIndexed3DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateShapeNodeColoredIndexed3DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }

    private func buildPipelineStatesSpriteNodeIndexed2D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexed2DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexed2DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.rasterSampleCount = 4
        pipelineStateSpriteNodeIndexed2DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeIndexed2DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeIndexed2DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeIndexed2DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    private func buildPipelineStatesSpriteNodeWhiteIndexed2D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexed2DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeWhiteIndexed2DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.rasterSampleCount = 4
        pipelineStateSpriteNodeWhiteIndexed2DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeWhiteIndexed2DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeWhiteIndexed2DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeWhiteIndexed2DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    private func buildPipelineStatesSpriteNodeIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexed3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexed3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeIndexed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeIndexed3DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeIndexed3DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeIndexed3DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    
    private func buildPipelineStatesSpriteNodeStereoscopicBlueIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeStereoscopicBlueIndexed3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeStereoscopicBlueIndexed3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeStereoscopicBlueIndexed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeStereoscopicBlueIndexed3DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeStereoscopicBlueIndexed3DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeStereoscopicBlueIndexed3DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    private func buildPipelineStatesSpriteNodeStereoscopicRedIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeStereoscopicRedIndexed3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeStereoscopicRedIndexed3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeStereoscopicRedIndexed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeStereoscopicRedIndexed3DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeStereoscopicRedIndexed3DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeStereoscopicRedIndexed3DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    private func buildPipelineStatesSpriteNodeColoredStereoscopicBlueIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeColoredStereoscopicBlueIndexed3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeColoredStereoscopicBlueIndexed3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredStereoscopicBlueIndexed3DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
        
    private func buildPipelineStatesSpriteNodeColoredStereoscopicRedIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeColoredStereoscopicRedIndexed3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeColoredStereoscopicRedIndexed3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredStereoscopicRedIndexed3DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func buildPipelineStatesSpriteNodeDiffuseIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexedDiffuse3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexedDiffuse3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeIndexedDiffuse3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func buildPipelineStatesSpriteNodeDiffuseColoredIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexedDiffuseColored3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexedDiffuseColored3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeIndexedDiffuseColored3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    
    func buildPipelineStatesSpriteNodeDiffuseColoredStereoscopicRedIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexedDiffuseColoredStereoscopicRed3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexedDiffuseColoredStereoscopicRed3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeIndexedDiffuseColoredStereoscopicRed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func buildPipelineStatesSpriteNodeDiffuseColoredStereoscopicBlueIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexedDiffuseColoredStereoscopicBlue3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexedDiffuseColoredStereoscopicBlue3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeIndexedDiffuseColoredStereoscopicBlue3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func buildPipelineStatesSpriteNodeNightIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexedNight3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexedNight3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeIndexedNight3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    
    func buildPipelineStatesSpriteNodeNightStereoscopicRedIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexedNightStereoscopicRed3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexedNightStereoscopicRed3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeIndexedNightStereoscopicRed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }

    func buildPipelineStatesSpriteNodeNightStereoscopicBlueIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexedNightStereoscopicBlue3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexedNightStereoscopicBlue3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeIndexedNightStereoscopicBlue3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func buildPipelineStatesSpriteNodePhongIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexedPhong3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexedPhong3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeIndexedPhong3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    
    
    func buildPipelineStatesSpriteNodePhongStereoscopicRedIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexedPhongStereoscopicRed3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexedPhongStereoscopicRed3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeIndexedPhongStereoscopicRed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func buildPipelineStatesSpriteNodePhongStereoscopicBlueIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexedPhongStereoscopicBlue3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexedPhongStereoscopicBlue3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeIndexedPhongStereoscopicBlue3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func buildPipelineStatesSpriteNodePhongColoredIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexedPhongColored3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeIndexedPhongColored3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeIndexedPhongColored3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    
    func buildPipelineStatesSpriteNodePhongColoredStereoscopicRedIndexed3D() {
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = spriteNodeIndexedPhongColoredStereoscopicRed3DVertexProgram
            pipelineDescriptor.fragmentFunction = spriteNodeIndexedPhongColoredStereoscopicRed3DFragmentProgram
            pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
            pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
            pipelineStateSpriteNodeIndexedPhongColoredStereoscopicRed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }
        
        func buildPipelineStatesSpriteNodePhongColoredStereoscopicBlueIndexed3D() {
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = spriteNodeIndexedPhongColoredStereoscopicBlue3DVertexProgram
            pipelineDescriptor.fragmentFunction = spriteNodeIndexedPhongColoredStereoscopicBlue3DFragmentProgram
            pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
            pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
            pipelineStateSpriteNodeIndexedPhongColoredStereoscopicBlue3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }
    
    private func buildPipelineStatesSpriteNodeWhiteIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeIndexed3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeWhiteIndexed3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeWhiteIndexed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeWhiteIndexed3DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeWhiteIndexed3DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeWhiteIndexed3DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    private func buildPipelineStatesSpriteNodeColoredIndexed2D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeColoredIndexed2DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeColoredIndexed2DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.rasterSampleCount = 4
        pipelineStateSpriteNodeColoredIndexed2DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredIndexed2DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredIndexed2DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredIndexed2DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    private func buildPipelineStatesSpriteNodeColoredWhiteIndexed2D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeColoredIndexed2DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeColoredWhiteIndexed2DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.rasterSampleCount = 4
        pipelineStateSpriteNodeColoredWhiteIndexed2DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredWhiteIndexed2DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredWhiteIndexed2DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredWhiteIndexed2DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    private func buildPipelineStatesSpriteNodeColoredIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeColoredIndexed3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeColoredIndexed3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeColoredIndexed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredIndexed3DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredIndexed3DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredIndexed3DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    private func buildPipelineStatesSpriteNodeColoredWhiteIndexed3D() {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = spriteNodeColoredIndexed3DVertexProgram
        pipelineDescriptor.fragmentFunction = spriteNodeColoredIndexed3DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineStateSpriteNodeColoredWhiteIndexed3DNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        configAlphaBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredWhiteIndexed3DAlphaBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        configAdditiveBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredWhiteIndexed3DAdditiveBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        configPremultipliedBlending(pipelineDescriptor: pipelineDescriptor)
        pipelineStateSpriteNodeColoredWhiteIndexed3DPremultipliedBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    private func buildPipelineStatesGaussianBlur() {
        
        let pipelineDescriptorHorizontal = MTLRenderPipelineDescriptor()
        pipelineDescriptorHorizontal.vertexFunction = gaussianBlurIndexedVertexProgram
        pipelineDescriptorHorizontal.fragmentFunction = gaussianBlurIndexedHorizontalFragmentProgram
        pipelineDescriptorHorizontal.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineStateGaussianBlurHorizontalIndexedNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptorHorizontal)
        
        let pipelineDescriptorVertical = MTLRenderPipelineDescriptor()
        pipelineDescriptorVertical.vertexFunction = gaussianBlurIndexedVertexProgram
        pipelineDescriptorVertical.fragmentFunction = gaussianBlurIndexedVerticalFragmentProgram
        pipelineDescriptorVertical.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        pipelineStateGaussianBlurVerticalIndexedNoBlending = try? metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptorVertical)
    }
    
    private func configAlphaBlending(pipelineDescriptor: MTLRenderPipelineDescriptor) {
        pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        pipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
        pipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
        pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
        pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
    }
    
    private func configAdditiveBlending(pipelineDescriptor: MTLRenderPipelineDescriptor) {
        pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        pipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
        pipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
        pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .one
    }
    
    private func configPremultipliedBlending(pipelineDescriptor: MTLRenderPipelineDescriptor) {
        pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        pipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
        pipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
        pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .one
        pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
    }
}
