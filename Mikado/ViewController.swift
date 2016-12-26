//
//  ViewController.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import UIKit

let backgroundColorKey = "background_color"
let defaultColorHex = "00B9F1"

class ViewController: UIViewController {
    @IBOutlet weak var colorPicker: UIPickerView!
    
    
    var userDefaultsDB: UserDefaultsDB!
    
    init() {
        super.init(nibName: "ViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Mikado Colors"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))
        
        
        // Create the database
        userDefaultsDB = UserDefaultsDB(userDefaults: MikadoApp.userDefaults)
        
        // Load the color from the database
        if let hexString = self.hexString {
            self.hexString = hexString
        } else {
            // Default to white if a color isn't set
            self.hexString = defaultColorHex
        }
    }
    
    func reset() {
        self.hexString = defaultColorHex
    }

    var hexString: String? {
        get {
            return userDefaultsDB[backgroundColorKey] as? String
        }
        set {
            guard let newHexString = newValue else { return }
            
            // Save the color to the database
            userDefaultsDB[backgroundColorKey] = newHexString
            
            // Update the UI
            UIView.animate(withDuration: 0.23) {
                self.view.backgroundColor = UIColor(hexString: newHexString)
            }
            
            let hex = Hex(string: newHexString)
            for i in 0..<hex.bytes.count {
                colorPicker.selectRow(Int(hex.bytes[i]), inComponent: i, animated: true)
            }
        }
    }
}


extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Hex(byte: UInt8(row)).string.uppercased()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.hexString = hexStringFromPickerView(pickerView: pickerView)
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 256
    }
}

extension ViewController {
    func hexStringFromPickerView(pickerView: UIPickerView) -> String {
        let r = pickerView.delegate!.pickerView!(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)!
        let g = pickerView.delegate!.pickerView!(pickerView, titleForRow: pickerView.selectedRow(inComponent: 1), forComponent: 1)!
        let b = pickerView.delegate!.pickerView!(pickerView, titleForRow: pickerView.selectedRow(inComponent: 2), forComponent: 2)!
        return r + g + b
    }
}
