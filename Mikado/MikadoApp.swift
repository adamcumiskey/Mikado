//
//  MikadoApp.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import UIKit

enum AppStyle {
    case light
    case dark
}


class MikadoApp {
    static var userDefaults: UserDefaults!
    
    var window: UIWindow
    init(window: UIWindow) {
        self.window = window
        
        // Use standard user defaults for storage
        MikadoApp.userDefaults = UserDefaults.standard
    }
    
    func launch() {
        let viewController = ViewController()
        let navigationViewController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
    }
    
    static func setStyle(style: AppStyle) {
        let navigationBarAppearence = UINavigationBar.appearance()
        let pickerViewAppearence = UIPickerView.appearance()
        let buttonAppearence = UIButton.appearance()
        switch style {
        case .light:
            navigationBarAppearence.barStyle = .default
            navigationBarAppearence.tintColor = .black
        case .dark:
            navigationBarAppearence.barStyle = .blackTranslucent
            navigationBarAppearence.tintColor = .white
        }
    }
}
