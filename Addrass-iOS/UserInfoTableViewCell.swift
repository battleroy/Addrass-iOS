//
//  ContactInfoTableViewCell.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 16/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: ADTableViewCell {
    
    // MARK: Constants
    
    static let cellIdentifier = "UserCell"
    
    private static let iconSize:             CGFloat = 15.0
    private static let gradientBorderHeight: CGFloat = 3.0
    
    
    // MARK: Variables
    
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
        
        backgroundColor = UIColor.ad.gray
        selectionStyle = .none

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
        
        infoIconImageView.snp.remakeConstraints({ (make) in
            make.left.equalTo(stripeView.snp.right).offset(8.0)
            make.centerY.equalTo(self)
            make.width.height.equalTo(UserInfoTableViewCell.iconSize)
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
