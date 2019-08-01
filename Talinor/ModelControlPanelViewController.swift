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
    var code: UInt8? {
        switch self {
        case .zero: return 0x00
        case .one: return 0x01
        case .two: return 0x02
        case .three: return 0x03
        case .four: return 0x04
        case .five: return 0x05
        case .six: return 0x06
        case .seven: return 0x07
        case .eight: return 0x08
        case .nine: return 0x09
        case .mode: return 0x0A
        case .up: return 0x0B
        case .down: return 0x0D
        case .enter: return 0x0C
        case .snowflake: return 0x0E
        case .hashtag: return 0x0F
        
        default: return nil
        }
    }
}

enum AppError : Error {
    case dataCharactertisticNotFound
    case enabledCharactertisticNotFound
    case updateCharactertisticNotFound
    case serviceNotFound
    case invalidState
    case resetting
    case poweredOff
    case unknown
}
