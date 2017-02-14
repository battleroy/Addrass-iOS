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

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    // MARK: Constants
    
    private static let weekDaysCollectionCount = 5
    private static let notTodayCellHeight: CGFloat = 70.0
    private static let todayCellHeight: CGFloat = 80.0
    
    
    // MARK: Variables
    
    var leftBarButtonItem: UIBarButtonItem!
    var rightBarButtonItem: UIBarButtonItem!
    
    var calendarView: FSCalendar!
    var weekCollectionView: UICollectionView!
    var eventsTableView: UITableView!
    
    var currentWeekDaysCache: [Date]!
    
    var eventsByDay: [Date : [Event]]?
    
    // MARK: Properties
    
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
    
    lazy var dayShortNameDateFormatter: DateFormatter! = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM";
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
        
        updateView()
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
        weekCollectionView.allowsMultipleSelection = false
        weekCollectionView.backgroundColor = UIColor.ad.gray
        weekCollectionView.reloadData()
        
        view.addSubview(weekCollectionView)
        
        
        eventsTableView = UITableView()
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.cellIdentifier)
        eventsTableView.isHidden = true
        eventsTableView.tableFooterView = UIView()
        eventsTableView.backgroundColor = UIColor.ad.gray
        
        view.addSubview(eventsTableView)
        
        
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
        
        
        eventsTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(weekCollectionView.snp.bottom)
        }
    }
    
    
    func updateNavigationBarTitle() {
        var title: String!
        
        if calendarView.isHidden {
            title = String.ad.events
        } else {
            title = titleDateFormatter.string(from: calendarView.currentPage)
        }
        
        navigationItem.title = title
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
    
    
    func switchShowMode() {
        UIView.animate(
            withDuration: 0.2, animations: {
                self.weekCollectionView.alpha = 0.0
                self.calendarView.alpha = 0.0
                self.eventsTableView.alpha = 0.0
            }, completion: { (isCompleted) in
                if isCompleted {
                    let isMonthShowing = !self.calendarView.isHidden
                    
                    self.calendarView.isHidden = isMonthShowing
                    self.weekCollectionView.isHidden = !isMonthShowing
                    self.eventsTableView.isHidden = !isMonthShowing
                    self.updateDatesArray(self.calendarView.selectedDate)
                    self.updateLeftBarButtonItemTitle()
                    self.updateNavigationBarTitle()
                    
                    let appearanceTime = DispatchTime.now() + 0.1
                    DispatchQueue.main.asyncAfter(deadline: appearanceTime, execute: {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.weekCollectionView.reloadData()
                            let selectedIndexPath = IndexPath(item: self.currentWeekDaysCache.count / 2, section: 0)
                            self.weekCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
                            
                            self.weekCollectionView.alpha = 1.0
                            self.calendarView.alpha = 1.0
                            self.eventsTableView.alpha = 1.0
                        })
                    })
                }
            }
        )
    }
    
    
    func updateView() {
        updateNavigationBarTitle()
        updateLeftBarButtonItemTitle()
        
        var deltaMonthDateComponents = DateComponents()
        deltaMonthDateComponents.month = 1
        deltaMonthDateComponents.day = -1
        
        let lastDayOfPage = Calendar.current.date(byAdding: deltaMonthDateComponents, to: calendarView.currentPage)!
        
        eventsByDay = nil
        APIManager.events(fromDate: calendarView.currentPage, to: lastDayOfPage) {
            (fetchedEvents, errorText) in
            guard let events = fetchedEvents else {
                return
            }
            
            self.eventsByDay = Event.eventsGroupedByDate(events)
            self.calendarView.reloadData()
        }
    }
    
    
    // MARK: FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: CalendarMonthDayCell.cellIdentifier, for: date, at: position) as! CalendarMonthDayCell
        cell.eventIndicator.color = UIColor.red
        return cell
    }
    
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return dayNumberDateFormatter.string(from: date)
    }
    
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return weekdayDateFormatter.string(from: date).uppercased()
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        guard let events = self.eventsByDay, let dayEvents = events[date] else {
            return 0
        }
        
        return dayEvents.count
    }
    
    
    // MARK: FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        switchShowMode()
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
        cell.dayMonth.text = dayShortNameDateFormatter.string(from: cellDate).uppercased()
        
        return cell
    }
    
    
    // MARK: UICollectionDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.bounds.width / CGFloat(CalendarViewController.weekDaysCollectionCount)
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
        if (scrollView == weekCollectionView) {
        
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
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        calendarView.select(currentWeekDaysCache[indexPath.item])
        flowLayout.invalidateLayout()
    }
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.cellIdentifier, for: indexPath) as! EventTableViewCell
        
        cell.eventTitleLabel.text = "Title"
        cell.eventTimeLabel.text = "12:00"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EventTableViewCell.cellHeight()
    }
    
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    // MARK: Actions
    
    func barButtonItemWasPressed(_ sender: UIBarButtonItem) {
        if (sender == leftBarButtonItem) {
            switchShowMode()
        } else if (sender == rightBarButtonItem) {
            let newEventVC = EventEditViewController()
            navigationController?.pushViewController(newEventVC, animated: true)
        }
    }

}
