//
//  ScannerView.swift
//  Tiger
//
//  Created by Henrik Thoroe on 25.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct ScannerScreen: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var results: [ImageProcessor.Result] = []
    
    @State private var resultToSave: ImageProcessor.Result? = nil
    
    @State private var showSaveSheet: Bool = false
    
    @State private var showCamera: Bool = true
    
    private let imageProcessor = ImageProcessor()
    
//    init() {
//        self.imageProcessor = ImageProcessor { result in
//            self.handleScannerResult(result)
//        }
//    }
    
    var body: some View {
        VStack {
            
            if showCamera {
                camera()
                    .edgesIgnoringSafeArea(.top)
            } else {
                preview()
                    .modifier(Stretch(direction: .both))
            }
            
//            preview()
//                .frame(height: 200, alignment: .top)
//                .modifier(Stretch(direction: .horizontal))
        }
        .sheet(isPresented: $showSaveSheet) {
            SaveScreen(scannerResult: Binding(self.$resultToSave)!, isPresented: self.$showSaveSheet)
                .environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
    
    func camera() -> some View {
        ZStack(alignment: .bottom) {
            CameraView(onReceiveFrame: { frame in
                do {
                    try self.imageProcessor.process(image: frame,
                                                    resultHandler: self.handleScannerResult(_:))
                } catch {
                    print(error)
                }
            })
            .modifier(Stretch(direction: .both))
            
            Button(action: { self.showCamera = false }) {
                VStack(spacing: 15) {
                    Text(results.isEmpty ? "Nothing Found yet" : "Found \(results.count) Links")
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
            }.background(Color(.systemBackground).opacity(0.4))
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(results, id: \.self) { result in
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
}

extension ScannerScreen {
    
    func handleScannerResult(_ result: ImageProcessor.Result) {
        if !results.contains(where: { $0.value == result.value }) {
            results += [result]
        }
    }
    
    func prepareSave(of result: ImageProcessor.Result) {
        resultToSave = result
        showSaveSheet = true
    }
    
    func addExample() {
        _ = ScannedLink(context: self.managedObjectContext, href: "https://www.example.com/blabla/bla")
    }
    
}

struct ScannerScreen_Previews: PreviewProvider {
    static var previews: some View {
        ScannerScreen()
    }
}
