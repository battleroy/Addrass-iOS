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
    }
    
    
    // MARK: Public methods
    
    public static func cellHeight() -> CGFloat {
        return 60.0
    }
    
}
