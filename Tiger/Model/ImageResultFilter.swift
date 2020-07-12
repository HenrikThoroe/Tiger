//
//  ImageResultFilter.swift
//  Tiger
//
//  Created by Henrik Thoroe on 11.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import Foundation

class ImageResultFilter: ObservableObject {
    
    @Published private(set) var results: [Result] = []
    
    private var groups: [[Result]] = []
    
    typealias Result = ImageProcessor.Result
    
}

// MARK: - API
extension ImageResultFilter {
    
    func feed(with result: Result) {
        addToGroup(result: result)
        mergeGroups()
    }
    
    func clear() {
        results = []
    }
    
}

// MARK: - Logic
private extension ImageResultFilter {
    
    func addToGroup(result: Result) {
        for (index, group) in groups.enumerated() {
            guard belongsToGroup(result: result, group: group) else {
                continue
            }
            
            groups[index] += [result]
            return
        }
        
        groups += [[result]]
    }
    
    func mergeGroups() {
        var res = [Result]()
        
        for group in groups {
            var mat: [[Double]] = [[Double]](repeating: [Double](repeating: 0, count: group.count), count: group.count)
            
            for (idx, item) in group.enumerated() {
                for (idx1, item1) in group.enumerated() {
                    mat[idx][idx1] = item.value.similarity(to: item1.value)
                }
            }
            
            let avg = mat.map { $0.average() }
            var max: Double = -1
            var maxResult: Result!
            
            for (index, item) in group.enumerated() {
                if avg[index] > max {
                    max = avg[index]
                    maxResult = item
                }
            }
            
            res += [maxResult]
        }
        
        DispatchQueue.main.async {
            self.results = res
        }
    }
    
    func belongsToGroup(result: Result, group: [Result]) -> Bool {
        let similarity = group.map { result.value.similarity(to: $0.value) }
        let avg = similarity.reduce(0, +) / Double(similarity.count)
        
        return avg > 0.8
    }
    
}
