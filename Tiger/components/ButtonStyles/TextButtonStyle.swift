//
//  TextButtonStyle.swift
//  Tiger
//
//  Created by Henrik Thoroe on 27.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct TextButtonStyle: ButtonStyle {
    
    var highlight: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(highlight ? .defaultHighlight : nil)
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
    
}

struct TextButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            Button(action: {}) {
                Text("This is just some text...")
            }.buttonStyle(TextButtonStyle())
            
            Button(action: {}) {
                Text("This is just some text...")
            }.buttonStyle(TextButtonStyle(highlight: true))
        }
    }
}
