//
//  DatePickerView.swift
//  Tiger
//
//  Created by Henrik Thoroe on 23.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct DatePickerView: View {
    
    let title: LocalizedStringKey
    
    @Binding var date: Date
    
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Text(title)
                    .font(.headline)
                
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                
                Button(action: { self.isPresented = false }) {
                    Text("Select")
                        .modifier(Stretch(direction: .horizontal))
                }.buttonStyle(FlatButtonStyle())
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
        }
        .padding()
        .modifier(Stretch())
        .background(Color.black.opacity(0.6))
        .edgesIgnoringSafeArea(.all)
        .opacity(isPresented ? 1 : 0)
        .transition(.opacity)
        .animation(.linear(duration: 0.2))
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView(title: "Select a Date", date: .constant(Date()), isPresented: .constant(true))
    }
}
