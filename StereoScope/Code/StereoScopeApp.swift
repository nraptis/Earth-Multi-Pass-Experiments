//
//  StereoScopeApp.swift
//  StereoScope
//
//  Created by Nicky Taylor on 5/24/24.
//

import SwiftUI

var overshoot = Float(0.1)
@main struct StereoScopeApp: App {
    
    enum StereoscopicModes: CaseIterable {
        case normal
        case stereoscopic3D
    }
    
    enum BloomModes: CaseIterable {
        case normal
        case bloom
    }
    
    @State private var _selectedStereoscopicMode = StereoscopicModes.stereoscopic3D
    @State private var _selectedBloomMode = BloomModes.bloom
    @State private var _selectedLightType = LightType.diffuse
    @State private var _selectedColorType = ColorType.none
    @State private var _overshoot = overshoot
    @State private var _stereoSpreadBase = Float(0.0)
    @State private var _stereoSpreadMax = Float(0.0)
    @State private var _bloomPasses = (0)
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                GeometryReader { geometry in
                    EarthSceneView(width: geometry.size.width,
                                   height: geometry.size.height)
                }
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                        .frame(height: 24.0)
                    HStack {
                        Picker("", selection: $_selectedStereoscopicMode) {
                            ForEach(StereoscopicModes.allCases, id: \.self) {
                                switch ($0) {
                                case .normal:
                                    Text("Not 3D")
                                case .stereoscopic3D:
                                    Text("3D")
                                }
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Picker("", selection: $_selectedBloomMode) {
                            ForEach(BloomModes.allCases, id: \.self) {
                                switch ($0) {
                                case .normal:
                                    Text("No Bloom")
                                case .bloom:
                                    Text("Bloom")
                                }
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Picker("", selection: $_selectedLightType) {
                        ForEach(LightType.allCases, id: \.self) {
                            switch ($0) {
                            case .none:
                                Text("None")
                            case .diffuse:
                                Text("Diffuse")
                            case .specular:
                                Text("Specular")
                            case .night:
                                Text("Night")
                            }
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("", selection: $_selectedColorType) {
                        ForEach(ColorType.allCases, id: \.self) {
                            switch ($0) {
                            case .none:
                                Text("No Colors")
                            case .colored:
                                Text("Colored Verts")
                            }
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Spacer()
                    
                    HStack {
                        Stepper("Bloom Passes", value: $_bloomPasses, in: 0...32)
                        Text("\(_bloomPasses)")
                    }
                    
                    HStack {
                        Text("Night Bleed")
                        Slider(value: $_overshoot, in: 0.0...0.5)
                    }
                    HStack {
                        Text("3D Base")
                        Slider(value: $_stereoSpreadBase, in: 0.0...8.0)
                    }
                    HStack {
                        Text("3D Per Vertex")
                        Slider(value: $_stereoSpreadMax, in: 0.0...16.0)
                    }
                    Spacer()
                        .frame(height: 24.0)
                }
                .preferredColorScheme(.dark)
                .padding(.top, 16.0)
                .padding(.horizontal, 16.0)
                .frame(maxWidth: 320.0)
                .onChange(of: _selectedStereoscopicMode) {
                    switch _selectedStereoscopicMode {
                    case .normal:
                        MetalViewController.shared?.isStereoscopicEnabled = false
                    case .stereoscopic3D:
                        MetalViewController.shared?.isStereoscopicEnabled = true
                    }
                }
                .onChange(of: _selectedBloomMode) {
                    switch _selectedBloomMode {
                    case .normal:
                        MetalViewController.shared?.isBloomEnabled = false
                    case .bloom:
                        MetalViewController.shared?.isBloomEnabled = true
                    }
                }
                .onChange(of: _selectedLightType) {
                    switch _selectedLightType {
                    case .none:
                        lightType = .none
                        print("lightType = .none")
                    case .diffuse:
                        lightType = .diffuse
                        print("lightType = .diffuse")
                    case .specular:
                        lightType = .specular
                        print("lightType = .specular")
                    case .night:
                        lightType = .night
                        print("lightType = .night")
                    }
                }
                .onChange(of: _selectedColorType) {
                    switch _selectedColorType {
                    case .none:
                        colorType = .none
                        print("colorType = .none")
                    case .colored:
                        colorType = .colored
                        print("colorType = .colored")
                    }
                }
                .onChange(of: _overshoot) {
                    overshoot = _overshoot
                    print("overshoot = \(overshoot)")
                }
                .onChange(of: _stereoSpreadBase) {
                    MetalViewController.shared?.stereoSpreadBase = _stereoSpreadBase
                    print("stereoSpreadBase = \(_stereoSpreadBase)")
                }
                .onChange(of: _stereoSpreadMax) {
                    MetalViewController.shared?.stereoSpreadMax = _stereoSpreadMax
                    print("stereoSpreadMax = \(_stereoSpreadMax)")
                }
                .onChange(of: _bloomPasses) {
                    MetalViewController.shared?.bloomPasses = _bloomPasses
                    print("bloomPasses = \(_bloomPasses)")
                }
                .onAppear {
                    if let metalViewController = MetalViewController.shared {
                        _selectedStereoscopicMode = metalViewController.isStereoscopicEnabled ? .stereoscopic3D : .normal
                        _selectedBloomMode = metalViewController.isBloomEnabled ? .bloom : .normal
                        _stereoSpreadBase = metalViewController.stereoSpreadBase
                        _stereoSpreadMax = metalViewController.stereoSpreadMax
                        _bloomPasses = metalViewController.bloomPasses
                    }
                    _selectedColorType = colorType
                    _selectedLightType = lightType
                    _overshoot = overshoot
                    
                }
            }
        }
    }
}
