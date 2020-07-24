//
//  NoContent.swift
//  Tiger
//
//  Created by Henrik Thoroe on 17.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct NoContent: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 100)
            
            Image("NoContent")
                .resizable()
                .scaledToFill()
            
            Rectangle()
                .fill(Color("Water"))
                .scaledToFill()
                .overlay(
                    Text("This is the place where all your scanned links will go. Start filling this place by using the scanner.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                )
        }
        .scaledToFit()
    }
    
}

struct NoContent_Previews: PreviewProvider {
    static var previews: some View {
        NoContent()
    }
}
