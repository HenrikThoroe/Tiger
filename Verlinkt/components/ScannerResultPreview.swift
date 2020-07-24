//
//  ScannerResultPreview.swift
//  Tiger
//
//  Created by Henrik Thoroe on 27.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct ScannerResultPreview: View {
    
    let scan: ImageProcessor.Result
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Confidence: Normal")
                            .font(.caption)
                        HStack {
                            GeometryReader { proxy in
                                RoundedRectangle(cornerRadius: 3)
                                    .frame(minWidth: proxy.size.width * CGFloat(self.scan.confidence),
                                           maxWidth: proxy.size.width * CGFloat(self.scan.confidence),
                                           minHeight: 3, maxHeight: 3)
                                    .foregroundColor(
                                        Color(hue: self.scan.confidence * 125 / 360,
                                              saturation: 1,
                                              brightness: 1)
                                    )
                                    .modifier(MUIShadow(elevation: .one))
                            }
                            .frame(minHeight: 3, maxHeight: 3)
                            
                            Spacer()
                        }
                    }
                    Text(self.scan.value)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .padding(.all)
                }
            }
        }.buttonStyle(MaterialButtonStyle(flat: false))
    }
}

struct ScannerResultPreview_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            ScannerResultPreview(scan: ImageProcessor.Result(value: "https://example.com", confidence: 1, location: .zero)) {
                
            }
            ScannerResultPreview(scan: ImageProcessor.Result(value: "https://example.com/long/long/long/long/long/path", confidence: 0.5, location: .zero)) {
                
            }
        }.padding()
    }
}
