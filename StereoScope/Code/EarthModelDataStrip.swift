//
//  EarthModelDataStrip.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

import Foundation
import Metal
import simd
import UIKit

class EarthModelDataStrip {
    
    
    weak var texture: MTLTexture?
    weak var textureLight: MTLTexture?
    
    weak var earthModelData: EarthModelData?
    
    let indexV: Int
    
    let bloomBuffer = IndexedShapeBuffer<Shape3DVertex, UniformsShapeNodeIndexedVertex, UniformsShapeNodeIndexedFragment>()
    let bloomBufferColored = IndexedShapeBuffer<Shape3DColoredVertex, UniformsShapeNodeIndexedVertex, UniformsShapeNodeIndexedFragment>()
    
    let noLightBuffer = IndexedSpriteBuffer<Sprite3DVertex, UniformsSpriteVertex, UniformsSpriteFragment>()
    let noLightBufferColored = IndexedSpriteBuffer<Sprite3DColoredVertex, UniformsSpriteVertex, UniformsSpriteFragment>()
    
    let noLightBufferStereoscopic = IndexedSpriteBuffer<Sprite3DVertexStereoscopic, UniformsSpriteVertex, UniformsSpriteFragment>()
    let noLightBufferColoredStereoscopic = IndexedSpriteBuffer<Sprite3DVertexColoredStereoscopic, UniformsSpriteVertex, UniformsSpriteFragment>()
    
    
    
    let diffuseBuffer = IndexedSpriteBuffer<Sprite3DLightedVertex,
                                            UniformsLightsVertex,
                                            UniformsDiffuseFragment>()
    let diffuseBufferColored = IndexedSpriteBuffer<Sprite3DLightedColoredVertex,
                                                    UniformsLightsVertex,
                                                    UniformsDiffuseFragment>()
    let diffuseBufferStereoscopic = IndexedSpriteBuffer<Sprite3DLightedStereoscopicVertex,
                                                        UniformsLightsVertex,
                                                        UniformsDiffuseFragment>()
    let diffuseBufferColoredStereoscopic = IndexedSpriteBuffer<Sprite3DLightedColoredStereoscopicVertex,
                                                               UniformsLightsVertex,
                                                               UniformsDiffuseFragment>()
    
    
    let phongBuffer = IndexedSpriteBuffer<Sprite3DLightedVertex,
                                          UniformsLightsVertex,
                                          UniformsPhongFragment>()
    let phongBufferColored = IndexedSpriteBuffer<Sprite3DLightedColoredVertex,
                                                    UniformsLightsVertex,
                                                    UniformsPhongFragment>()
    let phongBufferStereoscopic = IndexedSpriteBuffer<Sprite3DLightedStereoscopicVertex,
                                                      UniformsLightsVertex,
                                                      UniformsPhongFragment>()
    let phongBufferColoredStereoscopic = IndexedSpriteBuffer<Sprite3DLightedColoredStereoscopicVertex,
                                                             UniformsLightsVertex,
                                                             UniformsPhongFragment>()
    
