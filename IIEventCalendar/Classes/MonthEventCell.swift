//
//  MonthEventCell.swift
//  EventCalendar
//
//  Created by ice on 2020/8/13.
//  Copyright © 2020 iceboxidev. All rights reserved.
//

import UIKit

class MonthEventCell: UICollectionViewCell {
    private struct Magic {
        static let headerHeight: CGFloat = 60 + 25
        static let eventHeight: CGFloat = 20
        static let eventHeightPadding: CGFloat = 2
    }
    
    @IBOutlet weak var monthEventView: UIView!
    
    private let selectViewTag = 987
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cleanEventView()
    }
    
    private func cleanEventView() {
        for view in monthEventView.subviews {
            view.removeFromSuperview()
        }
    }
    
    public func setupEventView(_ monthDate: Date, selected currect: Date, manager: EventManager) {
        let date = getDisplayDate(monthDate)
        if let start = date.start, let end = date.end {
            let (width, height, rowCount) = getItemSize(start, end)
            let maxEventWidth = monthEventView.bounds.width
            
            var displayed: [String] = []
            var dateIndex = start
            while dateIndex <= end {
                let dateString = dateIndex.stringFormat("yyyy-MM-dd")
                
                if let events = manager.dayEvents[dateString] {
                    let limit = Int(floor((height-25)/Magic.eventHeight))
                    let count = max(min(events.count, limit), 0)
                    for index in 0..<count {
                        let event = events[index]
                        if event.eventID?.isEmpty ?? true {
                            continue
                        }
                        if displayed.contains(where: {$0 == event.eventID}) {
                            continue
                        }
                        displayed.append(event.eventID ?? "")
                        var (row, column) = getMapPath(dateIndex, start: start, end: end) ?? (0, 0)
                        
                        let offsetY = Magic.headerHeight + CGFloat(index) * Magic.eventHeight
                        var i = 0
                        var x = CGFloat(column) * width
                        var y = CGFloat(row) * height + CGFloat(offsetY)
                        var leftDay = event.duringDays - event.numberOfDay + 1
                        var eventWidth = min(width * CGFloat(leftDay), maxEventWidth)
                        repeat {
                            let view = EventView(frame: CGRect(x: x, y: y, width: eventWidth, height: Magic.eventHeight - 2 * Magic.eventHeightPadding))
                            view.adjustFrame(with: event, rowIndex: i, weekLeftDay: leftDay)
                            monthEventView.addSubview(view)
                            
                            i += 1
                            x = 0
                            y = CGFloat((row + i) % rowCount) * height + CGFloat(offsetY)
                            leftDay -= (7 - column)
                            column = 0
                            eventWidth = min(width * CGFloat(leftDay), maxEventWidth)
                        } while leftDay > 0 && row + i < rowCount
                    }
                }
                
                dateIndex.nextDay()
            }
            
            drawSelectDate(currect, start: start, end: end)
        }
    }
    
    private func drawSelectDate(_ currect: Date, start: Date, end: Date) {
        monthEventView.viewWithTag(selectViewTag)?.removeFromSuperview()
        
        guard let (row, column) = getMapPath(currect, start: start, end: end) else {
            return
        }

        let magic: CGFloat = 60
        let (width, height, _) = getItemSize(start, end)
        let x = width * CGFloat(column)
        let y = height * CGFloat(row) + magic
        let view = getSelectBordView(frame: CGRect(x: x, y: y, width: width, height: height))
        monthEventView.addSubview(view)
    }

    private func getSelectBordView(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor(rgba: "#5ccf9999").cgColor
        view.layer.borderWidth = 1
        view.tag = selectViewTag
        return view
    }
    
    typealias ItemSizeInfo = (width: CGFloat, height: CGFloat, rowCount: Int)
    private func getItemSize(_ start: Date, _ end: Date) -> ItemSizeInfo {
        let magic = 60
        let count = start.days(between: end) + 1
        let height = self.frame.height - CGFloat(magic)
        let width = self.frame.width
        if count == 35 {
            return (width/7, height/5, 5)
        } else if count == 42 {
            return (width/7, height/6, 6)
        }
        return (0, 0, 0)
    }
    
    private func getDisplayDate(_ monthDate: Date) -> (start: Date?, end: Date?) {
        return (monthDate.startDateOfMonth.startOfWeek, monthDate.endDateOfMonth.endOfWeek)
    }

    private func getMapPath(_ date: Date, start: Date, end: Date) -> (row: Int, column: Int)? {
        guard date >= start, date <= end else {
            return nil
        }
        
        let index = start.days(between: date)
        return (index/7, index%7)
    }
}
