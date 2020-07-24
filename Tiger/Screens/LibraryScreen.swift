//
//  LibraryView.swift
//  Tiger
//
//  Created by Henrik Thoroe on 25.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI
import CoreData

struct LibraryScreen: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: ScannedLink.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ScannedLink.scanned_, ascending: true)
        ]
    ) var links: FetchedResults<ScannedLink>
    
    @State private var filterOptions: FilterOptions = .none
    
    @State private var filterText: String = ""
    
    @State private var sortCondition: SortCondition = .date
    
    @State private var sortAscending = false
    
    @State private var showDeleteWarning: Bool = false
    
    @State private var sharedUrl: URL? = nil
    
    @State private var showListSettings: Bool = false
    
    var body: some View {
        Group {
            if links.count > 0 {
                main()
            } else {
                NoContent()
            }
        }
    }
    
}

extension LibraryScreen {
    
    func main() -> some View {
        VStack {
            NavigationView {
                content()
                    .navigationBarTitle(Text("My \(links.count) Links"), displayMode: .automatic)
                    .navigationBarItems(leading:
                        Button(action: { self.filterOptions = .none }) {
                            Text("Reset Filters")
                        },
                                        
                        trailing: Button(action: { self.showListSettings = true }) {
                            Image(systemName: "gear")
                                .resizable()
                        }.buttonStyle(IconButtonStyle())
                    )
                    .sheet(item: $sharedUrl) { url in
                        ShareSheet(activityItems: [url as Any])
                    }
                    .sheet(isPresented: $showListSettings) {
                        ListSettingsScreen(isPresented: self.$showListSettings, options: self.$filterOptions)
                    }
            }
        }
    }
    
    func content() -> some View {
        List {
            ForEach(displayedItems(), id: \.id) { link in
                NavigationLink(destination: LinkDetailScreen(link: link)) {
                    LinkPreview(link: link)
                        .contextMenu {
                            Button(action: link.open) {
                                Text("Open in Browser")
                                Image(systemName: "link")
                            }
                            
                            Button(action: { self.sharedUrl = link.url }) {
                                Text("Share")
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                }
            }
            .onDelete { indexSet in
                let displayed = self.displayedItems()
                
                indexSet.forEach { index in
                    self.delete(link: displayed[index])
                }
            }
        }
    }
    
}

private extension LibraryScreen {
    
    func displayedItems() -> [ScannedLink] {
        links.filter(filter(_:)).sorted(by: compare(_:_:))
    }
    
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
        var matchesQuery = true
        
        if !filterOptions.hrefQuery.isEmpty {
            matchesQuery = item.href.lowercased().contains(filterOptions.hrefQuery.lowercased())
        } else if !filterOptions.domainQuery.isEmpty {
            matchesQuery = item.name.lowercased().contains(filterOptions.domainQuery.lowercased())
        }
        
        if case let .exact(date) = filterOptions.created {
            matchesQuery = item.scanned.isSameDay(as: date)
        }
        
        if case let .span(start, end) = filterOptions.created {
            matchesQuery = item.scanned.isBetween(start, end)
        }
        
        return matchesQuery
    }
    
}

extension LibraryScreen {
    
    enum SortCondition: Int {
        case name, date
    }
    
}

struct LibraryScreen_Previews: PreviewProvider {
    static var previews: some View {
        LibraryScreen().environment(\.managedObjectContext, NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType))
    }
}
