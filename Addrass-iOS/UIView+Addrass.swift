//
//  UIView+Addrass.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 07/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

extension UIView {
    
    func blink(blinkColor: UIColor) {
        
        let previousBackgroundColor = backgroundColor
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = blinkColor
        }) { (isFinished) in
            if (isFinished) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.backgroundColor = previousBackgroundColor
                })
            }
        }
    }
    
}
