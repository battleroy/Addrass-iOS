//
//  UITextField+Inset.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 06/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class ADPaddedTextField: UITextField {
    
    // MARK: Variables
    
    static let defaultPadding = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)
    
    
    // MARK: Properties
    
    var padding: UIEdgeInsets
    
    
    // MARK: Init
    
    convenience init() {
        self.init(forFrame: CGRect.zero)
    }
    
    
    convenience init(forPadding padding: UIEdgeInsets) {
        self.init(forFrame: CGRect.zero, padding: padding)
    }
    
    
    convenience init(forFrame frame: CGRect) {
        self.init(forFrame: frame, padding: ADPaddedTextField.defaultPadding)
    }
    
    
    init(forFrame frame: CGRect, padding: UIEdgeInsets) {
        self.padding = padding
        
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        self.padding = ADPaddedTextField.defaultPadding
        
        super.init(coder: aDecoder)
        
    }

    
    // MARK: Overrides
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

}
