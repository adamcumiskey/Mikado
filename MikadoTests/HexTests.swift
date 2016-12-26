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
    
    func testZeroHexStringInitialization() {
        let string = "00"
        let hex = Hex(string: string)
        XCTAssert(hex.string == string)
        XCTAssert(hex.bytes == [0])
    }
    
    func testFFHexStringInitialization() {
        let string = "FF"
        let hex = Hex(string: string)
        XCTAssert(hex.string == string)
        XCTAssert(hex.bytes == [255])
    }
    
    func testColorHexStringInitialization() {
        let string = "00B9F1"
        let hex = Hex(string: string)
        XCTAssert(hex.string == string)
        XCTAssert(hex.bytes == [0, 185, 241])
    }
    
    func testZeroHexByteInitialization() {
        let byte = UInt8(0)
        let hex = Hex(byte: byte)
        XCTAssert(hex.bytes == [0])
        XCTAssert(hex.string == "00", "Actual value: \(hex.string)")
    }
    
    func test255HexByteInitialization() {
        let byte = UInt8(255)
        let hex = Hex(byte: byte)
        XCTAssert(hex.bytes == [255])
        XCTAssert(hex.string == "ff", "Actual value: \(hex.string)")
    }
}
