//
//  Rup_Chandra_Khatri_FE_8964748UITestsLaunchTests.swift
//  Rup_Chandra_Khatri_FE_8964748UITests
//
//  Created by user237233 on 4/5/24.
//

import XCTest

final class Rup_Chandra_Khatri_FE_8964748UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
