//
//  ContactInfoTableViewCell.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 16/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class ContactInfoTableViewCell: UITableViewCell {
    
    // MARK: Constants
    
    static let cellIdentifier = "ContactCell"
    
    private static let iconSize:             CGFloat = 15.0
    private static let cellWidth:            CGFloat = 320.0
    private static let stripeWidth:          CGFloat = 2.0
    private static let dotDiameter:          CGFloat = 6.0
    private static let gradientBorderHeight: CGFloat = 3.0
    
    // MARK: Variables
    
    private var gradientBackgroundLayer: CAGradientLayer?
    
    private var infoIconImageView: UIImageView?
    var infoTypeLabel: UILabel?
    var infoContentLabel: UILabel?
    private var stripeView: UIView?
    private var dotView: UIView?
    
    // MARK: Properties
    
    public var infoTypeIcon: UIImage? {
        get {
            return infoIconImageView?.image
        }
        set {
            infoIconImageView?.image = newValue
        }
    }
    
    // MARK: Overrides

    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        
        setupUI()
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientBackgroundLayer?.frame = bounds
        
        let gradientBorderRatioToHeight = ContactInfoTableViewCell.gradientBorderHeight / bounds.height
        gradientBackgroundLayer?.locations = [0.0, gradientBorderRatioToHeight, 0.5, 1.0 - gradientBorderRatioToHeight, 1.0].map {
            NSNumber(value: Float($0))
        }
        
    }
    
    
    // MARK: Public methods
    
    
    static func cellHeight(forInfoContent content: String?) -> CGFloat {
        
        let givenWidth = 0.5 * cellWidth
        let textHeight = UIFont.ad.bodyFont.height(forGivenText: content, width: givenWidth)
        return 16.0 + max(iconSize, textHeight) + 16.0
        
    }
    
    // MARK: Private methods
    
    func setupUI() {
        backgroundColor = UIColor.gray
        selectionStyle = .none
        
        setupSubviews()
    }
    
    
    func setupSubviews() {
        gradientBackgroundLayer = CAGradientLayer()
        gradientBackgroundLayer?.colors = [UIColor.ad.darkGray.cgColor, UIColor.ad.gray.cgColor, UIColor.ad.gray.cgColor, UIColor.ad.gray.cgColor, UIColor.ad.darkGray.cgColor]
        layer.insertSublayer(gradientBackgroundLayer!, at: 0)
        
        infoIconImageView = UIImageView()
        infoIconImageView?.contentMode = .scaleAspectFit
        addSubview(infoIconImageView!)
        
        infoTypeLabel = UILabel()
        infoTypeLabel?.font = UIFont.ad.boldFont
        infoTypeLabel?.textColor = UIColor.ad.white
        addSubview(infoTypeLabel!)
        
        infoContentLabel = UILabel()
        infoContentLabel?.font = UIFont.ad.bodyFont
        infoContentLabel?.textColor = UIColor.ad.white
        infoContentLabel?.numberOfLines = 0
        infoContentLabel?.textAlignment = .right
        addSubview(infoContentLabel!)
        
        stripeView = UIView()
        stripeView?.backgroundColor = UIColor.ad.lightGray
        addSubview(stripeView!)
        
        dotView = UIView()
        dotView?.backgroundColor = UIColor.ad.yellow
        dotView?.layer.cornerRadius = ContactInfoTableViewCell.dotDiameter / 2
        dotView?.layer.masksToBounds = true
        dotView?.layer.borderWidth = 1.5
        dotView?.layer.borderColor = UIColor.ad.gray.cgColor
        addSubview(dotView!)
        
        setConstraints()
    }
    
    
    func setConstraints() {
        
        stripeView?.snp.makeConstraints({ (make) in
            make.width.equalTo(ContactInfoTableViewCell.stripeWidth)
            make.top.bottom.equalTo(self)
            make.centerX.equalTo(self.snp.left).offset(15.5)
        })
     
        dotView?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(stripeView!)
            make.width.height.equalTo(ContactInfoTableViewCell.dotDiameter)
        })
        
        infoIconImageView?.snp.makeConstraints({ (make) in
            make.left.equalTo(stripeView!.snp.right).offset(8.0)
            make.centerY.equalTo(self)
            make.width.height.equalTo(ContactInfoTableViewCell.iconSize)
        })
        
        infoTypeLabel?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(infoIconImageView!)
            make.left.equalTo(infoIconImageView!.snp.right).offset(4.0)
        })
        
        infoContentLabel?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-8.0)
            make.width.equalTo(self).multipliedBy(0.5)
        })
    }

}
