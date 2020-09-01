//
//  EventListSectionCell.swift
//  EventCalendar
//
//  Created by ice on 2019/10/29.
//  Copyright © 2019 iceboxidev. All rights reserved.
//

import UIKit

class EventListSectionCell: UITableViewHeaderFooterView {
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func config(with session: TimeSession?) {
        timeLabel.isHidden = false
        switch session {
        case .allDay:
            sessionLabel.text = "全天"
            timeLabel.isHidden = true
        case .middleNight:
            sessionLabel.text = "深夜"
            timeLabel.text = "上午12:00-上午05:59"
        case .morning:
            sessionLabel.text = "上午"
            timeLabel.text = "上午06:00-上午11:59"
        case .afternoon:
            sessionLabel.text = "下午"
            timeLabel.text = "下午12:00-下午05:59"
        case .night:
            sessionLabel.text = "晚上"
            timeLabel.text = "下午06:00-下午11:59"
        default:
            break
        }
    }
}
