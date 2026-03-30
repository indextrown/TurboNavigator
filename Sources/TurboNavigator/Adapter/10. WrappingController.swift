//
//  WrappingController.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/30/26.
//

import SwiftUI


/// SwiftUI View를 UIKit 기반 네비게이션 시스템에서 사용할 수 있도록
/// 감싸는 UIHostingController 래퍼 컨트롤러
///
/// - 역할:
///   - SwiftUI View를 UIViewController로 변환
///   - 해당 화면이 어떤 Route로 생성되었는지 식별 가능하게 함
///
/// - 특징:
///   - `AnyRouteIdentifiable` 채택으로 route 추적 가능
///   - Navigator에서 back / backTo / backOrPush 동작을 위해 사용됨
///   - SwiftUI + UIKit 혼합 구조에서 핵심 브릿지 역할 수행
///
/// - Generic:
///   - Route: Hashable 라우트 타입
///   - Content: 표시할 SwiftUI View
///
/// - Note:
///   Navigator 내부에서 route 기반으로 ViewController를 찾기 위해
///   `anyRoute`를 사용합니다 (Type Erasure)
public final class WrappingController<
    Route: Hashable, Content: View
>: UIHostingController<Content>, AnyRouteIdentifiable {
    
    /// 해당 ViewController를 생성한 Route
    public let route: Route
    
    
    /// 타입 소거된 Route (AnyHashable)
    ///
    /// - Note:
    ///   다양한 Route 타입을 하나의 타입으로 비교하기 위해 사용
    public let anyRoute: AnyHashable
    
    
    /// SwiftUI View를 감싸는 WrappingController 생성자
    /// - Parameters:
    ///   - route: 현재 화면의 Route
    ///   - title: NavigationBar에 표시할 제목
    ///   - content: 표시할 SwiftUI View
    ///
    /// - Important:
    ///   content는 ViewBuilder를 통해 생성되며,
    ///   UIHostingController의 rootView로 설정됩니다.
    public init(
        route: Route,
        title: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.route = route
        self.anyRoute = AnyHashable(route)
        
        super.init(rootView: content())
        
        self.title = title
    }
    
    /// Storyboard / XIB 초기화는 지원하지 않음
    @available(*, unavailable)
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/*
 MARK: - Example

 enum AppRoute: Hashable {
   case home
   case detail(id: String)
 }

 // SwiftUI View
 struct DetailView: View {
   let id: String

   var body: some View {
     Text("Detail: \(id)")
   }
 }

 // MARK: - WrappingController 생성
 let vc = WrappingController(
   route: AppRoute.detail(id: "42"),
   title: "Detail"
 ) {
   DetailView(id: "42")
 }

 // UINavigationController에 push
 navigationController.pushViewController(vc, animated: true)

 // MARK: - Navigator 내부 활용 예시

 // 현재 스택에서 특정 route 찾기
 if let found = navigationController.viewControllers.first(where: {
   ($0 as? AnyRouteIdentifiable)?.anyRoute == AnyHashable(AppRoute.detail(id: "42"))
 }) {
   navigationController.popToViewController(found, animated: true)
 }
 */
