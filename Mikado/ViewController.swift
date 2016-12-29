//
//  ViewController.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    let backgroundColorKey = "background_color"
    let defaultHex = Hex(string: "FFFFFF")!
    
    @IBOutlet weak var colorPicker: UIPickerView!
    
    /// Persistent storage for the selected color
    var database: Database

    /// The datasource for the colorPicker
    var pickerViewDataSource: HexPickerViewDataSource
    
    init(database: Database) {
        self.database = database
        
        // Create a default dataSource
        pickerViewDataSource = WholeByteHexPickerViewDataSource()
        
        super.init(nibName: "ViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the navigation item
        title = "HEXES"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Style", style: .plain, target: self, action: #selector(togglePickerStyle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))

        // Configure the datasource
        configurePickerViewDataSource(dataSource: pickerViewDataSource)
        
        // Load the color from the database
        // or set it to the default
        if let savedHex = self.hex {
            self.hex = savedHex
        } else {
            self.hex = defaultHex
        }
    }
    
    var hex: Hex? {
        // Get the current Hex value from the database
        get {
            guard let hexString = database[backgroundColorKey] as? String else { return nil }
            return Hex(string: hexString)
        }
        // Save the new hex value to the database and update the UI
        set {
            if let newHex = newValue {
                database[backgroundColorKey] = newHex.string
                
                UIView.animate(withDuration: 0.4) {
                    self.view.backgroundColor = UIColor(hex: newHex)
                }
                pickerViewDataSource.setHex(hex: newHex, forColorPicker: colorPicker, animated: true)
            } else {
                self.hex = defaultHex
            }
        }
    }
}


// MARK: - Button Actions

extension ViewController {
    /// Set the color back to the default
    func reset() {
        self.hex = defaultHex
    }
    
    /// Randomize the color
    @IBAction func random(sender: UIButton) {
        self.hex = Hex(bytes: [arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255)].map { UInt8($0) })
    }
}


// MARK: - PickerView 

extension ViewController {
    /// Hook up a dataSource to the pickerView
    func configurePickerViewDataSource(dataSource: HexPickerViewDataSource) {
        // Set the datasource and delegate for the colorPicker
        colorPicker.dataSource = dataSource
        colorPicker.delegate = dataSource
        
        // Register callback for when the hex value changes from user input
        dataSource.didSelectHex = { [weak self] hex in
            self?.hex = hex
        }
        
        // Assign to ivar to hold a strong reference
        pickerViewDataSource = dataSource
    }
    
    /// Toggle between the WholeByte and HalfByte picker view styles
    func togglePickerStyle() {
        let newDataSource: HexPickerViewDataSource
        if let _ = pickerViewDataSource as? HalfByteHexPickerViewDataSource {
            newDataSource = WholeByteHexPickerViewDataSource()
        } else {
            newDataSource = HalfByteHexPickerViewDataSource()
        }
        
        UIView.animate(
            withDuration: 0.15,
            animations: {
                self.colorPicker.alpha = 0.0
            },
            completion: { finished in
                if finished == true {
                    self.configurePickerViewDataSource(dataSource: newDataSource)
                    self.colorPicker.reloadAllComponents()
                    
                    if let hex = self.hex {
                        self.pickerViewDataSource.setHex(hex: hex, forColorPicker: self.colorPicker, animated: false)
                    }
                    UIView.animate(withDuration: 0.15) {
                        self.colorPicker.alpha = 1.0
                    }
                }
            }
        )
    }
}
