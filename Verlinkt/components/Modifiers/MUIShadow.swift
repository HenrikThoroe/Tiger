//
//  MUIShadow.swift
//  Tiger
//
//  Created by Henrik Thoroe on 23.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct MUIShadow: ViewModifier {
    
    var elevation: ElevationLevel = .one
    
    var offset: (CGPoint, CGPoint) {
        switch elevation {
        case .zero:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))
        case .one:
            return (CGPoint(x: 0, y: 1), CGPoint(x: 0, y: 1))
        case .two:
            return (CGPoint(x: 0, y: 3), CGPoint(x: 0, y: 3))
        case .three:
            return (CGPoint(x: 0, y: 10), CGPoint(x: 0, y: 6))
        }
    }
    
    var blurRadius: (CGFloat, CGFloat) {
        switch elevation {
        case .zero:
            return (0, 0)
        case .one:
            return (3, 2)
        case .two:
            return (6, 6)
        case .three:
            return (20, 6)
        }
    }
    
    var color: (Color, Color) {
        switch elevation {
        case .zero:
            return (
                 Color.black.opacity(0),
                 Color.black.opacity(0)
            )
        case .one:
            return (
                 Color.black.opacity(0.12),
                 Color.black.opacity(0.24)
            )
        case .two:
            return (
                 Color.black.opacity(0.16),
                 Color.black.opacity(0.23)
            )
        case .three:
            return (
                 Color.black.opacity(0.19),
                 Color.black.opacity(0.23)
            )
        }
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.0,
                    radius: blurRadius.0, x: offset.0.x, y: offset.0.y)
            .shadow(color: color.1,
                    radius: blurRadius.1, x: offset.1.x, y: offset.1.y)
    }
    
}

extension MUIShadow {
    
    enum ElevationLevel: Int {
        case zero, one, two, three
    }
    
}
