//
//  Hex.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import UIKit


struct Hex: Equatable {
    var string: String
    var bytes: [UInt8]
    
    init?(string: String) {
        guard Hex.validate(string: string) else { return nil }
        self.string = string
        
        let chars = Array(string.characters)
        self.bytes = stride(from: 0, to: chars.count, by: 2).map {
            return UInt8(String(chars[$0..<min($0+2,chars.count)]), radix: 16)!
        }
    }
    
    init?(bytes: [UInt8]) {
        guard Hex.validate(bytes: bytes) else { return nil }
        self.bytes = bytes
        self.string = bytes.reduce("") { $0 + String($1, radix: 16).padding(toLength: 2, withPad: "0", startingAt: 0) }
    }
}

func ==(lhs: Hex, rhs: Hex) -> Bool {
    return lhs.string.caseInsensitiveCompare(rhs.string) == .orderedSame
}

extension Hex {
    // Hex string must have even number of terms and contain only valid hexidecimal characters
    static func validate(string: String) -> Bool {
        guard string.characters.count > 0 else { return false }
        guard string.characters.count % 2 == 0 else { return false }
        let hexCharacterSet = CharacterSet(charactersIn: "0123456789abcdef")
        return string.lowercased().rangeOfCharacter(from: hexCharacterSet.inverted) == nil
    }
    
    // Must have at least one byte
    static func validate(bytes: [UInt8]) -> Bool {
        return bytes.count > 0
    }
}


extension UInt8 {
    // Split a UInt8 into two equal 4 bit values
    func halve() -> (UInt8, UInt8) {
        return ((self & 0xF0) >> 4, self & 0x0F)
    }
}


extension UIColor {
    convenience init(hex: Hex) {
        var color: UInt32 = 0
        
        let scanner = Scanner(string: hex.string)
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
