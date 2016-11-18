//
//  CalendarViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 17/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    // MARK: Constants
    
    
    // MARK: Variables
    
    var leftBarButtonItem: UIBarButtonItem!
    var rightBarButtonItem: UIBarButtonItem!
    
    var calendarView: FSCalendar!
    
    lazy var dayNumberDateFormatter: DateFormatter! = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd";
        formatter.locale = Locale.current
        return formatter
    }()
    
    lazy var weekdayDateFormatter: DateFormatter! = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE";
        formatter.locale = Locale.current
        return formatter
    }()
    
    
    lazy var titleDateFormatter: DateFormatter! = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy";
        formatter.locale = Locale.current
        return formatter
    }()
    
    
    // MARK: VCL

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ad.gray

        setupSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationBarTitle()
        updateLeftBarButtonItemTitle()
    }

    
    // MARK: Private Methods
    
    func setupSubviews() {
        
        calendarView = FSCalendar()
        calendarView.clipsToBounds = true
        calendarView.backgroundColor = UIColor.ad.gray
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.register(CalendarMonthDayCell.self, forCellReuseIdentifier: CalendarMonthDayCell.cellIdentifier)
        calendarView.firstWeekday = 2
        calendarView.headerHeight = 0.0
        calendarView.weekdayHeight = 0.0
        calendarView.allowsMultipleSelection = false
        calendarView.select(Date())
        
        let appearance = calendarView.appearance
        appearance.adjustsFontSizeToFitContentSize = false
        appearance.titleFont = UIFont.ad.calendarNumbersFont
        appearance.subtitleFont = UIFont.ad.smallFont
        appearance.titleDefaultColor = UIColor.ad.white
        appearance.subtitleDefaultColor = UIColor.ad.white
        appearance.titleTodayColor = UIColor.ad.darkGray
        appearance.subtitleTodayColor = UIColor.ad.darkGray
        appearance.selectionColor = UIColor.ad.yellow
        appearance.titleSelectionColor = UIColor.ad.darkGray
        appearance.subtitleSelectionColor = UIColor.ad.darkGray
        appearance.borderRadius = 0.5
        appearance.todayColor = UIColor.ad.lightGray
        
        view.addSubview(calendarView)
        
        leftBarButtonItem = UIBarButtonItem(title: String.ad.toMonth, style: .done, target: self, action: #selector(barButtonItemWasPressed(_:)))
        rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(barButtonItemWasPressed(_:)))
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        setConstraints()
    }
    
    
    func setConstraints() {
        calendarView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.8)
        }
    }
    
    
    func updateNavigationBarTitle() {
        title = titleDateFormatter.string(from: calendarView.currentPage)
    }
    
    
    func updateLeftBarButtonItemTitle() {
        var title: String!
        
        switch calendarView.scope {
        case .month:
            title = String.ad.toWeek
            break
        case .week:
            title = String.ad.toMonth
            break
        }
        
        leftBarButtonItem.title = title
    }
    
    
    // MARK: FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: CalendarMonthDayCell.cellIdentifier, for: date, at: position) as! CalendarMonthDayCell
        
        return cell
    }
    
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return dayNumberDateFormatter.string(from: date)
    }
    
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return weekdayDateFormatter.string(from: date).uppercased()
    }
    
    
    // MARK: FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateNavigationBarTitle()
    }
    
    
    // MARK: Actions
    
    func barButtonItemWasPressed(_ sender: UIBarButtonItem) {
        if (sender == leftBarButtonItem) {
            UIView.animate(
                withDuration: 0.2, animations: {
                self.calendarView.alpha = 0.0
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.calendarView.scope = (self.calendarView.scope == .month) ? .week : .month
                        self.updateLeftBarButtonItemTitle()
                        let appearanceTime = DispatchTime.now() + 0.1
                        DispatchQueue.main.asyncAfter(deadline: appearanceTime, execute: { 
                            UIView.animate(withDuration: 0.2, animations: {
                                self.calendarView.alpha = 1.0
                            })
                        })
                    }
                }
            )
        } else if (sender == rightBarButtonItem) {
            
        }
    }

}
