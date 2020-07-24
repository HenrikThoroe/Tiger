//
//  IconButtonStyle.swift
//  Tiger
//
//  Created by Henrik Thoroe on 27.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct IconButtonStyle: ButtonStyle {
    
    var behaviour: Behaviour = .default
    
    var size: Size = .m
    
    var color: Color {
        switch behaviour {
        case .destructive:
            return .destructiveHighlight
        case .default:
            return .defaultHighlight
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaledToFit()
            .frame(width: 25 * CGFloat(size.rawValue), height: 25 * CGFloat(size.rawValue))
            .foregroundColor(color)
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
    
}

extension IconButtonStyle {
    
    enum Behaviour {
        case destructive, `default`
    }
    
    enum Size: Double {
        case s = 0.8
        case m = 1
        case l = 1.2
        case xl = 1.5
        case xxl = 2
    }
    
}

struct IconButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            HStack(spacing: 30) {
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                }.buttonStyle(IconButtonStyle(size: .s))
                
                Button(action: {}) {
                    Image(systemName: "trash")
                        .resizable()
                }.buttonStyle(IconButtonStyle(behaviour: .destructive, size: .s))
            }
            
            HStack(spacing: 30) {
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                }.buttonStyle(IconButtonStyle(size: .m))
                
                Button(action: {}) {
                    Image(systemName: "trash")
                        .resizable()
                }.buttonStyle(IconButtonStyle(behaviour: .destructive, size: .s))
            }
            
            HStack(spacing: 30) {
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                }.buttonStyle(IconButtonStyle(size: .l))
                
                Button(action: {}) {
                    Image(systemName: "trash")
                        .resizable()
                }.buttonStyle(IconButtonStyle(behaviour: .destructive, size: .l))
            }
            
            HStack(spacing: 30) {
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                }.buttonStyle(IconButtonStyle(size: .xl))
                
                Button(action: {}) {
                    Image(systemName: "trash")
                        .resizable()
                }.buttonStyle(IconButtonStyle(behaviour: .destructive, size: .xl))
            }
            
            HStack(spacing: 30) {
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                }.buttonStyle(IconButtonStyle(size: .xxl))
                
                Button(action: {}) {
                    Image(systemName: "trash")
                        .resizable()
                }.buttonStyle(IconButtonStyle(behaviour: .destructive, size: .xxl))
            }
        }
    }
}
