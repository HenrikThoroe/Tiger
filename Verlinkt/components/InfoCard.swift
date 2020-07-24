//
//  InfoCard.swift
//  Tiger
//
//  Created by Henrik Thoroe on 27.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct InfoCard: View {
    
    let info: LocalizedStringKey
    
    var body: some View {
        Text(info)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
                    .modifier(MUIShadow(elevation: .three))
            )
    }
}

struct InfoCard_Previews: PreviewProvider {
    static var previews: some View {
        InfoCard(info: "Just an info card.")
    }
}
