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
    case invalidHexString
}

protocol HexPickerViewDataSource: UIPickerViewDataSource, UIPickerViewDelegate  {
    var didSelectHex: ((Hex) -> Void)? { get set }
    func getHex(forColorPicker colorPicker: UIPickerView) throws -> Hex
    func setHex(hex: Hex, forColorPicker colorPicker: UIPickerView, animated: Bool)
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
        guard let hex = Hex(string: rows.reduce("", +)) else { throw HexPickerViewDataSourceError.invalidHexString }
        return hex
    }
}


class WholeByteHexPickerViewDataSource: NSObject, HexPickerViewDataSource {
    var didSelectHex: ((Hex) -> Void)?
    
    func setHex(hex: Hex, forColorPicker colorPicker: UIPickerView, animated: Bool) {
        for i in 0..<hex.bytes.count {
            let byte = hex.bytes[i]
            colorPicker.selectRow(Int(byte), inComponent: i, animated: animated)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 256
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Hex(bytes: [UInt8(row)])?.string.uppercased()
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
    
    func setHex(hex: Hex, forColorPicker colorPicker: UIPickerView, animated: Bool) {
        for i in 0..<hex.bytes.count {
            let byte = hex.bytes[i]
            let (row1, row2) = byte.halve()
            let n = i * 2
            colorPicker.selectRow(Int(row1), inComponent: n, animated: animated)
            colorPicker.selectRow(Int(row2), inComponent: n+1, animated: animated)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 16
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let char = Hex(bytes: [UInt8(row)])?.string.characters.first else { return nil }
        return "\(char)".uppercased()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let didSelectHex = didSelectHex else { return }
        do { try didSelectHex(self.getHex(forColorPicker: pickerView)) }
        catch {
            fatalError()
        }
    }
}
