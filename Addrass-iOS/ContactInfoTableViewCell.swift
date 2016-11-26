//
//  ContactInfoTableViewCell.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 16/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class ContactInfoTableViewCell: ADTableViewCell {
    
    // MARK: Constants
    
    static let cellIdentifier = "ContactCell"
    
    private static let iconSize:             CGFloat = 15.0
    private static let gradientBorderHeight: CGFloat = 3.0
    
    
    // MARK: Variables
    
    private var gradientBackgroundLayer: CAGradientLayer!
    
    private var infoIconImageView: UIImageView!
    var infoTypeLabel: UILabel!
    var infoContentLabel: UILabel!
    
    
    // MARK: Properties
    
    public var infoTypeIcon: UIImage? {
        get {
            return infoIconImageView.image
        }
        set {
            infoIconImageView.image = newValue
        }
    }
    
    
    // MARK: Overrides
    
    override func setupUI() {
        super.setupUI()
        
        backgroundColor = UIColor.gray
        selectionStyle = .none
        
        gradientBackgroundLayer = CAGradientLayer()
        gradientBackgroundLayer.colors = [UIColor.ad.darkGray.cgColor, UIColor.ad.gray.cgColor, UIColor.ad.gray.cgColor, UIColor.ad.gray.cgColor, UIColor.ad.darkGray.cgColor]
        layer.insertSublayer(gradientBackgroundLayer, at: 0)
        
        infoIconImageView = UIImageView()
        infoIconImageView.contentMode = .scaleAspectFit
        addSubview(infoIconImageView)
        
        infoTypeLabel = UILabel()
        infoTypeLabel.font = UIFont.ad.boldFont
        infoTypeLabel.textColor = UIColor.ad.white
        addSubview(infoTypeLabel)
        
        infoContentLabel = UILabel()
        infoContentLabel.font = UIFont.ad.bodyFont
        infoContentLabel.textColor = UIColor.ad.white
        infoContentLabel.numberOfLines = 0
        infoContentLabel.textAlignment = .right
        addSubview(infoContentLabel)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientBackgroundLayer.frame = bounds
        
        let gradientBorderRatioToHeight = ContactInfoTableViewCell.gradientBorderHeight / bounds.height
        gradientBackgroundLayer.locations = [0.0, gradientBorderRatioToHeight, 0.5, 1.0 - gradientBorderRatioToHeight, 1.0].map {
            NSNumber(value: Float($0))
        }
        
        infoIconImageView.snp.remakeConstraints({ (make) in
            make.left.equalTo(stripeView.snp.right).offset(8.0)
            make.centerY.equalTo(self)
            make.width.height.equalTo(ContactInfoTableViewCell.iconSize)
        })
        
        infoTypeLabel.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(infoIconImageView)
            make.left.equalTo(infoIconImageView.snp.right).offset(4.0)
        })
        
        infoContentLabel.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-8.0)
            make.width.equalTo(self).multipliedBy(0.5)
        })
    }
    
    
    // MARK: Public methods
    
    static func cellHeight(forInfoContent content: String?) -> CGFloat {
        
        let givenWidth = 0.5 * cellWidth
        let textHeight = UIFont.ad.bodyFont.height(forGivenText: content, width: givenWidth)
        return 16.0 + max(iconSize, textHeight) + 16.0
        
    }
    
}
