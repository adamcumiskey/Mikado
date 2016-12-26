//
//  AppDelegate.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var mikadoApp: MikadoApp!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Create the window and launch the app
        let window = UIWindow(frame: UIScreen.main.bounds)
        mikadoApp = MikadoApp(window: window)
        mikadoApp.launch()
        return true
    }
}
