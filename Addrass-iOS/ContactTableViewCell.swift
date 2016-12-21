//
//  ContactTableViewCell.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 09/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    // MARK: Constants
    
    static let cellIdentifier = "ContactCell"
    private static let chevronImageName = "chevron"
    
    private static let imageViewSize:     CGFloat = 60.0
    private static let colorViewSize:     CGFloat = 15.0
    private static let chevronViewSize:   CGFloat = 20.0
    private static let cellWidth:         CGFloat = 320.0
    private static let nameGroupGap:      CGFloat = 0.0
    
    
    // MARK: Variables
    
    var contactImageView:    UIImageView!
    var colorView:           UIView!
    var chevronView:         UIImageView!
    var labelsContainerView: UIView!
    var nameLabel:           UILabel!
    var groupLabel:          UILabel!
    
    
    // MARK: Overrides
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        
        setupUI()
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let circleColor = colorView.backgroundColor
        super.setSelected(selected, animated: animated)
        colorView.backgroundColor = circleColor
    }
    

    // MARK: Public methods
    
    func updateCell(withContact contact: User) {
        
        nameLabel.text = contact.name
        groupLabel.text = contact.group
        
        guard let imageLink = contact.image, let imageURL = URL(string: imageLink) else {
            contactImageView.image = #imageLiteral(resourceName: "user-icon-placeholder")
            return
        }
        
        contactImageView.af_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "user-icon-placeholder"))
    }
    
    
    static func cellHeight(forContact contact: User) -> CGFloat {
        
        let imageHeight = imageViewSize
        
        let givenWidth = cellWidth - 8.0 - imageViewSize - 8.0 - 8.0
        let textHeight = UIFont.ad.bodyFont.height(forGivenText: contact.name, width: givenWidth) +
                         ContactTableViewCell.nameGroupGap +
                         UIFont.ad.smallFont.height(forGivenText: contact.group, width: givenWidth)
        
        return 8.0 + max(imageHeight, textHeight) + 8.0
        
    }
    
    // MARK: Private methods
    
    func setupUI() {
        backgroundColor = UIColor.clear
        
        setupSubviews()
    }
    
    
    func setupSubviews() {
        contactImageView = UIImageView()
        contactImageView.contentMode = .scaleAspectFill
        contactImageView.layer.cornerRadius = ContactTableViewCell.imageViewSize / 2
        contactImageView.layer.masksToBounds = true
        contactImageView.layer.borderWidth = 1.0
        contactImageView.layer.borderColor = UIColor.ad.yellow.cgColor
        addSubview(contactImageView)
        
        colorView = UIView()
        colorView.layer.cornerRadius = ContactTableViewCell.colorViewSize / 2
        colorView.layer.masksToBounds = true
        addSubview(colorView)
        
        labelsContainerView = UIView()
        addSubview(labelsContainerView)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.ad.bodyFont
        nameLabel.textColor = UIColor.ad.white
        labelsContainerView.addSubview(nameLabel)
        
        groupLabel = UILabel()
        groupLabel.font = UIFont.ad.smallFont
        groupLabel.textColor = UIColor.ad.darkGray
        labelsContainerView.addSubview(groupLabel)
        
        chevronView = UIImageView(image: UIImage(named: ContactTableViewCell.chevronImageName))
        chevronView.contentMode = .scaleAspectFit
        addSubview(chevronView)
        
        setConstraints()
    }
    
    
    func setConstraints() {
        
        contactImageView.snp.makeConstraints({ (make) in
            make.width.height.equalTo(ContactTableViewCell.imageViewSize)
            make.top.equalTo(self).offset(8.0)
            make.bottom.lessThanOrEqualTo(self).offset(-8.0)
        })
        
        colorView.snp.makeConstraints({ (make) in
            make.width.height.equalTo(ContactTableViewCell.colorViewSize)
            make.centerY.equalTo(contactImageView)
            make.left.equalTo(self).offset(8.0)
            make.right.equalTo(contactImageView.snp.left).offset(-8.0)
        })
        
        chevronView.snp.makeConstraints({ (make) in
            make.width.height.equalTo(ContactTableViewCell.chevronViewSize)
            make.centerY.equalTo(contactImageView)
            make.right.equalTo(self).offset(-8.0)
        })
        
        nameLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(labelsContainerView)
            make.left.right.equalTo(labelsContainerView)
        })
        
        groupLabel.snp.makeConstraints({ (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(ContactTableViewCell.nameGroupGap)
            make.bottom.equalTo(labelsContainerView)
        })
        
        labelsContainerView.snp.makeConstraints({ (make) in
            make.left.equalTo(contactImageView.snp.right).offset(8.0)
            make.right.equalTo(chevronView.snp.left).offset(-8.0)
            make.centerY.equalTo(contactImageView)
        })
        
    }
}
