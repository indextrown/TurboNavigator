import AppCore

public protocol HomeScreenBuilding {
    func makeHomeScreen(
        route: AppRoute,
        navigator: Navigator<AppDependencies, AppRoute>
    ) -> RouteViewController
}
