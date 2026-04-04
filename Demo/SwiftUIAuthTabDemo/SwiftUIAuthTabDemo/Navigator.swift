import UIKit
import TurboNavigator

enum AuthRoute: Hashable {
    case login
}

enum MainRoute: Hashable {
    case feed
    case profile
    case detail(id: String)
    case settings
}

enum AppRouter {
    static func buildAuthNavigator(sessionStore: SessionStore) -> Navigator<AppDependencies, AuthRoute> {
        let dependencies = AppDependencies(
            sessionStore: sessionStore,
            profileRepository: DefaultProfileRepository()
        )

        let registry = RouteRegistry<AppDependencies, AuthRoute>()
            .registering(.login) { context in
                WrappingController(route: context.route, title: "Login") {
                    LoginView(
                        navigator: context.navigator,
                        sessionStore: context.dependencies.sessionStore
                    )
                }
            }

        return Navigator(
            dependencies: dependencies,
            registry: registry
        )
    }

    static func buildMainNavigator(sessionStore: SessionStore) -> Navigator<AppDependencies, MainRoute> {
        let dependencies = AppDependencies(
            sessionStore: sessionStore,
            profileRepository: DefaultProfileRepository()
        )

        let registry = RouteRegistry<AppDependencies, MainRoute>()
            .registering(.feed) { context in
                WrappingController(route: context.route, title: "Feed") {
                    FeedView(
                        navigator: context.navigator,
                        sessionStore: context.dependencies.sessionStore
                    )
                }
            }
            .registering(.profile) { context in
                WrappingController(route: context.route, title: "Profile") {
                    ProfileView(
                        navigator: context.navigator,
                        sessionStore: context.dependencies.sessionStore,
                        repository: context.dependencies.profileRepository
                    )
                }
            }
            .registering(.settings) { context in
                WrappingController(route: context.route, title: "Settings") {
                    SettingsView(
                        navigator: context.navigator,
                        sessionStore: context.dependencies.sessionStore
                    )
                }
            }
            .registering(
                extracting: { (route: MainRoute) -> String? in
                    guard case let .detail(id) = route else { return nil }
                    return id
                },
                build: { context, id in
                    WrappingController(
                        route: context.route,
                        title: "Detail \(id)",
                        isTabBarHiddenWhenPushed: true
                    ) {
                        DetailView(
                            navigator: context.navigator,
                            userID: id,
                            repository: context.dependencies.profileRepository
                        )
                    }
                }
            )

        return Navigator(
            dependencies: dependencies,
            registry: registry
        )
    }
}
