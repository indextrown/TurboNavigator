import SwiftUI
import AppCore
import AppNavigation
import FeatureHome
import FeatureDetail
import FeatureSettings

@main
struct SwiftUIInterfaceModularDemoApp: App {
    private let navigator = AppRouter.buildNavigator(
        homeFactory: HomeScreenFactory(),
        detailFactory: DetailScreenFactory(),
        settingsFactory: SettingsScreenFactory()
    )

    var body: some Scene {
        WindowGroup {
            NavigationContainer(
                navigator: navigator,
                initialRoutes: [.home],
                prefersLargeTitles: true
            )
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}
