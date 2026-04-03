import AppCore

public protocol DetailScreenBuilding {
    func makeDetailScreen(
        route: AppRoute,
        navigator: Navigator<AppDependencies, AppRoute>,
        userID: String,
        repository: any UserRepository
    ) -> RouteViewController
}
