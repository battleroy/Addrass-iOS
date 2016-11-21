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

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FSCalendarDataSource, FSCalendarDelegate {
    
    // MARK: Constants
    
    private static let weekDaysCollectionCount = 5
    private static let notTodayCellHeight: CGFloat = 70.0
    private static let todayCellHeight: CGFloat = 80.0
    
    
    // MARK: Variables
    
    var leftBarButtonItem: UIBarButtonItem!
    var rightBarButtonItem: UIBarButtonItem!
    
    var calendarView: FSCalendar!
    var weekCollectionView: UICollectionView!
    
    var currentWeekDaysCache: [Date]!
    
    lazy var flowLayout: CalendarWeekDaysCollectionViewLayout! = {
        let layout = CalendarWeekDaysCollectionViewLayout()
        
        layout.scrollDirection = .horizontal
        
        return layout
    }()
    
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
        edgesForExtendedLayout = []
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
        updateDatesArray(calendarView.selectedDate)
        
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
        
        
        weekCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        weekCollectionView.dataSource = self
        weekCollectionView.delegate = self
        weekCollectionView.register(CalendarWeekDayCell.self, forCellWithReuseIdentifier: CalendarWeekDayCell.cellIdentifier)
        weekCollectionView.isHidden = true
        weekCollectionView.showsHorizontalScrollIndicator = false
        weekCollectionView.bounces = true
        weekCollectionView.reloadData()
        weekCollectionView.scrollToItem(at: IndexPath(item: currentWeekDaysCache.count / 2, section: 0), at: .centeredHorizontally, animated: false)
        
        view.addSubview(weekCollectionView)
        
        
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
        
        
        weekCollectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(CalendarViewController.todayCellHeight)
        }
    }
    
    
    func updateNavigationBarTitle() {
        navigationItem.title = titleDateFormatter.string(from: calendarView.currentPage)
    }
    
    
    func updateLeftBarButtonItemTitle() {
        var title: String!
        
        if calendarView.isHidden {
            title = String.ad.toMonth
        } else {
            title = String.ad.toWeek
        }
        
        leftBarButtonItem.title = title
    }
    
    
    func updateDatesArray(_ centerDate: Date) {
        currentWeekDaysCache = []
        let arrayLength = 3 * CalendarViewController.weekDaysCollectionCount
        
        for i in 0..<arrayLength {
            let dateElement = centerDate.addingTimeInterval(60.0 * 60.0 * 24.0 * Double(i - arrayLength / 2))
            currentWeekDaysCache.append(dateElement)
        }
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
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentWeekDaysCache.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarWeekDayCell.cellIdentifier, for: indexPath) as! CalendarWeekDayCell
        
        let cellDate = currentWeekDaysCache[indexPath.item]
        
        if (cellDate == calendarView.selectedDate) {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        
        cell.dayName.text = weekdayDateFormatter.string(from: cellDate)
        cell.dayNumber.text = dayNumberDateFormatter.string(from: cellDate)
        cell.dayMonth.text = titleDateFormatter.string(from: cellDate).uppercased()
        
        return cell
    }
    
    
    // MARK: UICollectionDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width / CGFloat(CalendarViewController.weekDaysCollectionCount)
        var height: CGFloat
        
        let cellDate = currentWeekDaysCache[indexPath.item]
        
        if (cellDate == calendarView.selectedDate) {
            height = CalendarViewController.todayCellHeight
        } else {
            height = CalendarViewController.notTodayCellHeight
        }
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
        
    }
    
    
    // MARK: UICollectionViewDelegate
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentFullyScrolledToRightOffset = weekCollectionView.frame.width * 2
        
        if (scrollView.contentOffset.x == contentFullyScrolledToRightOffset) {
            updateDatesArray(currentWeekDaysCache[currentWeekDaysCache.count - 1 - CalendarViewController.weekDaysCollectionCount / 2])
            weekCollectionView.reloadData()
            weekCollectionView.scrollToItem(at: IndexPath(item: currentWeekDaysCache.count / 2, section: 0), at: .centeredHorizontally, animated: false)
        } else if (scrollView.contentOffset.x == 0) {
            updateDatesArray(currentWeekDaysCache[CalendarViewController.weekDaysCollectionCount / 2])
            weekCollectionView.reloadData()
            weekCollectionView.scrollToItem(at: IndexPath(item: currentWeekDaysCache.count / 2, section: 0), at: .centeredHorizontally, animated: false)
        }
        
    }
    
    
    // MARK: Actions
    
    func barButtonItemWasPressed(_ sender: UIBarButtonItem) {
        if (sender == leftBarButtonItem) {
            UIView.animate(
                withDuration: 0.2, animations: {
                self.weekCollectionView.alpha = 0.0
                self.calendarView.alpha = 0.0
                }, completion: { (isCompleted) in
                    if isCompleted {
                        let isMonthShowing = !self.calendarView.isHidden
                        
                        self.calendarView.isHidden = isMonthShowing
                        self.weekCollectionView.isHidden = !isMonthShowing
                        
                        self.updateLeftBarButtonItemTitle()
                        let appearanceTime = DispatchTime.now() + 0.1
                        DispatchQueue.main.asyncAfter(deadline: appearanceTime, execute: { 
                            UIView.animate(withDuration: 0.2, animations: {
                                self.weekCollectionView.reloadData()
                                self.weekCollectionView.alpha = 1.0
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
