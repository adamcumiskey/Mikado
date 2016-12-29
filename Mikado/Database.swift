//
//  Database.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import Foundation


protocol Database {
    subscript(key: String) -> Any? { get set }
}


class UserDefaultsDB: Database {
    fileprivate var userDefaults: UserDefaults
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    subscript(key: String) -> Any? {
        get {
            return userDefaults.value(forKey: key)
        }
        set {
            userDefaults.setValue(newValue, forKey: key)
        }
    }
}

class MemoryDB: Database {
    private var data: [String: Any] = [:]
    subscript(key: String) -> Any? {
        get {
            return data[key]
        }
        set {
            data[key] = newValue
        }
    }
}
