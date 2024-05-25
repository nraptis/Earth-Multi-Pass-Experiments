//
//  EarthSceneView.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

import SwiftUI

struct EarthSceneView: UIViewControllerRepresentable {
    let width: CGFloat
    let height: CGFloat
    func makeUIViewController(context: UIViewControllerRepresentableContext<EarthSceneView>) -> MetalViewController {
        
        let width = Float(Int(width + 0.5))
        let height = Float(Int(height + 0.5))
        let earthScene = EarthScene(width: width, 
                                    height: height)
        let metalViewController = MetalViewController(delegate: earthScene,
                                                      width: width,
                                                      height: height)
        //metalViewController.loadViewIfNeeded()
        metalViewController.load()
        metalViewController.loadComplete()
        
        return metalViewController
    }
    
    func updateUIViewController(_ uiViewController: MetalViewController,
                                context: UIViewControllerRepresentableContext<EarthSceneView>) {
        
    }
}
