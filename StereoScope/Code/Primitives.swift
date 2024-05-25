//
//  Primitives.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

import Foundation

struct Sprite2DVertex {
    var x: Float
    var y: Float
    var u: Float
    var v: Float
}

struct Sprite3DVertex {
    var x: Float
    var y: Float
    var z: Float
    var u: Float
    var v: Float
}

struct Sprite3DLightedVertex {
    var x: Float
    var y: Float
    var z: Float
    var u: Float
    var v: Float
    var normalX: Float
    var normalY: Float
    var normalZ: Float
}

struct Sprite3DLightedColoredVertex {
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
