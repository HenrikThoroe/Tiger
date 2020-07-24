//
//  ListSettingsScreen.swift
//  Tiger
//
//  Created by Henrik Thoroe on 22.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct ListSettingsScreen: View {
    
    @Binding var isPresented: Bool
    
    @Binding var options: FilterOptions
    
    @State private var showShortcuts = true
    
    @State private var showDatePicker = true
    
    @State private var dateOption: DateOption = .any
    
    @State private var exactDate = Date()
    
    @State private var startDate = Date()
    
    @State private var endDate = Date()
    
    @State private var shownPicker: DatePickerDestination = .none
    
    var body: some View {
        ZStack {
            VStack {
                Picker(selection: $showShortcuts, label: Text("")) {
                    Text("Shortcuts").tag(true)
                    Text("Manual").tag(false)
                }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if showShortcuts {
                    shortcuts()
                } else {
                    manual()
                }
                
                Spacer()
            }
            
            if shownPicker == .exact {
                DatePickerView(title: "Select a Date", date: $exactDate, isPresented: $showDatePicker)
            }
            
            if shownPicker == .start {
                DatePickerView(title: "Select a Start Date", date: $startDate, isPresented: $showDatePicker)
            }
            
            if shownPicker == .end {
                DatePickerView(title: "Select an End Date", date: $endDate, isPresented: $showDatePicker)
            }
        }
    }
    
    func title(_ name: LocalizedStringKey) -> some View {
        Text(name)
            .font(.system(size: 36, weight: .black, design: .rounded))
            .multilineTextAlignment(.leading)
    }
    
    func shortcuts() -> some View {
        VStack(alignment: .leading) {
            title("Shortcuts")
                .padding(.leading)
            
            ScrollView {
                VStack {
                    Button(action: { self.select(shortcut: .today) }) {
                        FilterShortcut(title: "Today", descripton: "Show Only Links from Today", thumbnail: "T", color: .purple)
                    }.buttonStyle(ListButtonStyle())
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Button(action: { self.select(shortcut: .thisWeek) }) {
                        FilterShortcut(title: "This Week", descripton: "Show Only Links from This Week", thumbnail: "W", color: .green)
                    }.buttonStyle(ListButtonStyle())
                    
                    Button(action: { self.select(shortcut: .lastWeek) }) {
                        FilterShortcut(title: "Last Week", descripton: "Show Only Links Scanned within the Last 7 Days", thumbnail: "7", color: .green)
                    }.buttonStyle(ListButtonStyle())
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Button(action: { self.select(shortcut: .thisMonth) }) {
                        FilterShortcut(title: "This Month", descripton: "Show Only Links from This Month", thumbnail: "M", color: .orange)
                    }.buttonStyle(ListButtonStyle())
                    
                    Button(action: { self.select(shortcut: .lastMonth) }) {
                        FilterShortcut(title: "Last Month", descripton: "Show Only Links Scanned within the Last 31 Days", thumbnail: "31", color: .orange)
                    }.buttonStyle(ListButtonStyle())
                }
            }
        }
    }
    
    func manual() -> some View {
        VStack(alignment: .leading, spacing: 40) {
            title("Manual")
            
            VStack(spacing: 25) {
                TextField("Domain (e.g. apple.com) Contains", text: $options.domainQuery)
                    .modifier(RoundedTextFieldBackground())
                TextField("URL (e.g. apple.com/iPhone) Contains", text: $options.hrefQuery)
                    .modifier(RoundedTextFieldBackground())
            }
            
            Divider()
            
            Picker(selection: $dateOption, label: Text("Range")) {
                Text("Any Time").tag(DateOption.any)
                Text("Exact Date").tag(DateOption.exact)
                Text("Between Dates").tag(DateOption.span)
            }.pickerStyle(SegmentedPickerStyle())
            
            if dateOption == .span {
                dateRangeSelection()
            }
            
            if dateOption == .exact {
                exactDateSelection()
            }
            
            if dateOption == .any {
                ZStack {
                    Image("Infinity")
                        .resizable()
                        .scaledToFit()
                }
                .padding()
                .modifier(Stretch())
            }
            
        }
        .padding()
        .onDisappear {
            self.save()
        }
    }
    
    func dateRangeSelection() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                dateSelectionRow(for: .start)
                dateSelectionRow(for: .end)
            }.padding()
        }.modifier(Stretch(direction: .horizontal, alignment: .leading))
    }
    
    func exactDateSelection() -> some View {
        dateSelectionRow(for: .exact)
            .padding()
    }
    
    func dateSelectionRow(for dateType: DatePickerDestination) -> some View {
        let label: LocalizedStringKey
        let formatter = DateFormatter()
        let date: Date
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        switch dateType {
        case .none:
            label = ""
            date = Date()
        case .exact:
            label = "Links Scanned On:"
            date = exactDate
        case .start:
            label = "From:"
            date = startDate
        case .end:
            label = "To:"
            date = endDate
        }
        
        return VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(.headline)
            Button(action: { self.showDatePicker(destination: dateType) }) {
                DateDisplay(date: date, showTime: false)
            }.buttonStyle(TextButtonStyle())
        }
    }
    
}

extension ListSettingsScreen {
    
    func select(shortcut: FilterOptions) {
        options = shortcut
        isPresented = false
    }
    
    func save() {
        switch dateOption {
        case .any:
            options.created = .any
        case .exact:
            options.created = .exact(exactDate)
        case .span:
            guard startDate <= endDate else {
                return
            }
            
            options.created = .span(startDate, endDate)
        }
    }
    
    func showDatePicker(destination: DatePickerDestination) {
        self.showDatePicker = true
        self.shownPicker = destination
    }
    
}

extension ListSettingsScreen {

    enum DateOption {
        case any, exact, span
    }
    
    enum DatePickerDestination {
        case none, exact, start, end
    }
    
}

struct ListSettingsScreen_Previews: PreviewProvider {
    
    @State private static var options = FilterOptions.none
    
    static var previews: some View {
        ListSettingsScreen(isPresented: .constant(true), options: $options)
    }
}
