//
//  CalendarEventHelper.swift
//  EventCalendar
//
//  Created by ice on 2019/10/25.
//  Copyright © 2019 iceboxidev. All rights reserved.
//

import UIKit

class CalendarEventHelper: NSObject {
    var dayEvents: [String: [DayEvent]] = [:]
    var startDate: Date?
    var endDate: Date?
    var currentDate: Date?
    var creatable: Bool = true
    private var days: Int = 0
    
    weak var delegate: CalendarEventViewController?
    
    func setup(from start: Date, to end: Date) {
        startDate = start
        endDate = start
        let components = Calendar.current.dateComponents([.day], from: start, to: end)
        days = (components.day ?? 0) + 1
    }
    
    override init() {
        super.init()
    }
}

extension CalendarEventHelper: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! CalendarEventViewCell
        if let date = startDate?.dateByAddDays(indexPath.row) {
            let dateString = date.startOfDay.stringFormat("yyyy-MM-dd")
            cell.config(with: date, events: dayEvents[dateString])
            cell.createButton.isHidden = !creatable
        }
        return cell
    }
}

extension CalendarEventHelper: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            var rows: [Int] = []
            for cell in collectionView.visibleCells {
                if let indexPath = collectionView.indexPath(for: cell) {
                    rows.append(indexPath.row)
                }
            }
            
            if rows.count > 2 {
                currentDate = startDate?.dateByAddDays(rows.sorted()[1])
                
                delegate?.showLoading()
                delegate?.delegate?.eventManager?.fetchCalendar(currentDate) { (status) in
                    DispatchQueue.main.async {
                        if status == .success {
                            self.dayEvents = self.delegate?.delegate?.eventManager?.dayEvents ?? [:]
                            collectionView.reloadData()
                        }
                        
                        self.delegate?.hideLoading()
                    }
                }
            }
        }
    }
}

public final class PagingFlowLayout: UICollectionViewFlowLayout {
    public var edgeInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    override public var itemSize: CGSize {
        get {
            guard let collectionView = collectionView else { return .zero }
            return CGSize(width: collectionView.bounds.width - minimumLineSpacing*2 - edgeInset.left - edgeInset.right, height: collectionView.bounds.height - sectionInset.top - sectionInset.bottom)
        }
        set {
            assertionFailure("Don't set by yourself\(newValue)")
        }
    }

    public override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        minimumLineSpacing = 12
    }

    override public func invalidateLayout() {
        super.invalidateLayout()
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: edgeInset.top, left: minimumLineSpacing + edgeInset.left, bottom: edgeInset.bottom, right: minimumLineSpacing + edgeInset.right)
    }

    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let pageWidth = itemSize.width + minimumLineSpacing
        if abs(velocity.x) > 0.2 {
            let nextPage = velocity.x > 0 ?
                ceil(proposedContentOffset.x / pageWidth) :
                floor(proposedContentOffset.x / pageWidth)
            return CGPoint(x: nextPage * pageWidth, y: proposedContentOffset.y)
        } else {
            let currentPage = round(proposedContentOffset.x / pageWidth)
            return CGPoint(x: currentPage * pageWidth, y: proposedContentOffset.y)
        }
    }
}
