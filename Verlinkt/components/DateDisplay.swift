//
//  DateDisplay.swift
//  Tiger
//
//  Created by Henrik Thoroe on 27.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import SwiftUI

struct DateDisplay: View {
    
    let date: Date
    
    var showTime: Bool = true
    
    var day: String {
        let formatter = NumberFormatter()
        let day = Calendar.current.dateComponents([.day], from: date).day ?? -1
        
        formatter.usesGroupingSeparator = false
        
        return formatter.string(from: NSNumber(integerLiteral: day)) ?? ""
    }
    
    var weekday: String {
        let weekday = Calendar.current.dateComponents([.weekday], from: date).weekday ?? 0
        return Calendar.current.weekdaySymbols[weekday - 1]
    }
    
    var month: String {
        let month = Calendar.current.dateComponents([.month], from: date).month ?? 0
        return Calendar.current.monthSymbols[month - 1]
    }
    
    var year: String {
        let formatter = NumberFormatter()
        let year = Calendar.current.dateComponents([.year], from: date).year ?? -1
        
        formatter.usesGroupingSeparator = false
        
        return formatter.string(from: NSNumber(integerLiteral: year)) ?? ""
    }
    
    var time: String {
        let formatter = DateFormatter()
        
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        return formatter.string(from: date)
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Text(day)
                .font(.system(size: 48))
                .fontWeight(.black)
                .frame(width: nil)
            HStack(spacing: 20) {
                stack(top: weekday, bottom: month)
                stack(top: showTime ? time : " ", bottom: year)
            }
        }
    }
    
    func stack(top: String, bottom: String) -> some View {
        VStack(alignment: .leading) {
            Text(top)
                .font(.system(size: 24))
                .multilineTextAlignment(.leading)
            Text(bottom)
                .font(.system(size: 24))
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
        }
    }
}

struct DateDisplay_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            DateDisplay(date: Date())
            
            DateDisplay(date: Date(), showTime: false)
        }
    }
}
