//
//  Primitives.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

import Foundation

protocol StereoscopicConforming {
    var shiftRed: Float { set get }
    var shiftBlue: Float { set get }
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
}

struct Shape2DColoredVertex: PositionConforming2D, ColorConforming {
    var x: Float
    var y: Float
    var r: Float
    var g: Float
    var b: Float
    var a: Float
}

struct Sprite2DVertex: PositionConforming2D, TextureCoordinateConforming {
    var x: Float
    var y: Float
    var u: Float
    var v: Float
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
}

struct Sprite3DVertex: PositionConforming3D, TextureCoordinateConforming {
    var x: Float
    var y: Float
    var z: Float
    var u: Float
    var v: Float
}

struct Sprite3DVertexStereoscopic: PositionConforming3D, TextureCoordinateConforming, StereoscopicConforming {
    var x: Float
    var y: Float
    var z: Float
    var u: Float
    var v: Float
    var shiftRed: Float
    var shiftBlue: Float
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
    var shiftRed: Float
    var shiftBlue: Float
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
}

struct Shape3DVertex: PositionConforming3D {
    var x: Float
    var y: Float
    var z: Float
}

struct Shape3DLightedVertex: PositionConforming3D, NormalConforming {
    var x: Float
    var y: Float
    var z: Float
    var normalX: Float
    var normalY: Float
    var normalZ: Float
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
}

struct Shape3DColoredVertex: PositionConforming3D, ColorConforming {
    var x: Float
    var y: Float
    var z: Float
    var r: Float
    var g: Float
    var b: Float
    var a: Float
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
}
