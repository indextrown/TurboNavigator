//
//  TabCoordinator.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/30/26.
//

import UIKit


/// Tab 기반 네비게이션을 관리하는 Coordinator
/// 
/// - Note:
///   각 탭마다 독립적인 `UINavigationController`를 생성하여
///   탭 간 naviagtion stack을 분리 관리합니다.
/// 
///   - 특징:
///     - 탭별 UINavigationController 캐싱
///     - tag 기반으로 탭 식별 및 전환
///     - 동일 탭 재선택 시 popToRoot 지원
///     - Navigator + Registry 기반 ViewController 생성
/// 
///   - Generic:
///     - Dependencies: 화면 생성 시 필요한 외부 의존성
///     - Route: Hashable 라우트 타입
public final class TabCoordinator<Dependencies, Route: Hashable> {
    
    /// 연결된 UITabbarController
    public weak var tabBarController: UITabBarController?
    
    /// tag -> UINavigationController 매핑
    public private(set) var tabCoordinators: [Int: UINavigationController] = [:]
    
    /// 탭 순서를 유지하기 위한 tag 배열
    public private(set) var orderedTags: [Int] = []
    
    /// 현재 선택된 탭의 tag
    public private(set) var currentTag: Int?
    
    public init() {}
    
    
    /// 현재 선택한 탭의 UINavigationController를 반환합니다.
    ///
    /// - Returns:
    ///   현재 활성화된 navigation controller (없으면 nil)
    ///
    /// - Note:
    ///   UITabBarController의 selectedViewController를 우선 사용하고,
    ///   fallback으로 내부 캐시를 조회합니다.
    public var currentNavigationController: UINavigationController? {
        if let selected = tabBarController?.selectedViewController as? UINavigationController {
            return selected
        }
        
        guard let currentTag else { return nil }
        return tabCoordinators[currentTag]
    }
    
    
    /// 각 탭에 대한 UINavigationController를 생성하고 초기 화면(route)를 설정합니다.
    ///
    /// - Parameters:
    ///   - items: 탭 구성 정보(route, tabBarItem, tag 등)
    ///   - navigator: ViewController 생성에 사용되는 Navigator
    ///
    /// - Returns: 생성된 UINavigationController 배열 (UITabBarController에 설정할 용도)
    ///
    /// - Flow:
    ///   1. tag 순서 저장
    ///   2. 초기 선택 탭 설정
    ///   3. 각 탭마다 UINavigationController 생성
    ///   4. registry를 통해 root ViewController 생성
    ///   5. controller 캐싱
    public func launch(
        items: [TabNavigationItem<Route>],
        navigator: Navigator<Dependencies, Route>
    ) -> [UINavigationController] {
        
        orderedTags = items.map(\.tag)
        currentTag = items.first?.tag
        tabCoordinators = [:]
        
        let controllers = items.map { item -> UINavigationController in
            let controller = UINavigationController()
            controller.navigationBar.prefersLargeTitles = item.prefersLargeTitles
            controller.tabBarItem = item.tabBarItem
            
            controller.setViewControllers(
                navigator.registry.build(
                    routes: [item.route],
                    navigator: navigator,
                    dependencies: navigator.dependencies),
                animated: false
            )
            
            tabCoordinators[item.tag] = controller
            return controller
        }
        return controllers
    }
    
    
    /// 탭을 전환합니다.
    ///
    /// - Parameters:
    ///   - tag: 이동할 탭의 tag
    ///   - popToRootIfSelected: 동일한 탭을 다시 선택했을 경우 root로 이동할지 여부
    ///
    /// - Behavior:
    ///   - 다른 탭 선택 → 해당 탭으로 전환
    ///   - 동일 탭 선택 →
    ///       - 옵션이 true면 root로 pop
    ///       - false면 아무 동작 없음
    public func switchTab(
        tag: Int,
        popToRootIfSelected: Bool = true
    ) {
        guard let tabBarController, let controller = tabCoordinators[tag] else { return }
        
        /// 같은 탭 다시 선택
        if tabBarController.selectedViewController === controller {
            currentTag = tag
            if popToRootIfSelected {
                if let rootViewController = controller.viewControllers.first {
                    controller.setViewControllers([rootViewController], animated: false)
                }
            }
            return
        }
        
        /// 다음 탭으로 전환
        currentTag = tag
        tabBarController.selectedViewController = controller
    }
    
    
    /// 외부(UI 이벤트 등)에서 선택된 탭 상태를 동기화합니다.
    ///
    /// - Parameter tag: 선택된 탭 tag
    public func setSelectedTag(_ tag: Int?) {
        currentTag = tag
    }
}

/**
 MARK: - Example

 enum AppRoute: Hashable {
   case home
   case search
   case profile
 }

 let navigator = Navigator<AppDependencies, AppRoute>(...)

 let tabCoordinator = TabCoordinator<AppDependencies, AppRoute>()

 let tabBarController = UITabBarController()
 tabCoordinator.tabBarController = tabBarController

 // MARK: - Tab 구성
 let items: [TabNavigationItem<AppRoute>] = [
   .init(
     tag: 0,
     route: .home,
     tabBarItem: UITabBarItem(title: "Home", image: nil, tag: 0),
     prefersLargeTitles: true
   ),
   .init(
     tag: 1,
     route: .search,
     tabBarItem: UITabBarItem(title: "Search", image: nil, tag: 1),
     prefersLargeTitles: false
   ),
   .init(
     tag: 2,
     route: .profile,
     tabBarItem: UITabBarItem(title: "Profile", image: nil, tag: 2),
     prefersLargeTitles: false
   )
 ]

 // MARK: - Launch
 let controllers = tabCoordinator.launch(
   items: items,
   navigator: navigator
 )

 tabBarController.viewControllers = controllers

 // MARK: - Tab Switch
 tabCoordinator.switchTab(tag: 1)

 // MARK: - 동일 탭 재선택 → root로 pop
 tabCoordinator.switchTab(tag: 1, popToRootIfSelected: true)
 */
