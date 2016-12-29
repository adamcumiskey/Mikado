//
//  Array.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/29/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import Foundation


extension Collection where Iterator.Element == Int, Index == Int {
    var average: Double {
        return isEmpty ? 0 : Double(reduce(0, +)) / Double(endIndex-startIndex)
    }
}
