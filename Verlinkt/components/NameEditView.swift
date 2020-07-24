//
//  LinkEditView.swift
//  Tiger
//
//  Created by Henrik Thoroe on 21.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct NameEditView: View {
    
    @Binding var name: String
    
    var keyboard: UIKeyboardType = .default
    
    var body: some View {
        VStack(spacing: 30) {
            Image("ArrowsDown")
                .resizable()
                .scaledToFit()
            
            TextField("Commit Your Changes", text: $name)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(keyboard)
            
            Image("ArrowsUp")
                .resizable()
                .scaledToFit()
        }
        .padding()
        .onDisappear {
            dismissKeyboard()
        }
    }
}

struct LinkEditView_Previews: PreviewProvider {
    
    @State private static var name: String = "https://www.apple.com/iPhone"
    
    static var previews: some View {
        NameEditView(name: $name)
    }
}
