//
//  SaveScreen.swift
//  Tiger
//
//  Created by Henrik Thoroe on 28.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct SaveScreen: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var scannerResult: ImageProcessor.Result
    
    @Binding var isPresented: Bool
    
    @State private var editMode: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: toggleEdit) {
                    Text(editMode ? "Cancel Edit" : "Edit")
                }.buttonStyle(TextButtonStyle(highlight: true))
                
                Spacer()
                
                Button(action: save) {
                    Text("Save")
                }.buttonStyle(TextButtonStyle(highlight: true))
            }
            
            Spacer()
            
            ZStack {
                Text(scannerResult.value)
                    .font(.title)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .opacity(editMode ? 0 : 1)
                    .onTapGesture(perform: toggleEdit)
                
                TextField("Edit your link...", text: $scannerResult.value, onCommit: toggleEdit)
                    .font(.system(size: 24, weight: .heavy, design: .default))
                    .textContentType(.URL)
                    .keyboardType(.URL)
                    .opacity(editMode ? 1 : 0)
            }
            
            Spacer()
            
            VStack(spacing: 20) {
                Button(action: saveAndOpen) {
                    Text("Save and Open in Safari")
                        .foregroundColor(.white)
                        .modifier(Stretch(direction: .horizontal))
                }.buttonStyle(ButtonComponent.Style(background: .defaultHighlight))
                
                Button(action: save) {
                    Text("Save and Scan More")
                        .foregroundColor(.white)
                        .modifier(Stretch(direction: .horizontal))
                }.buttonStyle(ButtonComponent.Style(background: .defaultHighlight))
            }
            
            Spacer()
            
            Button(action: dismissSheet) {
                Text("Discard")
                    .foregroundColor(.white)
                    .modifier(Stretch(direction: .horizontal))
            }.buttonStyle(ButtonComponent.Style(background: .destructiveHighlight))
            
            Spacer()
            
            Text("Are there any mistakes? You can edit the link!")
                .font(.footnote)
                .multilineTextAlignment(.center)
        }.padding()
    }
}

extension SaveScreen {
    
    func saveAndOpen() {
        let link = createLink()
        dismissSheet()
        link.open()
    }
    
    func save() {
        _ = createLink()
        dismissSheet()
    }
    
    func createLink() -> ScannedLink {
        return ScannedLink(context: managedObjectContext, href: scannerResult.value)
    }
    
    func dismissSheet() {
        isPresented = false
    }
    
    func toggleEdit() {
        if editMode {
            dismissKeyboard()
        }
        
        editMode.toggle()
    }
    
}

struct SaveScreen_Previews: PreviewProvider {
    static var previews: some View {
        SaveScreen(scannerResult: .constant(.init(value: "https://example.com/path/which/is/very/very/very/long/for/demonstration/purpose", confidence: 1, location: .zero)), isPresented: .constant(true))
    }
}
