//
//  LinkDetailView.swift
//  Tiger
//
//  Created by Henrik Thoroe on 27.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct LinkDetailScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let link: ScannedLink
    
    @State private var showDeleteWarning: Bool = false
    
    @State private var shouldDelete: Bool = false
    
    @State private var showShareSheet: Bool = false
    
    @State private var editMode = EditMode.inactive

    private var hrefBinding: Binding<String> {
        Binding(get: { self.link.href }) {
            self.link.href = $0
            try? self.managedObjectContext.save()
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            if self.editMode == .active {
                NameEditView(name: self.hrefBinding, keyboard: .URL)
            } else {
                VStack {
                    VStack(spacing: 30) {
                        self.image(in: proxy)
                        self.headlines()
                    }

                    Spacer()
                    
                    if self.editMode == .active {
                        Text("Editing")
                    }

                    DateDisplay(date: self.link.scanned)

                    Spacer()

                    self.toolbar()
                }
                .padding()
            }
        }
        .navigationBarTitle("Details", displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
        .environment(\.editMode, $editMode)
        .onDisappear(perform: handleDisappear)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [self.link.url as Any])
        }
    }
    
    func toolbar() -> some View {
        HStack(spacing: 30) {
            Spacer()
            
            Button(action: self.requestShare) {
                HStack(spacing: 10) {
                    Text("Share")
                    Image(systemName: "square.and.arrow.up")
                }
            }.buttonStyle(FlatButtonStyle())
            
            Button(action: self.requestDelete) {
                HStack(spacing: 10) {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            }
            .buttonStyle(FlatButtonStyle(type: .destructive))
            .alert(isPresented: self.$showDeleteWarning, content: self.deleteAlert)
        }
    }
    
    func deleteAlert() -> Alert {
        let dismiss = {
            self.showDeleteWarning = false
        }
        
        return Alert(
            title: Text("Delete \(link.name)?"),
            message: Text("This operation is destructive. You cannot resore this link afterwards."),
            primaryButton: .destructive(Text("Delete"), action: performDelete),
            secondaryButton: .cancel(Text("Cancel"), action: dismiss)
        )
    }
    
    func image(in proxy: GeometryProxy) -> some View {
        link.thumbnail
            .resizable()
            .scaledToFit()
            .frame(width: proxy.size.width * 0.5, height: proxy.size.width * 0.5)
    }
    
    func headlines() -> some View {
        Button(action: link.open) {
            VStack(spacing: 20) {
                Text(link.name)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)
                Text(link.href)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
        }.buttonStyle(TextButtonStyle())
    }
}

extension LinkDetailScreen {
    
    func requestShare() {
        showShareSheet = true
    }
    
    func requestDelete() {
        showDeleteWarning = true
    }
    
    func performDelete() {
        presentationMode.wrappedValue.dismiss()
        shouldDelete = true
    }
    
    func handleDisappear() {
        if shouldDelete {
            managedObjectContext.delete(link)
            try? managedObjectContext.save()
        }
    }
    
}

struct LinkDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LinkDetailScreen(link: ScannedLink.example)
        }
    }
}

