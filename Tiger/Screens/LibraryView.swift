//
//  LibraryView.swift
//  Tiger
//
//  Created by Henrik Thoroe on 25.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI
import UIKit

struct A: View {
    
    var body: some View {
        Text("Test")
    }
    
}

struct LibraryScreen: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: ScannedLink.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ScannedLink.scanned, ascending: false)
        ]
    ) var links: FetchedResults<ScannedLink>
    
    @State private var searchText: String = ""
    
    @State private var filterOption = "d"
    
    var body: some View {
        VStack {
            NavigationView {
                ScrollView {
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                    VStack {
                        ForEach(links, id: \.id) { link in
                            NavigationLink(destination: LinkDetailScreen(for: link)) {
                                LinkPreview(link: link)
                            }
                            .buttonStyle(ContrastButton(flat: false))
                            .padding()
                            .contextMenu {
                                Button(action: {}) {
                                    Text("Open in Browser")
                                    Image(systemName: "link")
                                }
                                
                                Button(action: {}) {
                                    Text("Share")
                                    Image(systemName: "square.and.arrow.up")
                                }
                                
                                Button(action: {}) {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }.foregroundColor(.red)
                            }
                        }
                    }
                }
                .navigationBarTitle(Text("My Library"))
                .navigationBarItems(
                    leading:
                        Picker(selection: $filterOption, label: Text("Sort By: ")) {
                            Text("Date").tag("d")
                            Text("Name").tag("n")
                        }.pickerStyle(SegmentedPickerStyle()),
                    trailing:
                        Button(action: {}) {
                            Image(systemName: "arrow.down.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                        }
                )
            }
        }
    }
    
    func deleteAll() {
        for link in links {
            managedObjectContext.delete(link)
        }
        
        try? managedObjectContext.save()
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryScreen()
    }
}
