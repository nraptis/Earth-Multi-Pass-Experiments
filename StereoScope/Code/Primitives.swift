//
//  Primitives.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

import Foundation

struct Sprite2DVertex: PositionConforming, TextureCoordinateConforming {
    var x: Float
    var y: Float
    var u: Float
    var v: Float
}

struct Sprite3DVertex: PositionConforming, TextureCoordinateConforming {
    var x: Float
    var y: Float
    var z: Float
    var u: Float
    var v: Float
}

struct Sprite3DLightedVertex: PositionConforming, TextureCoordinateConforming {
    var x: Float
    var y: Float
    var z: Float
    var u: Float
    var v: Float
    var normalX: Float
    var normalY: Float
    var normalZ: Float
}

struct Sprite3DLightedColoredVertex: PositionConforming, TextureCoordinateConforming {
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
