//
//  CommonTabBarViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 19/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class CommonTabBarViewController: UITabBarController {
    
    // MARK: VCL

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = UIColor.ad.darkGray
        tabBar.tintColor = UIColor.ad.yellow
        
        let friendsVC = RootNavigationViewController(rootViewController: FriendsViewController(), tabBarImage: #imageLiteral(resourceName: "contacts-inactive-tb"), title: String.ad.friends)
        let calendarVC = RootNavigationViewController(rootViewController: CalendarViewController(), tabBarImage: #imageLiteral(resourceName: "calendar-inactive-tb"), title: String.ad.calendar)

        viewControllers = [friendsVC, calendarVC]
    }

}
