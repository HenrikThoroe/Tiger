//
//  CircleImage.swift
//  Tiger
//
//  Created by Henrik Thoroe on 27.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct CircleImage: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .clipShape(Circle())
//            .overlay(
//                Circle()
//                    .fill(Color.red)
//                    .stroke(Color.white, lineWidth: 4)
//                    .shadow(radius: 10)
//            )
            
    }
    
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 200, height: 200)
                    .modifier(CircleImage())
                
                Spacer()
            }
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color.black)
    }
}
