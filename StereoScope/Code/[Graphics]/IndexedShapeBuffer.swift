//
//  IndexedShapeBuffer.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/25/24.
//

import Foundation
import Metal
import simd

class IndexedShapeBuffer<NodeType: PositionConforming2D,
                         UniformsVertexType: UniformsVertex,
                         UniformsFragmentType: UniformsFragment>: IndexedBuffer<NodeType, UniformsVertexType, UniformsFragmentType> {
    
}

class IndexedShapeBuffer2D: IndexedShapeBuffer<Shape2DVertex, UniformsShapeVertex, UniformsShapeFragment> { }
class IndexedShapeBuffer2DColored: IndexedShapeBuffer<Shape2DColoredVertex, UniformsShapeVertex, UniformsShapeFragment> { }

class IndexedShapeBuffer3D: IndexedShapeBuffer<Shape3DVertex, UniformsShapeVertex, UniformsShapeFragment> { }
class IndexedShapeBuffer3DColored: IndexedShapeBuffer<Shape3DColoredVertex, UniformsShapeVertex, UniformsShapeFragment> { }
