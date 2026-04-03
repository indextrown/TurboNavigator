import Combine
import Foundation
import TurboNavigator

struct AppDependencies {
    let userRepository: UserRepository
    let sessionStore: SessionStore
}

protocol UserRepository {
    func displayName(for id: String) -> String
}

struct DefaultUserRepository: UserRepository {
    func displayName(for id: String) -> String {
        "Auth Demo User \(id)"
    }
}

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var isLoggedIn: Bool

    private let defaults: UserDefaults
    private let authKey = "SwiftUIAuthMonolithicDemo.isLoggedIn"
    let storageDomain: String

    init(defaults: UserDefaults? = nil) {
        let domain = Bundle.main.bundleIdentifier ?? "SwiftUIAuthMonolithicDemo.debug"
        self.storageDomain = domain
        self.defaults = defaults ?? UserDefaults(suiteName: domain) ?? .standard
        self.isLoggedIn = Self.readLoginState(from: self.defaults, key: authKey)
    }

    func restoreSession() async -> Bool {
        try? await Task.sleep(for: .milliseconds(800))
        isLoggedIn = Self.readLoginState(from: defaults, key: authKey)
        return isLoggedIn
    }

    func signIn() {
        persistLoginState(true)
        isLoggedIn = true
    }

    func signOut() {
        defaults.removeObject(forKey: authKey)
        defaults.synchronize()
        isLoggedIn = false
    }

    var persistedValueDescription: String {
        if let value = defaults.object(forKey: authKey) {
            return String(describing: value)
        }
        return "nil"
    }

    private func persistLoginState(_ value: Bool) {
        defaults.set(value, forKey: authKey)
        defaults.synchronize()
    }

    private static func readLoginState(from defaults: UserDefaults, key: String) -> Bool {
        (defaults.object(forKey: key) as? Bool) ?? false
    }
}

extension AppDependencies: PreviewDependencies {
    @MainActor
    static var preview: Self {
        .init(
            userRepository: DefaultUserRepository(),
            sessionStore: SessionStore()
        )
    }
}

enum AppRoute: Hashable {
    case splash
    case login
    case home
    case detail(id: String)
    case settings
}

enum AppRouter {
    static func buildNavigator(sessionStore: SessionStore) -> Navigator<AppDependencies, AppRoute> {
        let registry = RouteRegistry<AppDependencies, AppRoute>()
            .registering(.splash) { context in
                WrappingController(route: context.route, title: "Launching") {
                    SplashView(
                        navigator: context.navigator,
                        sessionStore: context.dependencies.sessionStore
                    )
                }
            }
            .registering(.login) { context in
                WrappingController(route: context.route, title: "Login") {
                    LoginView(
                        navigator: context.navigator,
                        sessionStore: context.dependencies.sessionStore
                    )
                }
            }
            .registering(.home) { context in
                WrappingController(route: context.route, title: "Home") {
                    HomeView(
                        navigator: context.navigator,
                        sessionStore: context.dependencies.sessionStore
                    )
                }
            }
            .registering(.settings) { context in
                WrappingController(route: context.route, title: "Settings") {
                    SettingView(
                        navigator: context.navigator,
                        sessionStore: context.dependencies.sessionStore
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
                            navigator: context.navigator,
                            userID: id,
                            repository: context.dependencies.userRepository,
                            sessionStore: context.dependencies.sessionStore
                        )
                    }
                }
            )

        return Navigator(
            dependencies: AppDependencies(
                userRepository: DefaultUserRepository(),
                sessionStore: sessionStore
            ),
            registry: registry
        )
    }
}
