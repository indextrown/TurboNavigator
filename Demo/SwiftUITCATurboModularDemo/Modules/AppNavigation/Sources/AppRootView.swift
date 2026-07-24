import AppCore
import FeatureDetail
import FeatureHome
import FeatureSettings
import SwiftUI
import TurboNavigator

private struct AppDependencies {
    let userRepository: any UserRepository
}

@MainActor
public struct AppRootView: View {
    private let navigator: Navigator<AppDependencies, AppRoute>

    public init() {
        self.navigator = AppRouter.buildNavigator()
    }

    public var body: some View {
        NavigationContainer(
            navigator: navigator,
            initialRoutes: [.home],
            prefersLargeTitles: false
        )
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

@MainActor
private enum AppRouter {
    static func buildNavigator() -> Navigator<AppDependencies, AppRoute> {
        let registry = RouteRegistry<AppDependencies, AppRoute>()
            .registering(.home) { context in
                WrappingController(route: context.route, title: "Home") {
                    HomeView(
                        store: makeHomeStore(navigator: context.navigator)
                    )
                }
            }
            .registering(.settings) { context in
                WrappingController(route: context.route, title: "Settings") {
                    SettingsView(
                        store: makeSettingsStore(navigator: context.navigator)
                    )
                }
            }
            .registering(
                extracting: { (route: AppRoute) -> String? in
                    guard case let .detail(id) = route else { return nil }
                    return id
                },
                build: { context, id in
                    WrappingController(route: context.route, title: "Detail \(id)") {
                        DetailView(
                            store: makeDetailStore(
                                id: id,
                                repository: context.dependencies.userRepository,
                                navigator: context.navigator
                            )
                        )
                    }
                }
            )

        return Navigator(
            dependencies: AppDependencies(
                userRepository: DefaultUserRepository()
            ),
            registry: registry
        )
    }

    private static func makeHomeStore(
        navigator: Navigator<AppDependencies, AppRoute>
    ) -> StoreOf<HomeFeature> {
        Store(initialState: HomeFeature.State()) {
            HomeFeature()
        } withDependencies: {
            $0.demoNavigation = .live(navigator: navigator)
        }
    }

    private static func makeDetailStore(
        id: String,
        repository: any UserRepository,
        navigator: Navigator<AppDependencies, AppRoute>
    ) -> StoreOf<DetailFeature> {
        Store(
            initialState: DetailFeature.State(
                userID: id,
                displayName: repository.displayName(for: id)
            )
        ) {
            DetailFeature()
        } withDependencies: {
            $0.demoNavigation = .live(navigator: navigator)
        }
    }

    private static func makeSettingsStore(
        navigator: Navigator<AppDependencies, AppRoute>
    ) -> StoreOf<SettingsFeature> {
        Store(initialState: SettingsFeature.State()) {
            SettingsFeature()
        } withDependencies: {
            $0.demoNavigation = .live(navigator: navigator)
        }
    }
}

private extension DemoNavigationClient {
    @MainActor
    static func live(
        navigator: Navigator<AppDependencies, AppRoute>
    ) -> Self {
        Self(
            push: { route in
                navigator.push(route)
            },
            pushMany: { routes in
                navigator.push(routes)
            },
            present: { route in
                navigator.present(route)
            },
            presentFullScreen: { route in
                navigator.presentFullScreen(route)
            },
            replace: { routes in
                navigator.replace(with: routes)
            },
            back: {
                navigator.back()
            },
            backTo: { route in
                navigator.backTo(route)
            },
            backOrPush: { route in
                navigator.backOrPush(route)
            },
            routesDescription: {
                let routes = navigator.currentRoutes()
                    .map { String(describing: $0) }
                    .joined(separator: " → ")
                return routes.isEmpty ? "No routes" : routes
            }
        )
    }
}
