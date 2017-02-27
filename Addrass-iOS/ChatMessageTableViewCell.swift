//
//  ChatMessageTableViewCell.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 2/27/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AlamofireImage


class ChatMessageTableViewCell : UITableViewCell {
    
    enum CellMode {
        case left
        case right
    }
    
    // MARK: Fields
    
    static let cellIdentifier = "ChatMessageTableViewCell"
    static let cellToTableWidthRatio: CGFloat = 0.7
    static let imageSize: CGFloat = 35.0
    
    
    var containerView: UIView!
    var messageTextLabel: UILabel!
    var timeTextLabel: UILabel!
    var senderImageView: UIImageView!
        
    
    // MARK: Properties
    
    var cellMode: CellMode {
        willSet(newMode) {
            setNeedsUpdateConstraints()
        }
    }
    
    
    // MARK: Initialization
    
    required init?(coder aCoder: NSCoder) {
        cellMode = .left

        super.init(coder: aCoder)
        
        setupUI()
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        cellMode = .left

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    
    // MARK: Overrides
    
    override func updateConstraints() {
        super.updateConstraints()
        
        for subview in containerView.subviews {
            subview.snp.removeConstraints()
        }
        
        containerView.snp.remakeConstraints { [weak self] (make) in
            guard let `self` = self else {
                return
            }
            
            make.width.equalTo(self.contentView).multipliedBy(ChatMessageTableViewCell.cellToTableWidthRatio)
            make.top.equalTo(self.contentView).offset(4.0)
            make.bottom.equalTo(self.contentView).offset(-4.0)
            
            switch self.cellMode {
            case .left:
                make.left.equalTo(self.contentView).offset(4.0)
            case .right:
                make.right.equalTo(self.contentView).offset(-4.0)
            }
        }
        
        messageTextLabel.snp.remakeConstraints { [weak self] (make) in
            guard let `self` = self else {
                return
            }
            
            make.top.equalTo(self.containerView).offset(4.0)
            
            switch self.cellMode {
            case .left:
                make.right.equalTo(self.containerView).offset(-4.0)
            case .right:
                make.left.equalTo(self.containerView).offset(4.0)
            }
        }
        
        timeTextLabel.snp.remakeConstraints { [weak self] (make) in
            guard let `self` = self else {
                return
            }
            
            make.width.equalTo(self.messageTextLabel)
            make.top.equalTo(self.messageTextLabel.snp.bottom).offset(4.0)
            
            switch self.cellMode {
            case .left:
                make.right.equalTo(self.messageTextLabel)
            case .right:
                make.left.equalTo(self.messageTextLabel)
            }
        }
        
        
        senderImageView.snp.remakeConstraints { [weak self] (make) in
            guard let `self` = self else {
                return
            }
            
            make.width.height.equalTo(ChatMessageTableViewCell.imageSize)
            make.top.equalTo(self.messageTextLabel)
            
            switch self.cellMode {
            case .left:
                make.left.equalTo(self.containerView).offset(4.0)
                make.right.equalTo(self.messageTextLabel.snp.left).offset(-4.0)
            case .right:
                make.right.equalTo(self.containerView).offset(-4.0)
                make.left.equalTo(self.messageTextLabel.snp.right).offset(4.0)
            }
        }
    }
    
    
    // MARK: Public methods
    
    static func cellHeight(forMessage message: Message, tableWidth: CGFloat) -> CGFloat {
        let labelsWidth = tableWidth * ChatMessageTableViewCell.cellToTableWidthRatio - ChatMessageTableViewCell.imageSize - 4.0 * 3
        let textHeight = UIFont.ad.bodyFont.height(forGivenText: message.text, width: labelsWidth)
        let timeHeight = UIFont.ad.smallBoldFont.height(forGivenText: DateFormatter.timeDateFormatter.string(from: message.time!), width: labelsWidth)
        
        return 8.0 * 2 + max(ChatMessageTableViewCell.imageSize, textHeight + 4.0 + timeHeight)
    }
    
    
    func setupCell(forMessage message: Message) {
        
        cellMode = (message.sender?.id == SessionManager.currentUser?.id ? .right : .left)
        
        senderImageView.af_cancelImageRequest()
        senderImageView.image = nil
        
        messageTextLabel.text = message.text
        timeTextLabel.text = DateFormatter.timeDateFormatter.string(from: message.time!)
        
        if let imageLink = message.sender?.imageLink, let imageURL = URL(string: imageLink) {
            senderImageView.af_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "user-icon-placeholder"))
        }
        
        setNeedsUpdateConstraints()
    }
    
    
    // MARK: Private methods
    
    func setupUI() {
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        
        containerView = UIView()
        containerView.backgroundColor = UIColor.ad.lightGray
        containerView.layer.cornerRadius = 5.0
        containerView.layer.masksToBounds = true
        contentView.addSubview(containerView)
        
        
        messageTextLabel = UILabel()
        messageTextLabel.font = UIFont.ad.bodyFont
        messageTextLabel.textColor = UIColor.ad.darkGray
        messageTextLabel.numberOfLines = 0
        messageTextLabel.setContentHuggingPriority(100, for: .horizontal)
        containerView.addSubview(messageTextLabel)
        
        timeTextLabel = UILabel()
        timeTextLabel.font = UIFont.ad.smallBoldFont
        timeTextLabel.textColor = UIColor.ad.darkGray
        containerView.addSubview(timeTextLabel)
        
        senderImageView = UIImageView()
        senderImageView.contentMode = .scaleAspectFill
        senderImageView.layer.cornerRadius = ChatMessageTableViewCell.imageSize / 2
        senderImageView.layer.masksToBounds = true
        containerView.addSubview(senderImageView)
        
    }
}
