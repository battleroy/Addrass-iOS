//
//  AlertExtensions.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 17/12/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    // MARK: Messages
    
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
    
    
    // MARK: Dialogs
    
    static func presentInputAlert(withTitle title: String, text: String, placeholder: String?, parentController: UIViewController, completion: @escaping ((String?) -> Void)) {
        
        let inputAC = UIAlertController(title: title, message: text, preferredStyle: .alert)
        inputAC.addTextField { textField in
            textField.placeholder = placeholder
        }
        
        inputAC.addAction(UIAlertAction(title: String.ad.OK, style: .default, handler: { action in
            completion(inputAC.textFields?.first?.text)
        }))
        
        inputAC.addAction(UIAlertAction(title: String.ad.cancel, style: .cancel, handler: { action in
            completion(nil)
        }))
        
        parentController.present(inputAC, animated: true, completion: nil)
    }
    
}
