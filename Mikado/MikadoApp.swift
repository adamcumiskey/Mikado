//
//  MikadoApp.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import UIKit


class MikadoApp {
    var database: Database
    var window: UIWindow
    init(window: UIWindow, database: Database) {
        self.window = window
        self.database = database
    }
    
    func launch() {
        let viewController = ViewController(database: database)
        let navigationViewController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
    }
    
    func style() {
        let navigationBarAppearence = UINavigationBar.appearance()
        navigationBarAppearence.tintColor = .black
    }
}
