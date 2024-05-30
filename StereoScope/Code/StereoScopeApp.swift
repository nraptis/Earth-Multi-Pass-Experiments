//
//  StereoScopeApp.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

import SwiftUI

var overshoot = Float(0.1)

@main
struct StereoScopeApp: App {
    
    enum StereoscopicModes: CaseIterable {
        case normal
        case stereoscopic3D
    }
    
    enum BloomModes: CaseIterable {
        case normal
        case bloom
    }
    
    @State private var selectedStereoscopicMode = StereoscopicModes.stereoscopic3D
    @State private var selectedBloomMode = BloomModes.bloom
    @State private var _overshoot = Float(0.1)
    
    
    @State private var _stereoSpreadBase = Float(1.0)
    @State private var _stereoSpreadMax = Float(4.0)
    
    @State private var _bloomPasses = 6
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                GeometryReader { geometry in
                    EarthSceneView(width: geometry.size.width,
                                   height: geometry.size.height)
                }
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Picker("", selection: $selectedStereoscopicMode) {
                        ForEach(StereoscopicModes.allCases, id: \.self) {
                            switch ($0) {
                            case .normal:
                                Text("Normal")
                            case .stereoscopic3D:
                                Text("Stereoscopic 3D")
                            }
                            
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("", selection: $selectedBloomMode) {
                        ForEach(BloomModes.allCases, id: \.self) {
                            switch ($0) {
                            case .normal:
                                Text("Normal")
                            case .bloom:
                                Text("Bloom")
                            }
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Slider(value: $_overshoot, in: 0.0...0.5)
                    
                    
                    Spacer()
                    
                    Stepper("Bloom Passes", value: $_bloomPasses, in: 0...32)
                    
                    Slider(value: $_stereoSpreadBase, in: 0.0...8.0)
                    Slider(value: $_stereoSpreadMax, in: 0.0...16.0)
                    
                }
                .preferredColorScheme(.dark)
                .padding(.top, 16.0)
                .padding(.horizontal, 16.0)
                .frame(maxWidth: 320.0)
                .onChange(of: selectedStereoscopicMode) {
                    switch selectedStereoscopicMode {
                    case .normal:
                        MetalViewController.shared?.isStereoscopicEnabled = false
                    case .stereoscopic3D:
                        MetalViewController.shared?.isStereoscopicEnabled = true
                    }
                }
                .onChange(of: selectedBloomMode) {
                    switch selectedBloomMode {
                    case .normal:
                        MetalViewController.shared?.isBloomEnabled = false
                    case .bloom:
                        MetalViewController.shared?.isBloomEnabled = true
                    }
                }
                .onChange(of: _overshoot) {
                    overshoot = _overshoot
                    print("overshoot = \(overshoot)")
                }
                .onChange(of: _stereoSpreadBase) {
                    stereoSpreadBase = _stereoSpreadBase
                    print("stereoSpreadBase = \(stereoSpreadBase)")
                }
                .onChange(of: _stereoSpreadMax) {
                    stereoSpreadMax = _stereoSpreadMax
                    print("stereoSpreadMax = \(stereoSpreadMax)")
                }
                .onChange(of: _bloomPasses) {
                    bloomPasses = _bloomPasses
                    print("bloomPasses = \(bloomPasses)")
                }
            }
        }
    }
}