    let nightBuffer = IndexedNightBuffer<Sprite3DLightedVertex,
                                         UniformsLightsVertex,
                                         UniformsNightFragment>()
    let nightBufferStereoscopic = IndexedNightBuffer<Sprite3DLightedStereoscopicVertex,
                                                     UniformsLightsVertex,
                                                     UniformsNightFragment>()
    
    
    init(earthModelData: EarthModelData,
         indexV: Int) {
        
        self.indexV = indexV
        self.earthModelData = earthModelData
        
        for indexH in 0...EarthModelData.tileCountH {
            
            let u1 = earthModelData.textureCoords[indexH][indexV - 1].x
            let v1 = earthModelData.textureCoords[indexH][indexV - 1].y
            let u2 = earthModelData.textureCoords[indexH][indexV].x
            let v2 = earthModelData.textureCoords[indexH][indexV].y
            
            bloomBuffer.add(index: UInt32(indexH * 2))
            bloomBuffer.add(index: UInt32(indexH * 2 + 1))
            bloomBuffer.add(vertex: Shape3DVertex())
            bloomBuffer.add(vertex: Shape3DVertex())
            
            bloomBufferColored.add(index: UInt32(indexH * 2))
            bloomBufferColored.add(index: UInt32(indexH * 2 + 1))
            bloomBufferColored.add(vertex: Shape3DColoredVertex())
            bloomBufferColored.add(vertex: Shape3DColoredVertex())
            
            noLightBuffer.add(index: UInt32(indexH * 2))
            noLightBuffer.add(index: UInt32(indexH * 2 + 1))
            noLightBuffer.add(vertex: Sprite3DVertex(u: u1, v: v1))
            noLightBuffer.add(vertex: Sprite3DVertex(u: u2, v: v2))
            
            noLightBufferColored.add(index: UInt32(indexH * 2))
            noLightBufferColored.add(index: UInt32(indexH * 2 + 1))
            noLightBufferColored.add(vertex: Sprite3DColoredVertex(u: u1, v: v1))
            noLightBufferColored.add(vertex: Sprite3DColoredVertex(u: u2, v: v2))
            
            noLightBufferStereoscopic.add(index: UInt32(indexH * 2))
            noLightBufferStereoscopic.add(index: UInt32(indexH * 2 + 1))
            noLightBufferStereoscopic.add(vertex: Sprite3DVertexStereoscopic(u: u1, v: v1))
            noLightBufferStereoscopic.add(vertex: Sprite3DVertexStereoscopic(u: u2, v: v2))
            
            noLightBufferColoredStereoscopic.add(index: UInt32(indexH * 2))
            noLightBufferColoredStereoscopic.add(index: UInt32(indexH * 2 + 1))
            noLightBufferColoredStereoscopic.add(vertex: Sprite3DVertexColoredStereoscopic(u: u1, v: v1))
            noLightBufferColoredStereoscopic.add(vertex: Sprite3DVertexColoredStereoscopic(u: u2, v: v2))
            
            diffuseBuffer.add(index: UInt32(indexH * 2))
            diffuseBuffer.add(index: UInt32(indexH * 2 + 1))
            diffuseBuffer.add(vertex: Sprite3DLightedVertex(u: u1, v: v1))
            diffuseBuffer.add(vertex: Sprite3DLightedVertex(u: u2, v: v2))
            
            diffuseBufferColored.add(index: UInt32(indexH * 2))
            diffuseBufferColored.add(index: UInt32(indexH * 2 + 1))
            diffuseBufferColored.add(vertex: Sprite3DLightedColoredVertex(u: u1, v: v1))
            diffuseBufferColored.add(vertex: Sprite3DLightedColoredVertex(u: u2, v: v2))
            
            diffuseBufferStereoscopic.add(index: UInt32(indexH * 2))
            diffuseBufferStereoscopic.add(index: UInt32(indexH * 2 + 1))
            diffuseBufferStereoscopic.add(vertex: Sprite3DLightedStereoscopicVertex(u: u1, v: v1))
            diffuseBufferStereoscopic.add(vertex: Sprite3DLightedStereoscopicVertex(u: u2, v: v2))
            
            diffuseBufferColoredStereoscopic.add(index: UInt32(indexH * 2))
            diffuseBufferColoredStereoscopic.add(index: UInt32(indexH * 2 + 1))
            diffuseBufferColoredStereoscopic.add(vertex: Sprite3DLightedColoredStereoscopicVertex(u: u1, v: v1))
            diffuseBufferColoredStereoscopic.add(vertex: Sprite3DLightedColoredStereoscopicVertex(u: u2, v: v2))
            
            
            phongBuffer.add(index: UInt32(indexH * 2))
            phongBuffer.add(index: UInt32(indexH * 2 + 1))
            phongBuffer.add(vertex: Sprite3DLightedVertex(u: u1, v: v1))
            phongBuffer.add(vertex: Sprite3DLightedVertex(u: u2, v: v2))

            phongBufferColored.add(index: UInt32(indexH * 2))
            phongBufferColored.add(index: UInt32(indexH * 2 + 1))
            phongBufferColored.add(vertex: Sprite3DLightedColoredVertex(u: u1, v: v1))
            phongBufferColored.add(vertex: Sprite3DLightedColoredVertex(u: u2, v: v2))

            phongBufferStereoscopic.add(index: UInt32(indexH * 2))
            phongBufferStereoscopic.add(index: UInt32(indexH * 2 + 1))
            phongBufferStereoscopic.add(vertex: Sprite3DLightedStereoscopicVertex(u: u1, v: v1))
            phongBufferStereoscopic.add(vertex: Sprite3DLightedStereoscopicVertex(u: u2, v: v2))

            phongBufferColoredStereoscopic.add(index: UInt32(indexH * 2))
            phongBufferColoredStereoscopic.add(index: UInt32(indexH * 2 + 1))
            phongBufferColoredStereoscopic.add(vertex: Sprite3DLightedColoredStereoscopicVertex(u: u1, v: v1))
            phongBufferColoredStereoscopic.add(vertex: Sprite3DLightedColoredStereoscopicVertex(u: u2, v: v2))
            
            nightBuffer.add(index: UInt32(indexH * 2))
            nightBuffer.add(index: UInt32(indexH * 2 + 1))
            nightBuffer.add(vertex: Sprite3DLightedVertex(u: u1, v: v1))
            nightBuffer.add(vertex: Sprite3DLightedVertex(u: u2, v: v2))

            nightBufferStereoscopic.add(index: UInt32(indexH * 2))
            nightBufferStereoscopic.add(index: UInt32(indexH * 2 + 1))
            nightBufferStereoscopic.add(vertex: Sprite3DLightedStereoscopicVertex(u: u1, v: v1))
            nightBufferStereoscopic.add(vertex: Sprite3DLightedStereoscopicVertex(u: u2, v: v2))

        }
    }
    
    func load(graphics: Graphics,
              texture: MTLTexture?,
              textureLight: MTLTexture?) {
        self.texture = texture
        self.textureLight = textureLight
        
        bloomBuffer.load(graphics: graphics)
        bloomBufferColored.load(graphics: graphics)
        
        noLightBuffer.load(graphics: graphics, texture: texture)
        noLightBufferColored.load(graphics: graphics, texture: texture)
        
        noLightBufferStereoscopic.load(graphics: graphics, texture: texture)
        noLightBufferColoredStereoscopic.load(graphics: graphics, texture: texture)
        
        diffuseBuffer.load(graphics: graphics, texture: texture)
        diffuseBufferColored.load(graphics: graphics, texture: texture)
        diffuseBufferStereoscopic.load(graphics: graphics, texture: texture)
        diffuseBufferColoredStereoscopic.load(graphics: graphics, texture: texture)
        
        
        phongBuffer.load(graphics: graphics, texture: texture)
        phongBufferColored.load(graphics: graphics, texture: texture)
        phongBufferStereoscopic.load(graphics: graphics, texture: texture)
        phongBufferColoredStereoscopic.load(graphics: graphics, texture: texture)

        nightBuffer.load(graphics: graphics, texture: texture, textureLight: textureLight)
        nightBufferStereoscopic.load(graphics: graphics, texture: texture, textureLight: textureLight)
    }
    
    func update(deltaTime: Float) {
        
    }
    
