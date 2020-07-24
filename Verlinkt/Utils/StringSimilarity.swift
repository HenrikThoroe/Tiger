//
//  StringSimilarity.swift
//  Tiger
//
//  Created by Henrik Thoroe on 12.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import Foundation

extension String {
    
    subscript(ix: Int) -> Character {
        let index = self.index(startIndex, offsetBy: ix)
        return self[index]
    }

    subscript(range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start ..< end])
    }
    
    func similarity(to other: String) -> Double {
        let sCount = count
        let oCount = other.count

        guard sCount != 0 else {
            return 0
        }

        guard oCount != 0 else {
            return 0
        }

        let line : [Int]  = Array(repeating: 0, count: oCount + 1)
        var mat : [[Int]] = Array(repeating: line, count: sCount + 1)

        for i in 0...sCount {
            mat[i][0] = i
        }

        for j in 0...oCount {
            mat[0][j] = j
        }

        for j in 1...oCount {
            for i in 1...sCount {
                if self[i - 1] == other[j - 1] {
                    mat[i][j] = mat[i - 1][j - 1]       // no operation
                }
                else {
                    let del = mat[i - 1][j] + 1         // deletion
                    let ins = mat[i][j - 1] + 1         // insertion
                    let sub = mat[i - 1][j - 1] + 1     // substitution
                    mat[i][j] = min(min(del, ins), sub)
                }
            }
        }

        return 1 - Double(mat[sCount][oCount]) / Double(max(sCount, oCount))
    }
    
}
