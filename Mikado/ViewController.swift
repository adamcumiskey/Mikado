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
    
    var userDefaultsDB: UserDefaultsDB
    var pickerViewDataSource: HexPickerViewDataSource
    
    init() {
        // Create the database
        userDefaultsDB = UserDefaultsDB()
        // Configure to use the global store
        userDefaultsDB.userDefaults = MikadoApp.userDefaults
        
        pickerViewDataSource = HalfByteHexPickerViewDataSource()
        
        super.init(nibName: "ViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "HEXES"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))
        
        // Set the datasource for the color picker
        colorPicker.dataSource = pickerViewDataSource
        colorPicker.delegate = pickerViewDataSource
        
        // Callback for new hex colors from the picker view delegate
        pickerViewDataSource.didSelectHex = { [weak self] hex in
            self?.hex = hex
        }
        
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
            
            pickerViewDataSource.setHex(hex: newHex, forColorPicker: colorPicker)
        }
    }
}
