//
//  RootNavigationViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 06/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import SnapKit

class RootNavigationViewController: UINavigationController {
    
    // MARK: Initialization
    
    override convenience init(rootViewController viewController: UIViewController) {
        self.init(rootViewController: viewController, tabBarImage: nil, title: nil)
    }
    
    
    init(rootViewController viewController: UIViewController, tabBarImage image: UIImage?, title: String?) {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [viewController]
        
        tabBarItem.image = image
        tabBarItem.title = title
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: VCL
    
    override func viewDidLoad() {
        edgesForExtendedLayout = []
        
        let bar = navigationBar

        bar.shadowImage = UIImage()
        bar.setBackgroundImage(UIImage(), for: .default)
        bar.isTranslucent = false
        bar.tintColor = UIColor.ad.white
        bar.barTintColor = UIColor.ad.darkGray
        bar.titleTextAttributes = [
            NSFontAttributeName: UIFont.ad.largeBoldFont,
            NSForegroundColorAttributeName: UIColor.ad.white
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSFontAttributeName: UIFont.ad.largeFont,
            NSForegroundColorAttributeName: UIColor.ad.white
        ], for: .normal)
             
    }
    

    // MARK: Overrides
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
