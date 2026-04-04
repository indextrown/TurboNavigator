import UIKit
import TurboNavigator

struct AppDependencies {}

enum AppRoute: Hashable {
    case home
    case search
    case favorites
    case settings
    case red
    case green
    case blue
    case compare
    case nativeTabComparison
    case detail(title: String)
}

enum AppRouter {
    static func buildNavigator() -> Navigator<AppDependencies, AppRoute> {
        let registry = RouteRegistry<AppDependencies, AppRoute>()
            .registering(.home) { context in
                WrappingController(route: context.route, title: "Home") {
                    HomeView(navigator: context.navigator)
                }
            }
            .registering(.search) { context in
                WrappingController(route: context.route, title: "Search") {
                    SearchView(navigator: context.navigator)
                }
            }
            .registering(.favorites) { context in
                WrappingController(route: context.route, title: "Favorites") {
                    FavoritesView(navigator: context.navigator)
                }
            }
            .registering(.settings) { context in
                WrappingController(route: context.route, title: "Settings") {
                    SettingsView(navigator: context.navigator)
                }
            }
            .registering(.red) { context in
                WrappingController(route: context.route, title: "Red") {
                    SolidColorView(
                        title: "Red Tab",
                        color: .red
                    )
                }
            }
            .registering(.green) { context in
                WrappingController(route: context.route, title: "Green") {
                    SolidColorView(
                        title: "Green Tab",
                        color: .green
                    )
                }
            }
            .registering(.blue) { context in
                WrappingController(route: context.route, title: "Blue") {
                    SolidColorView(
                        title: "Blue Tab",
                        color: .blue
                    )
                }
            }
            .registering(.compare) { context in
                WrappingController(route: context.route, title: "Compare") {
                    CompareLauncherView(navigator: context.navigator)
                }
            }
            .registering(.nativeTabComparison) { context in
                WrappingController(route: context.route, title: "SwiftUI TabView") {
                    NativeTabComparisonView()
                }
            }
            .registering(
                extracting: { (route: AppRoute) -> String? in
                    guard case let .detail(title) = route else { return nil }
                    return title
                },
                build: { context, title in
                    WrappingController(route: context.route, title: title) {
                        DetailView(navigator: context.navigator, title: title)
                    }
                }
            )

        return Navigator(
            dependencies: AppDependencies(),
            registry: registry
        )
    }
}
