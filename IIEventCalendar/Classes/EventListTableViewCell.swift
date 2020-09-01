//
//  EventListTableViewCell.swift
//  EventCalendar
//
//  Created by ice on 2019/10/28.
//  Copyright © 2019 iceboxidev. All rights reserved.
//

import UIKit

class EventListTableViewCell: UITableViewCell {
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var bordView: UIView! {
        didSet {
            bordView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var alertIcon: UIImageView!
    @IBOutlet weak var repeatIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var groupInfoView: UIView!
    @IBOutlet weak var groupLabel: UILabel!
    
    var event: DayEvent?
    private var apiStatus: APIStatus = .none

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(with event: DayEvent) {
        self.event = event
        startView.backgroundColor = event.color
        let color = CalendarColor.getType(event.color)
        if event.style == .allDay {
            bordView.backgroundColor = color.backgroundColor()
            bordView.layer.borderColor = color.backgroundColor().cgColor
        } else if event.style == .halfDay {
            bordView.backgroundColor = .white
            bordView.layer.borderColor = color.bordColor().cgColor
        }
        alertIcon.isHidden = !(event.isAlert && event.isJoin)
        titleLabel.text = event.destription
        dateLabel.text = event.timeInterval
        
        groupLabel.text = event.name
        groupInfoView.isHidden = false
    }
    
    @IBAction func joinOrCancel(_ sender: UIButton) {
        guard apiStatus == .none else {
            return
        }
        
        apiStatus = .start
        if let event = event {
            if event.isJoin {
                quit(from: event)
            } else {
                join(to: event)
            }
        }
    }
    
    private func quit(from event: DayEvent) {
        guard let id = event.eventID else { return apiStatus = .none }
        
        let model = EventNotify(eventID: id, isJoin: false)
        NotificationCenter.default.post(name: .eventUpdate, object: nil, userInfo: ["event": model])
        apiStatus = .none
    }
    
    private func join(to event: DayEvent) {
        guard let id = event.eventID else { return apiStatus = .none }
        
        let model = EventNotify(eventID: id, isJoin: true)
        NotificationCenter.default.post(name: .eventUpdate, object: nil, userInfo: ["event": model])
        apiStatus = .none
    }
}
