//
//  Primitives.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation

protocol StereoscopicConforming {
    var shift: Float { set get }
}

protocol ColorConforming {
    var r: Float { set get }
    var g: Float { set get }
    var b: Float { set get }
    var a: Float { set get }
}

protocol PositionConforming2D {
    var x: Float { set get }
    var y: Float { set get }
}

protocol PositionConforming3D: PositionConforming2D {
    var z: Float { set get }
}

protocol NormalConforming {
    var normalX: Float { set get }
    var normalY: Float { set get }
    var normalZ: Float { set get }
}

protocol TextureCoordinateConforming {
    var u: Float { set get }
    var v: Float { set get }
}

struct Shape2DVertex: PositionConforming2D {
    var x: Float
    var y: Float
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    init() {
        self.x = 0.0
        self.y = 0.0
    }
}

struct Shape2DColoredVertex: PositionConforming2D, ColorConforming {
    var x: Float
    var y: Float
    var r: Float
    var g: Float
    var b: Float
    var a: Float
    init(x: Float, y: Float, r: Float, g: Float, b: Float, a: Float) {
        self.x = x
        self.y = y
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
}

struct Sprite2DVertex: PositionConforming2D, TextureCoordinateConforming {
    var x: Float
    var y: Float
    var u: Float
    var v: Float
    init(x: Float, y: Float, u: Float, v: Float) {
        self.x = x
        self.y = y
        self.u = u
        self.v = v
    }
    init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.u = u
        self.v = v
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.u = 0.0
        self.v = 0.0
    }
}

struct Sprite2DColoredVertex: PositionConforming2D, TextureCoordinateConforming, ColorConforming {
    var x: Float
    var y: Float
    var u: Float
    var v: Float
    var r: Float
    var g: Float
    var b: Float
    var a: Float
    init(x: Float, y: Float, u: Float, v: Float, r: Float, g: Float, b: Float, a: Float) {
        self.x = x
        self.y = y
        self.u = u
        self.v = v
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    init(x: Float, y: Float, u: Float, v: Float) {
        self.x = x
        self.y = y
        self.u = u
        self.v = v
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
    init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.u = u
        self.v = v
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.u = 0.0
        self.v = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
}

struct Sprite3DVertex: PositionConforming3D, TextureCoordinateConforming {
    var x: Float
    var y: Float
    var z: Float
    var u: Float
    var v: Float
    init(x: Float, y: Float, z: Float, u: Float, v: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
    }
    init(x: Float, y: Float, u: Float, v: Float) {
        self.x = x
        self.y = y
        self.z = 0.0
        self.u = u
        self.v = v
    }
    init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
    }
}

struct Sprite3DVertexStereoscopic: PositionConforming3D, TextureCoordinateConforming, StereoscopicConforming {
    var x: Float
    var y: Float
    var z: Float
    var u: Float
    var v: Float
    var shift: Float
    init(x: Float, y: Float, z: Float, u: Float, v: Float, shift: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
        self.shift = shift
    }
    init(x: Float, y: Float, u: Float, v: Float) {
        self.x = x
        self.y = y
        self.z = 0.0
        self.u = u
        self.v = v
        self.shift = 1.0
    }
    init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
        self.shift = 1.0
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
        self.shift = 1.0
    }
}

struct Sprite3DVertexColoredStereoscopic: PositionConforming3D, TextureCoordinateConforming, StereoscopicConforming, ColorConforming {
    var x: Float
    var y: Float
    var z: Float
    var u: Float
    var v: Float
    var r: Float
    var g: Float
    var b: Float
    var a: Float
    var shift: Float
    init(x: Float, y: Float, z: Float, u: Float, v: Float, r: Float, g: Float, b: Float, a: Float, shift: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
        self.r = r
        self.g = g
        self.b = b
        self.a = a
        self.shift = shift
    }
    init(x: Float, y: Float, u: Float, v: Float) {
        self.x = x
        self.y = y
        self.z = 0.0
        self.u = u
        self.v = v
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
        self.shift = 1.0
    }
    init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
        self.shift = 1.0
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
        self.shift = 1.0
    }
}

