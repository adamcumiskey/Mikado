//
//  HexTests.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import XCTest
@testable import Mikado

class HexTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMinHexStringInitialization() {
        let string = "00"
        let hex = Hex(string: string)
        XCTAssert(hex.string == string)
        XCTAssert(hex.bytes == [0])
    }
    
    func testMaxHexStringInitialization() {
        let string = "FF"
        let hex = Hex(string: string)
        XCTAssert(hex.string == string)
        XCTAssert(hex.bytes == [255])
    }
    
    func testMultiHexStringInitialization() {
        let string = "00b9f1"
        let hex = Hex(string: string)
        XCTAssert(hex.string == string)
        XCTAssert(hex.bytes == [0, 185, 241])
    }
    
    func testMinSingleByteInitialization() {
        let bytes = [UInt8(0)]
        let hex = Hex(bytes: bytes)
        XCTAssert(hex.bytes == bytes)
        XCTAssert(hex.string == "00", "Actual value: \(hex.string)")
    }
    
    func testMaxSingleByteInitialization() {
        let bytes = [UInt8(255)]
        let hex = Hex(bytes: bytes)
        XCTAssert(hex.bytes == bytes)
        XCTAssert(hex.string == "ff", "Actual value: \(hex.string)")
    }
    
    func testMultiByteInitialization() {
        let bytes = [0, 185, 241].map { UInt8($0) }
        let hex = Hex(bytes: bytes)
        XCTAssert(hex.bytes == bytes)
        XCTAssert(hex.string == "00b9f1")
    }
    
    func testCanHalve() {
        let a = UInt8(255)
        let (a1, a2) = a.halve()
        XCTAssert(a1 == 0xF)
        XCTAssert(a2 == 0xF)
        
        let b = UInt8(0)
        let (b1, b2) = b.halve()
        XCTAssert(b1 == 0x00)
        XCTAssert(b2 == 0x00)
        
        let c = UInt8(5)
        let (c1, c2) = c.halve()
        XCTAssert(c1 == 0x00)
        XCTAssert(c2 == 0x05)
        
        let d = UInt8(42)
        let (d1, d2) = d.halve()
        XCTAssert(d1 == 0x02)
        XCTAssert(d2 == 0x0A)
    }
}
