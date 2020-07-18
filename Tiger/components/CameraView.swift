//
//  CameraView.swift
//  Tiger
//
//  Created by Henrik Thoroe on 24.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = CameraController
    
    private var cameraDelegate: CameraControllerDelegate!
    
    let onReceiveFrame: (CMSampleBuffer) -> Void
    
    init(onReceiveFrame: @escaping (CMSampleBuffer) -> Void) {
        self.onReceiveFrame = onReceiveFrame
        cameraDelegate = CameraControllerDelegate(imageProcessor: handleVideoData)
    }
    
    func makeUIViewController(context: Context) -> CameraController {
        return CameraController(delegate: cameraDelegate)
    }
    
    func updateUIViewController(_ uiViewController: CameraController, context: Context) {
        
    }
    
    func handleVideoData(data: CMSampleBuffer) {
        onReceiveFrame(data)
    }
    
}

extension CameraView {
    
    final class CameraControllerDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        
        let onCapture: (CMSampleBuffer) -> Void
        
        private let start = mach_absolute_time()
        
        private var frames = 0
        
        init(imageProcessor: @escaping (CMSampleBuffer) -> Void) {
            onCapture = imageProcessor
            super.init()
        }
        
        func captureOutput(_ output: AVCaptureOutput,
                           didOutput sampleBuffer: CMSampleBuffer,
                           from connection: AVCaptureConnection) {
            onCapture(sampleBuffer)
        }
        
        func logFPS() {
            #if DEBUG
            let time = mach_absolute_time()
            
            frames += 1
            
            if frames.isMultiple(of: 100) {
                let elapsed = (Double(time) - Double(start)) / Double(NSEC_PER_SEC)
                let fps = Double(frames) / elapsed
                print("Frames: \(frames); Time: \(elapsed); FPS: \(fps)")
            }
            
            #endif
        }
        
    }
    
}

extension CameraView {
    
    class CameraController: UIViewController {
        
        let delegate: AVCaptureVideoDataOutputSampleBufferDelegate?
        
        var captureSession: AVCaptureSession?
        
        var frontCamera: AVCaptureDevice?
        
        var frontCameraInput: AVCaptureDeviceInput?
        
        var previewLayer: AVCaptureVideoPreviewLayer?
        
        var videoOutput: AVCaptureVideoDataOutput?
        
        init(delegate: AVCaptureVideoDataOutputSampleBufferDelegate?) {
            self.delegate = delegate
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            self.delegate = nil
            super.init(coder: coder)
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            captureSession = AVCaptureSession()
            captureSession?.sessionPreset = .medium
            
            guard let backCamera = AVCaptureDevice.default(for: .video) else {
                print("Failed to access back camera!")
                return
            }
            
            do {
                try backCamera.lockForConfiguration()
                backCamera.focusMode = .continuousAutoFocus
                backCamera.unlockForConfiguration()
            } catch let error {
                print("Failed to set Autofocus: \(error)")
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: backCamera)
                
                videoOutput = AVCaptureVideoDataOutput()
                videoOutput?.setSampleBufferDelegate(delegate,
                                                     queue: DispatchQueue.global(qos: .userInitiated))
                
                if captureSession!.canAddInput(input), captureSession!.canAddOutput(videoOutput!) {
                    captureSession?.addInput(input)
                    captureSession?.addOutput(videoOutput!)
                    captureSession?.connections.forEach { $0.videoOrientation = .portrait }
                    setupPreview()
                }
            } catch let error {
                print("failed to initiate input: \(error)")
            }
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.captureSession?.stopRunning()
            }
        }
        
        func setupPreview() {
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer?.videoGravity = .resizeAspectFill
            previewLayer?.connection?.videoOrientation = .portrait
            
            self.view.layer.addSublayer(previewLayer!)
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.captureSession?.startRunning()
                
                DispatchQueue.main.async {
                    self.previewLayer?.frame = self.view.bounds
                }
            }
        }
    }
    
    enum CameraControllerError: Swift.Error {
       case captureSessionAlreadyRunning
       case captureSessionIsMissing
       case inputsAreInvalid
       case invalidOperation
       case noCamerasAvailable
       case unknown
    }
    
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView { _ in
            
        }
    }
}
