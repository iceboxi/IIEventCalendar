//
//  UIViewController+Extension.swift
//  EventCalendar
//
//  Created by ice on 2020/8/13.
//  Copyright © 2020 iceboxidev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    final func showLoading() {
        if view.subviews.first(where: { $0.tag == -10001 }) != nil {
            return
        }

        view.isUserInteractionEnabled = false
        let loadingView = UIView(frame: .zero)
        loadingView.layer.cornerRadius = 10
        loadingView.tag = -10001
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)

        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(indicator)
        indicator.startAnimating()

        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.widthAnchor.constraint(equalToConstant: 60),
            loadingView.heightAnchor.constraint(equalToConstant: 60),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }
    
    final func hideLoading() {
        view.isUserInteractionEnabled = true

        if let loadingView = view.subviews.first(where: { $0.tag == -10001 }) {
            loadingView.removeFromSuperview()
        }
    }
}

extension NSObjectProtocol where Self: UIViewController {
    static func fromStoryboard(_ name: String? = nil, id: String? = nil) -> Self {
        let nameF = name ?? "\(Self.self)"
        let idF = id ?? "\(Self.self)"
        
        let bundle = Bundle(for: Self.self)
        
        guard
            let result = UIStoryboard(name: nameF, bundle: bundle)
                .instantiateViewController(withIdentifier: idF) as? Self
        else {
            fatalError()
        }
        
        return result
    }
}
