//
//  Stretch.swift
//  Tiger
//
//  Created by Henrik Thoroe on 23.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct Stretch: ViewModifier {
    
    let direction: Direction
    
    var alignment: Alignment = .center
    
    private var minWidth: CGFloat? {
        direction == .vertical ? nil : 0
    }
    
    private var minHeight: CGFloat? {
        direction == .horizontal ? nil : 0
    }
    
    private var maxWidth: CGFloat? {
        direction == .vertical ? nil : .infinity
    }
    
    private var maxHeight: CGFloat? {
        direction == .horizontal ? nil : .infinity
    }
    
    func body(content: Content) -> some View {
        content
            .frame(minWidth: minWidth,
                   maxWidth: maxWidth,
                   minHeight: minHeight,
                   maxHeight: maxHeight,
                   alignment: alignment)
    }
    
}

extension Stretch {
    
    enum Direction {
        case horizontal
        case vertical
        case both
    }
    
}
