//
//  ViewController.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import UIKit

let backgroundColorKey = "background_color"
let defaultColorHex = "FFFFFF"

class ViewController: UIViewController {
    @IBOutlet weak var colorPicker: UIPickerView!
    
    /// The datasource for the colorPicker
    var pickerViewDataSource: HexPickerViewDataSource
    
    /// Persistent storage for the selected color
    var userDefaultsDB: UserDefaultsDB
    
    var hex: Hex? {
        get {
            guard let hexString = userDefaultsDB[backgroundColorKey] as? String else { return nil }
            return Hex(string: hexString)
        }
        set {
            guard let newHex = newValue else { return }
            
            // Save the color to the database
            userDefaultsDB[backgroundColorKey] = newHex.string
            
            // Update the UI
            UIView.animate(withDuration: 0.4) {
                self.view.backgroundColor = UIColor(hexString: newHex.string)
            }
            pickerViewDataSource.setHex(hex: newHex, forColorPicker: colorPicker, animated: true)
        }
    }
    
    init() {
        // Create the database
        userDefaultsDB = UserDefaultsDB()
        // Configure to use the global store
        userDefaultsDB.userDefaults = MikadoApp.userDefaults
        
        // Create a default dataSource
        pickerViewDataSource = WholeByteHexPickerViewDataSource()
        
        super.init(nibName: "ViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "HEXES"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Style", style: .plain, target: self, action: #selector(togglePickerStyle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))

        // Configure the datasource
        configurePickerViewDataSource(dataSource: pickerViewDataSource)
        
        // Load the color from the database
        // or set it to the default
        if let hexString = self.hex {
            self.hex = hexString
        } else {
            reset()
        }
    }
    
    /// Set the color back to the default
    func reset() {
        self.hex = Hex(string: defaultColorHex)
    }
    
    /// Randomize the color
    @IBAction func random(sender: UIButton) {
        self.hex = Hex(bytes: [arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255)].map { UInt8($0) })
    }
    
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
