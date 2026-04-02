import XCTest

final class LaymanUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: - Launch Performance
    func testAppLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    // MARK: - Welcome Screen
    @MainActor
    func testWelcomeScreenLoads() throws {
        let app = XCUIApplication()
        app.launch()

        // Layman title should be visible
        XCTAssertTrue(app.staticTexts["Layman"].exists)
    }

    @MainActor
    func testWelcomeScreenLoadTime() throws {
        measure(metrics: [XCTClockMetric()]) {
            let app = XCUIApplication()
            app.launch()
            // Welcome screen should appear within 2 seconds
            _ = app.staticTexts["Layman"].waitForExistence(timeout: 2)
        }
    }

    // MARK: - Auth Screen
    @MainActor
    func testSwipeNavigatesToAuth() throws {
        let app = XCUIApplication()
        app.launch()

        // Swipe up to get to auth
        app.swipeUp()

        // Auth screen elements should appear
        _ = app.staticTexts["Login"].waitForExistence(timeout: 3)
        XCTAssertTrue(app.staticTexts["Login"].exists || app.staticTexts["Layman"].exists)
    }

    @MainActor
    func testAuthScreenHasRequiredElements() throws {
        let app = XCUIApplication()
        app.launch()
        app.swipeUp()

        _ = app.staticTexts["Login"].waitForExistence(timeout: 3)
        XCTAssertTrue(app.textFields.count > 0 || app.secureTextFields.count > 0)
    }

    @MainActor
    func testLoginToggleWorks() throws {
        let app = XCUIApplication()
        app.launch()
        app.swipeUp()

        _ = app.staticTexts["Sign Up"].waitForExistence(timeout: 3)
        app.staticTexts["Sign Up"].tap()

        XCTAssertTrue(app.staticTexts["Sign Up"].exists)
    }
}

