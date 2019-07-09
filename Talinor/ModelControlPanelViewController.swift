//
//  ModelControlPanelViewController.swift
//  Talinor
//
//  Created by Taras Kibitkin on 09/07/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import UIKit

enum ControlPanelButtonsType: CaseIterable{
    case one
    case two
    case three
    case mode
    case four
    case five
    case six
    case up
    case seven
    case eight
    case nine
    case down
    case snowflake
    case zero
    case hashtag
    case enter
    case youtube
    case support
    case home
}

extension ControlPanelButtonsType{
    var title: String?{
        switch self {
            case .one: return "1"
            case .two: return "2"
            case .three: return "3"
            case .four: return "4"
            case .five: return "5"
            case .six: return "6"
            case .seven: return "7"
            case .eight: return "8"
            case .nine: return "9"
            case .zero: return "0"
            case .mode: return "MODE"
            case .enter: return "ENTER"
            case .support: return "SUPPORT"
            case .snowflake: return "*"
            case .hashtag: return "#"
            case .up: return "↑"
            case .down: return "↓"
            case .youtube, .home: return nil
        }
    }
    
    var icon: UIImage?{
        switch self {
            case .youtube: return UIImage(named: "ic_youtube")
            case .home: return UIImage(named: "ic_home")
            default: return nil
        }
    }
    
    var width: CGFloat{
        switch self {
            case .up, .down, .mode, .youtube, .enter: return (UIScreen.main.bounds.width / 5) * 1.5
            case .support: return (UIScreen.main.bounds.width / 5) * 2.1
            default: return UIScreen.main.bounds.width / 6
        }
    }
}
