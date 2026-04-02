import ComposableArchitecture
import TurboNavigator

struct AppDependencies {
    let userRepository: any UserRepository
    let store: StoreOf<AppFeature>
}

protocol UserRepository {
    func displayName(for id: String) -> String
}

struct DefaultUserRepository: UserRepository {
    func displayName(for id: String) -> String {
        "SwiftUI User \(id)"
    }
}

extension AppDependencies: PreviewDependencies {
    static var preview: Self {
        .init(
            userRepository: DefaultUserRepository(),
            store: Store(
                initialState: AppFeature.State(),
                reducer: { AppFeature(navigatorClient: .noop) }
            )
        )
    }
}

enum AppRoute: Hashable {
    case home
    case detail(id: String)
    case settings
}

@MainActor
final class NavigatorBox {
    var navigator: Navigator<AppDependencies, AppRoute>?
}

struct NavigatorClient {
    var pushDetail42: @MainActor () -> Void
    var pushDetail42To99: @MainActor () -> Void
    var presentSettings: @MainActor () -> Void
    var replaceWithHomeDetail77: @MainActor () -> Void
    var backOrPushSettings: @MainActor () -> Void
    var currentRoutesText: @MainActor () -> String
    var pushNextDetail: @MainActor (String) -> Void
    var backToHome: @MainActor () -> Void
    var presentSettingsFullScreen: @MainActor () -> Void
    var back: @MainActor () -> Void
    var pushDetail7: @MainActor () -> Void
}

extension NavigatorClient {
    static let noop = Self(
        pushDetail42: {},
        pushDetail42To99: {},
        presentSettings: {},
        replaceWithHomeDetail77: {},
        backOrPushSettings: {},
        currentRoutesText: { "No routes" },
        pushNextDetail: { _ in },
        backToHome: {},
        presentSettingsFullScreen: {},
        back: {},
        pushDetail7: {}
    )

    static func live(box: NavigatorBox) -> Self {
        Self(
            pushDetail42: {
                box.navigator?.push(.detail(id: "42"))
            },
            pushDetail42To99: {
                box.navigator?.push([.detail(id: "42"), .detail(id: "99")])
            },
            presentSettings: {
                box.navigator?.present(.settings)
            },
            replaceWithHomeDetail77: {
                box.navigator?.replace(with: [.home, .detail(id: "77")])
            },
            backOrPushSettings: {
                box.navigator?.backOrPush(.settings)
            },
            currentRoutesText: {
                let routes = box.navigator?.currentRoutes()
                    .map { String(describing: $0) }
                    .joined(separator: " -> ")
                if let routes, !routes.isEmpty {
                    return routes
                }
                return "No routes"
            },
            pushNextDetail: { id in
                box.navigator?.push(.detail(id: "\(id)-next"))
            },
            backToHome: {
                box.navigator?.backTo(.home)
            },
            presentSettingsFullScreen: {
                box.navigator?.presentFullScreen(.settings)
            },
            back: {
                box.navigator?.back()
            },
            pushDetail7: {
                box.navigator?.push(.detail(id: "7"))
            }
        )
    }
}

enum AppRouter {
    static func buildNavigator(store: StoreOf<AppFeature>) -> Navigator<AppDependencies, AppRoute> {
        let registry = RouteRegistry<AppDependencies, AppRoute>()
            .registering(.home) { context in
                WrappingController(route: context.route, title: "Home") {
                    HomeView(
                        store: context.dependencies.store,
                        onPushDetail42: { context.dependencies.store.send(.pushDetail42Tapped) },
                        onPushDetail42To99: { context.dependencies.store.send(.pushDetail42To99Tapped) },
                        onPresentSettings: { context.dependencies.store.send(.presentSettingsTapped) },
                        onReplaceWithHomeDetail77: { context.dependencies.store.send(.replaceWithHomeDetail77Tapped) },
                        onBackOrPushSettings: { context.dependencies.store.send(.backOrPushSettingsTapped) },
                        onShowCurrentRoutes: { context.dependencies.store.send(.showCurrentRoutesTapped) }
                    )
                }
            }
            .registering(.settings) { context in
                WrappingController(route: context.route, title: "Settings") {
                    SettingView(
                        onPushDetail7: { context.dependencies.store.send(.settingsPushDetail7Tapped) },
                        onDismissOrBack: { context.dependencies.store.send(.settingsDismissOrBackTapped) }
                    )
                }
            }
            .registering(
                extracting: { (route: AppRoute) -> String? in
                    guard case let .detail(id) = route else { return nil }
                    return id
                },
                build: { (context: RouteContext<AppDependencies, AppRoute>, id: String) -> RouteViewController? in
                    WrappingController(route: context.route, title: "Detail \(id)") {
                        DetailView(
                            userID: id,
                            displayName: context.dependencies.userRepository.displayName(for: id),
                            onPushNext: { context.dependencies.store.send(.detailPushNextTapped(id: id)) },
                            onBackToHome: { context.dependencies.store.send(.detailBackToHomeTapped) },
                            onPresentSettingsFullScreen: { context.dependencies.store.send(.detailPresentSettingsFullScreenTapped) },
                            onBack: { context.dependencies.store.send(.detailBackTapped) }
                        )
                    }
                }
            )

        return Navigator(
            dependencies: AppDependencies(
                userRepository: DefaultUserRepository(),
                store: store
            ),
            registry: registry
        )
    }
}
