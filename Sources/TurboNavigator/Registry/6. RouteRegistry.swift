//
//  RouteRegistry.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/30/26.
//

import UIKit


/// Route와 ViewController를 연결하는 `Builder`들을 관리하고,
/// 실제 화면(ViewController)을 생성하는 역할을 담당하는 레지스트리
///
/// `RouteRegistry`는 여러 개의 `RouteBuilder`를 등록해두고,
/// 특정 Route가 들어왔을 때 해당 Route를 처리할 수 있는 Builder를 찾아
/// ViewController를 생성합니다.
///
/// Navigator는 이 Registry를 통해 Route -> ViewController 변환을 수행합니다.
///
/// - Generic Parameters:
///   - Dependencies: 외부 의존성 컨테이너 타입
///   - Route: 화면 상태를 나타내는 라우트 타입 (Hashable 필요)
public struct RouteRegistry<Dependencies, Route: Hashable> {
    
    
    /// 등록된 RouteBuilder 목록
    private var builders: [RouteBuilder<Dependencies, Route>]
    
    
    /// RouteRegistry 생성자
    /// - Parameter builders: 초기 Builder 목록(기본값: 빈 배열)
    public init(
        builders: [RouteBuilder<Dependencies, Route>] = []
    ) {
        self.builders = builders
    }
    
    
    /// 새로운 RouteBuilder를 등록
    ///
    /// - Parameter builder: 추가할 Builder
    /// - Returns: Builder가 추가된 새로운 Registry(Immutable 방식)
    public func registering(
        _ builder: RouteBuilder<Dependencies, Route>
    ) -> Self {
        var copied = self
        copied.builders.append(builder)
        return copied
    }
    
    
    /// matches 조건 기반으로 builder를 생성하여 등록
    ///
    /// - Parameters:
    ///   - matches: Route 매칭 조건
    ///   - build: ViewController 생성 로직
    /// - Returns: 새로운 Registry
    public func registering(
        matching matches: @escaping (Route) -> Bool,
        build: @escaping(RouteContext<Dependencies, Route>) -> RouteViewController?
    ) -> Self {
        return registering(.matching(matches, build: build))
    }
    
    
    /// extracting 기반으로 builder를 생성하여 등록
    ///
    /// - Parameters:
    ///   - extract: Route에서 값을 추출하는 함수
    ///   - build: 추출된 값과 함께 ViewController 생성
    /// - Returns: 새로운 Registry
    public func registering<Value>(
        extracting extract: @escaping (Route) -> Value?,
        build: @escaping(RouteContext<Dependencies, Route>, Value) -> RouteViewController?
    ) -> Self {
        return registering(.extracting(extract, build: build))
    }
    
    
    /// 단일 Route 기반으로 ViewController 생성
    /// 
    /// - Parameters:
    ///   - route: 변환할 Route
    ///   - navigator: Navigator 인스턴스
    ///   - dependencies: 외부 의존성
    /// - Returns: 생성된 ViewController (없으면 nil)
    ///
    /// 내부 동작:
    /// 1. RouteContext 생성
    /// 2. builders 순회
    /// 3. matches 조건에 맞는 첫 Builder 선택
    /// 4. build 실행
    public func build(
        route: Route,
        navigator: Navigator<Dependencies, Route>,
        dependencies: Dependencies
    ) -> RouteViewController? {
        
        let context = RouteContext(
            navigator: navigator,
            route: route,
            dependencies: dependencies
        )
        
        return builders
            .first(where: { $0.matches(route) })?
            .build(context)
    }
    
    
    /// 여러 Route를 ViewController 배열로 변환
    /// 
    /// - Parameters:
    ///   - routes: 변환할 Route 배열
    ///   - navigator: Navigator 인스턴스
    ///   - dependencies: 외부 의존성
    /// - Returns: ViewController 배열
    public func build(
        routes: [Route],
        navigator: Navigator<Dependencies, Route>,
        dependencies: Dependencies
    ) -> [UIViewController] {
        return routes.compactMap {
            build(
                route: $0,
                navigator: navigator,
                dependencies: dependencies
            )
        }
    }
}


extension RouteRegistry where Route: Equatable {
    
    
    /// exact 기반 Builder를 등록하는 편의 메서드
    /// - Parameters:
    ///   - route: 정확히 일치할 Route
    ///   - build: ViewController 생성 로직
    /// - Returns: 새로운 Registry
    public func registering(
        _ route: Route,
        build: @escaping (RouteContext<Dependencies, Route>) -> RouteViewController?
    ) -> Self {
        return registering(.exact(route, build: build))
    }
}


/**
 MARK: - Quick Start (RouteRegistry)

 // 1. Route 정의
 enum AppRoute: Hashable {
     case home
     case detail(id: String)
     case settings
 }


 // 2. Registry 생성 + Builder 등록
 let registry = RouteRegistry<AppDI, AppRoute>()
 
     // 값 없는 route (.home)
     .registering(.home) { _ in
         HomeViewController()
     }
 
     // 값 있는 route (.detail(id))
     .registering(
         extracting: {
             if case let .detail(id) = $0 { return id }
             return nil
         },
         build: { _, id in
             DetailViewController(id: id)
         }
     )
 
     // 조건 기반 (.settings)
     .registering(
         matching: {
             if case .settings = $0 { return true }
             return false
         },
         build: { _ in
             SettingsViewController()
         }
     )


 // 3. 단일 Route → ViewController 생성

 let vc = registry.build(
     route: .detail(id: "42"),
     navigator: navigator,
     dependencies: di
 )

 // 결과:
 // DetailViewController(id: "42")


 // 4. 여러 Route → ViewController 배열 생성

 let vcs = registry.build(
     routes: [.home, .detail(id: "42")],
     navigator: navigator,
     dependencies: di
 )

 // 결과:
 // [HomeViewController, DetailViewController]


 // 5. 내부 동작 흐름 (중요)

 // registry.build(route)

 // → 1. RouteContext 생성
 // → 2. builders 순회
 // → 3. matches(route) == true 인 첫 builder 찾기
 // → 4. build(context) 실행
 // → 5. ViewController 반환


 // 핵심 정리

 // RouteRegistry는
 // "Route → ViewController로 변환하는 공장"

 // RouteBuilder는
 // "이 route 내가 처리할게"

 // Registry는
 // "그럼 적절한 builder 찾아서 실행할게"

 */
