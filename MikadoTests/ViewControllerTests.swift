//
//  MikadoTests.swift
//  MikadoTests
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import XCTest
@testable import Mikado

class ViewControllerTests: XCTestCase {
    let whiteHex = Hex(string: "FFFFFF")!
    let blueHex: Hex = Hex(string: "00b9f1")!
    
    var database: MemoryDB!
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        database = MemoryDB()
        viewController = ViewController(database: database)
        let _ = viewController.view // invoke viewDidLoad()
    }
    
    func testCreatesDefaultColor() {
        XCTAssertEqual(viewController.hex, whiteHex)
        XCTAssertEqual(viewController.view.backgroundColor, UIColor(hex: whiteHex))
    }
    
    func testRestoreSavedColorOnLaunch() {
        database["background_color"] = blueHex.string
        viewController = ViewController(database: database)
        let _ = viewController.view // invoke viewDidLoad()

        XCTAssertEqual(viewController.hex, blueHex)
        XCTAssertEqual(viewController.view.backgroundColor, UIColor(hex: blueHex))
    }
    
    func testResetColor() {
        database["background_color"] = blueHex.string
        viewController = ViewController(database: database)
        let _ = viewController.view // invoke viewDidLoad()

        viewController.reset()
        XCTAssertNotEqual(viewController.hex, blueHex)
        XCTAssertEqual(viewController.view.backgroundColor, UIColor(hex: whiteHex))
    }
    
    func testRandomColor() {
        viewController.random(sender: UIButton())
        XCTAssertNotEqual(viewController.hex, whiteHex)
        XCTAssertNotEqual(viewController.view.backgroundColor, UIColor(hex: blueHex))
    }
    
    func testNilHexResetsToWhite() {
        viewController.hex = nil
        XCTAssertEqual(viewController.hex, whiteHex)
        XCTAssertEqual(viewController.view.backgroundColor, UIColor(hex: whiteHex))
    }
    
    func testPickerViewConfiguration() {
        let datasource = WholeByteHexPickerViewDataSource()
        let oldDatasource = viewController.pickerViewDataSource
        viewController.configurePickerViewDataSource(dataSource: datasource)
        
        XCTAssert(viewController.pickerViewDataSource !== oldDatasource)
        XCTAssert(viewController.colorPicker.delegate! === datasource)
        XCTAssert(viewController.colorPicker.dataSource! === datasource)
        XCTAssertNotNil(datasource.didSelectHex)
    }
    
    func testTogglePickerView() {
        let oldDatasource = viewController.pickerViewDataSource
        viewController.togglePickerStyle(animated: false)
        let newDatasource = self.viewController.pickerViewDataSource
        
        XCTAssert(oldDatasource !== newDatasource)
        XCTAssertNotEqual(String(describing: oldDatasource), String(describing: newDatasource))
    }
}