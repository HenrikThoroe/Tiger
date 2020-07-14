//
//  ScanningIndicator.swift
//  Tiger
//
//  Created by Henrik Thoroe on 14.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct ScanningIndicator: View {
    
    var opaque: Bool = false
    
    @State private var offset: CGFloat = 0
    
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Scanning...")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.green)
                .multilineTextAlignment(.center)
            
            GeometryReader { proxy in
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.green)
                    .modifier(Stretch(direction: .horizontal))
                    .frame(height: 5)
                    .offset(x: self.offset)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onAppear {
                        self.offset = -proxy.size.width
                        
                        self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                                guard self.timer?.isValid ?? false else {
                                    return
                                }
                                
                                self.offset = -proxy.size.width
                                
                                withAnimation(Animation.linear(duration: 1)) {
                                    guard self.timer?.isValid ?? false else {
                                        return
                                    }
                                    
                                    self.offset += proxy.size.width
                                }
                                
                                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                                    withAnimation(Animation.linear(duration: 1)) {
                                        guard self.timer?.isValid ?? false else {
                                            return
                                        }
                                        
                                        self.offset += proxy.size.width
                                    }
                                    
                                    timer.invalidate()
                                }
                                
                                timer.invalidate()
                            }
                        }
                    }
                    .onDisappear {
                        self.timer?.invalidate()
                    }
            }
        }
        .padding()
        .background(
            opaque ?
                
            Color
                .white
                .cornerRadius(10)
                .modifier(MUIShadow(elevation: .one))
            :
                
            nil
        )
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct ScanningIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            ScanningIndicator()
            ScanningIndicator(opaque: true)
        }.padding()
    }
}
