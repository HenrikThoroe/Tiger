//
//  URL.swift
//  Tiger
//
//  Created by Henrik Thoroe on 17.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import Foundation

extension URL: Identifiable {
    
    public var id: String {
        absoluteString.lowercased()
    }
    
}
