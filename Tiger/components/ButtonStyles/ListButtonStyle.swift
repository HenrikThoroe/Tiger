//
//  ListButtonStyle.swift
//  Tiger
//
//  Created by Henrik Thoroe on 17.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct ListButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color(.systemGray6) : Color.white)
    }
    
}

struct ListButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}) {
            LinkPreview(link: .example)
        }.buttonStyle(ListButtonStyle())
    }
}
