//
//  ModalPresentationStyle.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/30/26.
//

import UIKit

public enum ModalPresentationStyle: Equatable {
    case automatic
    case fullScreen
    case overFullScreen
    case pageSheet
    
    var uiKitStyle: UIModalPresentationStyle {
        switch self {
        case .automatic:
            return .automatic
        case .fullScreen:
            return .fullScreen
        case .overFullScreen:
            return .overFullScreen
        case .pageSheet:
            return .pageSheet
        }
    }
}
