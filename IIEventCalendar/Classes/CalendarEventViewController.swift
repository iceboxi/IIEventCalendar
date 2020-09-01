//
//  CalendarEventViewController.swift
//  EventCalendar
//
//  Created by ice on 2019/10/25.
//  Copyright © 2019 iceboxidev. All rights reserved.
//

import UIKit

class CalendarEventViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let helper = CalendarEventHelper()
    weak var delegate: CalendarViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = PagingFlowLayout()
        layout.minimumLineSpacing = 15
        layout.edgeInset = UIEdgeInsets(top: 10, left: 15, bottom: 15, right: 15)
//        collectionView.decelerationRate = .fast
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = helper
        collectionView.delegate = helper
        helper.delegate = self
        helper.creatable = !hideCreateButtonIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showEventDetail(notification:)), name: NSNotification.Name(rawValue: "ShowEventDetailFromCalendar"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateEventComplete(_:)), name: .eventUpdateComplete, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateEventComplete(_:)), name: NSNotification.Name(rawValue: "CalendarUpdate"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let start = helper.startDate, let current = helper.currentDate {
            let index = current.days(after: start)
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard self.presentedViewController == nil else {
            return
        }
        closeVC()
    }
    
    func hideCreateButtonIfNeeded() -> Bool {
        return true
    }
    
    func closeVC() {
        (delegate ?? self).dismiss(animated: true, completion: { [weak self] in
            self?.delegate?.eventManager?.reset()
            self?.delegate?.refresh(self?.helper.currentDate)
        })
    }
    
    @IBAction func createCalendar() {
        
    }
}

private extension CalendarEventViewController {
    @objc func showEventDetail(notification: Notification) {
        if notification.userInfo?["EventID"] is String {
            DispatchQueue.main.async {
                print("Show detail")
            }
        }
    }
    
    @objc func updateEventComplete(_ notify: Notification) {
        helper.dayEvents = delegate?.eventManager?.dayEvents ?? [:]
        collectionView.reloadData()
    }
}
