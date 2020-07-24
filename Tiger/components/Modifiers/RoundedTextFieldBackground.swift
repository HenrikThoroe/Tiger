//
//  RoundedTextFieldBackground.swift
//  Tiger
//
//  Created by Henrik Thoroe on 22.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct RoundedTextFieldBackground: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
    }
    
}

struct RoundedTextFieldBackground_Previews: PreviewProvider {
    static var previews: some View {
        TextField("Placeholder", text: .constant(""))
            .modifier(RoundedTextFieldBackground())
    }
}
