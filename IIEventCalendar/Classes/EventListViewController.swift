//
//  EventListViewController.swift
//  EventCalendar
//
//  Created by ice on 2019/10/28.
//  Copyright © 2019 iceboxidev. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let helper = EventListHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        helper.delegate = self
        tableView.dataSource = helper
        tableView.delegate = helper
    }
    
    func registerCell() {
        var bundle = Bundle(for: EventListTableViewCell.self)
        let nib = UINib(nibName: "EventListTableViewCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "EventListTableViewCell")
        
        bundle = Bundle(for: EventListSectionCell.self)
        let nib2 = UINib(nibName: "EventListSectionCell", bundle: bundle)
        tableView.register(nib2, forHeaderFooterViewReuseIdentifier: "EventListSectionCell")
    }
}
