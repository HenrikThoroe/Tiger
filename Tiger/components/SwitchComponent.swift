//
//  SwitchComponent.swift
//  Tiger
//
//  Created by Henrik Thoroe on 23.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct SwitchComponent: View {
    
    @Binding var activeTab: Tab
    
    var body: some View {
        HStack(spacing: 10) {
            self.box(isActive: self.activeTab == .left, callback: { self.activeTab = .left }) {
                self.label("Left")
            }
            self.box(isActive: self.activeTab == .right, callback: { self.activeTab = .right }) {
                self.label("Right")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .modifier(Stretch(direction: .horizontal))
        .overlay(
            RoundedRectangle(cornerRadius: .infinity)
                .stroke(Color.white, lineWidth: 4)
                .modifier(MUIShadow())
                .clipShape(
                    RoundedRectangle(cornerRadius: .infinity)
                )
                .modifier(MUIShadow())
                .clipShape(
                    RoundedRectangle(cornerRadius: .infinity)
                )
        )
        .padding()
    }
    
    func label(_ value: LocalizedStringKey) -> some View {
        Text(value)
            .font(.headline)
            .fontWeight(.semibold)
    }
    
    func box<T: View>(isActive: Bool, callback: @escaping () -> Void, _ content: () -> T) -> some View {
        content()
            .padding(.horizontal)
            .padding(.vertical, 10)
            .modifier(Stretch(direction: .horizontal))
            .background(
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .fill(Color.white)
                    .cornerRadius(20)
                    .modifier(MUIShadow())
                    .opacity(isActive ? 1 : 0)
            )
            .onTapGesture {
                callback()
            }
        
    }
}

extension SwitchComponent {
    
    enum Tab {
        case left, right
    }
    
}

struct SwitchComponent_Previews: PreviewProvider {
    
    @State private static var activeTab: SwitchComponent.Tab = .left
    
    static var previews: some View {
        SwitchComponent(activeTab: $activeTab)
    }
}
