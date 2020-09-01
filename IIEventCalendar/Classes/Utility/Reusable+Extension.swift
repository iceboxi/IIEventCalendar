//
//  Reusable+Extension.swift
//  EventCalendar
//
//  Created by ice on 2020/8/13.
//  Copyright © 2020 iceboxidev. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: type),
                                   for: indexPath) as! T
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: type),
                                   for: indexPath) as! T
    }
}