struct Sprite3DColoredVertex: PositionConforming3D, TextureCoordinateConforming, ColorConforming {
    var x: Float
    var y: Float
    var z: Float
    var u: Float
    var v: Float
    var r: Float
    var g: Float
    var b: Float
    var a: Float
    init(x: Float, y: Float, z: Float, u: Float, v: Float, r: Float, g: Float, b: Float, a: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    init(x: Float, y: Float, u: Float, v: Float) {
        self.x = x
        self.y = y
        self.z = 0.0
        self.u = u
        self.v = v
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
    init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
}

struct Shape3DVertex: PositionConforming3D {
    var x: Float
    var y: Float
    var z: Float
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
    }
}

struct Shape3DLightedVertex: PositionConforming3D, NormalConforming {
    var x: Float
    var y: Float
    var z: Float
    var normalX: Float
    var normalY: Float
    var normalZ: Float
    init(x: Float, y: Float, z: Float, normalX: Float, normalY: Float, normalZ: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.normalX = normalX
        self.normalY = normalY
        self.normalZ = normalZ
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
    }
}

struct Sprite3DLightedStereoscopicVertex: PositionConforming3D, TextureCoordinateConforming, StereoscopicConforming {
    var x: Float
    var y: Float
    var z: Float
    var u: Float
    var v: Float
    var normalX: Float
    var normalY: Float
    var normalZ: Float
    var shift: Float
    init(x: Float, y: Float, z: Float, u: Float, v: Float, normalX: Float, normalY: Float, normalZ: Float, shift: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
        self.normalX = normalX
        self.normalY = normalY
        self.normalZ = normalZ
        self.shift = shift
    }
    init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
        self.shift = 1.0
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
        self.shift = 1.0
    }
}

struct Shape3DLightedColoredVertex: PositionConforming3D, NormalConforming, ColorConforming {
    var x: Float
    var y: Float
    var z: Float
    var normalX: Float
    var normalY: Float
    var normalZ: Float
    var r: Float
    var g: Float
    var b: Float
    var a: Float
    init(x: Float, y: Float, z: Float, normalX: Float, normalY: Float, normalZ: Float, r: Float, g: Float, b: Float, a: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.normalX = normalX
        self.normalY = normalY
        self.normalZ = normalZ
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
}

struct Shape3DColoredVertex: PositionConforming3D, ColorConforming {
    var x: Float
    var y: Float
    var z: Float
    var r: Float
    var g: Float
    var b: Float
    var a: Float
    init(x: Float, y: Float, z: Float, r: Float, g: Float, b: Float, a: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
}

struct Sprite3DLightedVertex: PositionConforming3D, NormalConforming, TextureCoordinateConforming {
    var x: Float
    var y: Float
    var z: Float
    var u: Float
    var v: Float
    var normalX: Float
    var normalY: Float
    var normalZ: Float
    init(x: Float, y: Float, z: Float, u: Float, v: Float, normalX: Float, normalY: Float, normalZ: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
        self.normalX = normalX
        self.normalY = normalY
        self.normalZ = normalZ
    }
    init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
    }
}

struct Sprite3DLightedColoredVertex: PositionConforming3D, TextureCoordinateConforming, NormalConforming {
    var x: Float
    var y: Float
    var z: Float
    var u: Float
    var v: Float
    var normalX: Float
    var normalY: Float
    var normalZ: Float
    var r: Float
    var g: Float
    var b: Float
    var a: Float
    init(x: Float, y: Float, z: Float, u: Float, v: Float, normalX: Float, normalY: Float, normalZ: Float, r: Float, g: Float, b: Float, a: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
        self.normalX = normalX
        self.normalY = normalY
        self.normalZ = normalZ
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
}

struct Sprite3DLightedColoredStereoscopicVertex: PositionConforming3D, TextureCoordinateConforming, NormalConforming, StereoscopicConforming {
    var x: Float
    var y: Float
    var z: Float
    var u: Float
    var v: Float
    var normalX: Float
    var normalY: Float
    var normalZ: Float
    var r: Float
    var g: Float
    var b: Float
    var a: Float
    var shift: Float
    init(x: Float, y: Float, z: Float, u: Float, v: Float, normalX: Float, normalY: Float, normalZ: Float, r: Float, g: Float, b: Float, a: Float, shift: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
        self.normalX = normalX
        self.normalY = normalY
        self.normalZ = normalZ
        self.r = r
        self.g = g
        self.b = b
        self.a = a
        self.shift = shift
    }
    init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
        self.shift = 1.0
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
        self.shift = 1.0
    }
}
