//
//  IndexedShapeInstance.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/25/24.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation
import Metal
import simd

class IndexedShapeInstance<NodeType: PositionConforming2D,
                           UniformsVertexType: UniformsVertex,
                           UniformsFragmentType: UniformsFragment>: IndexedInstance<NodeType, UniformsVertexType, UniformsFragmentType> {
    
}

class IndexedShapeInstance2D: IndexedShapeInstance<Shape2DVertex, UniformsShapeVertex, UniformsShapeFragment> { }
class IndexedShapeInstance2DColored: IndexedShapeInstance<Shape2DColoredVertex, UniformsShapeVertex, UniformsShapeFragment> { }
class IndexedShapeInstance3D: IndexedShapeInstance<Shape3DVertex, UniformsShapeVertex, UniformsShapeFragment> { }
class IndexedShapeInstance3DColored: IndexedShapeInstance<Shape3DColoredVertex, UniformsShapeVertex, UniformsShapeFragment> { }
