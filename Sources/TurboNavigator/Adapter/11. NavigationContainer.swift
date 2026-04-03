//
//  NavigationContainer.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/30/26.
//

import SwiftUI

/// SwiftUI 환경에서 UIKit 기반 Navigator를 사용할 수 있도록 연결하는 브릿지 컴포넌트.
///
/// - 역할:
///   - UINavigationController를 생성하여 SwiftUI View 계층에 삽입
///   - Navigator의 rootController를 설정
///   - 초기 route를 기반으로 root 화면 구성
///
/// - 특징:
///   - SwiftUI ↔ UIKit 네비게이션 연결
///   - Navigator 기반 Route 시스템을 SwiftUI에서 사용 가능
///   - UINavigationController lifecycle을 SwiftUI에 위임
///
/// - Generic:
///   - Dependencies: ViewController 생성 시 필요한 외부 의존성
///   - Route: Hashable 라우트 타입
///
/// - Note:
///   내부적으로 `UIViewControllerRepresentable`을 사용하여
///   UINavigationController를 SwiftUI에 삽입합니다.
///
/// - Lifecycle:
///   - makeUIViewController → 최초 생성 및 초기 화면 구성
///   - updateUIViewController → SwiftUI 업데이트 시 rootController 동기화
public struct NavigationContainer<Dependencies, Route: Hashable>: UIViewControllerRepresentable {
    
    /// Navigator 인스턴스 (네비게이션 전체 관리)
    public let navigator: Navigator<Dependencies, Route>
    
    /// 초기 화면을 구성할 route 배열
    public let initialRoutes: [Route]
    
    /// NavigationBar Large Title 사용 여부
    public let prefersLargeTitles: Bool
    
    
    /// NavigationContainer 생성자
    ///
    /// - Parameters:
    ///   - navigator: Navigator 인스턴스
    ///   - initialRoutes: 초기 화면 route 목록
    ///   - prefersLargeTitles: Large Title 사용 여부 (기본값 false)
    public init(
        navigator: Navigator<Dependencies, Route>,
        initialRoutes: [Route],
        prefersLargeTitles: Bool = false
    ) {
        self.navigator = navigator
        self.initialRoutes = initialRoutes
        self.prefersLargeTitles = prefersLargeTitles
    }
    
    
    /// UINavigationController 생성 및 초기 화면 구성
    ///
    /// - Parameter context: SwiftUI Context
    /// - Returns: 생성된 UINavigationController
    ///
    /// - Flow:
    ///   1. UINavigationController 생성
    ///   2. NavigationBar 설정
    ///   3. Navigator를 통해 초기 ViewController 생성
    ///   4. rootController 연결
    public func makeUIViewController(context: Context) -> UINavigationController {
        let controller = UINavigationController()
        controller.navigationBar.prefersLargeTitles = prefersLargeTitles
        let viewControllers = navigator.launch(initialRoutes)
        
        // 초기 화면 구성
        controller.setViewControllers(viewControllers, animated: false)
        controller.applyNavigationBarVisibility(for: viewControllers.first)
        
        // Navigator와 연결
        navigator.rootController = controller
        return controller
    }
    
    /// SwiftUI 업데이트 시 Navigator와 UINavigationController를 동기화
    ///
    /// - Parameters:
    ///   - uiViewController: 현재 UINavigationController
    ///   - context: SwiftUI Context
    ///
    /// - Note:
    ///   SwiftUI lifecycle에 따라 controller가 변경될 수 있으므로
    ///   Navigator의 rootController를 항상 최신 상태로 유지합니다.
    public func updateUIViewController(
        _ uiViewController: UINavigationController,
        context: Context
    ) {
        navigator.rootController = uiViewController
    }
}


/*
 MARK: - Example

 enum AppRoute: Hashable {
   case home
   case detail(id: String)
 }

 struct AppDependencies {
   let repository: UserRepository
 }

 // MARK: - Navigator 생성
 let navigator = Navigator<AppDependencies, AppRoute>(
   dependencies: AppDependencies(repository: UserRepository())
 )

 // MARK: - SwiftUI Root View
 struct RootView: View {
   var body: some View {
     NavigationContainer(
       navigator: navigator,
       initialRoutes: [.home],
       prefersLargeTitles: true
     )
   }
 }

 // MARK: - SwiftUI 내부에서 사용

 struct HomeView: View {
   let navigator: Navigator<AppDependencies, AppRoute>

   var body: some View {
     VStack {
       Text("Home")

       Button("Detail 이동") {
         navigator.push(.detail(id: "42"))
       }

       Button("Modal 열기") {
         navigator.present(.detail(id: "99"))
       }
     }
   }
 }
 */
