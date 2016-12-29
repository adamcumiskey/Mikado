//
//  MikadoApp.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import UIKit


class MikadoApp {
    // Global UserDefaults store
    static var userDefaults: UserDefaults!
    
    var window: UIWindow
    init(window: UIWindow) {
        self.window = window
        
        // Use standard user defaults for storage
        MikadoApp.userDefaults = UserDefaults.standard
    }
    
    /// Set appearence defaults
    func style() {
        let navigationBarAppearence = UINavigationBar.appearance()
        navigationBarAppearence.tintColor = .black
    }
    
    /// Load main view controller and present window
    func launch() {
        let viewController = ViewController()
        let navigationViewController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
    }
}
