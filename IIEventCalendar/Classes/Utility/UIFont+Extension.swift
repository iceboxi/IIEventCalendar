//
//  UIFont+Extension.swift
//  EventCalendar
//
//  Created by ice on 2020/8/13.
//  Copyright © 2020 iceboxidev. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    func sizeOfString(_ string: String, containedSize: CGSize) -> CGSize {
        return NSString(string: string).boundingRect(with: containedSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self], context: nil).size
    }
    
    static func fontPingFang(_ size: CGFloat, weight: UIFont.Weight) -> UIFont {
        var name: String = "PingFangTC-Regular"
        switch weight {
        case UIFont.Weight.thin:
            name = "PingFangTC-Thin"
        case UIFont.Weight.medium:
            name = "PingFangTC-Medium"
        case UIFont.Weight.semibold:
            name = "PingFangTC-Semibold"
        case UIFont.Weight.light:
            name = "PingFangTC-Light"
        case UIFont.Weight.ultraLight:
            name = "PingFangTC-Ultralight"
        default:
            break
        }
        
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
