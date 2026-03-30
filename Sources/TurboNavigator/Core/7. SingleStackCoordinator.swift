//
//  File.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/30/26.
//

import UIKit


/// 단일 UINavigationController 스택에 대한 읽기/쓰기 작업을 담당하는 Coordinator
///
/// `SingleStackCoordinator`는 현재 네비게이션 스택 상태를 조회하거나,
/// 새로운 화면을 추가/교체하거나, 특정 Route에 해당하는 ViewController를 찾는 역할을 합니다.
///
/// Navigator 내부에서 실제 UIKit 스택 조작을 담당하는 "저수준 유틸리티" 입니다.
///
/// - Generic Parameters:
///   - Route: 화면 상태를 나타내는 라우트 타입 (Hashable 필요)
public struct SingleStackCoordinator<Route: Hashable> {
    
    
    public init() {}
    
    
    /// 현재 UINavigationController 스택을 Route 배열로 변환하여 반환
    ///
    /// - Parameter controller: 대상 UINavigationController
    /// - Returns: 현재 스택에 해당하는 Route 배열(AnyHashable 형태)
    ///
    /// 내부 동작:
    /// - viewControllers를 순회하면서
    /// - AnyRouteIdentifiable을 통해 route를 추출
    public func currentRoutes(
        controller: UINavigationController?
    ) -> [AnyHashable] {
        (controller?.viewControllers ?? []).compactMap {
            ($0 as? AnyRouteIdentifiable)?.anyRoute
        }
    }
    
    
    /// 기존 스택에 새로운 ViewController들을 추가 (push)
    /// - Parameters:
    ///   - viewControllers: 추가할 ViewController 배열
    ///   - controller: 대상 UINavigationController?
    ///   - animated: 애니메이션 여부
    ///
    /// 내부 동작:
    /// - 기존 스택 + 새로운 VC를 합쳐서 setViewControllers 호출
    public func append(
        viewControllers: [UIViewController],
        to controller: UINavigationController?,
        animated: Bool
    ) {
        guard let controller else { return }
        controller.setViewControllers(
            controller.viewControllers + viewControllers,
            animated: animated
        )
    }
    
    
    /// 스택 전체를 새로운 ViewController 배열로 교체 (replace 개념)
    ///
    /// - Parameters:
    ///   - viewControllers: 새로 설정할 ViewController 배열
    ///   - controller: 대상 UINavigationController
    ///   - animated: 애니메이션 여부
    public func replace(
        viewControllers: [UIViewController],
        on controller: UINavigationController?,
        animated: Bool
    ) {
        controller?.setViewControllers(viewControllers, animated: animated)
    }
    
    
    /// 특정 Route와 일치하는 마지막 ViewController를 스택에서 찾음
    ///
    /// - Parameters:
    ///   - route: 찾을 Route
    ///   - controller: 대상 UINavigationController
    /// - Returns: 해당 Route에 해당하는 ViewController (없으면 nil)
    ///
    /// 내부 동작:
    /// - route를 AnyHashable로 변환
    /// - 스택을 뒤에서부터 탐색하여 일치하는 VC 반환
    public func lastMatchedViewController(
        route: Route,
        in controller: UINavigationController?
    ) -> UIViewController? {
        
        let target = AnyHashable(route)
        
        return controller?.viewControllers.last(where: {
            ($0 as? AnyRouteIdentifiable)?.anyRoute == target
        })
    }
}

