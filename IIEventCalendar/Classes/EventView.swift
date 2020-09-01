//
//  EventView.swift
//  EventCalendar
//
//  Created by ice on 2019/10/21.
//  Copyright © 2019 iceboxidev. All rights reserved.
//

import UIKit

class EventView: UIView {
    var view: UIView!
    
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var endView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var topBordView: UIView!
    @IBOutlet weak var bottomBordView: UIView!
    
    @IBOutlet weak var repeatView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    
    // MARK: -
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupXib() {
        self.backgroundColor = .white
        view = loadViewFromNib()
        if let view = view {
            self.addSubview(view)
            layoutAttachAll(from: view, to: self)
        }
    }
    
    private func layoutAttachAll(from childView: UIView, to superView: UIView) {
        NSLayoutConstraint.activate([
            childView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            childView.topAnchor.constraint(equalTo: superView.topAnchor),
            childView.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
            ])
        layoutSubviews()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EventView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else { fatalError("cast to UIView Fail") }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    // MARK: -
    func config(with event: DayEvent) {
        backgroundColor = event.color == .clear ? .clear : .white
        contentView.backgroundColor = .clear
        
        startView.backgroundColor = event.color
        repeatView.backgroundColor = event.color
        repeatView.isHidden = true
        startView.isHidden = event.status != .begin
        titleLabel.text = event.destription
        
        let textColor = event.style == .holiday ? UIColor.white : UIColor(r: 39, g: 41, b: 43)
        titleLabel.textColor = textColor
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = event.style == .holiday ? 2 : 0
        
        let color = CalendarColor.getType(event.color)
        switch event.style {
        case .halfDay:
            view.backgroundColor = .white
            topBordView.backgroundColor = color.bordColor()
            bottomBordView.backgroundColor = color.bordColor()
            if event.status == .begin {
                if event.duringDays == 1 {
                    endView.backgroundColor = color.bordColor()
                } else {
                    endView.backgroundColor = .clear
                }
            } else if event.status == .during {
                endView.backgroundColor = .clear
                if event.duringDays == 1 {
                    endView.backgroundColor = color.bordColor()
                }
            } else if event.status == .end {
                endView.backgroundColor = color.bordColor()
            }
        case .allDay:
            view.backgroundColor = color.backgroundColor()
            endView.backgroundColor = color.backgroundColor()
            topBordView.backgroundColor = color.backgroundColor()
            bottomBordView.backgroundColor = color.backgroundColor()
        case .holiday:
            view.backgroundColor = .white
            contentView.backgroundColor = color.backgroundColor()
            endView.backgroundColor = color.backgroundColor()
            topBordView.backgroundColor = color.backgroundColor()
            bottomBordView.backgroundColor = color.backgroundColor()
        }
    }
}

extension EventView {
    func adjustFrame(with event: DayEvent, rowIndex: Int, weekLeftDay: Int) {
        var copyEvent = event
        if rowIndex != 0 {
            copyEvent.status = .during
        }
        if weekLeftDay <= 7 {
            if rowIndex != 0 {
                copyEvent.status = .end
                frame.size.width -= 4
            } else {
                copyEvent.duringDays = 1
                frame.size.width -= 4
            }
        }
        if copyEvent.status == .begin {
            frame.origin.x += 4
            frame.size.width -= 4
        }
        config(with: copyEvent)
        
        if rowIndex != 0 {
            titleLabel.text = ""
        }
    }
}

enum CalendarColor {
    case unknown
    case yellow
    case red
    case blue
    case green
    case purple
    case orange
    case holiday
    
    static func getType(_ color: UIColor) -> CalendarColor {
        switch color {
        case UIColor(rgba: "#0076f2"):
            return .yellow
        case UIColor(rgba: "#38ffff"):
            return .red
        case UIColor(rgba: "#3876f2"):
            return .blue
        case UIColor(rgba: "#387600"):
            return .green
        case UIColor(rgba: "#9276f2"):
            return .purple
        case .orange:
            return .orange
        case UIColor(rgba: "#d65757"):
            return .holiday
        default:
            return .unknown
        }
    }
    
    func backgroundColor() -> UIColor {
        switch self {
        case .yellow:
            return UIColor(r: 249, g: 243, b: 223)
        case .red:
            return UIColor(r: 248, g: 231, b: 236)
        case .blue:
            return UIColor(r: 231, g: 245, b: 246)
        case .green:
            return UIColor(r: 238, g: 243, b: 232)
        case .purple:
            return UIColor(r: 235, g: 232, b: 241)
        case .orange:
            return UIColor(r: 249, g: 237, b: 226)
        case .holiday:
            return UIColor(r: 214, g: 87, b: 87)
        default:
            return .clear
        }
    }
    
    func bordColor() -> UIColor {
        switch self {
        case .yellow:
            return UIColor(r: 250, g: 235, b: 186)
        case .red:
            return UIColor(r: 247, g: 204, b: 216)
        case .blue:
            return UIColor(r: 205, g: 238, b: 241)
        case .green:
            return UIColor(r: 221, g: 234, b: 208)
        case .purple:
            return UIColor(r: 214, g: 207, b: 230)
        case .orange:
            return UIColor(r: 250, g: 221, b: 192)
        case .holiday:
            return UIColor(r: 214, g: 87, b: 87)
        default:
            return .clear
        }
    }
    
    func contentBordColor() -> UIColor {
        switch self {
        case .unknown:
            return .clear
        default:
            return UIColor(rgba: "#f2f8ff")
        }
    }
    
    func selectedBordColor() -> UIColor {
        switch self {
        case .yellow:
            return UIColor(r: 155, g: 221, b: 181)
        case .red:
            return UIColor(r: 154, g: 217, b: 186)
        case .blue:
            return UIColor(r: 148, g: 222, b: 190)
        case .green:
            return UIColor(r: 150, g: 221, b: 185)
        case .purple:
            return UIColor(r: 149, g: 217, b: 188)
        case .orange:
            return UIColor(r: 155, g: 219, b: 182)
        case .holiday:
            return UIColor(r: 214, g: 87, b: 87)
        default:
            return .clear
        }
    }
}
