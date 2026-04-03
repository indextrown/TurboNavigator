//
//  TabNavigationContainer.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/31/26.
//

import SwiftUI

/// SwiftUI 환경에서 Tab 기반 UIKit 네비게이션을 사용할 수 있도록 연결하는 브릿지.
///
/// - 역할:
///   - UITabBarController를 생성하여 SwiftUI View 계층에 삽입
///   - 각 탭마다 UINavigationController를 구성
///   - Navigator의 TabCoordinator와 연결하여 탭 상태 관리
///
/// - 특징:
///   - 탭별 독립적인 navigation stack 유지
///   - Route 기반 초기 화면 구성
///   - SwiftUI에서 UIKit Tab 구조 사용 가능
///   - 탭 선택 상태를 Navigator와 동기화
///
/// - Generic:
///   - Dependencies: ViewController 생성 시 필요한 외부 의존성
///   - Route: Hashable 라우트 타입
///
/// - Note:
///   내부적으로 `UIViewControllerRepresentable`을 사용하여
///   UITabBarController를 SwiftUI에 삽입합니다.
///
/// - Lifecycle:
///   - makeUIViewController → 탭 구성 및 초기 화면 설정
///   - updateUIViewController → 선택된 탭 상태 및 UI 동기화
public struct TabNavigationContainer<
    Dependencies, Route: Hashable
>: UIViewControllerRepresentable {
    
    /// Navigator 인스턴스
    public let navigator: Navigator<Dependencies, Route>
    
    /// 탭 구성 정보 (각 탭의 route, tabBarItem, tag 포함)
    public let items: [TabNavigationItem<Route>]
    
    /// TabBar 숨김 여부
    public let isTabBarHidden: Bool
    
    
    /// TabNavigationContainer 생성자
    ///
    /// - Parameters:
    ///   - navigator: Navigator 인스턴스
    ///   - items: 탭 구성 정보 배열
    ///   - isTabBarHidden: TabBar 숨김 여부 (기본값: false)
    public init(
        navigator: Navigator<Dependencies, Route>,
        items: [TabNavigationItem<Route>],
        isTabBarHidden: Bool = false
    ) {
        self.navigator = navigator
        self.items = items
        self.isTabBarHidden = isTabBarHidden
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(items: items, navigator: navigator)
    }
    
    
    /// UITabBarController 생성 및 초기 탭 구성
    ///
    /// - Parameter context: SwiftUI Context
    /// - Returns: 생성된 UITabBarController
    ///
    /// - Flow:
    ///   1. UITabBarController 생성
    ///   2. TabCoordinator를 통해 각 탭의 UINavigationController 생성
    ///   3. 탭 컨트롤러에 설정
    ///   4. 초기 선택 탭 설정 (index 0)
    ///   5. TabBar 표시 여부 설정
    ///   6. Navigator와 연결
    public func makeUIViewController(context: Context) -> UITabBarController {
        let controller = UITabBarController()
        context.coordinator.items = items
        context.coordinator.attach(to: controller)
        
        // 각 탭별 navigation stack 생성
        let navigationControllers = navigator.tabCoordinator.launch(
            items: items,
            navigator: navigator
        )
        
        controller.setViewControllers(navigationControllers, animated: false)
        controller.selectedIndex = 0
        controller.tabBar.isHidden = isTabBarHidden
        
        // Navigator와 연결
        navigator.tabCoordinator.tabBarController = controller
        return controller
    }
    
    
    /// SwiftUI 업데이트 시 탭 상태 및 UI를 동기화
    ///
    /// - Parameters:
    ///   - uiViewController: 현재 UITabBarController
    ///   - context: SwiftUI Context
    ///
    /// - Behavior:
    ///   - 선택된 탭 index → tag로 변환하여 Navigator에 반영
    ///   - TabBar 숨김 상태 업데이트
    public func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
        
        // 최신 controller 연결
        navigator.tabCoordinator.tabBarController = uiViewController
        context.coordinator.items = items
        
        // 현재 선택된 탭 index -> tag 동기화
        if let selectedIndex = uiViewController.viewControllers?.firstIndex(where: {
            $0 === uiViewController.selectedViewController
        }),
           selectedIndex < items.count
        {
            navigator.tabCoordinator.setSelectedTag(items[selectedIndex].tag)
        }
        
        // TabBar 표시 여부 업데이트
        uiViewController.tabBar.isHidden = isTabBarHidden
    }
    
    public final class Coordinator: NSObject, UITabBarControllerDelegate {
        public var items: [TabNavigationItem<Route>]
        private let navigator: Navigator<Dependencies, Route>
        private let feedbackGenerator = UISelectionFeedbackGenerator()
        
        init(
            items: [TabNavigationItem<Route>],
            navigator: Navigator<Dependencies, Route>
        ) {
            self.items = items
            self.navigator = navigator
        }
        
        func attach(to controller: UITabBarController) {
            controller.delegate = self
            feedbackGenerator.prepare()
        }
        
        public func tabBarController(
            _ tabBarController: UITabBarController,
            didSelect viewController: UIViewController
        ) {
            guard let selectedIndex = tabBarController.viewControllers?.firstIndex(where: {
                $0 === viewController
            }),
            selectedIndex < items.count
            else {
                return
            }
            
            let item = items[selectedIndex]
            navigator.tabCoordinator.setSelectedTag(item.tag)
            
            if item.isHapticFeedbackEnabled {
                feedbackGenerator.selectionChanged()
                feedbackGenerator.prepare()
            }
        }
    }
}


/*
 MARK: - Example

 enum AppRoute: Hashable {
   case home
   case search
   case profile
   case detail(id: String)
 }

 struct AppDependencies { }

 // MARK: - Navigator 생성
 let navigator = Navigator<AppDependencies, AppRoute>(
   dependencies: AppDependencies()
 )

 // MARK: - SwiftUI Root View
 struct RootView: View {
   var body: some View {
     TabNavigationContainer(
       navigator: navigator,
       items: [
         .init(
           tag: 0,
           route: .home,
           tabBarItem: UITabBarItem(title: "Home", image: nil, tag: 0),
           prefersLargeTitles: true,
           isHapticFeedbackEnabled: true
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
     )
   }
 }

 // MARK: - 탭 내부에서 사용

 struct HomeView: View {
   let navigator: Navigator<AppDependencies, AppRoute>

   var body: some View {
     VStack {
       Text("Home")

       // 다른 탭으로 이동
       Button("Search 탭 이동") {
         navigator.switchTab(tag: 1)
       }

       // 현재 탭에서 push
       Button("Detail 이동") {
         navigator.push(.detail(id: "42"))
       }

       // Modal
       Button("Modal 열기") {
         navigator.present(.detail(id: "99"))
       }
     }
   }
 }
 */