    func updateStereo(radians: Float, width: Float, height: Float, stereoSpreadBase: Float, stereoSpreadMax: Float) {
        
        let radius: Float
        if UIDevice.current.userInterfaceIdiom == .pad {
            radius = min(width, height) * (0.5 * 0.75)
        } else {
            radius = min(width, height) * (0.5 * 0.85)
        }
        
        let startRotationH = Float(Float.pi)
        let endRotationH = startRotationH + Float.pi * 2.0
        let startRotationV = Float.pi
        let endRotationV = Float(0.0)
        
        let percentV1 = (Float(indexV - 1) / Float(EarthModelData.tileCountV))
        let percentV2 = (Float(indexV) / Float(EarthModelData.tileCountV))
        let _angleV1 = startRotationV + (endRotationV - startRotationV) * percentV1
        let _angleV2 = startRotationV + (endRotationV - startRotationV) * percentV2
        var indexH = 0
        while indexH <= EarthModelData.tileCountH {
            let percentH = (Float(indexH) / Float(EarthModelData.tileCountH))
            let _angleH = startRotationH + (endRotationH - startRotationH) * percentH - radians
            var point1 = simd_float3(0.0, 1.0, 0.0)
            point1 = Math.rotateX(float3: point1, radians: _angleV1)
            point1 = Math.rotateY(float3: point1, radians: _angleH)
            
            var point2 = simd_float3(0.0, 1.0, 0.0)
            point2 = Math.rotateX(float3: point2, radians: _angleV2)
            point2 = Math.rotateY(float3: point2, radians: _angleH)
            
            let vertexIndex1 = (indexH << 1)
            let vertexIndex2 = vertexIndex1 + 1
            
            let shift1 = stereoSpreadBase + fabsf(point1.z) * stereoSpreadMax
            let shift2 = stereoSpreadBase + fabsf(point2.z) * stereoSpreadMax
            

            let x1 = point1.x * radius
            let y1 = point1.y * radius
            let z1 = point1.z * radius
            
            let x2 = point2.x * radius
            let y2 = point2.y * radius
            let z2 = point2.z * radius
            
            let normalX1 = point1.x
            let normalY1 = point1.y
            let normalZ1 = point1.z
            
            let normalX2 = point1.x
            let normalY2 = point1.y
            let normalZ2 = point1.z
            
            let r1 = Float.random(in: 0.75...1.0)
            let g1 = Float.random(in: 0.75...1.0)
            let b1 = Float.random(in: 0.75...1.0)
            
            let r2 = Float.random(in: 0.75...1.0)
            let g2 = Float.random(in: 0.75...1.0)
            let b2 = Float.random(in: 0.75...1.0)
            
            //
            //
            //
            bloomBuffer.vertices[vertexIndex1].x = x1
            bloomBuffer.vertices[vertexIndex1].y = y1
            bloomBuffer.vertices[vertexIndex1].z = z1
            //
            bloomBuffer.vertices[vertexIndex2].x = x2
            bloomBuffer.vertices[vertexIndex2].y = y2
            bloomBuffer.vertices[vertexIndex2].z = z2
            //
            //
            //
            bloomBufferColored.vertices[vertexIndex1].x = x1
            bloomBufferColored.vertices[vertexIndex1].y = y1
            bloomBufferColored.vertices[vertexIndex1].z = z1
            bloomBufferColored.vertices[vertexIndex1].r = r1
            bloomBufferColored.vertices[vertexIndex1].g = g1
            bloomBufferColored.vertices[vertexIndex1].b = b1
            //
            bloomBufferColored.vertices[vertexIndex2].x = x2
            bloomBufferColored.vertices[vertexIndex2].y = y2
            bloomBufferColored.vertices[vertexIndex2].z = z2
            bloomBufferColored.vertices[vertexIndex2].r = r2
            bloomBufferColored.vertices[vertexIndex2].g = g2
            bloomBufferColored.vertices[vertexIndex2].b = b2
            //
            //
            //
            noLightBuffer.vertices[vertexIndex1].x = x1
            noLightBuffer.vertices[vertexIndex1].y = y1
            noLightBuffer.vertices[vertexIndex1].z = z1
            //
            noLightBuffer.vertices[vertexIndex2].x = x2
            noLightBuffer.vertices[vertexIndex2].y = y2
            noLightBuffer.vertices[vertexIndex2].z = z2
            //
            //
            //
            noLightBufferColored.vertices[vertexIndex1].x = x1
            noLightBufferColored.vertices[vertexIndex1].y = y1
            noLightBufferColored.vertices[vertexIndex1].z = z1
            noLightBufferColored.vertices[vertexIndex1].r = r1
            noLightBufferColored.vertices[vertexIndex1].g = g1
            noLightBufferColored.vertices[vertexIndex1].b = b1
            //
            noLightBufferColored.vertices[vertexIndex2].x = x2
            noLightBufferColored.vertices[vertexIndex2].y = y2
            noLightBufferColored.vertices[vertexIndex2].z = z2
            noLightBufferColored.vertices[vertexIndex2].r = r2
            noLightBufferColored.vertices[vertexIndex2].g = g2
            noLightBufferColored.vertices[vertexIndex2].b = b2
            //
            //
            //
            noLightBufferStereoscopic.vertices[vertexIndex1].x = x1
            noLightBufferStereoscopic.vertices[vertexIndex1].y = y1
            noLightBufferStereoscopic.vertices[vertexIndex1].z = z1
            noLightBufferStereoscopic.vertices[vertexIndex1].shift = shift1
            //
            noLightBufferStereoscopic.vertices[vertexIndex2].x = x2
            noLightBufferStereoscopic.vertices[vertexIndex2].y = y2
            noLightBufferStereoscopic.vertices[vertexIndex2].z = z2
            noLightBufferStereoscopic.vertices[vertexIndex2].shift = shift2
            //
            //
            //
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].x = x1
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].y = y1
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].z = z1
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].r = r1
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].g = g1
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].b = b1
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].shift = shift1
            //
            noLightBufferColoredStereoscopic.vertices[vertexIndex2].x = x2
            noLightBufferColoredStereoscopic.vertices[vertexIndex2].y = y2
            noLightBufferColoredStereoscopic.vertices[vertexIndex2].z = z2
            noLightBufferColoredStereoscopic.vertices[vertexIndex2].r = r2
            noLightBufferColoredStereoscopic.vertices[vertexIndex2].g = g2
            noLightBufferColoredStereoscopic.vertices[vertexIndex2].b = b2
            noLightBufferColoredStereoscopic.vertices[vertexIndex2].shift = shift2
            //
            //
            //
            diffuseBuffer.vertices[vertexIndex1].x = x1
            diffuseBuffer.vertices[vertexIndex1].y = y1
            diffuseBuffer.vertices[vertexIndex1].z = z1
            diffuseBuffer.vertices[vertexIndex1].normalX = normalX1
            diffuseBuffer.vertices[vertexIndex1].normalY = normalY1
            diffuseBuffer.vertices[vertexIndex1].normalZ = normalZ1
            //
            diffuseBuffer.vertices[vertexIndex2].x = x2
            diffuseBuffer.vertices[vertexIndex2].y = y2
            diffuseBuffer.vertices[vertexIndex2].z = z2
            diffuseBuffer.vertices[vertexIndex2].normalX = normalX2
            diffuseBuffer.vertices[vertexIndex2].normalY = normalY2
            diffuseBuffer.vertices[vertexIndex2].normalZ = normalZ2
            //
            //
            //
            diffuseBufferColored.vertices[vertexIndex1].x = x1
            diffuseBufferColored.vertices[vertexIndex1].y = y1
            diffuseBufferColored.vertices[vertexIndex1].z = z1
            diffuseBufferColored.vertices[vertexIndex1].normalX = normalX1
            diffuseBufferColored.vertices[vertexIndex1].normalY = normalY1
            diffuseBufferColored.vertices[vertexIndex1].normalZ = normalZ1
            diffuseBufferColored.vertices[vertexIndex1].r = r1
            diffuseBufferColored.vertices[vertexIndex1].g = g1
            diffuseBufferColored.vertices[vertexIndex1].b = b1
            //
            diffuseBufferColored.vertices[vertexIndex2].x = x2
            diffuseBufferColored.vertices[vertexIndex2].y = y2
            diffuseBufferColored.vertices[vertexIndex2].z = z2
            diffuseBufferColored.vertices[vertexIndex2].normalX = normalX2
            diffuseBufferColored.vertices[vertexIndex2].normalY = normalY2
            diffuseBufferColored.vertices[vertexIndex2].normalZ = normalZ2
            diffuseBufferColored.vertices[vertexIndex2].r = r2
            diffuseBufferColored.vertices[vertexIndex2].g = g2
            diffuseBufferColored.vertices[vertexIndex2].b = b2
            //
            //
            //
            diffuseBufferStereoscopic.vertices[vertexIndex1].x = x1
            diffuseBufferStereoscopic.vertices[vertexIndex1].y = y1
            diffuseBufferStereoscopic.vertices[vertexIndex1].z = z1
            diffuseBufferStereoscopic.vertices[vertexIndex1].normalX = normalX1
            diffuseBufferStereoscopic.vertices[vertexIndex1].normalY = normalY1
            diffuseBufferStereoscopic.vertices[vertexIndex1].normalZ = normalZ1
            diffuseBufferStereoscopic.vertices[vertexIndex1].shift = shift1
            //
            diffuseBufferStereoscopic.vertices[vertexIndex2].x = x2
            diffuseBufferStereoscopic.vertices[vertexIndex2].y = y2
            diffuseBufferStereoscopic.vertices[vertexIndex2].z = z2
            diffuseBufferStereoscopic.vertices[vertexIndex2].normalX = normalX2
            diffuseBufferStereoscopic.vertices[vertexIndex2].normalY = normalY2
            diffuseBufferStereoscopic.vertices[vertexIndex2].normalZ = normalZ2
            diffuseBufferStereoscopic.vertices[vertexIndex2].shift = shift2
            //
            //
            //
            diffuseBufferColoredStereoscopic.vertices[vertexIndex1].x = x1
            diffuseBufferColoredStereoscopic.vertices[vertexIndex1].y = y1
            diffuseBufferColoredStereoscopic.vertices[vertexIndex1].z = z1
            diffuseBufferColoredStereoscopic.vertices[vertexIndex1].normalX = normalX1
            diffuseBufferColoredStereoscopic.vertices[vertexIndex1].normalY = normalY1
            diffuseBufferColoredStereoscopic.vertices[vertexIndex1].normalZ = normalZ1
            diffuseBufferColoredStereoscopic.vertices[vertexIndex1].r = r1
            diffuseBufferColoredStereoscopic.vertices[vertexIndex1].g = g1
            diffuseBufferColoredStereoscopic.vertices[vertexIndex1].b = b1
            diffuseBufferColoredStereoscopic.vertices[vertexIndex1].shift = shift1
            //
            diffuseBufferColoredStereoscopic.vertices[vertexIndex2].x = x2
            diffuseBufferColoredStereoscopic.vertices[vertexIndex2].y = y2
            diffuseBufferColoredStereoscopic.vertices[vertexIndex2].z = z2
            diffuseBufferColoredStereoscopic.vertices[vertexIndex2].normalX = normalX2
            diffuseBufferColoredStereoscopic.vertices[vertexIndex2].normalY = normalY2
            diffuseBufferColoredStereoscopic.vertices[vertexIndex2].normalZ = normalZ2
            diffuseBufferColoredStereoscopic.vertices[vertexIndex2].r = r2
            diffuseBufferColoredStereoscopic.vertices[vertexIndex2].g = g2
            diffuseBufferColoredStereoscopic.vertices[vertexIndex2].b = b2
            diffuseBufferColoredStereoscopic.vertices[vertexIndex2].shift = shift2
            //
            //
            //
            phongBuffer.vertices[vertexIndex1].x = x1
            phongBuffer.vertices[vertexIndex1].y = y1
            phongBuffer.vertices[vertexIndex1].z = z1
            phongBuffer.vertices[vertexIndex1].normalX = normalX1
            phongBuffer.vertices[vertexIndex1].normalY = normalY1
            phongBuffer.vertices[vertexIndex1].normalZ = normalZ1
            //
            phongBuffer.vertices[vertexIndex2].x = x2
            phongBuffer.vertices[vertexIndex2].y = y2
            phongBuffer.vertices[vertexIndex2].z = z2
            phongBuffer.vertices[vertexIndex2].normalX = normalX2
            phongBuffer.vertices[vertexIndex2].normalY = normalY2
            phongBuffer.vertices[vertexIndex2].normalZ = normalZ2
            //
            //
            //
            phongBufferColored.vertices[vertexIndex1].x = x1
            phongBufferColored.vertices[vertexIndex1].y = y1
            phongBufferColored.vertices[vertexIndex1].z = z1
            phongBufferColored.vertices[vertexIndex1].normalX = normalX1
            phongBufferColored.vertices[vertexIndex1].normalY = normalY1
            phongBufferColored.vertices[vertexIndex1].normalZ = normalZ1
            phongBufferColored.vertices[vertexIndex1].r = r1
            phongBufferColored.vertices[vertexIndex1].g = g1
            phongBufferColored.vertices[vertexIndex1].b = b1
            //
            phongBufferColored.vertices[vertexIndex2].x = x2
            phongBufferColored.vertices[vertexIndex2].y = y2
            phongBufferColored.vertices[vertexIndex2].z = z2
            phongBufferColored.vertices[vertexIndex2].normalX = normalX2
            phongBufferColored.vertices[vertexIndex2].normalY = normalY2
            phongBufferColored.vertices[vertexIndex2].normalZ = normalZ2
            phongBufferColored.vertices[vertexIndex2].r = r2
            phongBufferColored.vertices[vertexIndex2].g = g2
            phongBufferColored.vertices[vertexIndex2].b = b2
            //
            //
            //
            phongBufferStereoscopic.vertices[vertexIndex1].x = x1
            phongBufferStereoscopic.vertices[vertexIndex1].y = y1
            phongBufferStereoscopic.vertices[vertexIndex1].z = z1
            phongBufferStereoscopic.vertices[vertexIndex1].normalX = normalX1
            phongBufferStereoscopic.vertices[vertexIndex1].normalY = normalY1
            phongBufferStereoscopic.vertices[vertexIndex1].normalZ = normalZ1
            phongBufferStereoscopic.vertices[vertexIndex1].shift = shift1
            //
            phongBufferStereoscopic.vertices[vertexIndex2].x = x2
            phongBufferStereoscopic.vertices[vertexIndex2].y = y2
            phongBufferStereoscopic.vertices[vertexIndex2].z = z2
            phongBufferStereoscopic.vertices[vertexIndex2].normalX = normalX2
            phongBufferStereoscopic.vertices[vertexIndex2].normalY = normalY2
            phongBufferStereoscopic.vertices[vertexIndex2].normalZ = normalZ2
            phongBufferStereoscopic.vertices[vertexIndex2].shift = shift2
            //
            //
            //
            phongBufferColoredStereoscopic.vertices[vertexIndex1].x = x1
            phongBufferColoredStereoscopic.vertices[vertexIndex1].y = y1
            phongBufferColoredStereoscopic.vertices[vertexIndex1].z = z1
            phongBufferColoredStereoscopic.vertices[vertexIndex1].normalX = normalX1
            phongBufferColoredStereoscopic.vertices[vertexIndex1].normalY = normalY1
            phongBufferColoredStereoscopic.vertices[vertexIndex1].normalZ = normalZ1
            phongBufferColoredStereoscopic.vertices[vertexIndex1].r = r1
            phongBufferColoredStereoscopic.vertices[vertexIndex1].g = g1
            phongBufferColoredStereoscopic.vertices[vertexIndex1].b = b1
            phongBufferColoredStereoscopic.vertices[vertexIndex1].shift = shift1
            //
            phongBufferColoredStereoscopic.vertices[vertexIndex2].x = x2
            phongBufferColoredStereoscopic.vertices[vertexIndex2].y = y2
            phongBufferColoredStereoscopic.vertices[vertexIndex2].z = z2
            phongBufferColoredStereoscopic.vertices[vertexIndex2].normalX = normalX2
            phongBufferColoredStereoscopic.vertices[vertexIndex2].normalY = normalY2
            phongBufferColoredStereoscopic.vertices[vertexIndex2].normalZ = normalZ2
            phongBufferColoredStereoscopic.vertices[vertexIndex2].r = r2
            phongBufferColoredStereoscopic.vertices[vertexIndex2].g = g2
            phongBufferColoredStereoscopic.vertices[vertexIndex2].b = b2
            phongBufferColoredStereoscopic.vertices[vertexIndex2].shift = shift2
            //
            //
            //
            nightBuffer.vertices[vertexIndex1].x = x1
            nightBuffer.vertices[vertexIndex1].y = y1
            nightBuffer.vertices[vertexIndex1].z = z1
            nightBuffer.vertices[vertexIndex1].normalX = normalX1
            nightBuffer.vertices[vertexIndex1].normalY = normalY1
            nightBuffer.vertices[vertexIndex1].normalZ = normalZ1
            //
            nightBuffer.vertices[vertexIndex2].x = x2
            nightBuffer.vertices[vertexIndex2].y = y2
            nightBuffer.vertices[vertexIndex2].z = z2
            nightBuffer.vertices[vertexIndex2].normalX = normalX2
            nightBuffer.vertices[vertexIndex2].normalY = normalY2
            nightBuffer.vertices[vertexIndex2].normalZ = normalZ2
            //
            //
            //
            nightBufferStereoscopic.vertices[vertexIndex1].x = x1
            nightBufferStereoscopic.vertices[vertexIndex1].y = y1
            nightBufferStereoscopic.vertices[vertexIndex1].z = z1
            nightBufferStereoscopic.vertices[vertexIndex1].normalX = normalX1
            nightBufferStereoscopic.vertices[vertexIndex1].normalY = normalY1
            nightBufferStereoscopic.vertices[vertexIndex1].normalZ = normalZ1
            nightBufferStereoscopic.vertices[vertexIndex1].shift = shift1
            //
            nightBufferStereoscopic.vertices[vertexIndex2].x = x2
            nightBufferStereoscopic.vertices[vertexIndex2].y = y2
            nightBufferStereoscopic.vertices[vertexIndex2].z = z2
            nightBufferStereoscopic.vertices[vertexIndex2].normalX = normalX2
            nightBufferStereoscopic.vertices[vertexIndex2].normalY = normalY2
            nightBufferStereoscopic.vertices[vertexIndex2].normalZ = normalZ2
            nightBufferStereoscopic.vertices[vertexIndex2].shift = shift2
            //
            //
            //
            
            
            
            indexH += 1
        }
    }
    
    func draw3DBloom_NotColored(renderEncoder: MTLRenderCommandEncoder,
                                projectionMatrix: matrix_float4x4,
                                modelViewMatrix: matrix_float4x4) {
        bloomBuffer.uniformsVertex.projectionMatrix = projectionMatrix
        bloomBuffer.uniformsVertex.modelViewMatrix = modelViewMatrix
        bloomBuffer.uniformsFragment.red = 0.6
        bloomBuffer.uniformsFragment.green = 0.75
        bloomBuffer.uniformsFragment.blue = 1.0
        bloomBuffer.uniformsFragment.alpha = 1.0
        bloomBuffer.setDirty(isVertexBufferDirty: true,
                                             isIndexBufferDirty: false,
                                             isUniformsVertexBufferDirty: true,
                                             isUniformsFragmentBufferDirty: true)
        
        bloomBuffer.render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed3DAlphaBlending)
    }
    
    func draw3DBloom_YesColored(renderEncoder: MTLRenderCommandEncoder,
                                projectionMatrix: matrix_float4x4,
                                modelViewMatrix: matrix_float4x4) {
        
        bloomBufferColored.uniformsVertex.projectionMatrix = projectionMatrix
        bloomBufferColored.uniformsVertex.modelViewMatrix = modelViewMatrix
        bloomBufferColored.uniformsFragment.red = 0.6
        bloomBufferColored.uniformsFragment.green = 0.75
        bloomBufferColored.uniformsFragment.blue = 1.0
        bloomBufferColored.uniformsFragment.alpha = 1.0
        bloomBufferColored.setDirty(isVertexBufferDirty: true,
                                    isIndexBufferDirty: false,
                                    isUniformsVertexBufferDirty: true,
                                    isUniformsFragmentBufferDirty: true)
        
        bloomBufferColored.render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed3DAlphaBlending)
    }
    
    func draw3D_NoLight_NotColored(renderEncoder: MTLRenderCommandEncoder,
                                   projectionMatrix: matrix_float4x4,
                                   modelViewMatrix: matrix_float4x4) {
        noLightBuffer.uniformsVertex.projectionMatrix = projectionMatrix
        noLightBuffer.uniformsVertex.modelViewMatrix = modelViewMatrix
        noLightBuffer.setDirty(isVertexBufferDirty: true,
                               isIndexBufferDirty: false,
                               isUniformsVertexBufferDirty: true,
                               isUniformsFragmentBufferDirty: true)
        noLightBuffer.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed3DNoBlending)
    }
    
    func draw3D_NoLight_YesColored(renderEncoder: MTLRenderCommandEncoder,
                                   projectionMatrix: matrix_float4x4,
                                   modelViewMatrix: matrix_float4x4) {
        noLightBufferColored.uniformsVertex.projectionMatrix = projectionMatrix
        noLightBufferColored.uniformsVertex.modelViewMatrix = modelViewMatrix
        noLightBufferColored.setDirty(isVertexBufferDirty: true,
                                      isIndexBufferDirty: false,
                                      isUniformsVertexBufferDirty: true,
                                      isUniformsFragmentBufferDirty: true)
        noLightBufferColored.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredIndexed3DNoBlending)
    }
    
    func draw3DStereoscopic_NoLight_NoColors(renderEncoder: MTLRenderCommandEncoder,
                                             projectionMatrix: matrix_float4x4,
                                             modelViewMatrix: matrix_float4x4,
                                             pipelineState: Graphics.PipelineState) {
        noLightBufferStereoscopic.uniformsVertex.projectionMatrix = projectionMatrix
        noLightBufferStereoscopic.uniformsVertex.modelViewMatrix = modelViewMatrix
        noLightBufferStereoscopic.setDirty(isVertexBufferDirty: true,
                                           isIndexBufferDirty: false,
                                           isUniformsVertexBufferDirty: true,
                                           isUniformsFragmentBufferDirty: true)
        noLightBufferStereoscopic.render(renderEncoder: renderEncoder, pipelineState: pipelineState)
    }
    
    func draw3DStereoscopic_NoLight_YesColors(renderEncoder: MTLRenderCommandEncoder,
                                              projectionMatrix: matrix_float4x4,
                                              modelViewMatrix: matrix_float4x4,
                                              pipelineState: Graphics.PipelineState) {
        
        noLightBufferColoredStereoscopic.uniformsVertex.projectionMatrix = projectionMatrix
        noLightBufferColoredStereoscopic.uniformsVertex.modelViewMatrix = modelViewMatrix
        noLightBufferColoredStereoscopic.setDirty(isVertexBufferDirty: true,
                                                  isIndexBufferDirty: false,
                                                  isUniformsVertexBufferDirty: true,
                                                  isUniformsFragmentBufferDirty: true)
        noLightBufferColoredStereoscopic.render(renderEncoder: renderEncoder, pipelineState: pipelineState)
        
    }
    
    
    func draw3D_Diffuse_NotColored(renderEncoder: MTLRenderCommandEncoder,
                                   projectionMatrix: matrix_float4x4,
                                   modelViewMatrix: matrix_float4x4,
                                   normalMatrix: matrix_float4x4,
                                   lightDirX: Float,
                                   lightDirY: Float,
                                   lightDirZ: Float,
                                   lightAmbientIntensity: Float,
                                   lightDiffuseIntensity: Float) {
        diffuseBuffer.uniformsVertex.projectionMatrix = projectionMatrix
        diffuseBuffer.uniformsVertex.modelViewMatrix = modelViewMatrix
        diffuseBuffer.uniformsVertex.normalMatrix = normalMatrix
        
        diffuseBuffer.uniformsFragment.lightDirX = lightDirX
        diffuseBuffer.uniformsFragment.lightDirY = lightDirY
        diffuseBuffer.uniformsFragment.lightDirZ = lightDirZ
        
        diffuseBuffer.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
        diffuseBuffer.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
        
        diffuseBuffer.setDirty(isVertexBufferDirty: true,
                               isIndexBufferDirty: false,
                               isUniformsVertexBufferDirty: true,
                               isUniformsFragmentBufferDirty: true)
        diffuseBuffer.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexedDiffuse3DNoBlending)
    }

    func draw3D_Diffuse_YesColored(renderEncoder: MTLRenderCommandEncoder,
                                   projectionMatrix: matrix_float4x4,
                                   modelViewMatrix: matrix_float4x4,
                                   normalMatrix: matrix_float4x4,
                                   lightDirX: Float,
                                   lightDirY: Float,
                                   lightDirZ: Float,
                                   lightAmbientIntensity: Float,
                                   lightDiffuseIntensity: Float) {
        diffuseBufferColored.uniformsVertex.projectionMatrix = projectionMatrix
        diffuseBufferColored.uniformsVertex.modelViewMatrix = modelViewMatrix
        diffuseBufferColored.uniformsVertex.normalMatrix = normalMatrix
        
        diffuseBufferColored.uniformsFragment.lightDirX = lightDirX
        diffuseBufferColored.uniformsFragment.lightDirY = lightDirY
        diffuseBufferColored.uniformsFragment.lightDirZ = lightDirZ
        
        diffuseBufferColored.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
        diffuseBufferColored.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
        
        diffuseBufferColored.setDirty(isVertexBufferDirty: true,
                               isIndexBufferDirty: false,
                               isUniformsVertexBufferDirty: true,
                               isUniformsFragmentBufferDirty: true)
        diffuseBufferColored.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexedDiffuseColored3DNoBlending)
    }

    func draw3DStereoscopic_Diffuse_NotColored(renderEncoder: MTLRenderCommandEncoder,
                                               projectionMatrix: matrix_float4x4,
                                               modelViewMatrix: matrix_float4x4,
                                               normalMatrix: matrix_float4x4,
                                               lightDirX: Float, lightDirY: Float, lightDirZ: Float,
                                               lightAmbientIntensity: Float,
                                               lightDiffuseIntensity: Float,
                                               pipelineState: Graphics.PipelineState) {
        diffuseBufferStereoscopic.uniformsVertex.projectionMatrix = projectionMatrix
        diffuseBufferStereoscopic.uniformsVertex.modelViewMatrix = modelViewMatrix
        diffuseBufferStereoscopic.uniformsVertex.normalMatrix = normalMatrix
        
        diffuseBufferStereoscopic.uniformsFragment.lightDirX = lightDirX
        diffuseBufferStereoscopic.uniformsFragment.lightDirY = lightDirY
        diffuseBufferStereoscopic.uniformsFragment.lightDirZ = lightDirZ
        
        diffuseBufferStereoscopic.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
        diffuseBufferStereoscopic.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
        
        diffuseBufferStereoscopic.setDirty(isVertexBufferDirty: true,
                               isIndexBufferDirty: false,
                               isUniformsVertexBufferDirty: true,
                               isUniformsFragmentBufferDirty: true)
        diffuseBufferStereoscopic.render(renderEncoder: renderEncoder, pipelineState: pipelineState)
    }

    func draw3DStereoscopic_Diffuse_YesColored(renderEncoder: MTLRenderCommandEncoder,
                                               projectionMatrix: matrix_float4x4,
                                               modelViewMatrix: matrix_float4x4,
                                               normalMatrix: matrix_float4x4,
                                               lightDirX: Float, lightDirY: Float, lightDirZ: Float,
                                               lightAmbientIntensity: Float,
                                               lightDiffuseIntensity: Float,
                                               pipelineState: Graphics.PipelineState) {
        diffuseBufferColoredStereoscopic.uniformsVertex.projectionMatrix = projectionMatrix
        diffuseBufferColoredStereoscopic.uniformsVertex.modelViewMatrix = modelViewMatrix
        diffuseBufferColoredStereoscopic.uniformsVertex.normalMatrix = normalMatrix
        diffuseBufferColoredStereoscopic.uniformsFragment.lightDirX = lightDirX
        diffuseBufferColoredStereoscopic.uniformsFragment.lightDirY = lightDirY
        diffuseBufferColoredStereoscopic.uniformsFragment.lightDirZ = lightDirZ
        diffuseBufferColoredStereoscopic.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
        diffuseBufferColoredStereoscopic.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
        diffuseBufferColoredStereoscopic.setDirty(isVertexBufferDirty: true,
                                                  isIndexBufferDirty: false,
                                                  isUniformsVertexBufferDirty: true,
                                                  isUniformsFragmentBufferDirty: true)
        diffuseBufferColoredStereoscopic.render(renderEncoder: renderEncoder, pipelineState: pipelineState)
    }
    
    func draw3D_Phong_NotColored(renderEncoder: MTLRenderCommandEncoder,
                                 projectionMatrix: matrix_float4x4,
                                 modelViewMatrix: matrix_float4x4,
                                 normalMatrix: matrix_float4x4,
                                 lightDirX: Float,
                                 lightDirY: Float,
                                 lightDirZ: Float,
                                 lightAmbientIntensity: Float,
                                 lightDiffuseIntensity: Float,
                                 lightSpecularIntensity: Float,
                                 lightShininess: Float) {
        phongBuffer.uniformsVertex.projectionMatrix = projectionMatrix
        phongBuffer.uniformsVertex.modelViewMatrix = modelViewMatrix
        phongBuffer.uniformsVertex.normalMatrix = normalMatrix
        
        phongBuffer.uniformsFragment.lightDirX = lightDirX
        phongBuffer.uniformsFragment.lightDirY = lightDirY
        phongBuffer.uniformsFragment.lightDirZ = lightDirZ
        phongBuffer.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
        phongBuffer.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
        phongBuffer.uniformsFragment.lightSpecularIntensity = lightSpecularIntensity
        phongBuffer.uniformsFragment.lightShininess = lightShininess
        phongBuffer.setDirty(isVertexBufferDirty: true,
                               isIndexBufferDirty: false,
                               isUniformsVertexBufferDirty: true,
                               isUniformsFragmentBufferDirty: true)
        phongBuffer.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexedPhong3DNoBlending)
    }

    func draw3D_Phong_YesColored(renderEncoder: MTLRenderCommandEncoder,
                                 projectionMatrix: matrix_float4x4,
                                 modelViewMatrix: matrix_float4x4,
                                 normalMatrix: matrix_float4x4,
                                 lightDirX: Float,
                                 lightDirY: Float,
                                 lightDirZ: Float,
                                 lightAmbientIntensity: Float,
                                 lightDiffuseIntensity: Float,
                                 lightSpecularIntensity: Float,
                                 lightShininess: Float) {
        phongBufferColored.uniformsVertex.projectionMatrix = projectionMatrix
        phongBufferColored.uniformsVertex.modelViewMatrix = modelViewMatrix
        phongBufferColored.uniformsVertex.normalMatrix = normalMatrix
        
        phongBufferColored.uniformsFragment.lightDirX = lightDirX
        phongBufferColored.uniformsFragment.lightDirY = lightDirY
        phongBufferColored.uniformsFragment.lightDirZ = lightDirZ
        phongBufferColored.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
        phongBufferColored.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
        phongBufferColored.uniformsFragment.lightSpecularIntensity = lightSpecularIntensity
        phongBufferColored.uniformsFragment.lightShininess = lightShininess
        phongBufferColored.setDirty(isVertexBufferDirty: true,
                                    isIndexBufferDirty: false,
                                    isUniformsVertexBufferDirty: true,
                                    isUniformsFragmentBufferDirty: true)
        phongBufferColored.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexedPhongColored3DNoBlending)
    }

    func draw3DStereoscopic_Phong_NotColored(renderEncoder: MTLRenderCommandEncoder,
                                             projectionMatrix: matrix_float4x4,
                                             modelViewMatrix: matrix_float4x4,
                                             normalMatrix: matrix_float4x4,
                                             lightDirX: Float, lightDirY: Float, lightDirZ: Float,
                                             lightAmbientIntensity: Float,
                                             lightDiffuseIntensity: Float,
                                             lightSpecularIntensity: Float,
                                             lightShininess: Float,
                                             pipelineState: Graphics.PipelineState) {
        phongBufferStereoscopic.uniformsVertex.projectionMatrix = projectionMatrix
        phongBufferStereoscopic.uniformsVertex.modelViewMatrix = modelViewMatrix
        phongBufferStereoscopic.uniformsVertex.normalMatrix = normalMatrix
        
        phongBufferStereoscopic.uniformsFragment.lightDirX = lightDirX
        phongBufferStereoscopic.uniformsFragment.lightDirY = lightDirY
        phongBufferStereoscopic.uniformsFragment.lightDirZ = lightDirZ
        phongBufferStereoscopic.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
        phongBufferStereoscopic.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
        phongBufferStereoscopic.uniformsFragment.lightSpecularIntensity = lightSpecularIntensity
        phongBufferStereoscopic.uniformsFragment.lightShininess = lightShininess
        phongBufferStereoscopic.setDirty(isVertexBufferDirty: true,
                                         isIndexBufferDirty: false,
                                         isUniformsVertexBufferDirty: true,
                                         isUniformsFragmentBufferDirty: true)
        phongBufferStereoscopic.render(renderEncoder: renderEncoder, pipelineState: pipelineState)
    }

    func draw3DStereoscopic_Phong_YesColored(renderEncoder: MTLRenderCommandEncoder,
                                             projectionMatrix: matrix_float4x4,
                                             modelViewMatrix: matrix_float4x4,
                                             normalMatrix: matrix_float4x4,
                                             lightDirX: Float, lightDirY: Float, lightDirZ: Float,
                                             lightAmbientIntensity: Float,
                                             lightDiffuseIntensity: Float,
                                             lightSpecularIntensity: Float,
                                             lightShininess: Float,
                                             pipelineState: Graphics.PipelineState) {
        phongBufferColoredStereoscopic.uniformsVertex.projectionMatrix = projectionMatrix
        phongBufferColoredStereoscopic.uniformsVertex.modelViewMatrix = modelViewMatrix
        phongBufferColoredStereoscopic.uniformsVertex.normalMatrix = normalMatrix
        phongBufferColoredStereoscopic.uniformsFragment.lightDirX = lightDirX
        phongBufferColoredStereoscopic.uniformsFragment.lightDirY = lightDirY
        phongBufferColoredStereoscopic.uniformsFragment.lightDirZ = lightDirZ
        phongBufferColoredStereoscopic.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
        phongBufferColoredStereoscopic.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
        phongBufferColoredStereoscopic.uniformsFragment.lightSpecularIntensity = lightSpecularIntensity
        phongBufferColoredStereoscopic.uniformsFragment.lightShininess = lightShininess
        phongBufferColoredStereoscopic.setDirty(isVertexBufferDirty: true,
                                                  isIndexBufferDirty: false,
                                                  isUniformsVertexBufferDirty: true,
                                                  isUniformsFragmentBufferDirty: true)
        phongBufferColoredStereoscopic.render(renderEncoder: renderEncoder, pipelineState: pipelineState)
    }
    
    func draw3D_Night(renderEncoder: MTLRenderCommandEncoder,
                      projectionMatrix: matrix_float4x4,
                      modelViewMatrix: matrix_float4x4,
                      normalMatrix: matrix_float4x4,
                      lightDirX: Float,
                      lightDirY: Float,
                      lightDirZ: Float,
                      lightAmbientIntensity: Float,
                      lightDiffuseIntensity: Float,
                      lightNightIntensity: Float,
                      overshoot: Float) {
        nightBuffer.uniformsVertex.projectionMatrix = projectionMatrix
        nightBuffer.uniformsVertex.modelViewMatrix = modelViewMatrix
        nightBuffer.uniformsVertex.normalMatrix = normalMatrix
        nightBuffer.uniformsFragment.lightDirX = lightDirX
        nightBuffer.uniformsFragment.lightDirY = lightDirY
        nightBuffer.uniformsFragment.lightDirZ = lightDirZ
        nightBuffer.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
        nightBuffer.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
        nightBuffer.uniformsFragment.lightNightIntensity = lightNightIntensity
        nightBuffer.uniformsFragment.overshoot = overshoot
        nightBuffer.setDirty(isVertexBufferDirty: true,
                               isIndexBufferDirty: false,
                               isUniformsVertexBufferDirty: true,
                               isUniformsFragmentBufferDirty: true)
        nightBuffer.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexedNight3DNoBlending)
    }

    func draw3DStereoscopic_Night(renderEncoder: MTLRenderCommandEncoder,
                                  projectionMatrix: matrix_float4x4,
                                  modelViewMatrix: matrix_float4x4,
                                  normalMatrix: matrix_float4x4,
                                  lightDirX: Float, lightDirY: Float, lightDirZ: Float,
                                  lightAmbientIntensity: Float,
                                  lightDiffuseIntensity: Float,
                                  lightNightIntensity: Float,
                                  overshoot: Float,
                                  pipelineState: Graphics.PipelineState) {
        nightBufferStereoscopic.uniformsVertex.projectionMatrix = projectionMatrix
        nightBufferStereoscopic.uniformsVertex.modelViewMatrix = modelViewMatrix
        nightBufferStereoscopic.uniformsVertex.normalMatrix = normalMatrix
        nightBufferStereoscopic.uniformsFragment.lightDirX = lightDirX
        nightBufferStereoscopic.uniformsFragment.lightDirY = lightDirY
        nightBufferStereoscopic.uniformsFragment.lightDirZ = lightDirZ
        nightBufferStereoscopic.uniformsFragment.lightAmbientIntensity = lightAmbientIntensity
        nightBufferStereoscopic.uniformsFragment.lightDiffuseIntensity = lightDiffuseIntensity
        nightBufferStereoscopic.uniformsFragment.lightNightIntensity = lightNightIntensity
        nightBufferStereoscopic.uniformsFragment.overshoot = overshoot
        nightBufferStereoscopic.setDirty(isVertexBufferDirty: true,
                                         isIndexBufferDirty: false,
                                         isUniformsVertexBufferDirty: true,
                                         isUniformsFragmentBufferDirty: true)
        nightBufferStereoscopic.render(renderEncoder: renderEncoder, pipelineState: pipelineState)
    }
    
}
