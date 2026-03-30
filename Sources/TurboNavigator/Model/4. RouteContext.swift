//
//  RouteContext.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/30/26.
//

import Foundation


/// 화면 생성 및 전환에 필요한 정보를 하나로 묶는 컨텍스트 객체
///
/// `RouteContext`는 Navigator, 현재 Route, 그리고 외부 의존성(Dependencies)을 함꼐 전달하여
/// ViewController 또는 View를 생성할 때 필요한 모든 요소를 일관된 방식으로 제공합니다
///
/// - Generic Parameters:
///     - Dependencies: 외부 의존성 컨테이너 (예: Repository, NetworkService 등)
///     - Route: 화면 상태를 나타내는 타입(Hashable 필요)
public struct RouteContext<Dependencies, Route: Hashable> {
    
    
    /// 화면 전환을 담당하눈 Navigator 객체
    ///
    /// - push, pop, present 등의 네비게이션 동작을 수행할 수 있습니다.
    /// - ViewController 내부에서 다음 화면으로 이동할 때 사용합니다.
    public let navigator: Navigator<Dependencies, Route>
    
    
    /// 현재 화면을 나타내는 Route값
    ///
    /// - 어떤 화면인지, 어떤 데이터를 기반으로 생성되었는지를 표현합니다.
    /// - 예: `.detail(id: "123")`
    public let route: Route
    
    
    /// 외부 의존성 컨테이너
    ///
    /// - ViewModel, Repository, NetworkService 등
    ///   화면 구성에 필요한 객체들을 표현합니다.
    ///   - DI(Dependency Injection)를 위해 사용됩니다.
    public let dependencies: Dependencies
    
    
    /// RouteContext 생성자
    ///
    /// - Parameters:
    ///   - navigator: 화면 전환을 담당하는 Navigator
    ///   - route: 현재 화면을 나타내는 Route
    ///   - dependencies: 외부 의존성 컨테이너
    public init(
        navigator: Navigator<Dependencies, Route>,
        route: Route,
        dependencies: Dependencies
    ) {
        self.navigator = navigator
        self.route = route
        self.dependencies = dependencies
    }
}
