//
//  ViewController.swift
//  IIEventCalendar
//
//  Created by ice on 08/26/2020.
//  Copyright (c) 2020 ice. All rights reserved.
//

import UIKit
import IIEventCalendar

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func click() {
        let storyboardBundle = Bundle(for: CalendarViewController.self)
        let storyboard = UIStoryboard(name: "Calendar", bundle: storyboardBundle)
        if let nav = storyboard.instantiateViewController(identifier: "main") as? UINavigationController {
            let vc = nav.visibleViewController as? CalendarViewController
            vc?.title = "行事曆"
            vc?.eventManager = CalendarEventManager.shared
            present(nav, animated: true, completion: nil)
        }
    }
}
