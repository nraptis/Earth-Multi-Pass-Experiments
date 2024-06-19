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
    
    
    weak var skinMap: Sprite?
    weak var lightMap: Sprite?
    
    let indexV: Int
    
    let bloomBuffer = IndexedShapeBuffer3D()
    let bloomBufferColored = IndexedShapeBuffer3DColored()
    
    let noLightBuffer = IndexedSpriteBuffer3D()
    let noLightBufferColored = IndexedSpriteBuffer3DColored()
    
    let noLightBufferStereoscopic = IndexedSpriteBuffer3DStereoscopic()
    let noLightBufferColoredStereoscopic = IndexedSpriteBuffer3DColoredStereoscopic()
    
    
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
    
    
    init(indexV: Int) {
        
        self.indexV = indexV
        
        for indexH in 0...Earth.tileCountH {

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
            noLightBuffer.add(vertex: Sprite3DVertex())
            noLightBuffer.add(vertex: Sprite3DVertex())
            
            noLightBufferColored.add(index: UInt32(indexH * 2))
            noLightBufferColored.add(index: UInt32(indexH * 2 + 1))
            noLightBufferColored.add(vertex: Sprite3DColoredVertex())
            noLightBufferColored.add(vertex: Sprite3DColoredVertex())
            
            noLightBufferStereoscopic.add(index: UInt32(indexH * 2))
            noLightBufferStereoscopic.add(index: UInt32(indexH * 2 + 1))
            noLightBufferStereoscopic.add(vertex: Sprite3DVertexStereoscopic())
            noLightBufferStereoscopic.add(vertex: Sprite3DVertexStereoscopic())
            
            noLightBufferColoredStereoscopic.add(index: UInt32(indexH * 2))
            noLightBufferColoredStereoscopic.add(index: UInt32(indexH * 2 + 1))
            noLightBufferColoredStereoscopic.add(vertex: Sprite3DVertexColoredStereoscopic())
            noLightBufferColoredStereoscopic.add(vertex: Sprite3DVertexColoredStereoscopic())
            
            diffuseBuffer.add(index: UInt32(indexH * 2))
            diffuseBuffer.add(index: UInt32(indexH * 2 + 1))
            diffuseBuffer.add(vertex: Sprite3DLightedVertex())
            diffuseBuffer.add(vertex: Sprite3DLightedVertex())
            
            diffuseBufferColored.add(index: UInt32(indexH * 2))
            diffuseBufferColored.add(index: UInt32(indexH * 2 + 1))
            diffuseBufferColored.add(vertex: Sprite3DLightedColoredVertex())
            diffuseBufferColored.add(vertex: Sprite3DLightedColoredVertex())
            
            diffuseBufferStereoscopic.add(index: UInt32(indexH * 2))
            diffuseBufferStereoscopic.add(index: UInt32(indexH * 2 + 1))
            diffuseBufferStereoscopic.add(vertex: Sprite3DLightedStereoscopicVertex())
            diffuseBufferStereoscopic.add(vertex: Sprite3DLightedStereoscopicVertex())
            
            diffuseBufferColoredStereoscopic.add(index: UInt32(indexH * 2))
            diffuseBufferColoredStereoscopic.add(index: UInt32(indexH * 2 + 1))
            diffuseBufferColoredStereoscopic.add(vertex: Sprite3DLightedColoredStereoscopicVertex())
            diffuseBufferColoredStereoscopic.add(vertex: Sprite3DLightedColoredStereoscopicVertex())
            
            phongBuffer.add(index: UInt32(indexH * 2))
            phongBuffer.add(index: UInt32(indexH * 2 + 1))
            phongBuffer.add(vertex: Sprite3DLightedVertex())
            phongBuffer.add(vertex: Sprite3DLightedVertex())

            phongBufferColored.add(index: UInt32(indexH * 2))
            phongBufferColored.add(index: UInt32(indexH * 2 + 1))
            phongBufferColored.add(vertex: Sprite3DLightedColoredVertex())
            phongBufferColored.add(vertex: Sprite3DLightedColoredVertex())

            phongBufferStereoscopic.add(index: UInt32(indexH * 2))
            phongBufferStereoscopic.add(index: UInt32(indexH * 2 + 1))
            phongBufferStereoscopic.add(vertex: Sprite3DLightedStereoscopicVertex())
            phongBufferStereoscopic.add(vertex: Sprite3DLightedStereoscopicVertex())

            phongBufferColoredStereoscopic.add(index: UInt32(indexH * 2))
            phongBufferColoredStereoscopic.add(index: UInt32(indexH * 2 + 1))
            phongBufferColoredStereoscopic.add(vertex: Sprite3DLightedColoredStereoscopicVertex())
            phongBufferColoredStereoscopic.add(vertex: Sprite3DLightedColoredStereoscopicVertex())
            
            nightBuffer.add(index: UInt32(indexH * 2))
            nightBuffer.add(index: UInt32(indexH * 2 + 1))
            nightBuffer.add(vertex: Sprite3DLightedVertex())
            nightBuffer.add(vertex: Sprite3DLightedVertex())

            nightBufferStereoscopic.add(index: UInt32(indexH * 2))
            nightBufferStereoscopic.add(index: UInt32(indexH * 2 + 1))
            nightBufferStereoscopic.add(vertex: Sprite3DLightedStereoscopicVertex())
            nightBufferStereoscopic.add(vertex: Sprite3DLightedStereoscopicVertex())
        }
    }
    
    func load(graphics: Graphics,
              skinMap: Sprite?,
              lightMap: Sprite?) {
        self.skinMap = skinMap
        self.lightMap = lightMap
        
        bloomBuffer.load(graphics: graphics)
        bloomBuffer.primitiveType = .triangleStrip
        bloomBuffer.cullMode = .none
        
        bloomBufferColored.load(graphics: graphics)
        bloomBufferColored.primitiveType = .triangleStrip
        bloomBufferColored.cullMode = .none
        
        noLightBuffer.load(graphics: graphics, sprite: skinMap)
        noLightBuffer.primitiveType = .triangleStrip
        noLightBuffer.cullMode = .none
        
        noLightBufferColored.load(graphics: graphics, sprite: skinMap)
        noLightBufferColored.primitiveType = .triangleStrip
        noLightBufferColored.cullMode = .none
        
        noLightBufferStereoscopic.load(graphics: graphics, sprite: skinMap)
        noLightBufferStereoscopic.primitiveType = .triangleStrip
        noLightBufferStereoscopic.cullMode = .none
        
        noLightBufferColoredStereoscopic.load(graphics: graphics, sprite: skinMap)
        noLightBufferColoredStereoscopic.primitiveType = .triangleStrip
        noLightBufferColoredStereoscopic.cullMode = .none
        
        diffuseBuffer.load(graphics: graphics, sprite: skinMap)
        diffuseBuffer.primitiveType = .triangleStrip
        diffuseBuffer.cullMode = .none
        
        diffuseBufferColored.load(graphics: graphics, sprite: skinMap)
        diffuseBufferColored.primitiveType = .triangleStrip
        diffuseBufferColored.cullMode = .none
        
        diffuseBufferStereoscopic.load(graphics: graphics, sprite: skinMap)
        diffuseBufferStereoscopic.primitiveType = .triangleStrip
        diffuseBufferStereoscopic.cullMode = .none
        
        diffuseBufferColoredStereoscopic.load(graphics: graphics, sprite: skinMap)
        diffuseBufferColoredStereoscopic.primitiveType = .triangleStrip
        diffuseBufferColoredStereoscopic.cullMode = .none
        
        phongBuffer.load(graphics: graphics, sprite: skinMap)
        phongBuffer.primitiveType = .triangleStrip
        phongBuffer.cullMode = .none
        
        phongBufferColored.load(graphics: graphics, sprite: skinMap)
        phongBufferColored.primitiveType = .triangleStrip
        phongBufferColored.cullMode = .none
        
        phongBufferStereoscopic.load(graphics: graphics, sprite: skinMap)
        phongBufferStereoscopic.primitiveType = .triangleStrip
        phongBufferStereoscopic.cullMode = .none
        
        phongBufferColoredStereoscopic.load(graphics: graphics, sprite: skinMap)
        phongBufferColoredStereoscopic.primitiveType = .triangleStrip
        phongBufferColoredStereoscopic.cullMode = .none
        
        nightBuffer.load(graphics: graphics, sprite: skinMap, lights: lightMap)
        nightBuffer.primitiveType = .triangleStrip
        nightBuffer.cullMode = .none
        
        nightBufferStereoscopic.load(graphics: graphics, sprite: skinMap, lights: lightMap)
        nightBufferStereoscopic.primitiveType = .triangleStrip
        nightBufferStereoscopic.cullMode = .none
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
        
        let percentV1 = (Float(indexV - 1) / Float(Earth.tileCountV))
        let percentV2 = (Float(indexV) / Float(Earth.tileCountV))
        let _angleV1 = startRotationV + (endRotationV - startRotationV) * percentV1
        let _angleV2 = startRotationV + (endRotationV - startRotationV) * percentV2
        var indexH = 0
        while indexH <= Earth.tileCountH {
            let percentH = (Float(indexH) / Float(Earth.tileCountH))
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
            
            let u1 = percentH
            let v1 = percentV1
            
            let u2 = percentH
            let v2 = percentV2
            
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
            noLightBuffer.vertices[vertexIndex1].u = u1
            noLightBuffer.vertices[vertexIndex1].v = v1
            
            //
            noLightBuffer.vertices[vertexIndex2].x = x2
            noLightBuffer.vertices[vertexIndex2].y = y2
            noLightBuffer.vertices[vertexIndex2].z = z2
            noLightBuffer.vertices[vertexIndex2].u = u2
            noLightBuffer.vertices[vertexIndex2].v = v2
            //
            //
            //
            noLightBufferColored.vertices[vertexIndex1].x = x1
            noLightBufferColored.vertices[vertexIndex1].y = y1
            noLightBufferColored.vertices[vertexIndex1].z = z1
            noLightBufferColored.vertices[vertexIndex1].u = u1
            noLightBufferColored.vertices[vertexIndex1].v = v1
            noLightBufferColored.vertices[vertexIndex1].r = r1
            noLightBufferColored.vertices[vertexIndex1].g = g1
            noLightBufferColored.vertices[vertexIndex1].b = b1
            //
            noLightBufferColored.vertices[vertexIndex2].x = x2
            noLightBufferColored.vertices[vertexIndex2].y = y2
            noLightBufferColored.vertices[vertexIndex2].z = z2
            noLightBufferColored.vertices[vertexIndex2].u = u2
            noLightBufferColored.vertices[vertexIndex2].v = v2
            noLightBufferColored.vertices[vertexIndex2].r = r2
            noLightBufferColored.vertices[vertexIndex2].g = g2
            noLightBufferColored.vertices[vertexIndex2].b = b2
            //
            //
            //
            noLightBufferStereoscopic.vertices[vertexIndex1].x = x1
            noLightBufferStereoscopic.vertices[vertexIndex1].y = y1
            noLightBufferStereoscopic.vertices[vertexIndex1].z = z1
            noLightBufferStereoscopic.vertices[vertexIndex1].u = u1
            noLightBufferStereoscopic.vertices[vertexIndex1].v = v1
            noLightBufferStereoscopic.vertices[vertexIndex1].shift = shift1
            //
            noLightBufferStereoscopic.vertices[vertexIndex2].x = x2
            noLightBufferStereoscopic.vertices[vertexIndex2].y = y2
            noLightBufferStereoscopic.vertices[vertexIndex2].z = z2
            noLightBufferStereoscopic.vertices[vertexIndex2].u = u2
            noLightBufferStereoscopic.vertices[vertexIndex2].v = v2
            noLightBufferStereoscopic.vertices[vertexIndex2].shift = shift2
            //
            //
            //
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].x = x1
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].y = y1
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].z = z1
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].u = u1
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].v = v1
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].r = r1
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].g = g1
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].b = b1
            noLightBufferColoredStereoscopic.vertices[vertexIndex1].shift = shift1
            //
            noLightBufferColoredStereoscopic.vertices[vertexIndex2].x = x2
            noLightBufferColoredStereoscopic.vertices[vertexIndex2].y = y2
            noLightBufferColoredStereoscopic.vertices[vertexIndex2].z = z2
            noLightBufferColoredStereoscopic.vertices[vertexIndex2].u = u2
            noLightBufferColoredStereoscopic.vertices[vertexIndex2].v = v2
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
            diffuseBuffer.vertices[vertexIndex1].u = u1
            diffuseBuffer.vertices[vertexIndex1].v = v1
            diffuseBuffer.vertices[vertexIndex1].normalX = normalX1
            diffuseBuffer.vertices[vertexIndex1].normalY = normalY1
            diffuseBuffer.vertices[vertexIndex1].normalZ = normalZ1
            //
            diffuseBuffer.vertices[vertexIndex2].x = x2
            diffuseBuffer.vertices[vertexIndex2].y = y2
            diffuseBuffer.vertices[vertexIndex2].z = z2
            diffuseBuffer.vertices[vertexIndex2].u = u2
            diffuseBuffer.vertices[vertexIndex2].v = v2
            diffuseBuffer.vertices[vertexIndex2].normalX = normalX2
            diffuseBuffer.vertices[vertexIndex2].normalY = normalY2
            diffuseBuffer.vertices[vertexIndex2].normalZ = normalZ2
            //
            //
            //
            diffuseBufferColored.vertices[vertexIndex1].x = x1
            diffuseBufferColored.vertices[vertexIndex1].y = y1
            diffuseBufferColored.vertices[vertexIndex1].z = z1
            diffuseBufferColored.vertices[vertexIndex1].u = u1
            diffuseBufferColored.vertices[vertexIndex1].v = v1
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
            diffuseBufferColored.vertices[vertexIndex2].u = u2
            diffuseBufferColored.vertices[vertexIndex2].v = v2
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
            diffuseBufferStereoscopic.vertices[vertexIndex1].u = u1
            diffuseBufferStereoscopic.vertices[vertexIndex1].v = v1
            diffuseBufferStereoscopic.vertices[vertexIndex1].normalX = normalX1
            diffuseBufferStereoscopic.vertices[vertexIndex1].normalY = normalY1
            diffuseBufferStereoscopic.vertices[vertexIndex1].normalZ = normalZ1
            diffuseBufferStereoscopic.vertices[vertexIndex1].shift = shift1
            //
            diffuseBufferStereoscopic.vertices[vertexIndex2].x = x2
            diffuseBufferStereoscopic.vertices[vertexIndex2].y = y2
            diffuseBufferStereoscopic.vertices[vertexIndex2].z = z2
            diffuseBufferStereoscopic.vertices[vertexIndex2].u = u2
            diffuseBufferStereoscopic.vertices[vertexIndex2].v = v2
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
            diffuseBufferColoredStereoscopic.vertices[vertexIndex1].u = u1
            diffuseBufferColoredStereoscopic.vertices[vertexIndex1].v = v1
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
            diffuseBufferColoredStereoscopic.vertices[vertexIndex2].u = u2
            diffuseBufferColoredStereoscopic.vertices[vertexIndex2].v = v2
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
            phongBuffer.vertices[vertexIndex1].u = u1
            phongBuffer.vertices[vertexIndex1].v = v1
            phongBuffer.vertices[vertexIndex1].normalX = normalX1
            phongBuffer.vertices[vertexIndex1].normalY = normalY1
            phongBuffer.vertices[vertexIndex1].normalZ = normalZ1
            //
            phongBuffer.vertices[vertexIndex2].x = x2
            phongBuffer.vertices[vertexIndex2].y = y2
            phongBuffer.vertices[vertexIndex2].z = z2
            phongBuffer.vertices[vertexIndex2].u = u2
            phongBuffer.vertices[vertexIndex2].v = v2
            phongBuffer.vertices[vertexIndex2].normalX = normalX2
            phongBuffer.vertices[vertexIndex2].normalY = normalY2
            phongBuffer.vertices[vertexIndex2].normalZ = normalZ2
            //
            //
            //
            phongBufferColored.vertices[vertexIndex1].x = x1
            phongBufferColored.vertices[vertexIndex1].y = y1
            phongBufferColored.vertices[vertexIndex1].z = z1
            phongBufferColored.vertices[vertexIndex1].u = u1
            phongBufferColored.vertices[vertexIndex1].v = v1
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
            phongBufferColored.vertices[vertexIndex2].u = u2
            phongBufferColored.vertices[vertexIndex2].v = v2
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
            phongBufferStereoscopic.vertices[vertexIndex1].u = u1
            phongBufferStereoscopic.vertices[vertexIndex1].v = v1
            phongBufferStereoscopic.vertices[vertexIndex1].normalX = normalX1
            phongBufferStereoscopic.vertices[vertexIndex1].normalY = normalY1
            phongBufferStereoscopic.vertices[vertexIndex1].normalZ = normalZ1
            phongBufferStereoscopic.vertices[vertexIndex1].shift = shift1
            //
            phongBufferStereoscopic.vertices[vertexIndex2].x = x2
            phongBufferStereoscopic.vertices[vertexIndex2].y = y2
            phongBufferStereoscopic.vertices[vertexIndex2].z = z2
            phongBufferStereoscopic.vertices[vertexIndex2].u = u2
            phongBufferStereoscopic.vertices[vertexIndex2].v = v2
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
            phongBufferColoredStereoscopic.vertices[vertexIndex1].u = u1
            phongBufferColoredStereoscopic.vertices[vertexIndex1].v = v1
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
            phongBufferColoredStereoscopic.vertices[vertexIndex2].u = u2
            phongBufferColoredStereoscopic.vertices[vertexIndex2].v = v2
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
            nightBuffer.vertices[vertexIndex1].u = u1
            nightBuffer.vertices[vertexIndex1].v = v1
            nightBuffer.vertices[vertexIndex1].normalX = normalX1
            nightBuffer.vertices[vertexIndex1].normalY = normalY1
            nightBuffer.vertices[vertexIndex1].normalZ = normalZ1
            //
            nightBuffer.vertices[vertexIndex2].x = x2
            nightBuffer.vertices[vertexIndex2].y = y2
            nightBuffer.vertices[vertexIndex2].z = z2
            nightBuffer.vertices[vertexIndex2].u = u2
            nightBuffer.vertices[vertexIndex2].v = v2
            nightBuffer.vertices[vertexIndex2].normalX = normalX2
            nightBuffer.vertices[vertexIndex2].normalY = normalY2
            nightBuffer.vertices[vertexIndex2].normalZ = normalZ2
            //
            //
            //
            nightBufferStereoscopic.vertices[vertexIndex1].x = x1
            nightBufferStereoscopic.vertices[vertexIndex1].y = y1
            nightBufferStereoscopic.vertices[vertexIndex1].z = z1
            nightBufferStereoscopic.vertices[vertexIndex1].u = u1
            nightBufferStereoscopic.vertices[vertexIndex1].v = v1
            nightBufferStereoscopic.vertices[vertexIndex1].normalX = normalX1
            nightBufferStereoscopic.vertices[vertexIndex1].normalY = normalY1
            nightBufferStereoscopic.vertices[vertexIndex1].normalZ = normalZ1
            nightBufferStereoscopic.vertices[vertexIndex1].shift = shift1
            //
            nightBufferStereoscopic.vertices[vertexIndex2].x = x2
            nightBufferStereoscopic.vertices[vertexIndex2].y = y2
            nightBufferStereoscopic.vertices[vertexIndex2].z = z2
            nightBufferStereoscopic.vertices[vertexIndex2].u = u2
            nightBufferStereoscopic.vertices[vertexIndex2].v = v2
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
