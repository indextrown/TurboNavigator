//
//  TabNavigationIte.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/30/26.
//

import UIKit

public struct TabNavigationItem<Route: Hashable> {
    public let tag: Int                     /// 탭 구분 ID
    public let route: Route                 /// 이 탭을 선택하면 어떤 화면(route)로 갈지
    public let tabBarItem: UITabBarItem?    /// UI
    public let prefersLargeTitles: Bool     /// 타이틀 크기 설정
    
    public init(
        tag: Int,
        route: Route,
        tabBarItem: UITabBarItem? = nil,
        prefersLargeTitles: Bool = false
    ) {
        self.tag = tag
        self.route = route
        self.tabBarItem = tabBarItem
        self.prefersLargeTitles = prefersLargeTitles
    }
}
