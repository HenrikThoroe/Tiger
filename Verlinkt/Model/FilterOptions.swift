//
//  FilterOptions.swift
//  Tiger
//
//  Created by Henrik Thoroe on 22.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import Foundation

struct FilterOptions {
    var domainQuery: String
    var hrefQuery: String
    var created: Creation
}

extension FilterOptions {
    
    enum Creation: Hashable {
        case exact(Date)
        case span(Date, Date)
        case any
    }
    
}

extension FilterOptions: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(domainQuery)
        hasher.combine(hrefQuery)
        hasher.combine(created)
    }
    
}

// MARK: - Defaults
extension FilterOptions {
    
    static var none: Self {
        FilterOptions(domainQuery: "", hrefQuery: "", created: .any)
    }
    
    static var today: Self {
        FilterOptions(domainQuery: "", hrefQuery: "", created: .exact(Date()))
    }
    
    static var thisWeek: Self {
        FilterOptions(domainQuery: "", hrefQuery: "", created: .span(Date().find(last: .monday), Date()))
    }
    
    static var lastWeek: Self {
        FilterOptions(domainQuery: "", hrefQuery: "", created: .span(Date(timeIntervalSinceNow: -(60 * 60 * 24 * 7)), Date()))
    }
    
    static var thisMonth: Self {
        FilterOptions(domainQuery: "", hrefQuery: "", created: .span(Date().startOfCurrentMonth(), Date()))
    }
    
    static var lastMonth: Self {
        FilterOptions(domainQuery: "", hrefQuery: "", created: .span(Date(timeIntervalSinceNow: -(60 * 60 * 24 * 30)), Date()))
    }
    
}
