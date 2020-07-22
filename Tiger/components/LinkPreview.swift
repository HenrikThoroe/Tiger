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
    
    var customNavigationHint: Bool = false
    
    var body: some View {
        HStack(spacing: 30) {
            HStack(alignment: .top, spacing: 20) {
                link.thumbnail
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .cornerRadius(10)
                    
                
                VStack(alignment: .leading, spacing: 7) {
                    Text(link.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .lineLimit(1)
                    
                    Text(link.href)
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .lineLimit(2)
                }.modifier(Stretch(direction: .horizontal, alignment: .leading))
            }
            
            if customNavigationHint {
                Image(systemName: "chevron.right")
                    .font(.system(size: 24))
            }
        }
        .padding()
        .padding(.trailing, 10)
    }
}

struct LinkPreview_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LinkPreview(link: ScannedLink.shortExample)
            LinkPreview(link: ScannedLink.longExample)
            LinkPreview(link: ScannedLink.example)
        }
    }
}
