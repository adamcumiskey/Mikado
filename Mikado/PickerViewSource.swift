//
//  PickerViewSource.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/29/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import UIKit

protocol HexPickerViewSource: UIPickerViewDataSource  {
    var didSelectHexString: ((String) -> Void)? { get set }
    func hexStringFromPickerView(pickerView: UIPickerView) -> String
}

extension HexPickerViewSource where Self: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Hex(bytes: [UInt8(row)]).string.uppercased()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let didSelectHexString = didSelectHexString else { return }
        didSelectHexString(self.hexStringFromPickerView(pickerView: pickerView))
    }
}


class WholeByteHexPickerViewSource: NSObject, HexPickerViewSource {
    var didSelectHexString: ((String) -> Void)?

    func hexStringFromPickerView(pickerView: UIPickerView) -> String {
        let r = pickerView.delegate!.pickerView!(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)!
        let g = pickerView.delegate!.pickerView!(pickerView, titleForRow: pickerView.selectedRow(inComponent: 1), forComponent: 1)!
        let b = pickerView.delegate!.pickerView!(pickerView, titleForRow: pickerView.selectedRow(inComponent: 2), forComponent: 2)!
        return r + g + b
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 256
    }
}


class HalfByteHexPickerViewSource: NSObject, HexPickerViewSource {
    var didSelectHexString: ((String) -> Void)?
    
    func hexStringFromPickerView(pickerView: UIPickerView) -> String {
        let r1 = pickerView.delegate!.pickerView!(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)!
        let r2 = pickerView.delegate!.pickerView!(pickerView, titleForRow: pickerView.selectedRow(inComponent: 1), forComponent: 1)!
        let b1 = pickerView.delegate!.pickerView!(pickerView, titleForRow: pickerView.selectedRow(inComponent: 2), forComponent: 2)!
        let b2 = pickerView.delegate!.pickerView!(pickerView, titleForRow: pickerView.selectedRow(inComponent: 3), forComponent: 3)!
        let g1 = pickerView.delegate!.pickerView!(pickerView, titleForRow: pickerView.selectedRow(inComponent: 4), forComponent: 4)!
        let g2 = pickerView.delegate!.pickerView!(pickerView, titleForRow: pickerView.selectedRow(inComponent: 5), forComponent: 5)!
        return r1 + r2 + b1 + b2 + g1 + g2
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
}
