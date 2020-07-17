//
//  LibraryView.swift
//  Tiger
//
//  Created by Henrik Thoroe on 25.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct LibraryScreen: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: ScannedLink.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ScannedLink.scanned_, ascending: true)
        ]
    ) var links: FetchedResults<ScannedLink>
    
    @State private var filterText: String = ""
    
    @State private var sortCondition: SortCondition = .date
    
    @State private var sortAscending = false
    
    @State private var showDeleteWarning: Bool = false
    
    @State private var sharedUrl: URL? = nil
    
    var body: some View {
        VStack {
            NavigationView {
                ScrollView {
                    SearchBar(text: $filterText)
                        .padding()
                    
                    if links.count > 0 {
                        content()
                    } else {
                        NoContent()
                    }
                }
                .navigationBarTitle(Text("My Library"))
                .navigationBarItems(trailing:
                    HStack(spacing: 20) {
                        Spacer()
                        
                        Picker(selection: $sortCondition, label: Text("Sort By: ")) {
                            Text("Date").tag(SortCondition.date)
                            Text("Name").tag(SortCondition.name)
                        }.pickerStyle(SegmentedPickerStyle())
                        Button(action: toggleSortDirection) {
                            Image(systemName: sortAscending ? "arrow.up.circle" : "arrow.down.circle")
                                    .resizable()
                        }.buttonStyle(IconButtonStyle())
                    }   
                )
                .sheet(item: $sharedUrl) { url in
                    ShareSheet(activityItems: [url as Any])
                }
            }
        }
    }
    
}

extension LibraryScreen {
    
    func content() -> some View {
        VStack {
            ForEach(links.filter(filter(_:)).sorted(by: compare(_:_:)), id: \.id) { link in
                NavigationLink(destination: LinkDetailScreen(for: link)) {
                    LinkPreview(link: link)
                }
                .buttonStyle(ListButtonStyle())
                .contextMenu {
                    Button(action: link.open) {
                        Text("Open in Browser")
                        Image(systemName: "link")
                    }
                    
                    Button(action: { self.sharedUrl = link.url }) {
                        Text("Share")
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                    Button(action: { self.delete(link: link) }) {
                        Text("Delete")
                        Image(systemName: "trash")
                    }.foregroundColor(.red)
                }
            }
        }
    }
    
}

private extension LibraryScreen {
    
    func delete(link: ScannedLink) {
        managedObjectContext.delete(link)
        try? managedObjectContext.save()
    }
    
    func compare(_ a: ScannedLink, _ b: ScannedLink) -> Bool {
        if sortCondition == .date {
            return sortAscending ? a.scanned < b.scanned : a.scanned > b.scanned
        } else {
            return sortAscending ? a.name < b.name : a.name > b.name
        }
    }
    
    func toggleSortDirection() {
        sortAscending.toggle()
    }
    
    func filter(_ item: ScannedLink) -> Bool {
        filterText.isEmpty || item.name.lowercased().contains(filterText.lowercased())
    }
    
}

extension LibraryScreen {
    
    enum SortCondition: Int {
        case name, date
    }
    
}

struct LibraryScreen_Previews: PreviewProvider {
    static var previews: some View {
        LibraryScreen()
    }
}
