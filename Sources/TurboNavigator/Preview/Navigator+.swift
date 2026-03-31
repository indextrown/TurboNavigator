//
//  Navigator+.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/31/26.
//

import Foundation

/// `Navigator.preview` 프로퍼티가 사용할 기본 mock dependencies를 제공합니다.
public protocol PreviewDependencies {
    static var preview: Self { get }
}

extension Navigator where Dependencies == Void {

    /// 의존성이 없는 경우 바로 사용할 수 있는 SwiftUI Preview 전용 Navigator
    public static var preview: Self {
        preview(dependencies: ())
    }

    /// 의존성이 없는 경우 registry만 구성해서 사용할 수 있는 Preview 전용 Navigator
    public static func preview(
        _ configure: (RouteRegistry<Void, Route>) -> RouteRegistry<Void, Route>
    ) -> Self {
        preview(dependencies: (), configure)
    }
}

extension Navigator where Dependencies: PreviewDependencies {

    /// dependencies가 preview 기본값을 제공하는 경우 바로 사용할 수 있는 SwiftUI Preview 전용 Navigator
    public static var preview: Self {
        preview(dependencies: .preview)
    }

    /// dependencies가 preview 기본값을 제공하는 경우 registry까지 함께 구성할 수 있는 Preview 전용 Navigator
    public static func preview(
        _ configure: (RouteRegistry<Dependencies, Route>) -> RouteRegistry<Dependencies, Route>
    ) -> Self {
        preview(dependencies: .preview, configure)
    }
}

extension Navigator {

    /// dependencies를 직접 주입해 mock preview를 구성하는 Preview 전용 Navigator
    public static func preview(
        dependencies: Dependencies,
        registry: RouteRegistry<Dependencies, Route> = .init()
    ) -> Self {
        .init(
            dependencies: dependencies,
            registry: registry
        )
    }

    /// registry builder 스타일로 mock preview를 구성하는 Preview 전용 Navigator
    public static func preview(
        dependencies: Dependencies,
        _ configure: (RouteRegistry<Dependencies, Route>) -> RouteRegistry<Dependencies, Route>
    ) -> Self {
        let registry = configure(.init())

        return .init(
            dependencies: dependencies,
            registry: registry
        )
    }
}


/*
 MARK: - Preview Example 1

 가장 단순한 사용법
 `Dependencies == Void` 인 경우 바로 사용

 #Preview {
     SampleView(
         navigator: .preview
     )
 }
 */

/*
 MARK: - Preview Example 2

 `Dependencies == Void` 이고
 Preview에서 route registry까지 직접 넣고 싶을 때

 #Preview {
     SampleView(
         navigator: .preview { registry in
             registry
                 .registering(.home) { _ in UIViewController() }
                 .registering(.setting) { _ in UIViewController() }
         }
     )
 }
 */

/*
 MARK: - Preview Example 3

 앱에서 사용하는 Dependencies를 직접 주입
 `PreviewDependencies` 채택 없이도 사용 가능

 #Preview {
     SettingView(
         navigator: .preview(
             dependencies: AppDependencies()
         )
     )
 }
 */

/*
 MARK: - Preview Example 4

 앱 Dependencies가 `PreviewDependencies` 를 채택한 경우
 가장 간단하게 `.preview` 프로퍼티 사용 가능

 extension AppDependencies: PreviewDependencies {
     static var preview: Self {
         .init()
     }
 }

 #Preview {
     SettingView(
         navigator: .preview
     )
 }
 */

/*
 MARK: - Preview Example 5

 앱 Dependencies가 `PreviewDependencies` 를 채택했고
 Preview에서 route registry도 함께 구성하고 싶을 때

 extension AppDependencies: PreviewDependencies {
     static var preview: Self {
         .init()
     }
 }

 #Preview {
     SettingView(
         navigator: .preview { registry in
             registry
                 .registering(.setting) { _ in UIViewController() }
                 .registering(.home) { _ in UIViewController() }
         }
     )
 }
 */
