//
//  ContentView.swift
//  Tiger
//
//  Created by Henrik Thoroe on 23.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct MainScreen: View {
    
    @State private var selection: Tab = .library
    
    var body: some View {
//        VStack {
//            viewSwitch()
//
//            if selection == .scanner {
//                ScannerScreen()
//                    .modifier(Stretch(direction: .both))
//            } else {
//                LibraryScreen()
//                    .modifier(Stretch(direction: .both))
//            }
//        }
        
        TabView {
            
            ScannerScreen()
                .modifier(Stretch(direction: .both))
                .tabItem {
                    VStack {
                        Image(systemName: "doc.text.viewfinder")
                        Text("Scanner")
                    }
                }
            
            LibraryScreen()
                .modifier(Stretch(direction: .both))
                .tabItem {
                    VStack {
                        Image(systemName: "tray.2")
                        Text("Library")
                    }
                }
            
        }
    }
    
    func viewSwitch() -> some View {
        Picker(selection: $selection, label: Text("Select Anything")) {
            Text("Scanner").tag(Tab.scanner)
            Text("Library").tag(Tab.library)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}

extension MainScreen {
    
    enum Tab: Int {
        case scanner, library
    }
    
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
