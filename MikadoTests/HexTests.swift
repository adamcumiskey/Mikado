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
}
