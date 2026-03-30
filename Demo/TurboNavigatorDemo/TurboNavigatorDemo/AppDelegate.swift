//
//  AppDelegate.swift
//  TurboNavigatorDemo
//
//  Created by 김동현 on 3/31/26.
//

import UIKit
import TurboNavigator

final class AppDelegate: NSObject, UIApplicationDelegate {
    
}

enum AppRoute: Hashable {
    case home
    case detail(id: String)
    case mvvmSample
    case settings
}

enum AppRouter {
    static func buildNavigator() -> Navigator<AppDependencies, AppRoute> {
        let registry = RouteRegistry<AppDependencies, AppRoute>()
            .registering(.home) { context in
                WrappingController(route: context.route, title: "Home") {
                    HomeView(navigator: context.navigator)
                }
            }
            .registering(
                extracting: { (route: AppRoute) -> String? in
                    guard case let .detail(id) = route else { return nil }
                    return id
                },
                build: { context, id in
                    WrappingController(route: context.route, title: "Detail") {
                        DetailView(
                            userID: id,
                            repository: context.dependencies.userRepository,
                            navigator: context.navigator)
                    }
                })
            .registering(.settings) { context in
                WrappingController(route: context.route, title: "Setting") {
                    SettingView(navigator: context.navigator)
                }
            }
            .registering(.mvvmSample) { context in
                WrappingController(route: context.route, title: "MVVM Sample") {
                    MVVMSampleView(
                        viewModel: MVVMSampleViewModel(
                            navigator: context.navigator,
                            analytics: context.dependencies.analytics,
                            userRepository: context.dependencies.userRepository))
                }
            }
        
        return Navigator(
            dependencies: AppDependencies(
                userRepository: DefaultUserRepository(),
                analytics: DefaultAnalyticsClient()),
            registry: registry
        )
    }
}
