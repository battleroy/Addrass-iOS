//
//  CalendarMonthDayCell.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 18/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import FSCalendar
import SnapKit

class CalendarMonthDayCell: FSCalendarCell {
    
    // MARK: Constants
    
    public static let cellIdentifier = "MonthDayCell"

    // MARK: Variables
    
    
    // MARK: Overrides
    
    required init!(coder aCoder: NSCoder) {
        fatalError("not implemented")
    }
    
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let midPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        
        titleLabel.layer.position = midPoint
        subtitleLabel.layer.position = CGPoint(x: midPoint.x, y: midPoint.y - titleLabel.bounds.height / 2 - subtitleLabel.bounds.height / 2)
    }
    
    
    // MARK: Private methods
    
    func setupSubviews() {
        
        setConstraints()
    }
    
    
    func setConstraints() {
        
//        titleLabel.snp.makeConstraints { (make) in
//            make.center.equalTo(self)
//        }
//        
//        subtitleLabel.snp.makeConstraints { (make) in
//            make.bottom.equalTo(titleLabel.snp.top)
//            make.centerX.equalTo(titleLabel)
//        }
        
    }

}
