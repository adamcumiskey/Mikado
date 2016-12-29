//
//  PickerViewSourceTests.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/29/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import XCTest
@testable import Mikado


class HalfBytePickerViewSourceTests: XCTestCase {
    let blueHex: Hex = Hex(string: "00b9f1")!
    
    var pickerView: UIPickerView!
    var ds: HalfByteHexPickerViewDataSource!
    
    override func setUp() {
        super.setUp()
        ds = HalfByteHexPickerViewDataSource()
        pickerView = UIPickerView()
        pickerView.delegate = ds
        pickerView.dataSource = ds
    }
    
    func testHalfByteRowsAndColumns() {
        XCTAssert(pickerView.numberOfComponents == 6)
        XCTAssert(pickerView.numberOfRows(inComponent: 0) == 16)
    }
    
    func testHalfByteSetAndGet() {
        ds.setHex(hex: blueHex, forColorPicker: pickerView, animated: false)
        let hex = try! ds.getHex(forColorPicker: pickerView)
        XCTAssertEqual(hex, blueHex)
    }
    
    func testHalfByteCallback() {
        let expect = expectation(description: "did select hex")
        ds.didSelectHex = { [weak self] hex in
            XCTAssertEqual(hex, self!.blueHex)
            expect.fulfill()
        }
        ds.setHex(hex: blueHex, forColorPicker: pickerView, animated: false)
        ds.pickerView(pickerView, didSelectRow: 0, inComponent: 0) // should still match blueHex
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}

class WholeBytePickerViewSourceTests: XCTestCase {
    let blueHex: Hex = Hex(string: "00b9f1")!
    
    var pickerView: UIPickerView!
    var ds: WholeByteHexPickerViewDataSource!
    
    override func setUp() {
        super.setUp()
        ds = WholeByteHexPickerViewDataSource()
        pickerView = UIPickerView()
        pickerView.delegate = ds
        pickerView.dataSource = ds
    }
    
    func testWholeByteRowsAndColumns() {
        let ds = WholeByteHexPickerViewDataSource()
        pickerView.delegate = ds
        pickerView.dataSource = ds
        XCTAssert(pickerView.numberOfComponents == 3)
        XCTAssert(pickerView.numberOfRows(inComponent: 0) == 256)
    }
    
    func testWholeByteSetAndGet() {
        let ds = WholeByteHexPickerViewDataSource()
        pickerView.delegate = ds
        pickerView.dataSource = ds
        ds.setHex(hex: blueHex, forColorPicker: pickerView, animated: false)
        let hex = try! ds.getHex(forColorPicker: pickerView)
        XCTAssertEqual(hex, blueHex)
    }
    
    func testWholeByteCallback() {
        let expect = expectation(description: "did select hex")
        ds.didSelectHex = { [weak self] hex in
            XCTAssertEqual(hex, self!.blueHex)
            expect.fulfill()
        }
        ds.setHex(hex: blueHex, forColorPicker: pickerView, animated: false)
        ds.pickerView(pickerView, didSelectRow: 0, inComponent: 0) // should still match blueHex
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
