//
//  ScannerView.swift
//  Tiger
//
//  Created by Henrik Thoroe on 25.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI
import AVFoundation

struct ScannerScreen: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var results: [ImageProcessor.Result] = []
    
    @State private var resultToSave: ImageProcessor.Result? = nil
    
    @State private var showSaveSheet: Bool = false
    
    @State private var showCamera: Bool = true
    
    @State private var allowCamera = false
    
    @State private var pauseCamera = false
    
    @State private var lastScannerEvent = Date()
    
    @State private var timer: Timer?
    
    @ObservedObject private var imageFilter = ImageResultFilter()
    
    private let imageProcessor = ImageProcessor()
    
    var body: some View {
        VStack {
            
            if showCamera {
                if pauseCamera {
                    pauseScreen()
                } else {
                    GeometryReader { proxy in
                        if self.allowCamera {
                            self.camera(in: proxy)
                                .edgesIgnoringSafeArea(.top)
                        } else {
                            CameraDenied()
                        }
                    }
                }
            } else {
                preview()
                    .modifier(Stretch(direction: .both))
            }
        }
        .sheet(isPresented: $showSaveSheet) {
            SaveScreen(scannerResult: Binding(self.$resultToSave)!, isPresented: self.$showSaveSheet)
                .environment(\.managedObjectContext, self.managedObjectContext)
        }
        .onAppear {
            self.requestCameraPermission()
            self.setupTimer()
        }
        .onDisappear {
            self.deleteTimer()
        }
    }
    
    func camera(in rect: GeometryProxy) -> some View {
        ZStack(alignment: .bottom) {
            CameraView(onReceiveFrame: { frame in
                do {
                    try self.imageProcessor.process(image: frame, in: nil,
                                                    resultHandler: self.handleScannerResult(_:))
                } catch {
                    print(error)
                }
            })
            .modifier(Stretch(direction: .both))
            
            VStack {
                ScanningIndicator(opaque: true)
                    .padding()
                    .offset(y: 30)
                
                Spacer()
                
                if imageFilter.results.count > 0 {
                    Button(action: { self.showCamera = false }) {
                        VStack(spacing: 15) {
                            Text(results.isEmpty ? "Nothing Found yet" : "Found \(imageFilter.results.count) Links")
                                .font(.headline)
                                .fontWeight(.heavy)
                            Text("Click to View your Results")
                                .font(.caption)
                        }
                        .padding(.horizontal)
                    }
                    .buttonStyle(MaterialButtonStyle())
                    .modifier(MUIShadow(elevation: .three))
                    .offset(y: -20)
                }
            }
        }
    }
    
    func preview() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Button(action: { self.showCamera = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                        Text("Go Back")
                    }.padding()
                }
                
                Spacer()
                
                Button(action: self.imageFilter.clear) {
                    Text("Clear")
                        .padding()
                }.buttonStyle(TextButtonStyle(highlight: true))
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(imageFilter.results, id: \.self) { result in
                        ScannerResultPreview(scan: result) {
                            self.prepareSave(of: result)
                        }
                    }
                }
                .padding()
                .padding(.top)
            }
        }
    }
    
    func pauseScreen() -> some View {
        let resume = {
            self.pauseCamera = false
            self.lastScannerEvent = Date()
        }
        
        return VStack(spacing: 50) {
            VStack(spacing: 30) {
                Image("Battery")
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                Text("Scanning has been paused to save your battery power.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }.padding()
            
            Button(action: resume) {
                Text("Resume").modifier(Stretch(direction: .horizontal))
            }.buttonStyle(FlatButtonStyle())
        }.padding()
    }
}

private extension ScannerScreen {
    
    func setupTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.timerAction()
        }
    }
    
    func timerAction() {
        let elapsed = Date().timeIntervalSince(lastScannerEvent)
        
        if elapsed >= 60 {
            pauseCamera = true
        }
    }
    
    func deleteTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func requestCameraPermission() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            allowCamera = true
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
               if granted {
                    self.allowCamera = true
               } else {
                    self.allowCamera = false
               }
           }
        }
    }
    
    func handleScannerResult(_ result: ImageProcessor.Result) {
        lastScannerEvent = Date()
        
        if !results.contains(where: { $0.value == result.value }) {
            results += [result]
            imageFilter.feed(with: result)
        }
    }
    
    func prepareSave(of result: ImageProcessor.Result) {
        resultToSave = result
        showSaveSheet = true
    }
    
}

struct ScannerScreen_Previews: PreviewProvider {
    static var previews: some View {
        ScannerScreen()
    }
}
