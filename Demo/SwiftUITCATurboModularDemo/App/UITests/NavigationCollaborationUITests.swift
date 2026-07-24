import XCTest

final class NavigationCollaborationUITests: XCTestCase {
    @MainActor
    func testTCAActionsDriveTurboNavigatorStackTransitions() {
        let app = launchApp()

        tapButton("Push Detail 42", in: app)
        assertNavigationTitle("Detail 42", in: app)

        tapButton("Push Next Detail", in: app)
        assertNavigationTitle("Detail 42-next", in: app)

        tapButton("Back To Home", in: app)
        assertNavigationTitle("Home", in: app)

        tapButton("Replace With Home → Detail 77", in: app)
        assertNavigationTitle("Detail 77", in: app)

        tapButton("Back To Home", in: app)
        assertNavigationTitle("Home", in: app)
    }

    @MainActor
    func testTCAActionsDriveTurboNavigatorModalTransitions() {
        let app = launchApp()

        tapButton("Present Settings", in: app)
        assertNavigationTitle("Settings", in: app)

        tapButton("Push Detail 7", in: app)
        assertNavigationTitle("Detail 7", in: app)

        tapButton("Back", in: app)
        assertNavigationTitle("Settings", in: app)

        tapButton("Dismiss Or Back", in: app)
        assertNavigationTitle("Home", in: app)
    }

    @MainActor
    private func launchApp() -> XCUIApplication {
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launch()
        assertNavigationTitle("Home", in: app)
        return app
    }

    @MainActor
    private func tapButton(
        _ identifier: String,
        in app: XCUIApplication,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let button = app.buttons.matching(identifier: identifier).firstMatch

        for _ in 0..<4 where !button.isHittable {
            app.swipeUp()
        }

        XCTAssertTrue(
            button.waitForExistence(timeout: 2),
            "Button '\(identifier)' did not appear.",
            file: file,
            line: line
        )
        button.tap()
    }

    @MainActor
    private func assertNavigationTitle(
        _ title: String,
        in app: XCUIApplication,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(
            app.navigationBars[title].waitForExistence(timeout: 3),
            "Navigation title '\(title)' did not appear.",
            file: file,
            line: line
        )
    }
}
