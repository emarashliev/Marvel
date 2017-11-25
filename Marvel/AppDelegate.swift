//
//  AppDelegate.swift
//  Marvel
//
//  Created by Emil Marashliev on 10/28/17.
//  Copyright © 2017 Emil Marashliev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.appCoordinator = AppCoordinator()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.appCoordinator?.rootViewController
        self.window?.makeKeyAndVisible()
        self.appCoordinator?.start()
        return true
    }
}

