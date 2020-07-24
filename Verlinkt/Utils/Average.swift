//
//  Average.swift
//  Tiger
//
//  Created by Henrik Thoroe on 12.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import Foundation

extension Array where Element == Double {
    
    func average() -> Double {
        let sum = reduce(0, +)
        return sum / Double(count)
    }
    
}
