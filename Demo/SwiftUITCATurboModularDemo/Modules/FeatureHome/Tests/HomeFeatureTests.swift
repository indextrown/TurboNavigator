import AppCore
@testable import FeatureHome
import XCTest

@MainActor
final class HomeFeatureTests: XCTestCase {
    func testCurrentRoutesAreStoredInFeatureState() async {
        let store = TestStore(initialState: HomeFeature.State()) {
            HomeFeature()
        } withDependencies: {
            $0.demoNavigation = DemoNavigationClient(
                routesDescription: {
                    "home → detail(42)"
                }
            )
        }

        await store.send(.showCurrentRoutesTapped)
        await store.receive(.routesTextUpdated("home → detail(42)")) {
            $0.routesText = "home → detail(42)"
        }
    }
}
