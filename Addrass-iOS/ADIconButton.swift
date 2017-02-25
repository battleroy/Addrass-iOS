//
//  ADIconButton.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 15/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class ADIconButton: UIButton {
    
    // MARK: Fields
    
    private var iconImageView: UIImageView!
    
    
    // MARK: Properties
    
    var iconImage: UIImage? {
        get {
            return iconImageView.image
        }
        
        set {
            iconImageView.image = newValue
        }
    }
    
    
    var iconSize: CGFloat {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    // MARK: Initializers
    
    init(withIconSize iconSize: CGFloat, icon: UIImage?) {
        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = icon
        self.iconSize = iconSize
        
        super.init(frame: CGRect.zero)
        addSubview(iconImageView)
    }
    
    
    required init(coder aCoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.frame = CGRect(x: 0.0, y: 0.0, width: iconSize, height: iconSize)
        contentEdgeInsets = UIEdgeInsetsMake(0.0, 5.0 + iconSize, 0.0, 0.0)
        
        iconImageView.layer.position = CGPoint(x: 0.0 + iconSize / 2, y: 0.0 + iconSize / 2)
        iconImageView.bounds = CGRect(x: 0.0, y: 0.0, width: iconSize, height: iconSize)
    }
}
