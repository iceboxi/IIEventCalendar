//
//  CalendarDateCell.swift
//  EventCalendar
//
//  Created by ice on 2019/10/21.
//  Copyright © 2019 iceboxidev. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarDateCell: JTACDayCell {
    @IBOutlet weak var dateBackgroundView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var borderView: UIView! {
        didSet {
            borderView.layer.borderColor = UIColor(rgba: "#f2f8ff").cgColor
            borderView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var eventCountBackgroundView: UIView!
    @IBOutlet weak var eventCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with cellState: CellState, events: [DayEvent]?) {
        dateLabel.text = cellState.text
        handleContentColor(with: cellState)
        handleEventCount(events)
    }
    
    func setupEventCount(_ count: Int) {
        if count > 0 {
            eventCountLabel.text = "+\(count)"
            eventCountLabel.isHidden = false
            eventCountBackgroundView.isHidden = false
        } else {
            eventCountLabel.isHidden = true
            eventCountBackgroundView.isHidden = true
        }
    }
    
    private func handleContentColor(with cellState: CellState) {
        dateLabel.font = UIFont.fontPingFang(10, weight: .regular)
        if cellState.dateBelongsTo == .thisMonth {
            if cellState.day == .sunday {
                dateLabel.textColor = UIColor(rgba: "#d65757")
            } else if cellState.day == .saturday {
                dateLabel.textColor = UIColor(rgba: "#ff7200")
            } else {
                dateLabel.textColor = UIColor(rgba: "#2f3c4b")
            }
        } else {
            dateLabel.textColor = UIColor(rgba: "#b2c3d9")
        }
        
        contentView.backgroundColor = .white
        if cellState.isSelected {
            if cellState.date.endOfDay != Date().endOfDay {
                dateLabel.font = UIFont.fontPingFang(10, weight: .semibold)
                dateLabel.textColor = UIColor(rgba: "#5ccf99")
            }
            contentView.backgroundColor = UIColor(rgba: "#f2f8ff")
        }
        
        if cellState.date.endOfDay == Date().endOfDay {
            dateBackgroundView.backgroundColor = UIColor(rgba: "#5ccf99")
            dateLabel.textColor = .white
        } else {
            dateBackgroundView.backgroundColor = .clear
        }
    }
    
    private func handleEventCount(_ events: [DayEvent]?) {
        if let events = events {
            let eventHeight: CGFloat = 20.0
            let stackViewHeight: CGFloat = frame.size.height-25.0
            let limit = Int(floor(stackViewHeight/eventHeight))
            let count = min(limit, events.count)
            setupEventCount(calculateDisplayCount(events, max: count))
        } else {
            setupEventCount(0)
        }
    }
    
    private func calculateDisplayCount(_ events: [DayEvent], max: Int) -> Int {
        if max > events.count {
            return 0
        }
        
        var result = 0
        for i in max..<events.count {
            let e = events[i]
            if e.color != .clear {
                result += 1
            }
        }
        return result
    }
}

class CalendarDateHeader: JTACMonthReusableView {
    @IBOutlet var monthTitle: UILabel!
    @IBOutlet var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach({
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        })
    }
}
