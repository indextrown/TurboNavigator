import SwiftUI
import TurboNavigator

struct RootView: View {
    @ObservedObject var sessionStore: SessionStore

    let authNavigator: Navigator<AppDependencies, AuthRoute>
    let mainNavigator: Navigator<AppDependencies, MainRoute>

    var body: some View {
        Group {
            switch sessionStore.phase {
            case .checking:
                SplashView(sessionStore: sessionStore)

            case .signedOut:
                NavigationContainer(
                    navigator: authNavigator,
                    initialRoutes: [.login],
                    prefersLargeTitles: true
                )

            case .signedIn:
                TabNavigationContainer(
                    navigator: mainNavigator,
                    items: tabItems
                )
                .ignoresSafeArea(.container, edges: .bottom)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: sessionStore.phaseDescription)
    }

    private var tabItems: [TabNavigationItem<MainRoute>] {
        [
            .init(
                tag: 0,
                route: .feed,
                tabBarItem: UITabBarItem(
                    title: "Feed",
                    image: UIImage(systemName: "house"),
                    tag: 0
                ),
                prefersLargeTitles: true
            ),
            .init(
                tag: 1,
                route: .profile,
                tabBarItem: UITabBarItem(
                    title: "Profile",
                    image: UIImage(systemName: "person.crop.circle"),
                    tag: 1
                ),
                prefersLargeTitles: true
            )
        ]
    }
}

private extension SessionStore {
    var phaseDescription: String {
        switch phase {
        case .checking: return "checking"
        case .signedOut: return "signedOut"
        case .signedIn: return "signedIn"
        }
    }
}
