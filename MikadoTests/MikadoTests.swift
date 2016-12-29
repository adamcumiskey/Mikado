//
//  MikadoTests.swift
//  MikadoTests
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import XCTest
@testable import Mikado

class MikadoTests: XCTestCase {
    var database: MemoryDB!
    var hex: Hex = Hex(string: "00b9f1")!
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        database = MemoryDB()
        database["background_color"] = hex.string
        viewController = ViewController(database: database)
        let _ = viewController.view // invoke viewDidLoad()
    }
    
    func testRestoreSavedColorOnLaunch() {
        XCTAssertEqual(viewController.hex, hex)
        XCTAssertEqual(viewController.view.backgroundColor, UIColor(hex: hex))
    }
    
    func testResetColor() {
        viewController.reset()
        XCTAssertNotEqual(viewController.hex, hex)
        XCTAssertEqual(viewController.view.backgroundColor, UIColor(hex: Hex(string: "FFFFFF")!))
    }
    
    func testRandomColor() {
        viewController.random(sender: UIButton())
        XCTAssertNotEqual(viewController.hex, hex)
        XCTAssertNotEqual(viewController.view.backgroundColor, UIColor(hex: hex))
    }
    
}
