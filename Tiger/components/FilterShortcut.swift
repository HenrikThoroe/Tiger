//
//  FilterShortcut.swift
//  Tiger
//
//  Created by Henrik Thoroe on 22.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct FilterShortcut: View {
    
    let title: LocalizedStringKey
    
    let descripton: LocalizedStringKey
    
    let thumbnail: LocalizedStringKey
    
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Text(thumbnail)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(
                    Circle()
                        .fill(color)
                )
            
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                Text(descripton)
                    .font(.system(size: 18, weight: .regular))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true) 
            }
            
            Spacer()
        }
        .padding()
        .cornerRadius(10)
    }
}

struct FilterShortcut_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            FilterShortcut(title: "Today", descripton: "Show Only Links from Today", thumbnail: "T", color: .purple)
        
            FilterShortcut(title: "This Week", descripton: "Show Only Links from This Week", thumbnail: "W", color: .green)
            
            FilterShortcut(title: "Today", descripton: "Show Only Links from Last Week", thumbnail: "7", color: .green)
        }.padding()
    }
}
