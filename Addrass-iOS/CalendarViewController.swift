//
//  CalendarViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 17/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import SnapKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    // MARK: Constants
    
    private static let monthDayIdentifier = "MonthCell"
    
    // MARK: Variables
    
    var calendarView: FSCalendar?
    
    // MARK: VCL

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String.ad.calendar

        setupSubviews()
    }

    
    // MARK: Private Methods
    
    func setupSubviews() {
        
        calendarView = FSCalendar()
        calendarView?.delegate = self
        calendarView?.register(FSCalendarCell.self, forCellReuseIdentifier: CalendarViewController.monthDayIdentifier)
        view.addSubview(calendarView!)
        
        setConstraints()
    }
    
    
    func setConstraints() {
        calendarView?.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    
    // MARK: FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: CalendarViewController.monthDayIdentifier, for: date, at: position)
        return cell
    }
    
    
    // MARK: FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        
    }

}
