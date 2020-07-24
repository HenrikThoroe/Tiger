//
//  ContrastButton.swift
//  Tiger
//
//  Created by Henrik Thoroe on 27.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct MaterialButtonStyle: ButtonStyle {
    
    var flat: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.backgroundSecondary)
            .cornerRadius(10)
            .modifier(MUIShadow(elevation: flat || configuration.isPressed ? .zero : .one))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.backgroundSecondary)
                .modifier(MUIShadow(elevation: .one))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .opacity(configuration.isPressed ? 1 : 0)
        )
    }
    
}

struct ContrastButton_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}) {
            Text("Hello")
        }.buttonStyle(MaterialButtonStyle(flat: false))
    }
}
