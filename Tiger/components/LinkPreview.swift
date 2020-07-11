//
//  LinkPreview.swift
//  Tiger
//
//  Created by Henrik Thoroe on 27.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct LinkPreview: View {
    
    let link: ScannedLink
    
    var body: some View {
        HStack(spacing: 20) {
            link.thumbnail
                .resizable()
                .modifier(CircleImage())
                .frame(width: 50, height: 50, alignment: .center)
                
            VStack(alignment: .leading) {
                Text(link.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Spacer()
                Text(link.href)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.vertical)
        .modifier(Stretch(direction: .horizontal))
    }
}

struct LinkPreview_Previews: PreviewProvider {
    static var previews: some View {
        LinkPreview(link: ScannedLink.example)
    }
}
