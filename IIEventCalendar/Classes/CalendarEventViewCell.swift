//
//  CalendarEventViewCell.swift
//  EventCalendar
//
//  Created by ice on 2019/10/25.
//  Copyright © 2019 iceboxidev. All rights reserved.
//

import UIKit

class CalendarEventViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var holidayLabel: UILabel!
    @IBOutlet weak var eventListView: UIView!
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var createButton: UIButton!
    
    var outlet = EventListViewController(nibName: "EventListViewController", bundle: Bundle(for: EventListViewController.self))
    var events: [DayEvent]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 10.0
        self.containerView.layer.masksToBounds = true
        setupEventListView()
    }
    
    final func setupEventListView() {
        outlet.view.translatesAutoresizingMaskIntoConstraints = false
        eventListView.addSubview(outlet.view)
        outlet.view.topAnchor.anchor(eventListView.topAnchor)
        outlet.view.leadingAnchor.anchor(eventListView.leadingAnchor)
        outlet.view.bottomAnchor.anchor(eventListView.bottomAnchor)
        outlet.view.trailingAnchor.anchor(eventListView.trailingAnchor)
    }
    
    func config(with date: Date, events: [DayEvent]?) {
        dateLabel.text = date.stringFormat("yyyy年M月d日")
        
        holidayLabel.text = events?.filter({$0.style == .holiday}).reduce("", { (r, e) -> String in
            if r.isEmpty {
                return e.name ?? ""
            }
            return r + ", " + (e.name ?? "")
        })
        
        let filter = events?.filter({$0.style != .holiday})
        
        var result: [[DayEvent]] = [[], [], [], [], []]
        var anyEvent = false
        for event in filter ?? [] where event.color != .clear {
            result[event.session.rawValue].append(event)
            anyEvent = true
        }
        
        outlet.helper.events = result
        emptyView.isHidden = anyEvent
    }
}

@objc extension NSLayoutAnchor {
    @discardableResult
    final func anchor(
        _ anchor: NSLayoutAnchor,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        var result: NSLayoutConstraint

        switch relation {
        case .equal:
            result = constraint(equalTo: anchor)
        case .greaterThanOrEqual:
            result = constraint(greaterThanOrEqualTo: anchor)
        case .lessThanOrEqual:
            result = constraint(lessThanOrEqualTo: anchor)
        @unknown default:
            result = constraint(equalTo: anchor)
        }

        result.isActive = true
        return result
    }
}
