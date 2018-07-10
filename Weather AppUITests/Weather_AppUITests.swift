//
//  Weather_AppUITests.swift
//  Weather AppUITests
//
//  Created by Mansur Muaz  Ekici on 3.07.2018.
//  Copyright © 2018 Adesso. All rights reserved.
//

import XCTest

class WeatherAppUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()

        app = XCUIApplication()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDeletingSavedBookmarks() {
        
        let cellCount = app.tables.firstMatch.cells.count
        for index in 1...cellCount {
            app.tables.firstMatch.cells.firstMatch.swipeLeft()
            app.buttons["Delete"].tap()
        }

        XCTAssertEqual(app.tables.firstMatch.cells.count, 0)
    }
    
    func testLongPressToSelectSaveBookmark_inAddBookmarkView() {

        app.navigationBars["Weather App"].buttons["Add"].tap()
        app.maps.firstMatch.press(forDuration: 1.5)

        let addBookmarkNavigationBar = app.navigationBars["Add Bookmark"]
        addBookmarkNavigationBar.buttons["Save"].tap()
        
        let lastItemIndex = app.tables.firstMatch.cells.count-1
        
        XCTAssertTrue(app.tables.firstMatch.cells.element(boundBy: lastItemIndex).staticTexts["Arnavutköy"].exists)
    }

}
