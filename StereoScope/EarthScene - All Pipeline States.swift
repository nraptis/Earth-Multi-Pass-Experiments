//
//  JiggleScene.swift
//  Jiggle3
//
//  Created by Nicky Taylor on 11/9/23.
//

import Foundation
import Metal
import MetalKit
import simd

class EarthScene: GraphicsDelegate {
    
    var graphics: Graphics!
    
    let width: Float
    let height: Float
    let centerX: Float
    let centerY: Float
    
    var earthTexture: MTLTexture?
    var lightsTexture: MTLTexture?
    var size80Texture: MTLTexture?
    
    
   
    
    let testSprite = SpriteInstance2D()
    
    let earth = Earth()
    
    
    let shapeInstance2D = [IndexedShapeInstance<Shape2DVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape2DVertex(x: 0.0, y: 0.0)),
                           IndexedShapeInstance<Shape2DVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape2DVertex(x: 0.0, y: 0.0)),
                           IndexedShapeInstance<Shape2DVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape2DVertex(x: 0.0, y: 0.0)),
                           IndexedShapeInstance<Shape2DVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape2DVertex(x: 0.0, y: 0.0))]
    
    let shapeInstance3D = [IndexedShapeInstance<Shape3DVertex,
                           UniformsShapeVertex,
                           UniformsShapeFragment>(sentinelNode: Shape3DVertex(x: 0.0, y: 0.0, z: 0.0)),
                           IndexedShapeInstance<Shape3DVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape3DVertex(x: 0.0, y: 0.0, z: 0.0)),
                           IndexedShapeInstance<Shape3DVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape3DVertex(x: 0.0, y: 0.0, z: 0.0)),
                           IndexedShapeInstance<Shape3DVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape3DVertex(x: 0.0, y: 0.0, z: 0.0))]
    
    let shapeInstance2DColored = [IndexedShapeInstance<Shape2DColoredVertex,
                           UniformsShapeVertex,
                                  UniformsShapeFragment>(sentinelNode: Shape2DColoredVertex(x: 0.0, y: 0.0
                                                                                            , r: Float.random(in: 0.0...1.0)
                                                                                            , g: Float.random(in: 0.0...1.0)
                                                                                            , b: Float.random(in: 0.0...1.0)
                                                                                            , a: Float.random(in: 0.5...1.0))),
                           IndexedShapeInstance<Shape2DColoredVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape2DColoredVertex(x: 0.0, y: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                         , g: Float.random(in: 0.0...1.0)
                                                                                                                         , b: Float.random(in: 0.0...1.0)
                                                                                                                         , a: Float.random(in: 0.5...1.0))),
                           IndexedShapeInstance<Shape2DColoredVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape2DColoredVertex(x: 0.0, y: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                         , g: Float.random(in: 0.0...1.0)
                                                                                                                         , b: Float.random(in: 0.0...1.0)
                                                                                                                         , a: Float.random(in: 0.5...1.0))),
                           IndexedShapeInstance<Shape2DColoredVertex,
                           UniformsShapeVertex,
                                                                      UniformsShapeFragment>(sentinelNode: Shape2DColoredVertex(x: 0.0, y: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                         , g: Float.random(in: 0.0...1.0)
                                                                                                                         , b: Float.random(in: 0.0...1.0)
                                                                                                                         , a: Float.random(in: 0.5...1.0)))]
    
    let shapeInstance3DColored = [IndexedShapeInstance<Shape3DColoredVertex,
                               UniformsShapeVertex,
                                  UniformsShapeFragment>(sentinelNode: Shape3DColoredVertex(x: 0.0, y: 0.0, z: 0.0
                                                                                                , r: Float.random(in: 0.0...1.0)
                                                                                                , g: Float.random(in: 0.0...1.0)
                                                                                                , b: Float.random(in: 0.0...1.0)
                                                                                                , a: Float.random(in: 0.5...1.0))),
                               IndexedShapeInstance<Shape3DColoredVertex,
                               UniformsShapeVertex,
                                                                          UniformsShapeFragment>(sentinelNode: Shape3DColoredVertex(x: 0.0, y: 0.0, z: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                             , g: Float.random(in: 0.0...1.0)
                                                                                                                             , b: Float.random(in: 0.0...1.0)
                                                                                                                             , a: Float.random(in: 0.5...1.0))),
                               IndexedShapeInstance<Shape3DColoredVertex,
                               UniformsShapeVertex,
                                                                          UniformsShapeFragment>(sentinelNode: Shape3DColoredVertex(x: 0.0, y: 0.0, z: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                             , g: Float.random(in: 0.0...1.0)
                                                                                                                             , b: Float.random(in: 0.0...1.0)
                                                                                                                             , a: Float.random(in: 0.5...1.0))),
                               IndexedShapeInstance<Shape3DColoredVertex,
                               UniformsShapeVertex,
                                                                          UniformsShapeFragment>(sentinelNode: Shape3DColoredVertex(x: 0.0, y: 0.0, z: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                             , g: Float.random(in: 0.0...1.0)
                                                                                                                             , b: Float.random(in: 0.0...1.0)
                                                                                                                             , a: Float.random(in: 0.5...1.0)))]
    
    
    let spriteInstance2D = [IndexedSpriteInstance<Sprite2DVertex,
                               UniformsSpriteVertex,
                            UniformsSpriteFragment>(sentinelNode: Sprite2DVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0)),
                               IndexedSpriteInstance<Sprite2DVertex,
                               UniformsSpriteVertex,
                                                                          UniformsSpriteFragment>(sentinelNode: Sprite2DVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0)),
                               IndexedSpriteInstance<Sprite2DVertex,
                               UniformsSpriteVertex,
                                                                          UniformsSpriteFragment>(sentinelNode: Sprite2DVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0)),
                               IndexedSpriteInstance<Sprite2DVertex,
                               UniformsSpriteVertex,
                                                                          UniformsSpriteFragment>(sentinelNode: Sprite2DVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0))]
    
    let spriteInstanceWhite2D = [IndexedSpriteInstance<Sprite2DVertex,
                               UniformsSpriteVertex,
                            UniformsSpriteFragment>(sentinelNode: Sprite2DVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0)),
                               IndexedSpriteInstance<Sprite2DVertex,
                               UniformsSpriteVertex,
                                                                          UniformsSpriteFragment>(sentinelNode: Sprite2DVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0)),
                               IndexedSpriteInstance<Sprite2DVertex,
                               UniformsSpriteVertex,
                                                                          UniformsSpriteFragment>(sentinelNode: Sprite2DVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0)),
                               IndexedSpriteInstance<Sprite2DVertex,
                               UniformsSpriteVertex,
                                                                          UniformsSpriteFragment>(sentinelNode: Sprite2DVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0))]
    
    
        
    let spriteInstance3D = [IndexedSpriteInstance<Sprite3DVertex,
                           UniformsSpriteVertex,
                           UniformsSpriteFragment>(sentinelNode: Sprite3DVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0)),
                           IndexedSpriteInstance<Sprite3DVertex,
                           UniformsSpriteVertex,
                                                                      UniformsSpriteFragment>(sentinelNode: Sprite3DVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0)),
                           IndexedSpriteInstance<Sprite3DVertex,
                           UniformsSpriteVertex,
                                                                      UniformsSpriteFragment>(sentinelNode: Sprite3DVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0)),
                           IndexedSpriteInstance<Sprite3DVertex,
                           UniformsSpriteVertex,
                                                                      UniformsSpriteFragment>(sentinelNode: Sprite3DVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0))]
    
    
    let spriteInstanceWhite3D = [IndexedSpriteInstance<Sprite3DVertex,
                           UniformsSpriteVertex,
                           UniformsSpriteFragment>(sentinelNode: Sprite3DVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0)),
                           IndexedSpriteInstance<Sprite3DVertex,
                           UniformsSpriteVertex,
                                                                      UniformsSpriteFragment>(sentinelNode: Sprite3DVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0)),
                           IndexedSpriteInstance<Sprite3DVertex,
                           UniformsSpriteVertex,
                                                                      UniformsSpriteFragment>(sentinelNode: Sprite3DVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0)),
                           IndexedSpriteInstance<Sprite3DVertex,
                           UniformsSpriteVertex,
                                                                      UniformsSpriteFragment>(sentinelNode: Sprite3DVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0))]
        
        let spriteInstance2DColored = [IndexedSpriteInstance<Sprite2DColoredVertex,
                               UniformsSpriteVertex,
                                      UniformsSpriteFragment>(sentinelNode: Sprite2DColoredVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0
                                                                                                , r: Float.random(in: 0.0...1.0)
                                                                                                , g: Float.random(in: 0.0...1.0)
                                                                                                , b: Float.random(in: 0.0...1.0)
                                                                                                , a: Float.random(in: 0.5...1.0))),
                               IndexedSpriteInstance<Sprite2DColoredVertex,
                               UniformsSpriteVertex,
                                                                          UniformsSpriteFragment>(sentinelNode: Sprite2DColoredVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                             , g: Float.random(in: 0.0...1.0)
                                                                                                                             , b: Float.random(in: 0.0...1.0)
                                                                                                                             , a: Float.random(in: 0.5...1.0))),
                               IndexedSpriteInstance<Sprite2DColoredVertex,
                               UniformsSpriteVertex,
                                                                          UniformsSpriteFragment>(sentinelNode: Sprite2DColoredVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                             , g: Float.random(in: 0.0...1.0)
                                                                                                                             , b: Float.random(in: 0.0...1.0)
                                                                                                                             , a: Float.random(in: 0.5...1.0))),
                               IndexedSpriteInstance<Sprite2DColoredVertex,
                               UniformsSpriteVertex,
                                                                          UniformsSpriteFragment>(sentinelNode: Sprite2DColoredVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                             , g: Float.random(in: 0.0...1.0)
                                                                                                                             , b: Float.random(in: 0.0...1.0)
                                                                                                                             , a: Float.random(in: 0.5...1.0)))]
    let spriteInstance2DWhiteColored = [IndexedSpriteInstance<Sprite2DColoredVertex,
                           UniformsSpriteVertex,
                                  UniformsSpriteFragment>(sentinelNode: Sprite2DColoredVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0
                                                                                            , r: Float.random(in: 0.0...1.0)
                                                                                            , g: Float.random(in: 0.0...1.0)
                                                                                            , b: Float.random(in: 0.0...1.0)
                                                                                            , a: Float.random(in: 0.5...1.0))),
                           IndexedSpriteInstance<Sprite2DColoredVertex,
                           UniformsSpriteVertex,
                                                                      UniformsSpriteFragment>(sentinelNode: Sprite2DColoredVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                         , g: Float.random(in: 0.0...1.0)
                                                                                                                         , b: Float.random(in: 0.0...1.0)
                                                                                                                         , a: Float.random(in: 0.5...1.0))),
                           IndexedSpriteInstance<Sprite2DColoredVertex,
                           UniformsSpriteVertex,
                                                                      UniformsSpriteFragment>(sentinelNode: Sprite2DColoredVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                         , g: Float.random(in: 0.0...1.0)
                                                                                                                         , b: Float.random(in: 0.0...1.0)
                                                                                                                         , a: Float.random(in: 0.5...1.0))),
                           IndexedSpriteInstance<Sprite2DColoredVertex,
                           UniformsSpriteVertex,
                                                                      UniformsSpriteFragment>(sentinelNode: Sprite2DColoredVertex(x: 0.0, y: 0.0, u: 0.0, v: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                         , g: Float.random(in: 0.0...1.0)
                                                                                                                         , b: Float.random(in: 0.0...1.0)
                                                                                                                         , a: Float.random(in: 0.5...1.0)))]
    
   
    
        let spriteInstance3DColored = [IndexedSpriteInstance<Sprite3DColoredVertex,
                                   UniformsSpriteVertex,
                                      UniformsSpriteFragment>(sentinelNode: Sprite3DColoredVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0
                                                                                                    , r: Float.random(in: 0.0...1.0)
                                                                                                    , g: Float.random(in: 0.0...1.0)
                                                                                                    , b: Float.random(in: 0.0...1.0)
                                                                                                    , a: Float.random(in: 0.5...1.0))),
                                   IndexedSpriteInstance<Sprite3DColoredVertex,
                                   UniformsSpriteVertex,
                                                                              UniformsSpriteFragment>(sentinelNode: Sprite3DColoredVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                                 , g: Float.random(in: 0.0...1.0)
                                                                                                                                 , b: Float.random(in: 0.0...1.0)
                                                                                                                                 , a: Float.random(in: 0.5...1.0))),
                                   IndexedSpriteInstance<Sprite3DColoredVertex,
                                   UniformsSpriteVertex,
                                                                              UniformsSpriteFragment>(sentinelNode: Sprite3DColoredVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                                 , g: Float.random(in: 0.0...1.0)
                                                                                                                                 , b: Float.random(in: 0.0...1.0)
                                                                                                                                 , a: Float.random(in: 0.5...1.0))),
                                   IndexedSpriteInstance<Sprite3DColoredVertex,
                                   UniformsSpriteVertex,
                                                                              UniformsSpriteFragment>(sentinelNode: Sprite3DColoredVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                                 , g: Float.random(in: 0.0...1.0)
                                                                                                                                 , b: Float.random(in: 0.0...1.0)
                                                                                                                                 , a: Float.random(in: 0.5...1.0)))]
    
    let spriteInstance3DWhiteColored = [IndexedSpriteInstance<Sprite3DColoredVertex,
                               UniformsSpriteVertex,
                                  UniformsSpriteFragment>(sentinelNode: Sprite3DColoredVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0
                                                                                                , r: Float.random(in: 0.0...1.0)
                                                                                                , g: Float.random(in: 0.0...1.0)
                                                                                                , b: Float.random(in: 0.0...1.0)
                                                                                                , a: Float.random(in: 0.5...1.0))),
                               IndexedSpriteInstance<Sprite3DColoredVertex,
                               UniformsSpriteVertex,
                                                                          UniformsSpriteFragment>(sentinelNode: Sprite3DColoredVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                             , g: Float.random(in: 0.0...1.0)
                                                                                                                             , b: Float.random(in: 0.0...1.0)
                                                                                                                             , a: Float.random(in: 0.5...1.0))),
                               IndexedSpriteInstance<Sprite3DColoredVertex,
                               UniformsSpriteVertex,
                                                                          UniformsSpriteFragment>(sentinelNode: Sprite3DColoredVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                             , g: Float.random(in: 0.0...1.0)
                                                                                                                             , b: Float.random(in: 0.0...1.0)
                                                                                                                             , a: Float.random(in: 0.5...1.0))),
                               IndexedSpriteInstance<Sprite3DColoredVertex,
                               UniformsSpriteVertex,
                                                                          UniformsSpriteFragment>(sentinelNode: Sprite3DColoredVertex(x: 0.0, y: 0.0, z: 0.0, u: 0.0, v: 0.0, r: Float.random(in: 0.0...1.0)
                                                                                                                             , g: Float.random(in: 0.0...1.0)
                                                                                                                             , b: Float.random(in: 0.0...1.0)
                                                                                                                             , a: Float.random(in: 0.5...1.0)))]
    
    
    
    
    init(width: Float,
         height: Float) {
        self.width = width
        self.height = height
        centerX = Float(Int(width * 0.5 + 0.5))
        centerY = Float(Int(height * 0.5 + 0.5))
    }
    
    deinit {
        print("[--] JiggleScene")
    }
    
    func load() {
        let loader = MTKTextureLoader(device: graphics.metalDevice)
        if let image = UIImage(named: "earth_texture") {
            if let cgImage = image.cgImage {
                earthTexture = try? loader.newTexture(cgImage: cgImage)
            }
        }
        if let image = UIImage(named: "lights_texture") {
            if let cgImage = image.cgImage {
                lightsTexture = try? loader.newTexture(cgImage: cgImage)
            }
        }
        
        if let image = UIImage(named: "size_80") {
            if let cgImage = image.cgImage {
                size80Texture = try? loader.newTexture(cgImage: cgImage)
            }
        }
        
        
        
        
        
        print("earthTexture = \(earthTexture)")
        print("lightsTexture = \(lightsTexture)")
        
        testSprite.load(graphics: graphics,
                        texture: earthTexture)
        
        earth.load(graphics: graphics,
                   texture: earthTexture)
        
        shapeInstance2D[0].load(graphics: graphics)
        shapeInstance2D[1].load(graphics: graphics)
        shapeInstance2D[2].load(graphics: graphics)
        shapeInstance2D[3].load(graphics: graphics)
        
        shapeInstance3D[0].load(graphics: graphics)
        shapeInstance3D[1].load(graphics: graphics)
        shapeInstance3D[2].load(graphics: graphics)
        shapeInstance3D[3].load(graphics: graphics)
        
        shapeInstance2DColored[0].load(graphics: graphics)
        shapeInstance2DColored[1].load(graphics: graphics)
        shapeInstance2DColored[2].load(graphics: graphics)
        shapeInstance2DColored[3].load(graphics: graphics)
        
        shapeInstance3DColored[0].load(graphics: graphics)
        shapeInstance3DColored[1].load(graphics: graphics)
        shapeInstance3DColored[2].load(graphics: graphics)
        shapeInstance3DColored[3].load(graphics: graphics)
        
        spriteInstance2D[0].load(graphics: graphics,
                                 texture: lightsTexture)
        spriteInstance2D[1].load(graphics: graphics,
                                 texture: lightsTexture)
        spriteInstance2D[2].load(graphics: graphics,
                                 texture: lightsTexture)
        spriteInstance2D[3].load(graphics: graphics,
                                 texture: lightsTexture)
        
        spriteInstanceWhite2D[0].load(graphics: graphics,
                                      texture: size80Texture)
        spriteInstanceWhite2D[1].load(graphics: graphics,
                                      texture: size80Texture)
        spriteInstanceWhite2D[2].load(graphics: graphics,
                                      texture: size80Texture)
        spriteInstanceWhite2D[3].load(graphics: graphics,
                                      texture: size80Texture)
        
        spriteInstance2DWhiteColored[0].load(graphics: graphics,
                                      texture: size80Texture)
        spriteInstance2DWhiteColored[1].load(graphics: graphics,
                                      texture: size80Texture)
        spriteInstance2DWhiteColored[2].load(graphics: graphics,
                                      texture: size80Texture)
        spriteInstance2DWhiteColored[3].load(graphics: graphics,
                                      texture: size80Texture)
        
        
        spriteInstanceWhite3D[0].load(graphics: graphics,
                                      texture: size80Texture)
        spriteInstanceWhite3D[1].load(graphics: graphics,
                                      texture: size80Texture)
        spriteInstanceWhite3D[2].load(graphics: graphics,
                                      texture: size80Texture)
        spriteInstanceWhite3D[3].load(graphics: graphics,
                                      texture: size80Texture)
        
        
        
        
        spriteInstance3DWhiteColored[0].load(graphics: graphics,
                                      texture: size80Texture)
        spriteInstance3DWhiteColored[1].load(graphics: graphics,
                                      texture: size80Texture)
        spriteInstance3DWhiteColored[2].load(graphics: graphics,
                                      texture: size80Texture)
        spriteInstance3DWhiteColored[3].load(graphics: graphics,
                                      texture: size80Texture)
        
        spriteInstance3D[0].load(graphics: graphics,
                                 texture: lightsTexture)
        spriteInstance3D[1].load(graphics: graphics,
                                 texture: lightsTexture)
        spriteInstance3D[2].load(graphics: graphics,
                                 texture: lightsTexture)
        spriteInstance3D[3].load(graphics: graphics,
                                 texture: lightsTexture)
        
        spriteInstance2DColored[0].load(graphics: graphics,
                                        texture: lightsTexture)
        spriteInstance2DColored[1].load(graphics: graphics,
                                        texture: lightsTexture)
        spriteInstance2DColored[2].load(graphics: graphics,
                                        texture: lightsTexture)
        spriteInstance2DColored[3].load(graphics: graphics,
                                        texture: lightsTexture)
        
        spriteInstance3DColored[0].load(graphics: graphics,
                                        texture: lightsTexture)
        spriteInstance3DColored[1].load(graphics: graphics,
                                        texture: lightsTexture)
        spriteInstance3DColored[2].load(graphics: graphics,
                                        texture: lightsTexture)
        spriteInstance3DColored[3].load(graphics: graphics,
                                        texture: lightsTexture)
    }
    
    func loadComplete() {
        //jiggleEngine.loadComplete()
        
    }
    
    var earthRotation = Float(0.0)
    var lightRotation = Float(0.0)
    
    func update(deltaTime: Float) {
        
        earthRotation += 0.0075
        if earthRotation >= (Float.pi * 2.0) {
            earthRotation -= (Float.pi * 2.0)
        }
        
        lightRotation -= 0.01
        if lightRotation < 0.0 {
            lightRotation += (Float.pi * 2.0)
        }
        
    }
    
    func draw2D(renderEncoder: MTLRenderCommandEncoder) {
        
        var projectionMatrix = matrix_float4x4()
        projectionMatrix.ortho(width: width, height: height)
        
        let modelViewMatrix = matrix_identity_float4x4
        
        /*
         var projectionMatrix2D = matrix_float4x4()
         projectionMatrix2D.ortho(width: width,
         height: height)
         
         let modelViewMatrix2D = matrix_identity_float4x4
         
         
         testSprite.projectionMatrix = projectionMatrix2D
         testSprite.modelViewMatrix = modelViewMatrix2D
         
         testSprite.render(renderEncoder: renderEncoder)
         */
        
        for i in 0..<4 {
            
            shapeInstance2D[i].setPositionFrame(x: 220.0 + Float(i) * 120.0, y: 200.0, width: 100.0, height: 160.0)
            shapeInstance2D[i].uniformsVertex.projectionMatrix = projectionMatrix
            shapeInstance2D[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            shapeInstance2D[i].uniformsFragment.red = 1.0
            shapeInstance2D[i].uniformsFragment.green = 1.0
            shapeInstance2D[i].uniformsFragment.blue = 0.5
            shapeInstance2D[i].uniformsFragment.alpha = 0.5
            shapeInstance2D[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            if i == 0 {
                shapeInstance2D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed2DNoBlending)
            }
            if i == 1 {
                shapeInstance2D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed2DAlphaBlending)
            }
            if i == 2 {
                shapeInstance2D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed2DAdditiveBlending)
            }
            if i == 3 {
                shapeInstance2D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed2DPremultipliedBlending)
            }
        }
        
        for i in 0..<4 {
            
            spriteInstance2D[i].setPositionFrame(x: 120.0 + Float(i) * 120.0, y: 320.0, width: 100.0, height: 160.0)
            spriteInstance2D[i].uniformsVertex.projectionMatrix = projectionMatrix
            spriteInstance2D[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            spriteInstance2D[i].uniformsFragment.red = 1.0
            spriteInstance2D[i].uniformsFragment.green = 1.0
            spriteInstance2D[i].uniformsFragment.blue = 0.5
            spriteInstance2D[i].uniformsFragment.alpha = 0.5
            spriteInstance2D[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            if i == 0 {
                spriteInstance2D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed2DNoBlending)
            }
            if i == 1 {
                spriteInstance2D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed2DAlphaBlending)
            }
            if i == 2 {
                spriteInstance2D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed2DAdditiveBlending)
            }
            if i == 3 {
                spriteInstance2D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed2DPremultipliedBlending)
            }
        }
        
        
        for i in 0..<4 {
            
            spriteInstanceWhite2D[i].setPositionFrame(x: 80.0 + Float(i) * 120.0, y: 390.0, width: 100.0, height: 160.0)
            spriteInstanceWhite2D[i].uniformsVertex.projectionMatrix = projectionMatrix
            spriteInstanceWhite2D[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            spriteInstanceWhite2D[i].uniformsFragment.red = 1.0
            spriteInstanceWhite2D[i].uniformsFragment.green = 1.0
            spriteInstanceWhite2D[i].uniformsFragment.blue = 0.5
            spriteInstanceWhite2D[i].uniformsFragment.alpha = 0.5
            spriteInstanceWhite2D[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            if i == 0 {
                spriteInstanceWhite2D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeWhiteIndexed2DNoBlending)
            }
            if i == 1 {
                spriteInstanceWhite2D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeWhiteIndexed2DAlphaBlending)
            }
            if i == 2 {
                spriteInstanceWhite2D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeWhiteIndexed2DAdditiveBlending)
            }
            if i == 3 {
                spriteInstanceWhite2D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeWhiteIndexed2DPremultipliedBlending)
            }
        }
        
        for i in 0..<4 {
            
            shapeInstance2DColored[i].setPositionFrame(x: 180.0 + Float(i) * 120.0, y: 260.0, width: 100.0, height: 160.0)
            shapeInstance2DColored[i].uniformsVertex.projectionMatrix = projectionMatrix
            shapeInstance2DColored[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            shapeInstance2DColored[i].uniformsFragment.red = 1.0
            shapeInstance2DColored[i].uniformsFragment.green = 1.0
            shapeInstance2DColored[i].uniformsFragment.blue = 0.5
            shapeInstance2DColored[i].uniformsFragment.alpha = 0.5
            shapeInstance2DColored[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            shapeInstance2DColored[i].vertices[0].r = Float.random(in: 0.0...1.0)
            shapeInstance2DColored[i].vertices[0].g = Float.random(in: 0.0...1.0)
            
            shapeInstance2DColored[i].vertices[3].b = Float.random(in: 0.0...1.0)
            shapeInstance2DColored[i].vertices[3].a = Float.random(in: 0.0...1.0)
            
            if i == 0 {
                shapeInstance2DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed2DNoBlending)
            }
            if i == 1 {
                shapeInstance2DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed2DAlphaBlending)
            }
            if i == 2 {
                shapeInstance2DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed2DAdditiveBlending)
            }
            if i == 3 {
                shapeInstance2DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed2DPremultipliedBlending)
            }
        }
        
        for i in 0..<4 {
            
            spriteInstance2DColored[i].setPositionFrame(x: 120.0 + Float(i) * 120.0, y: 120.0, width: 100.0, height: 160.0)
            spriteInstance2DColored[i].uniformsVertex.projectionMatrix = projectionMatrix
            spriteInstance2DColored[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            spriteInstance2DColored[i].uniformsFragment.red = 1.0
            spriteInstance2DColored[i].uniformsFragment.green = 1.0
            spriteInstance2DColored[i].uniformsFragment.blue = 0.5
            spriteInstance2DColored[i].uniformsFragment.alpha = 0.5
            spriteInstance2DColored[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            spriteInstance2DColored[i].vertices[0].r = Float.random(in: 0.0...1.0)
            spriteInstance2DColored[i].vertices[0].g = Float.random(in: 0.0...1.0)
            
            spriteInstance2DColored[i].vertices[3].b = Float.random(in: 0.0...1.0)
            spriteInstance2DColored[i].vertices[3].a = Float.random(in: 0.0...1.0)
            
            if i == 0 {
                spriteInstance2DColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredIndexed2DNoBlending)
            }
            if i == 1 {
                spriteInstance2DColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredIndexed2DAlphaBlending)
            }
            if i == 2 {
                spriteInstance2DColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredIndexed2DAdditiveBlending)
            }
            if i == 3 {
                spriteInstance2DColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredIndexed2DPremultipliedBlending)
            }
        }
        
        for i in 0..<4 {
            
            spriteInstance2DWhiteColored[i].setPositionFrame(x: 90.0 + Float(i) * 120.0, y: 180.0, width: 100.0, height: 160.0)
            spriteInstance2DWhiteColored[i].uniformsVertex.projectionMatrix = projectionMatrix
            spriteInstance2DWhiteColored[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            spriteInstance2DWhiteColored[i].uniformsFragment.red = 1.0
            spriteInstance2DWhiteColored[i].uniformsFragment.green = 1.0
            spriteInstance2DWhiteColored[i].uniformsFragment.blue = 0.5
            spriteInstance2DWhiteColored[i].uniformsFragment.alpha = 0.5
            spriteInstance2DWhiteColored[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            spriteInstance2DWhiteColored[i].vertices[0].r = Float.random(in: 0.0...1.0)
            spriteInstance2DWhiteColored[i].vertices[0].g = Float.random(in: 0.0...1.0)
            
            spriteInstance2DWhiteColored[i].vertices[3].b = Float.random(in: 0.0...1.0)
            spriteInstance2DWhiteColored[i].vertices[3].a = Float.random(in: 0.0...1.0)
            
            if i == 0 {
                spriteInstance2DWhiteColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredWhiteIndexed2DNoBlending)
            }
            if i == 1 {
                spriteInstance2DWhiteColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredWhiteIndexed2DAlphaBlending)
            }
            if i == 2 {
                spriteInstance2DWhiteColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredWhiteIndexed2DAdditiveBlending)
            }
            if i == 3 {
                spriteInstance2DWhiteColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredWhiteIndexed2DPremultipliedBlending)
            }
        }
    }
    
    struct MatrixPack {
        let projectionMatrix: matrix_float4x4
        let modelViewMatrix: matrix_float4x4
        let normalMatrix: matrix_float4x4
    }
    
    func getMatrixPack() -> MatrixPack {
        let aspect = graphics.width / graphics.height
        var perspective = matrix_float4x4()
        perspective.perspective(fovy: Float.pi * 0.125, aspect: aspect, nearZ: 0.01, farZ: 255.0)
        
        var lookAt = matrix_float4x4()
        lookAt.lookAt(eyeX: 0.0, eyeY: 0.0, eyeZ: -6.0,
                      centerX: 0.0, centerY: 0.0, centerZ: 0.0,
                      upX: 0.0, upY: 1.0, upZ: 0.0)
        let projectionMatrix = simd_mul(perspective, lookAt)
        var modelViewMatrix = matrix_identity_float4x4
        modelViewMatrix.rotateY(radians: -earthRotation)
        
        var normalMatrix = modelViewMatrix
        normalMatrix = simd_inverse(normalMatrix)
        normalMatrix = simd_transpose(normalMatrix)
        
        let result = MatrixPack(projectionMatrix: projectionMatrix,
                                modelViewMatrix: modelViewMatrix,
                                normalMatrix: normalMatrix)
        return result
    }
    
    func draw3DBloom(renderEncoder: MTLRenderCommandEncoder) {
        let matrixPack = getMatrixPack()
        graphics.set(depthState: .lessThan, renderEncoder: renderEncoder)
        earth.draw3DBloom(renderEncoder: renderEncoder,
                          projectionMatrix: matrixPack.projectionMatrix,
                          modelViewMatrix: matrixPack.modelViewMatrix)
    }
    
    func draw3D(renderEncoder: MTLRenderCommandEncoder) {
        
        
        let matrixPack = getMatrixPack()
        
        
        
        
        graphics.set(depthState: .lessThan, renderEncoder: renderEncoder)
        earth.draw3D(renderEncoder: renderEncoder,
                     projectionMatrix: matrixPack.projectionMatrix,
                     modelViewMatrix: matrixPack.modelViewMatrix,
                     normalMatrix: matrixPack.normalMatrix,
                     lightDirX: sin(lightRotation),
                     lightDirY: 0.0,
                     lightDirZ: -cosf(lightRotation),
                     lightAmbientIntensity: 0.2,
                     lightDiffuseIntensity: 0.6,
                     lightSpecularIntensity: 1.0,
                     lightShininess: 24.0)
        
        
        
        graphics.set(depthState: .disabled, renderEncoder: renderEncoder)
        
        var projectionMatrix = matrix_float4x4()
        projectionMatrix.ortho(width: width, height: height)
        
        let modelViewMatrix = matrix_identity_float4x4
        for i in 0..<4 {
            
            shapeInstance3D[i].setPositionFrame(x: 220.0 + Float(i) * 120.0, y: 500.0, width: 100.0, height: 120.0)
            shapeInstance3D[i].uniformsVertex.projectionMatrix = projectionMatrix
            shapeInstance3D[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            shapeInstance3D[i].uniformsFragment.red = 0.5
            shapeInstance3D[i].uniformsFragment.green = 1.0
            shapeInstance3D[i].uniformsFragment.blue = 1.0
            shapeInstance3D[i].uniformsFragment.alpha = 0.6
            shapeInstance3D[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            if i == 0 {
                shapeInstance3D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed3DNoBlending)
            }
            if i == 1 {
                shapeInstance3D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed3DAlphaBlending)
            }
            if i == 2 {
                shapeInstance3D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed3DAdditiveBlending)
            }
            if i == 3 {
                shapeInstance3D[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed3DPremultipliedBlending)
            }
            
            
            
        }
        
        for i in 0..<4 {
            
            spriteInstance3D[i].setPositionFrame(x: 120.0 + Float(i) * 120.0, y: 590.0, width: 100.0, height: 120.0)
            
            spriteInstance3D[i].uniformsVertex.projectionMatrix = projectionMatrix
            spriteInstance3D[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            spriteInstance3D[i].uniformsFragment.red = 0.5
            spriteInstance3D[i].uniformsFragment.green = 1.0
            spriteInstance3D[i].uniformsFragment.blue = 1.0
            spriteInstance3D[i].uniformsFragment.alpha = 0.6
            spriteInstance3D[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            if i == 0 {
                spriteInstance3D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed3DNoBlending)
            }
            if i == 1 {
                spriteInstance3D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed3DAlphaBlending)
            }
            if i == 2 {
                spriteInstance3D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed3DAdditiveBlending)
            }
            if i == 3 {
                spriteInstance3D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed3DPremultipliedBlending)
            }
            
            
            
        }
        
        for i in 0..<4 {
            
            spriteInstanceWhite3D[i].setPositionFrame(x: 120.0 + Float(i) * 80.0, y: 630.0, width: 100.0, height: 120.0)
            
            spriteInstanceWhite3D[i].uniformsVertex.projectionMatrix = projectionMatrix
            spriteInstanceWhite3D[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            spriteInstanceWhite3D[i].uniformsFragment.red = 0.5
            spriteInstanceWhite3D[i].uniformsFragment.green = 1.0
            spriteInstanceWhite3D[i].uniformsFragment.blue = 1.0
            spriteInstanceWhite3D[i].uniformsFragment.alpha = 0.6
            spriteInstanceWhite3D[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            if i == 0 {
                spriteInstanceWhite3D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeWhiteIndexed3DNoBlending)
            }
            if i == 1 {
                spriteInstanceWhite3D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeWhiteIndexed3DAlphaBlending)
            }
            if i == 2 {
                spriteInstanceWhite3D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeWhiteIndexed3DAdditiveBlending)
            }
            if i == 3 {
                spriteInstanceWhite3D[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeWhiteIndexed3DPremultipliedBlending)
            }
            
            
            
        }
        
        for i in 0..<4 {
            
            shapeInstance3DColored[i].setPositionFrame(x: 120.0 + Float(i) * 120.0, y: 700.0, width: 100.0, height: 120.0)
            shapeInstance3DColored[i].uniformsVertex.projectionMatrix = projectionMatrix
            shapeInstance3DColored[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            shapeInstance3DColored[i].uniformsFragment.red = 0.5
            shapeInstance3DColored[i].uniformsFragment.green = 1.0
            shapeInstance3DColored[i].uniformsFragment.blue = 1.0
            shapeInstance3DColored[i].uniformsFragment.alpha = 0.6
            shapeInstance3DColored[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            shapeInstance3DColored[i].vertices[0].r = Float.random(in: 0.0...1.0)
            shapeInstance3DColored[i].vertices[0].g = Float.random(in: 0.0...1.0)
            
            shapeInstance3DColored[i].vertices[3].b = Float.random(in: 0.0...1.0)
            shapeInstance3DColored[i].vertices[3].a = Float.random(in: 0.0...1.0)
            
            if i == 0 {
                shapeInstance3DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed3DNoBlending)
            }
            if i == 1 {
                shapeInstance3DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed3DAlphaBlending)
            }
            if i == 2 {
                shapeInstance3DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed3DAdditiveBlending)
            }
            if i == 3 {
                shapeInstance3DColored[i].render(renderEncoder: renderEncoder, pipelineState: .shapeNodeColoredIndexed3DPremultipliedBlending)
            }
            
            
            
        }
        
        for i in 0..<4 {
            
            spriteInstance3DColored[i].setPositionFrame(x: 100.0 + Float(i) * 120.0, y: 900.0, width: 80.0, height: 120.0)
            spriteInstance3DColored[i].uniformsVertex.projectionMatrix = projectionMatrix
            spriteInstance3DColored[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            spriteInstance3DColored[i].uniformsFragment.red = 0.5
            spriteInstance3DColored[i].uniformsFragment.green = 1.0
            spriteInstance3DColored[i].uniformsFragment.blue = 1.0
            spriteInstance3DColored[i].uniformsFragment.alpha = 0.6
            spriteInstance3DColored[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            spriteInstance3DColored[i].vertices[0].r = Float.random(in: 0.0...1.0)
            spriteInstance3DColored[i].vertices[0].g = Float.random(in: 0.0...1.0)
            
            spriteInstance3DColored[i].vertices[3].b = Float.random(in: 0.0...1.0)
            spriteInstance3DColored[i].vertices[3].a = Float.random(in: 0.0...1.0)
            
            if i == 0 {
                spriteInstance3DColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredIndexed3DNoBlending)
            }
            if i == 1 {
                spriteInstance3DColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredIndexed3DAlphaBlending)
            }
            if i == 2 {
                spriteInstance3DColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredIndexed3DAdditiveBlending)
            }
            if i == 3 {
                spriteInstance3DColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredIndexed3DPremultipliedBlending)
            }
            
            
            
        }
        
        for i in 0..<4 {
            
            spriteInstance3DWhiteColored[i].setPositionFrame(x: 60.0 + Float(i) * 130.0, y: 820.0, width: 80.0, height: 120.0)
            spriteInstance3DWhiteColored[i].uniformsVertex.projectionMatrix = projectionMatrix
            spriteInstance3DWhiteColored[i].uniformsVertex.modelViewMatrix = modelViewMatrix
            spriteInstance3DWhiteColored[i].uniformsFragment.red = 0.5
            spriteInstance3DWhiteColored[i].uniformsFragment.green = 1.0
            spriteInstance3DWhiteColored[i].uniformsFragment.blue = 1.0
            spriteInstance3DWhiteColored[i].uniformsFragment.alpha = 0.6
            spriteInstance3DWhiteColored[i].setDirty(isVertexBufferDirty: true, isUniformsVertexBufferDirty: true, isUniformsFragmentBufferDirty: true)
            
            spriteInstance3DWhiteColored[i].vertices[0].r = Float.random(in: 0.0...1.0)
            spriteInstance3DWhiteColored[i].vertices[0].g = Float.random(in: 0.0...1.0)
            
            spriteInstance3DWhiteColored[i].vertices[3].b = Float.random(in: 0.0...1.0)
            spriteInstance3DWhiteColored[i].vertices[3].a = Float.random(in: 0.0...1.0)
            
            if i == 0 {
                spriteInstance3DWhiteColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredWhiteIndexed3DNoBlending)
            }
            if i == 1 {
                spriteInstance3DWhiteColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredWhiteIndexed3DAlphaBlending)
            }
            if i == 2 {
                spriteInstance3DWhiteColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredWhiteIndexed3DAdditiveBlending)
            }
            if i == 3 {
                spriteInstance3DWhiteColored[i].render(renderEncoder: renderEncoder, pipelineState: .spriteNodeColoredWhiteIndexed3DPremultipliedBlending)
            }
            
            
            
        }
    }
    
    func draw3DStereoscopicLeft(renderEncoder: MTLRenderCommandEncoder) {
        
    }
    
    func draw3DStereoscopicRight(renderEncoder: MTLRenderCommandEncoder) {
        
    }
}
