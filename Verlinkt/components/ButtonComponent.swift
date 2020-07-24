//
//  ButtonComponent.swift
//  Tiger
//
//  Created by Henrik Thoroe on 23.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct ButtonComponent: View {
    
    var text: LocalizedStringKey?
    
    var icon: Image?
    
    var backgroundColor: Color = .defaultHighlight
    
    var color: Color = .inputTextColor
    
    let callback: () -> Void
    
    var body: some View {
        Button(action: handleClick) {
            buttonContent()
        }.buttonStyle(Style(background: backgroundColor))
    }
    
    func buttonContent() -> some View {
        HStack(alignment: .firstTextBaseline) {
            icon
                .foregroundColor(color)
            
            if icon != nil && text != nil {
                Rectangle()
                    .background(Color(red: 0, green: 0, blue: 0))
                    .frame(width: 5, height: 1)
            }
            
            if text != nil {
                Text(text!)
                    .fontWeight(.medium)
                    .foregroundColor(color)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    func handleClick() {
        callback()
    }
}

extension ButtonComponent {
    
    struct Style: ButtonStyle {
        
        let background: Color
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(15)
                .padding(.horizontal)
                .background(background)
                .cornerRadius(8)
                .modifier(MUIShadow(elevation: configuration.isPressed ? .zero : .two))
                
        }
        
    }
    
}

struct ButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        ButtonComponent(text: "Hello, World!", icon: Image(systemName: "square.and.arrow.up")) {
            
        }
    }
}
