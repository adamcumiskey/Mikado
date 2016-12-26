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
    
    init() {
        // Create the database
        userDefaultsDB = UserDefaultsDB(userDefaults: MikadoApp.userDefaults)
        
        super.init(nibName: "ViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Mikado Colors"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Random", style: .plain, target: self, action: #selector(random))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))
        
        // Load the color from the database
        // or set it to the default
        if let hexString = self.hexString {
            self.hexString = hexString
        } else {
            self.hexString = defaultColorHex
        }
    }
    
    /// Set the color back to the default
    func reset() {
        self.hexString = defaultColorHex
    }
    
    /// Randomize the color
    func random() {
        self.hexString = Hex(bytes: [arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255)].map { UInt8($0) }).string
    }

    ///
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
        return Hex(bytes: [UInt8(row)]).string.uppercased()
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
