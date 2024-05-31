//
//  MetalViewController.swift
//  RebuildEarth
//
//  Created by Nicky Taylor on 2/10/23.
//

import UIKit

class MetalViewController: UIViewController {
    
    weak static var shared: MetalViewController?
    
    let delegate: GraphicsDelegate
    let graphics: Graphics
    let metalEngine: MetalEngine
    let metalPipeline: MetalPipeline
    let metalLayer: CAMetalLayer
    
    private var timer: CADisplayLink?
    private var _isTimerRunning = false
    private var _isMetalEngineLoaded = false
    
    var isStereoscopicEnabled = false
    var isBloomEnabled = true
    var bloomPasses = ((UIDevice.current.userInterfaceIdiom == .pad) ? 6 : 4)
    var stereoSpreadBase = Float((UIDevice.current.userInterfaceIdiom == .pad) ? 2.0 : 1.0)
    var stereoSpreadMax = Float((UIDevice.current.userInterfaceIdiom == .pad) ? 8.0 : 4.0)
    
    let metalView: MetalView
    required init(delegate: GraphicsDelegate,
                  width: Float,
                  height: Float) {
        
        let _metalView = MetalView(width: CGFloat(Int(width + 0.5)),
                                   height: CGFloat(Int(height + 0.5)))
        let _metalLayer = _metalView.layer as! CAMetalLayer
        let _metalEngine = MetalEngine(metalLayer: _metalLayer,
                                       width: width,
                                       height: height)
        let _metalPipeline = MetalPipeline(metalEngine: _metalEngine)
        let _graphics = Graphics(width: width,
                                 height: height,
                                 scaleFactor: Float(Int(_metalLayer.contentsScale + 0.5)))
        
        _metalEngine.graphics = _graphics
        _metalEngine.delegate = delegate
        
        _graphics.metalEngine = _metalEngine
        _graphics.metalPipeline = _metalPipeline
        _graphics.metalDevice = _metalEngine.metalDevice
        _graphics.metalView = _metalView
        
        delegate.graphics = _graphics
        
        self.delegate = delegate
        self.metalView = _metalView
        self.metalLayer = _metalLayer
        self.metalEngine = _metalEngine
        self.metalPipeline = _metalPipeline
        self.graphics = _graphics
        
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(applicationWillResignActive(notification:)),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive(notification:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        MetalViewController.shared = self
    }
    
    @objc func applicationWillResignActive(notification: NSNotification) {
        stopTimer()
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        startTimer()
    }
    
    func startTimer() {
        if _isMetalEngineLoaded {
            if _isTimerRunning == false {
                _isTimerRunning = true
                timer?.invalidate()
                timer = nil
                previousTimeStamp = nil
                timer = CADisplayLink(target: self, selector: #selector(drawloop))
                if let timer = timer {
                    timer.add(to: RunLoop.main, forMode: .default)
                }
            }
        }
    }
    
    func stopTimer() {
        if _isTimerRunning == true {
            _isTimerRunning = false
            timer?.invalidate()
            timer = nil
            previousTimeStamp = nil
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = metalView
    }
    
    func load() {
        
        metalEngine.load()
        metalPipeline.load()
        
        _isMetalEngineLoaded = true
        
        delegate.load()
        
        startTimer()
    }
    
    func loadComplete() {
        delegate.loadComplete()
    }
    
    private var previousTimeStamp: CFTimeInterval?
    @objc func drawloop() {
        if let timer = timer {
            var time = 0.0
            if let previousTimeStamp = previousTimeStamp {
                time = timer.timestamp - previousTimeStamp
            }
            delegate.update(deltaTime: Float(time), stereoSpreadBase: stereoSpreadBase, stereoSpreadMax: stereoSpreadMax)
            previousTimeStamp = timer.timestamp
            metalEngine.draw(isStereoscopicEnabled: isStereoscopicEnabled,
                             isBloomEnabled: isBloomEnabled,
                             bloomPasses: bloomPasses, 
                             stereoSpreadBase: stereoSpreadBase,
                             stereoSpreadMax: stereoSpreadMax)
        }
    }
}
