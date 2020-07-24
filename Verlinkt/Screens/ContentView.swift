//
//  ContentView.swift
//  Tiger
//
//  Created by Henrik Thoroe on 23.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @State private var selection = 0
    
    var body: some View {
        VStack {
            
            Picker(selection: $selection, label: Text("Select Anything")) {
                Text("Left").tag(0)
                Text("Right").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
//            VStack {
//                ZStack(alignment: .bottom) {
//                    Image("Demo")
//                        .resizable()
//                    Text("Move your iPhone over a Link")
//                        .fontWeight(.medium)
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(Color.white)
//                                .modifier(MUIShadow())
//                        )
//                        .offset(y: -20)
//                }
//                ScrollView {
//                    HStack(alignment: .center, spacing: 10.0) {
//                        Text("https://www.example.com/bla/blabla/blablabal")
//                            .font(.body)
//                            .fontWeight(.medium)
//                            .multilineTextAlignment(.leading)
//                            .lineLimit(2)
//                            .padding()
//                        ButtonComponent(text: "Select") {
//
//                        }
//                    }
//                    .padding(.all)
//                    HStack(alignment: .center, spacing: 10.0) {
//                        Text("https://www.example.com/bla/blabla/blablabal")
//                            .font(.body)
//                            .fontWeight(.medium)
//                            .multilineTextAlignment(.leading)
//                            .lineLimit(2)
//                            .padding()
//                        ButtonComponent(text: "Select") {
//
//                        }
//                    }
//                    .padding(.all)
//                    HStack(alignment: .center, spacing: 10.0) {
//                        Text("https://www.example.com/bla/blabla/blablabal")
//                            .font(.body)
//                            .fontWeight(.medium)
//                            .multilineTextAlignment(.leading)
//                            .lineLimit(2)
//                            .padding()
//                        ButtonComponent(text: "Select") {
//
//                        }
//                    }
//                    .padding(.all)
//                }
//                .frame(height: 200.0)
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
