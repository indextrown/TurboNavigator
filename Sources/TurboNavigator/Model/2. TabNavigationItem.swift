//
//  TabNavigationIte.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/30/26.
//

import UIKit

public enum TabHapticStyle {
    case selection
    case light
    case medium
    case heavy
}

public struct TabNavigationItem<Route: Hashable> {
    public let tag: Int                     /// 탭 구분 ID
    public let route: Route                 /// 이 탭을 선택하면 어떤 화면(route)로 갈지
    public let tabBarItem: UITabBarItem?    /// UI
    public let prefersLargeTitles: Bool     /// 타이틀 크기 설정
    public let hapticStyle: TabHapticStyle? /// 탭 선택 시 햅틱 스타일
    
    public init(
        tag: Int,
        route: Route,
        tabBarItem: UITabBarItem? = nil,
        prefersLargeTitles: Bool = false,
        hapticStyle: TabHapticStyle? = nil
    ) {
        self.tag = tag
        self.route = route
        self.tabBarItem = tabBarItem
        self.prefersLargeTitles = prefersLargeTitles
        self.hapticStyle = hapticStyle
    }
}
