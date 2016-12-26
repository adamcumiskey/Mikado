//
//  Hex.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import Foundation


struct Hex {
    var string: String
    var bytes: [UInt8]
    
    init(string: String) {
        self.string = string
        
        let chars = Array(string.characters)
        self.bytes = stride(from: 0, to: chars.count, by: 2).map {
            return UInt8(String(chars[$0..<min($0+2, chars.count)]), radix: 16) ?? 0
        }
    }
    
    init(byte: UInt8) {
        self.bytes = [byte]
        self.string = String(byte, radix: 16).padding(toLength: 2, withPad: "0", startingAt: 0)
    }
}
