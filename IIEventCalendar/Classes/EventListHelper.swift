//
//  EventListHelper.swift
//  EventCalendar
//
//  Created by ice on 2019/10/28.
//  Copyright © 2019 iceboxidev. All rights reserved.
//

import Foundation
import UIKit

class EventListHelper: NSObject {
    weak var delegate: EventListViewController?
    var events: [[DayEvent]]? {
        didSet {
            delegate?.tableView.reloadData()
        }
    }
    
    override init() {
        super.init()
    }
}

extension EventListHelper: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return events?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListTableViewCell") as! EventListTableViewCell
        cell.selectionStyle = .none
        let event = events![indexPath.section][indexPath.row]
        cell.config(with: event)
        return cell
    }
}

extension EventListHelper: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return events?[section].count ?? 0 > 0 ? 31 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "EventListSectionCell") as! EventListSectionCell
        view.config(with: TimeSession(rawValue: section))
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let event = events?[indexPath.section][indexPath.row] {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowEventDetailFromCalendar"), object: nil, userInfo: ["EventID": event.eventID as Any])
        }
    }
}
