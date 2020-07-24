//
//  LinkEditView.swift
//  Tiger
//
//  Created by Henrik Thoroe on 21.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct NameEditView: View {
    
    @Binding var link: ScannedLink
    
    var body: some View {
        TextField("Change the link as you want", text: $link.href)
    }
}

struct LinkEditView_Previews: PreviewProvider {
    static var previews: some View {
        NameEditView(link: .constant(.example))
    }
}
