//
//  CameraDenied.swift
//  Tiger
//
//  Created by Henrik Thoroe on 18.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct CameraDenied: View {
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .center, spacing: 20.0) {
                Image("Camera")
                Text("Please allow this app to use your camera. Otherwise nothing can be scanned ):")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            Text("You can allow camera usage in Settings > !!!THIS APP!!! > Camera")
                .font(.footnote)
                .multilineTextAlignment(.center)
        }
        .padding()
        .modifier(Stretch())
    }
    
}

struct CameraDenied_Previews: PreviewProvider {
    static var previews: some View {
        CameraDenied()
    }
}
