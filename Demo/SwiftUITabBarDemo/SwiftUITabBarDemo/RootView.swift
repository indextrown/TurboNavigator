import SwiftUI
import TurboNavigator

struct RootView: View {
    let navigator: Navigator<AppDependencies, AppRoute>

    var body: some View {
        TabNavigationContainer(
            navigator: navigator,
            items: [
                item(tag: 0, route: .home, title: "Home", image: "house.fill"),
                item(tag: 1, route: .search, title: "Search", image: "magnifyingglass"),
                item(tag: 7, route: .compare, title: "Compare", image: "square.on.square"),
                item(tag: 2, route: .favorites, title: "Favorites", image: "star.fill"),
                item(tag: 3, route: .settings, title: "Settings", image: "gearshape.fill"),
                item(tag: 4, route: .red, title: "Red", image: "circle.fill"),
                item(tag: 5, route: .green, title: "Green", image: "circle.fill"),
                item(tag: 6, route: .blue, title: "Blue", image: "circle.fill")
            ]
        )
    }

    private func item(
        tag: Int,
        route: AppRoute,
        title: String,
        image: String
    ) -> TabNavigationItem<AppRoute> {
        .init(
            tag: tag,
            route: route,
            tabBarItem: UITabBarItem(
                title: title,
                image: UIImage(systemName: image),
                tag: tag
            ),
            prefersLargeTitles: true
        )
    }
}
