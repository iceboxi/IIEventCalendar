//
//  CalendarViewController.swift
//  EventCalendar
//
//  Created by ice on 2019/10/19.
//  Copyright © 2019 iceboxidev. All rights reserved.
//

import UIKit
import JTAppleCalendar

open class CalendarViewController: UIViewController {
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var eventCollectionView: UICollectionView!
    
    @IBOutlet weak var monthEventView: UIView!
    
    private var currect = Date().startOfDay
    private static let selectViewTag = 987
    public var eventManager: EventManager?
    private var visibleDates: DateSegmentInfo!
    
    private let startDate: Date = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        return formatter.date(from: "2018 01 01")!
    }()
    private let endDate: Date = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        return formatter.date(from: "2101 1 1")!
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.scrollDirection = .horizontal
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.allowsMultipleSelection = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateEventComplete(_:)), name: .eventUpdateComplete, object: nil)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func closeVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToToday() {
        currect = Date().startOfDay
        calendarView.selectDates([currect], triggerSelectionDelegate: false)
        calendarView.scrollToDate(currect, animateScroll: true)
    }
}

extension CalendarViewController: JTACMonthViewDataSource {
    public func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfRow,
                                       firstDayOfWeek: .sunday)
    }
}

extension CalendarViewController: JTACMonthViewDelegate {
    public func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! CalendarDateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    public func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    public func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! CalendarDateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        let today = Date()
        header.backView.isHidden = (today >= range.start && today <= range.end)
        return header
    }

    public func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 60)
    }
    
    public func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if cellState.date == currect {
            showDayEventList(cellState.date)
        } else {
            configureCell(view: cell, cellState: cellState)
            currect = cellState.date
            
            guard visibleDates != nil else { return }
            eventCollectionView.reloadData()
        }
    }
    
    public func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    public func calendarDidScroll(_ calendar: JTACMonthView) {
        eventCollectionView.setContentOffset(calendar.contentOffset, animated: false)
    }
    
    public func calendar(_ calendar: JTACMonthView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
    }
    
    public func scrollDidEndDecelerating(for calendar: JTACMonthView) {

    }
    
    public func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.visibleDates = visibleDates
        let date = getDisplayDate(visibleDates)
        fetchCalendar(date.start, end: date.end)
    }
}

extension CalendarViewController {
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? CalendarDateCell else { return }
        let dateString = cellState.date.startOfDay.stringFormat("yyyy-MM-dd")
        cell.configure(with: cellState, events: eventManager?.dayEvents[dateString])
    }
    
    func getDisplayDate(_ visibleDates: DateSegmentInfo) -> (start: Date?, end: Date?) {
        var startDate = visibleDates.monthDates.first?.date
        var endDate = visibleDates.monthDates.last?.date
        if let date = visibleDates.indates.first?.date {
            startDate = date
        }
        if let date = visibleDates.outdates.last?.date {
            endDate = date
        }
        return (startDate, endDate)
    }
    
    func fetchCalendar(_ start: Date?, end: Date?) {
        showLoading()
        eventManager?.fetchCalendar(start, end: end) { [weak self] _ in
            guard let self = self else { return }
            
            self.hideLoading()
            self.reloadData()
            self.calendarView.selectDates([self.currect], triggerSelectionDelegate: false)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CalendarUpdate"), object: nil)
        }
    }
    
    func showDayEventList(_ date: Date) {
        let vc = CalendarEventViewController.fromStoryboard("Calendar")
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        vc.helper.setup(from: startDate, to: endDate)
        vc.helper.currentDate = date
        vc.helper.dayEvents = eventManager?.dayEvents ?? [:]
        self.present(vc, animated: true)
    }
}

extension CalendarViewController {
    func refresh(_ date: Date?) {
        if let date = date {
            currect = date
            calendarView.scrollToDate(date, animateScroll: true)
        }
    }
    
    @objc func updateEventComplete(_ notify: Notification) {
        reloadData()
    }
    
    func reloadData() {
        calendarView.reloadData()
        eventCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: MonthEventCell.self, for: indexPath)
        
        cell.setupEventView(startDate.getMonth(indexPath.row), selected: currect, manager: eventManager ?? EventManager())
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CalendarViewController: UICollectionViewDelegate {
    
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
