//
//  AnyRouteIdentifiable.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/30/26.
//

import UIKit

/// 네비게이션 스택에 이미 올라가 있는 UIViewController로부터
/// 해당 화면이 어떤 route로 생성되었는지를 식별하기 위한 프로토콜
public protocol AnyRouteIdentifiable {
    
    /// 현재 ViewController를 생성한 route정보를 반환
    /// - AnyHashable을 사용해 다양한 Route 타입을 하나의 타입으로 추상화 (Type Erasure)
    var anyRoute: AnyHashable { get }
}

/// route 정보를 포함하고 있는 UIKit ViewController 타입을 나타내는 별칭
/// - UIViewController이면서 AnyRouteIdentifiable을 채택한 타입만 허용
/// - Navigator / Coordinator에서 route 기반 네비게이션을 처리하기 위해 사용
public typealias RouteViewController = UIViewController & AnyRouteIdentifiable

/*
MARK: - Example
final class HomeVC: @preconcurrency RouteViewController {
    
    /// 이 ViewController가 어떤 route인지 반환
    /// - "나는 홈 화면이다"
    var anyRoute: AnyHashable {
        AppRoute.home
    }
}
*/
