//
//  ContactTableViewCell.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 09/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    // MARK: Constants
    
    static let cellIdentifier = "FriendCell"
    private static let chevronImageName = "chevron"
    
    private static let imageViewSize:     CGFloat = 60.0
    private static let chevronViewSize:   CGFloat = 20.0
    private static let cellWidth:         CGFloat = 320.0
    
    
    // MARK: Variables
    
    var friendImageView:    UIImageView!
    var chevronView:         UIImageView!
    var nameLabel:           UILabel!
    
    
    // MARK: Overrides
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        
        setupUI()
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    

    // MARK: Public methods
    
    func updateCell(withContact contact: User) {
        
        nameLabel.text = contact.fullName
        
        guard let imageLink = contact.image, let imageURL = URL(string: imageLink) else {
            friendImageView.image = #imageLiteral(resourceName: "user-icon-placeholder")
            return
        }
        
        friendImageView.af_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "user-icon-placeholder"))
    }
    
    
    static func cellHeight(forContact contact: User) -> CGFloat {
        let imageHeight = imageViewSize
        
        let givenWidth = cellWidth - 8.0 - imageViewSize - 8.0 - 8.0
        let textHeight = UIFont.ad.bodyFont.height(forGivenText: contact.fullName, width: givenWidth)
        
        return 8.0 + max(imageHeight, textHeight) + 8.0
    }
    
    // MARK: Private methods
    
    func setupUI() {
        backgroundColor = UIColor.clear
        
        setupSubviews()
    }
    
    
    func setupSubviews() {
        friendImageView = UIImageView()
        friendImageView.contentMode = .scaleAspectFill
        friendImageView.layer.cornerRadius = FriendTableViewCell.imageViewSize / 2
        friendImageView.layer.masksToBounds = true
        friendImageView.layer.borderWidth = 1.0
        friendImageView.layer.borderColor = UIColor.ad.yellow.cgColor
        addSubview(friendImageView)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.ad.bodyFont
        nameLabel.textColor = UIColor.ad.white
        addSubview(nameLabel)
        
        chevronView = UIImageView(image: UIImage(named: FriendTableViewCell.chevronImageName))
        chevronView.contentMode = .scaleAspectFit
        addSubview(chevronView)
        
        setConstraints()
    }
    
    
    func setConstraints() {
        
        friendImageView.snp.makeConstraints({ (make) in
            make.width.height.equalTo(FriendTableViewCell.imageViewSize)
            make.left.top.equalTo(self).offset(10.0)
            make.bottom.lessThanOrEqualTo(self).offset(-8.0)
        })
        
        chevronView.snp.makeConstraints({ (make) in
            make.width.height.equalTo(FriendTableViewCell.chevronViewSize)
            make.centerY.equalTo(friendImageView)
            make.right.equalTo(self).offset(-10.0)
        })
        
        nameLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(friendImageView.snp.right).offset(8.0)
            make.right.equalTo(chevronView.snp.left).offset(-8.0)
            make.centerY.equalTo(friendImageView)
        })
        
    }
}
