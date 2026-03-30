//
//  File.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/30/26.
//

import Foundation

/// Route를 기반으로 화면(ViewController) 을 생성하는 빌더 구조체
///
/// `RouteBuilder`는 특정 Route를 처리할 수 있는지 판단(matches)하고,
/// 해당 Route에 맞는 ViewController를 생성(build)하는 역할을 합니다.
///
/// Navigator는 여러 개의 RouteBuilder를 순회하며,
/// matches 조건에 만족하느 Builder를 찾아 화면을 생성합니다.
///
/// - Generic Parameters:
///   - Dependencies: 외부 의존성 컨테이너 타입
///   - Route: 화면 상태를 나타내는 라우트 타입 (Hashable 필요)
public struct RouteBuilder<Dependencies, Route: Hashable> {
    
    
    /// 해당 Builder가 주어진 Route를 처리할 수 있는지 판단하는 함수
    ///
    ///  - Parameter route: 현재 처리하려는 Route
    ///  - Returns: 처리 가능하면 true, 아니면 false
    public let matches: (Route) -> Bool
    
    
    /// RouteContext 기반으로 ViewController를 생성하는 함수
    ///
    /// - Parameter context: Navigator, Route, Dependencies를 포함한 컨텍스트
    /// - Returns: 생성된 ViewController (또는 nil)
    public let build: (RouteContext<Dependencies, Route>) -> RouteViewController?
    
    
    /// RouteBuilder 생성자
    ///
    /// - Parameters:
    ///   - matches: Route 매칭 조건
    ///   - build: ViewController 생성 로직
    public init(
        matches: @escaping (Route) -> Bool,
        build: @escaping (RouteContext<Dependencies, Route>) -> RouteViewController?
    ) {
        self.matches = matches
        self.build = build
    }
}

// MARK: - Convenience Builders
extension RouteBuilder {
    
    
    // MARK: - 복잡한 조건
    /// 특정 조건(matches)을 기반으로 Builder를 생성하는 메서드
    ///
    /// - Parameters:
    ///   - matches: Route 매칭 조건
    ///   - build: ViewController 생성 로직
    /// - Returns: RouteBuilder 인스턴스
    public static func matching(
        _ matches: @escaping (Route) -> Bool,
        build: @escaping (RouteContext<Dependencies, Route>) -> RouteViewController?
    ) -> Self {
        .init(matches: matches, build: build)
    }
    
    
    // MARK: - 값 있는 route (.detail(id))
    /// Route에서 특정 값을 추출하여 ViewController 생성 시 함꼐 전달하는 Builder
    ///
    /// - Parameters:
    ///   - extract: Route에서 값을 추출하는 함수 (값이 없으면 nil 반환)
    ///   - build: 추출된 값과 함께 ViewController를 생성하는 함수
    /// - Returns: RouteBuilder 인스턴스
    ///
    /// - Example:
    ///   .extracting(
    ///       { route in if case let .detail(id) = route { return id } else { return nil } },
    ///       build: { context, id in DetailViewController(id: id) }
    ///   )
    public static func extracting<Value>(
        _ extract: @escaping (Route) -> Value?,
        build: @escaping (RouteContext<Dependencies, Route>, Value) -> RouteViewController?
    ) -> Self {
        .init(
            matches: { extract($0) != nil },
            build: { context in
                guard let value = extract(context.route) else { return nil }
                return build(context, value)
            }
        )
    }
}

// MARK: - Equatable 전용 Builder
extension RouteBuilder where Route: Equatable {
    
    // MARK: - 값 없는 route (.home, .settings)
    /// 특정 Route와 정확히 일치하는 경우에만 동작하는 Builder
    ///
    /// - Parameters:
    ///   - route: 비교할 Route
    ///   - build: ViewController 생성 로직
    /// - Returns: RouteBuilder 인스턴스
    public static func exact(
        _ route: Route,
        build: @escaping (RouteContext<Dependencies, Route>) -> RouteViewController?
    ) -> Self {
        /// route: .home
        /// $0: 나중에 들어오는 값
        .init(matches: { $0 == route }, build: build)
    }
}


/**
 MARK: - Quick Start
 
 // 1. Route 정의
 enum AppRoute: Hashable {
     case home
     case detail(id: String)
     case settings
 }
 
 // 2. Builder 정의
 let builders: [RouteBuilder<AppDI, AppRoute>] = [
     
     // exact: 완전히 같은 route일 때
     .exact(.home) { context in
         return HomeViewController()
     },
     
     
     // extracting: route에서 값 꺼내서 사용
     .extracting(
         { route in
             if case let .detail(id) = route { return id }
             return nil
         },
         build: { context, id in
             return DetailViewController(id: id)
         }
     ),
     
     
     // matching: 자유롭게 조건 정의
     .matching(
         { route in
             if case .settings = route { return true }
             return false
         },
         build: { context in
             return SettingsViewController()
         }
     )
 ]
 
 // 3. Navigator 내부 동작 (개념)
 
 func buildViewController(
     route: AppRoute,
     navigator: Navigator<AppDI, AppRoute>,
     dependencies: AppDI
 ) -> UIViewController? {
     
     let context = RouteContext(
         navigator: navigator,
         route: route,
         dependencies: dependencies
     )
     
     for builder in builders {
         if builder.matches(route) {
             return builder.build(context)
         }
     }
     
     return nil
 }
 
 
 // 4. 실제 동작 흐름
 
 // navigator.push(.detail(id: "42"))
 
 // -> 내부 동작:
 
 // 1. builders 순회
 // 2. extracting builder에서 id 추출 성공
 // 3. DetailViewController(id: "42") 생성
 // 4. push
 
 
 
 // 핵심 정리
 
 // RouteBuilder는
 // "이 route 내가 처리할게 → 그럼 VC 만들어줄게"
 
 // exact      → 완전 일치
 // extracting → 값 꺼내서 사용
 // matching   → 자유 조건
 */
