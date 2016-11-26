//
//  CalendarWeekDayCell.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 21/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit


class CalendarWeekDayCell: UICollectionViewCell {

    // MARK: Constants
    
    public static let cellIdentifier = "WeekDayCell"
    private static let weekDayNumberGapUnselected: CGFloat = 2.0
    
    
    // MARK: Variables
    
    var dayName: UILabel!
    var dayNumber: UILabel!
    var dayMonth: UILabel!
    
    
    // MARK: Initialization
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Overrides
    
    override var isSelected: Bool {
        
        get {
            return super.isSelected
        }
        set (_isSelected) {
            super.isSelected = _isSelected
            
            dayMonth.isHidden = !_isSelected
            
            if (_isSelected) {
                backgroundColor = UIColor.ad.lightGray
                dayName.textColor = UIColor.ad.white
                dayNumber.textColor = UIColor.ad.white
                dayMonth.textColor = UIColor.ad.white
            } else {
                backgroundColor = UIColor.ad.darkGray
                dayName.textColor = UIColor.ad.gray
                dayNumber.textColor = UIColor.ad.gray
                dayMonth.textColor = UIColor.ad.darkGray
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (isSelected) {
            dayName.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: dayName.font.lineHeight)
            dayNumber.frame = CGRect(x: 0.0, y: dayName.bounds.height, width: bounds.width, height: bounds.height - dayName.font.lineHeight - dayMonth.font.lineHeight)
            dayMonth.frame = CGRect(x: 0.0, y: bounds.height - dayMonth.font.lineHeight, width: bounds.width, height: dayMonth.font.lineHeight)
        } else {
            let contentHeight = dayName.font.lineHeight + CalendarWeekDayCell.weekDayNumberGapUnselected + dayNumber.font.lineHeight
            let vGap = (bounds.height - contentHeight) / 2
            
            dayName.frame = CGRect(x: 0.0, y: vGap, width: bounds.width, height: dayName.font.lineHeight)
            dayNumber.frame = CGRect(x: 0.0, y: bounds.height - vGap - dayNumber.font.lineHeight, width: bounds.width, height: dayNumber.font.lineHeight)
        }
    }
    
    
    // MARK: Private methods
    
    func setupSubviews() {
        
        dayName = UILabel()
        dayName.font = UIFont.ad.bodyFont
        dayName.textAlignment = .center
        contentView.addSubview(dayName)
        
        dayNumber = UILabel()
        dayNumber.font = UIFont.ad.weekCollectionFont
        dayNumber.textAlignment = .center
        contentView.addSubview(dayNumber)
        
        dayMonth = UILabel()
        dayMonth.font = UIFont.ad.bodyFont
        dayMonth.textAlignment = .center
        contentView.addSubview(dayMonth)
    }
}
