//
//  FlatButtonStyle.swift
//  Tiger
//
//  Created by Henrik Thoroe on 16.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct FlatButtonStyle: ButtonStyle {
    
    var type: ContentType = .primary
    
    private var backgroundColor: Color {
        switch type {
        case .primary:
            return .blue
        case .destructive:
            return .red
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(backgroundColor.brightness(configuration.isPressed ? -0.2 : 0))
            .cornerRadius(10)
    }
    
}

extension FlatButtonStyle {
    
    enum ContentType {
        case primary, destructive
    }
    
}

struct FlatButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Button(action: {}) {
                Text("Hello")
            }.buttonStyle(FlatButtonStyle())
            
            Button(action: {}) {
                Text("Hello")
            }.buttonStyle(FlatButtonStyle(type: .destructive))
        }
    }
}
