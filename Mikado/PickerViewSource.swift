//
//  PickerViewSource.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/29/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import UIKit


enum HexPickerViewDataSourceError: Error {
    case invalidDelegate
    case missingRow
}

protocol HexPickerViewDataSource: UIPickerViewDataSource, UIPickerViewDelegate  {
    var didSelectHex: ((Hex) -> Void)? { get set }
    func getHex(forColorPicker colorPicker: UIPickerView) throws -> Hex
    func setHex(hex: Hex, forColorPicker colorPicker: UIPickerView)
}

extension HexPickerViewDataSource {
    func getHex(forColorPicker colorPicker: UIPickerView) throws -> Hex {
        guard let delegate = colorPicker.delegate else { throw HexPickerViewDataSourceError.invalidDelegate }
        var rows = [String]()
        for i in 0..<colorPicker.numberOfComponents {
            let selectedRow = colorPicker.selectedRow(inComponent: i)
            guard let rowText = delegate.pickerView!(colorPicker, titleForRow: selectedRow, forComponent: i) else {
                throw HexPickerViewDataSourceError.missingRow
            }
            rows.append(rowText)
        }
        return Hex(string: rows.reduce("", +))
    }
}


class WholeByteHexPickerViewDataSource: NSObject, HexPickerViewDataSource {
    var didSelectHex: ((Hex) -> Void)?
    
    func setHex(hex: Hex, forColorPicker colorPicker: UIPickerView) {
        for i in 0..<hex.bytes.count {
            let byte = hex.bytes[i]
            colorPicker.selectRow(Int(byte), inComponent: i, animated: true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 256
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Hex(bytes: [UInt8(row)]).string.uppercased()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let didSelectHex = didSelectHex else { return }
        do { try didSelectHex(self.getHex(forColorPicker: pickerView)) }
        catch {
            fatalError()
        }
    }
}


class HalfByteHexPickerViewDataSource: NSObject, HexPickerViewDataSource {
    var didSelectHex: ((Hex) -> Void)?
    
    func setHex(hex: Hex, forColorPicker colorPicker: UIPickerView) {
        for i in 0..<(hex.bytes.count-1) {
            let byte = hex.bytes[i]
            let row1 = byte & 0xF0 >> 4
            let row2 = byte & 0x0F
            colorPicker.selectRow(Int(row1), inComponent: i, animated: true)
            colorPicker.selectRow(Int(row2), inComponent: i+1, animated: true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component % 2 == 0 {
            return 6 // a-f
        } else {
            return 10 // 0-9
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Hex(bytes: [UInt8(row)]).string.uppercased()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let didSelectHex = didSelectHex else { return }
        do { try didSelectHex(self.getHex(forColorPicker: pickerView)) }
        catch {
            fatalError()
        }
    }
}
