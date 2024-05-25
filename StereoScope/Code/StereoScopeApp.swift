//
//  StereoScopeApp.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

import SwiftUI

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
    
    @State private var selectedStereoscopicMode = StereoscopicModes.normal
    @State private var selectedBloomMode = BloomModes.normal
    
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
                    Spacer()
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
            }
        }
    }
}
