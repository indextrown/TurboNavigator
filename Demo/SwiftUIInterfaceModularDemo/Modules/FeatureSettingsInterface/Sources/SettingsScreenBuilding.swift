import AppCore

public protocol SettingsScreenBuilding {
    func makeSettingsScreen(
        route: AppRoute,
        navigator: Navigator<AppDependencies, AppRoute>
    ) -> RouteViewController
}
