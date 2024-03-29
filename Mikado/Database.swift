//
//  Database.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import Foundation


class UserDefaultsDB {
    var userDefaults: UserDefaults!
    
    subscript(key: String) -> Any? {
        get {
            return userDefaults.value(forKey: key)
        }
        set {
            userDefaults.setValue(newValue, forKey: key)
        }
    }
}
