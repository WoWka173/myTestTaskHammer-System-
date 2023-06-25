//
//  AppDelegate.swift
//  myTestTask
//
//  Created by Владимир Курганов on 22.06.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    //MARK: - Properties
    var window: UIWindow?
    
    //MARK: - Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        return true
    }
    
}
