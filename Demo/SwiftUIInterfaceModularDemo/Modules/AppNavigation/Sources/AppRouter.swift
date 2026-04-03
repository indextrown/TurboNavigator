import AppCore
import FeatureHomeInterface
import FeatureDetailInterface
import FeatureSettingsInterface

public enum AppRouter {
    public static func buildNavigator(
        homeFactory: any HomeScreenBuilding,
        detailFactory: any DetailScreenBuilding,
        settingsFactory: any SettingsScreenBuilding
    ) -> Navigator<AppDependencies, AppRoute> {
        let registry = RouteRegistry<AppDependencies, AppRoute>()
            .registering(.home) { context in
                homeFactory.makeHomeScreen(
                    route: context.route,
                    navigator: context.navigator
                )
            }
            .registering(.settings) { context in
                settingsFactory.makeSettingsScreen(
                    route: context.route,
                    navigator: context.navigator
                )
            }
            .registering(
                extracting: { (route: AppRoute) -> String? in
                    guard case let .detail(id) = route else { return nil }
                    return id
                },
                build: { (context: RouteContext<AppDependencies, AppRoute>, id: String) -> RouteViewController? in
                    detailFactory.makeDetailScreen(
                        route: context.route,
                        navigator: context.navigator,
                        userID: id,
                        repository: context.dependencies.userRepository
                    )
                }
            )

        return Navigator(
            dependencies: AppDependencies(userRepository: DefaultUserRepository()),
            registry: registry
        )
    }
}
