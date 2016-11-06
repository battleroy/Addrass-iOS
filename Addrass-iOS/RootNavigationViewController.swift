//
//  RootNavigationViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 06/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class RootNavigationViewController: UINavigationController {
    
    // MARK: VCL
    
    override func viewDidLoad() {
        
        let bar = navigationBar
        
        bar.setBackgroundImage(UIImage(), for: .default)
        bar.shadowImage = UIImage()
        bar.isTranslucent = true
        bar.tintColor = UIColor.ad.white
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
