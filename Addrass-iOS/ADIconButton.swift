//
//  ADIconButton.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 15/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class ADIconButton: UIButton {
    
    // MARK: Variables
    
    public var iconImage: UIImage? {
        get {
            return imageView?.image
        }
        
        set {
            imageView?.image = newValue
        }
    }
    
    // MARK: Initializers

    public init(withIcon iconImage: UIImage?) {
        super.init(frame: CGRect.zero)
        
        self.iconImage = iconImage
        
        
    }
    
    required init(coder aCoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Private methods
    
    func

}
