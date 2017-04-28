//
//  EventTableViewCell.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 26/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class EventTableViewCell: ADTableViewCell {
    
    // MARK: Constants
    
    static let cellIdentifier = "EventCell"
    private static let iconSize: CGFloat = 15.0
    private static let iconsOffset: CGFloat = 8.0
    private static let labelsOffset: CGFloat = 4.0
    

    // MARK: Variables
    
    var eventTitleLabel: UILabel!
    var eventTimeLabel: UILabel!
    var eventTitleImageView: UIImageView!
    var eventTimeImageView: UIImageView!
    var eventTypeLabel: UILabel!
    var eventOwnedLabel: UILabel!
    var eventIsPrivateImageView: UIImageView!
    
    
    // MARK: Properties
    
    static let cellHeight: CGFloat = {
        return 50.0
    }()
    
    
    // MARK: Overrides
    
    override func setupUI() {
        super.setupUI()
        
        eventTitleLabel = UILabel()
        eventTitleLabel.font = UIFont.ad.boldFont
        eventTitleLabel.textColor = UIColor.ad.white
        addSubview(eventTitleLabel)
        
        eventTimeLabel = UILabel()
        eventTimeLabel.font = UIFont.ad.bodyFont
        eventTimeLabel.textColor = UIColor.ad.lightGray
        addSubview(eventTimeLabel)
        
        eventTitleImageView = UIImageView()
        eventTitleImageView.contentMode = .scaleAspectFit
        eventTitleImageView.image = #imageLiteral(resourceName: "pencil-gray")
        addSubview(eventTitleImageView)
        
        eventTimeImageView = UIImageView()
        eventTimeImageView.contentMode = .scaleAspectFit
        eventTimeImageView.image = #imageLiteral(resourceName: "calendar-inactive")
        addSubview(eventTimeImageView)
        
        eventTypeLabel = UILabel()
        eventTypeLabel.font = UIFont.ad.bodyItalicFont
        eventTypeLabel.textColor = UIColor.ad.lightGray
        addSubview(eventTypeLabel)
        
        eventOwnedLabel = UILabel()
        eventOwnedLabel.font = UIFont.ad.boldFont
        eventOwnedLabel.textColor = UIColor.ad.lightGray
        addSubview(eventOwnedLabel)
        
        eventIsPrivateImageView = UIImageView()
        eventIsPrivateImageView.contentMode = .scaleAspectFit
        addSubview(eventIsPrivateImageView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        eventTitleImageView.snp.remakeConstraints { (make) in
            make.left.equalTo(dotView.snp.right).offset(EventTableViewCell.iconsOffset)
            make.bottom.equalTo(dotView.snp.centerY).offset(-EventTableViewCell.labelsOffset)
            make.width.height.equalTo(EventTableViewCell.iconSize)
        }
        
        eventTimeImageView.snp.remakeConstraints { (make) in
            make.left.equalTo(dotView.snp.right).offset(EventTableViewCell.iconsOffset)
            make.top.equalTo(dotView.snp.centerY).offset(EventTableViewCell.labelsOffset)
            make.width.height.equalTo(EventTableViewCell.iconSize)
        }
        
        eventTitleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(eventTitleImageView.snp.right).offset(EventTableViewCell.labelsOffset)
            make.centerY.equalTo(eventTitleImageView)
        }
        
        eventTimeLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(eventTimeImageView.snp.right).offset(EventTableViewCell.labelsOffset)
            make.centerY.equalTo(eventTimeImageView)
        }
        
        eventTypeLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-EventTableViewCell.labelsOffset)
            make.centerY.equalTo(eventTimeLabel)
        }
        
        eventOwnedLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(eventTypeLabel)
            make.centerY.equalTo(eventTitleLabel)
        }
        
        eventIsPrivateImageView.snp.remakeConstraints { (make) in
            make.right.equalTo(eventTypeLabel.snp.left).offset(-4.0)
            make.centerY.equalTo(eventTypeLabel)
            make.height.width.equalTo(16.0)
        }
    }
    
    
    // MARK: Public methods
    
    public func updateCell(withEvent event: Event) {
        eventTitleLabel.text = event.name
        
        if let eventDate = event.date {
            eventTimeLabel.text = DateFormatter.timeDateFormatter.string(from: eventDate)
        }
        
        eventTypeLabel.text = event.type.stringValue
        eventOwnedLabel.text = event.isOwnedByCurrentUser ? String.ad.owner : ""
        eventIsPrivateImageView.image = event.isPublic ? #imageLiteral(resourceName: "acc-public-inactive") : #imageLiteral(resourceName: "acc-private-inactive")
    }
    
}
