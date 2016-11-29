//
//  AppDelegate.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 05/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        let startVC = RootNavigationViewController(rootViewController: WelcomeViewController()) // CommonTabBarViewController()
        
        window?.rootViewController = startVC
        window?.makeKeyAndVisible()
        
        return true
    }


}

