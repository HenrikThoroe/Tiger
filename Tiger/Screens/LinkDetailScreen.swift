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
    
    init(for link: ScannedLink) {
        self.link = link
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                VStack(spacing: 30) {
                    self.image(in: proxy)
                    self.headlines()
                }

                Spacer()

                DateDisplay(date: self.link.scanned)

                Spacer()

                self.toolbar()
            }
            .padding()
        }
        .onDisappear(perform: handleDisappear)
    }
    
    func toolbar() -> some View {
        HStack(spacing: 30) {
            Spacer()
            
            Button(action: self.requestShare) {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
            }.buttonStyle(IconButtonStyle(size: .l))
            
            Button(action: self.requestDelete) {
                Image(systemName: "trash")
                    .resizable()
            }
            .buttonStyle(IconButtonStyle(behaviour: .destructive, size: .l))
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
//            .modifier(CircleImage())
//            .modifier(Stretch(direction: .horizontal))
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
        LinkDetailScreen(for: ScannedLink.example)
    }
}

