//
//  ADTableViewCell.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 26/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import SnapKit

class ADTableViewCell: UITableViewCell {

    // MARK: Constants
    
    static let cellWidth:            CGFloat = 320.0
    static let stripeWidth:          CGFloat = 2.0
    static let dotDiameter:          CGFloat = 8.0
    
    
    // MARK: Variables
    
    var stripeView: UIView!
    var dotView: UIView!
    
    
    // MARK: Overrides
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        
        setupUI()
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    
    override func updateConstraints() {
        super.updateConstraints()
        
        stripeView.snp.remakeConstraints({ (make) in
            make.width.equalTo(ADTableViewCell.stripeWidth)
            make.top.bottom.equalTo(self)
            make.centerX.equalTo(self.snp.left).offset(15.5)
        })
        
        dotView.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(stripeView!)
            make.width.height.equalTo(ADTableViewCell.dotDiameter)
        })
    }
    
    
    // MARK: Public methods
    
    
    
    // MARK: Private methods
    
    func setupUI() {
        backgroundColor = UIColor.gray
        selectionStyle = .none
        
        stripeView = UIView()
        stripeView.backgroundColor = UIColor.ad.lightGray
        addSubview(stripeView)
        
        dotView = UIView()
        dotView.backgroundColor = UIColor.ad.yellow
        dotView.layer.cornerRadius = ADTableViewCell.dotDiameter / 2
        dotView.layer.masksToBounds = true
        dotView.layer.borderWidth = 1.5
        dotView.layer.borderColor = UIColor.ad.gray.cgColor
        addSubview(dotView)
    }

}
