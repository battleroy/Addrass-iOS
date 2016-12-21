//
//  AlertExtensions.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 17/12/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func presentInfoAlert(withText text: String, parentController: UIViewController) {
        
        presentAlert(withTitle: String.ad.info, text: text, parentController: parentController)
        
    }

    
    static func presentErrorAlert(withText text: String, parentController: UIViewController) {
        
        presentAlert(withTitle: String.ad.error, text: text, parentController: parentController)
        
    }
    
    
    static func presentAlert(withTitle title: String, text: String, parentController: UIViewController) {
        
        let ac = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: String.ad.OK, style: .default) { action in
            ac.dismiss(animated: true, completion: nil)
        })
        
        parentController.present(ac, animated: true, completion: nil)
        
    }
    
}
