//
//  ViewController.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import UIKit

let backgroundColorKey = "background_color"
let defaultColorHex = "000000"

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var colorPicker: UIPickerView!
    
    var userDefaultsDB: UserDefaultsDB
    var pickerViewDataSource: HexPickerViewDataSource {
        didSet {
            // Register callback for when the hex value changes from user input
            pickerViewDataSource.didSelectHex = { [weak self] hex in
                self?.hex = hex
            }
        }
    }
    
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Style", style: .plain, target: self, action: #selector(togglePickerStyle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))
        
        // Set the datasource for the color picker
        colorPicker.dataSource = pickerViewDataSource
        colorPicker.delegate = pickerViewDataSource
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
                    self.pickerViewDataSource = newDataSource
                    self.colorPicker.dataSource = newDataSource
                    self.colorPicker.delegate = newDataSource
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
            updateAppStyleIfNeededForHex(hex: newHex)
        }
    }
}

extension ViewController {
    func updateAppStyleIfNeededForHex(hex: Hex) {
        let average = hex.bytes.map { Int($0) }.average
        print(average)
        let isDark = average < 100
        let textColor: UIColor = isDark ? .white : .black
        
        UIView.animate(withDuration: 0.3) {
            self.colorPicker.tintColor = textColor
            self.button.setTitleColor(textColor, for: .normal)
            self.navigationController?.navigationBar.tintColor = textColor
            self.navigationController?.navigationBar.barStyle = isDark ? .blackTranslucent : .default
        }
    }
}
